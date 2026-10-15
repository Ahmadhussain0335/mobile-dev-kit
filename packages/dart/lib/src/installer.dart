import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import 'skills.dart';
import 'targets.dart';
import 'version.dart';

/// Name of the marker file written into every skill folder this package
/// installs. Uninstall only touches folders that contain it.
const String markerFileName = '.mobile-dev-kit.json';

/// What happened, or would happen in a dry run, to one skill folder.
enum ActionKind {
  /// The folder did not exist and was created.
  created,

  /// A folder installed by this package was rewritten with the current files.
  updated,

  /// A folder installed by this package already had the current files.
  unchanged,

  /// A folder not installed by this package was overwritten with `--force`.
  forced,

  /// The folder exists but was not installed by this package; left untouched.
  conflict,

  /// The path is a symbolic link or a file; left untouched.
  notADirectory,

  /// The folder was removed.
  removed,

  /// Installed files were removed but the folder holds other files, so it
  /// was kept.
  keptUserFiles,

  /// Nothing to uninstall at this path.
  notInstalled,
}

/// The result for one skill in one skills folder.
class SkillAction {
  /// Creates an action record.
  const SkillAction({
    required this.skill,
    required this.directory,
    required this.kind,
  });

  /// Skill name.
  final String skill;

  /// Absolute path of the skill folder.
  final String directory;

  /// What happened.
  final ActionKind kind;

  /// True for outcomes that mean the request was not fully carried out.
  bool get isSkipped =>
      kind == ActionKind.conflict || kind == ActionKind.notADirectory;
}

/// A skills folder and the tools that read it.
class SkillsLocation {
  /// Creates a location.
  const SkillsLocation(this.path, this.tools);

  /// Absolute path of the skills folder, for example `<project>/.claude/skills`.
  final String path;

  /// Names of the tools that read this folder.
  final List<String> tools;
}

/// A skill folder found by [Installer.inspect].
class InstalledSkill {
  /// Creates an inspection record.
  const InstalledSkill({
    required this.skill,
    required this.directory,
    required this.installedVersion,
  });

  /// Skill name.
  final String skill;

  /// Absolute path of the skill folder.
  final String directory;

  /// Version recorded in the marker, or null if the folder was not installed
  /// by this package.
  final String? installedVersion;

  /// True if this package installed the folder.
  bool get isManaged => installedVersion != null;

  /// True if this package installed an older or different version.
  bool get isOutdated => isManaged && installedVersion != packageVersion;
}

/// Installs, removes and inspects bundled skills on disk.
///
/// All writes and deletes stay inside `<skills folder>/<skill name>/`.
class Installer {
  /// Creates an installer that resolves project paths against [projectRoot]
  /// and global paths against [home].
  Installer({
    required this.projectRoot,
    required this.home,
    List<Skill>? skills,
    this.version = packageVersion,
  }) : skills = skills ?? bundledSkills;

  /// Project root used for project installs.
  final String projectRoot;

  /// Home directory used for global installs.
  final String home;

  /// Skills available to install.
  final List<Skill> skills;

  /// Version written into markers.
  final String version;

  /// Resolves [targets] to unique skills folders. Several tools can share a
  /// folder (for example `.agents/skills`); each folder appears once.
  List<SkillsLocation> locations(List<Target> targets, {required bool global}) {
    final byPath = <String, List<String>>{};
    for (final target in targets) {
      final path = target.resolve(
        global: global,
        projectRoot: projectRoot,
        home: home,
      );
      byPath.putIfAbsent(path, () => []).add(target.name);
    }
    return [for (final e in byPath.entries) SkillsLocation(e.key, e.value)];
  }

  /// Installs [selected] skills (all when empty) into every location.
  ///
  /// A folder that exists without a marker is left alone unless [force] is
  /// true. Symbolic links are never followed or replaced. With [dryRun]
  /// nothing is written.
  List<SkillAction> install(
    List<SkillsLocation> locations, {
    List<String> selected = const [],
    bool force = false,
    bool dryRun = false,
  }) {
    final actions = <SkillAction>[];
    for (final location in locations) {
      for (final skill in _select(selected)) {
        final dir = p.join(location.path, skill.name);
        final kind = _installOne(skill, dir, force: force, dryRun: dryRun);
        actions.add(SkillAction(skill: skill.name, directory: dir, kind: kind));
      }
    }
    return actions;
  }

  /// Removes [selected] skills (all when empty) from every location, but only
  /// folders that contain a marker, and only the files the marker lists.
  List<SkillAction> uninstall(
    List<SkillsLocation> locations, {
    List<String> selected = const [],
    bool dryRun = false,
  }) {
    final actions = <SkillAction>[];
    for (final location in locations) {
      for (final skill in _select(selected)) {
        final dir = p.join(location.path, skill.name);
        final kind = _uninstallOne(dir, dryRun: dryRun);
        actions.add(SkillAction(skill: skill.name, directory: dir, kind: kind));
      }
    }
    return actions;
  }

  /// Lists bundled skill names found in [location], managed or not.
  List<InstalledSkill> inspect(SkillsLocation location) {
    final found = <InstalledSkill>[];
    for (final skill in skills) {
      final dir = p.join(location.path, skill.name);
      if (FileSystemEntity.typeSync(dir, followLinks: false) ==
          FileSystemEntityType.notFound) {
        continue;
      }
      found.add(
        InstalledSkill(
          skill: skill.name,
          directory: dir,
          installedVersion: _readMarker(dir)?.version,
        ),
      );
    }
    return found;
  }

  Iterable<Skill> _select(List<String> selected) {
    if (selected.isEmpty) return skills;
    return skills.where((s) => selected.contains(s.name));
  }

  ActionKind _installOne(
    Skill skill,
    String dir, {
    required bool force,
    required bool dryRun,
  }) {
    final type = FileSystemEntity.typeSync(dir, followLinks: false);
    if (type == FileSystemEntityType.notFound) {
      if (!dryRun) _write(skill, dir, previous: null);
      return ActionKind.created;
    }
    if (type != FileSystemEntityType.directory) return ActionKind.notADirectory;

    final marker = _readMarker(dir);
    if (marker == null) {
      if (!force) return ActionKind.conflict;
      if (!dryRun) _write(skill, dir, previous: null);
      return ActionKind.forced;
    }
    if (marker.version == version && _matches(skill, dir)) {
      return ActionKind.unchanged;
    }
    if (!dryRun) _write(skill, dir, previous: marker);
    return ActionKind.updated;
  }

  ActionKind _uninstallOne(String dir, {required bool dryRun}) {
    final type = FileSystemEntity.typeSync(dir, followLinks: false);
    if (type == FileSystemEntityType.notFound) return ActionKind.notInstalled;
    if (type != FileSystemEntityType.directory) return ActionKind.notADirectory;

    final marker = _readMarker(dir);
    if (marker == null) return ActionKind.conflict;

    final listed = {...marker.files, markerFileName};
    final others = Directory(dir)
        .listSync(recursive: true, followLinks: false)
        .whereType<File>()
        .map((f) => _relative(f.path, dir))
        .where((rel) => !listed.contains(rel));
    final keepsUserFiles = others.isNotEmpty;
    if (dryRun) {
      return keepsUserFiles ? ActionKind.keptUserFiles : ActionKind.removed;
    }

    // Resolve every path first so an unsafe entry aborts before anything is
    // deleted.
    final paths = [for (final rel in listed) _inside(dir, rel)];
    for (final path in paths) {
      if (FileSystemEntity.typeSync(path, followLinks: false) ==
          FileSystemEntityType.file) {
        File(path).deleteSync();
      }
    }
    _deleteEmptyDirectories(dir);
    return Directory(dir).existsSync()
        ? ActionKind.keptUserFiles
        : ActionKind.removed;
  }

  void _write(Skill skill, String dir, {required _Marker? previous}) {
    if (previous != null) {
      final stale = [
        for (final f in previous.files)
          if (!skill.files.containsKey(f)) _inside(dir, f),
      ];
      for (final path in stale) {
        if (FileSystemEntity.typeSync(path, followLinks: false) ==
            FileSystemEntityType.file) {
          File(path).deleteSync();
        }
      }
      _deleteEmptyDirectories(dir, keepRoot: true);
    }
    for (final entry in skill.files.entries) {
      File(_inside(dir, entry.key))
        ..parent.createSync(recursive: true)
        ..writeAsStringSync(entry.value);
    }
    final marker = _Marker(
      version: version,
      skill: skill.name,
      files: skill.files.keys.toList()..sort(),
    );
    File(p.join(dir, markerFileName)).writeAsStringSync(marker.encode());
  }

  bool _matches(Skill skill, String dir) {
    for (final entry in skill.files.entries) {
      final file = File(_inside(dir, entry.key));
      if (!file.existsSync() || file.readAsStringSync() != entry.value) {
        return false;
      }
    }
    return true;
  }

  _Marker? _readMarker(String dir) {
    final file = File(p.join(dir, markerFileName));
    if (FileSystemEntity.typeSync(file.path, followLinks: false) !=
        FileSystemEntityType.file) {
      return null;
    }
    try {
      return _Marker.decode(file.readAsStringSync());
    } on FormatException {
      return null;
    }
  }

  /// Joins a marker or bundle path onto [dir], refusing anything that would
  /// resolve outside it, either lexically or through a symbolic link in an
  /// intermediate folder.
  String _inside(String dir, String relative) {
    final path = p.normalize(p.join(dir, p.joinAll(relative.split('/'))));
    if (!p.isWithin(dir, path)) {
      throw StateError('Refusing to touch $path: outside $dir');
    }
    for (var parent = p.dirname(path);
        parent != dir;
        parent = p.dirname(parent)) {
      if (FileSystemEntity.isLinkSync(parent)) {
        throw StateError('Refusing to touch $path: $parent is a symbolic link');
      }
    }
    return path;
  }

  String _relative(String path, String dir) =>
      p.split(p.relative(path, from: dir)).join('/');

  /// Removes empty folders below [dir], deepest first, then [dir] itself if
  /// it is empty and [keepRoot] is false. Never follows links.
  void _deleteEmptyDirectories(String dir, {bool keepRoot = false}) {
    final subdirs = Directory(dir)
        .listSync(recursive: true, followLinks: false)
        .whereType<Directory>()
        .toList()
      ..sort((a, b) => b.path.length.compareTo(a.path.length));
    for (final sub in subdirs) {
      if (sub.listSync().isEmpty) sub.deleteSync();
    }
    if (!keepRoot && Directory(dir).listSync().isEmpty) {
      Directory(dir).deleteSync();
    }
  }
}

class _Marker {
  const _Marker({
    required this.version,
    required this.skill,
    required this.files,
  });

  factory _Marker.decode(String source) {
    final json = jsonDecode(source);
    if (json is! Map<String, Object?> ||
        json['installedBy'] != 'mobile_dev_kit' ||
        json['version'] is! String ||
        json['files'] is! List) {
      throw const FormatException('Not a mobile_dev_kit marker');
    }
    return _Marker(
      version: json['version']! as String,
      skill: (json['skill'] as String?) ?? '',
      files: (json['files']! as List).whereType<String>().toList(),
    );
  }

  final String version;
  final String skill;
  final List<String> files;

  String encode() => '${const JsonEncoder.withIndent('  ').convert({
            'installedBy': 'mobile_dev_kit',
            'version': version,
            'skill': skill,
            'files': files,
          })}\n';
}
