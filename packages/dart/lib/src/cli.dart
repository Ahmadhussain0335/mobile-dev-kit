import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;

import 'installer.dart';
import 'skills.dart';
import 'targets.dart';
import 'version.dart';

/// Exit code for invalid command-line usage (EX_USAGE).
const int usageExitCode = 64;

/// Runs the `mobile_dev_kit` command line with [args] and returns the exit
/// code.
///
/// [out] and [err] default to stdout and stderr. [environment] and
/// [workingDirectory] default to the current process; tests override them to
/// point the home directory and project root at temporary folders.
Future<int> runCli(
  List<String> args, {
  StringSink? out,
  StringSink? err,
  Map<String, String>? environment,
  String? workingDirectory,
}) async {
  final context = _Context(
    out: out ?? stdout,
    err: err ?? stderr,
    environment: environment ?? Platform.environment,
    workingDirectory: workingDirectory ?? Directory.current.path,
  );
  final runner = _Runner(context);
  try {
    return await runner.run(args) ?? 0;
  } on UsageException catch (e) {
    context.err
      ..writeln(e.message)
      ..writeln()
      ..writeln(e.usage);
    return usageExitCode;
  } on ArgumentError catch (e) {
    context.err.writeln(e.message);
    return usageExitCode;
  } on StateError catch (e) {
    context.err.writeln('Error: ${e.message}');
    return 1;
  } on FileSystemException catch (e) {
    context.err.writeln('Error: ${e.message} (${e.path ?? ''})');
    return 1;
  }
}

/// Resolves the user's home directory from [environment]: `USERPROFILE`
/// first on Windows, `HOME` first elsewhere, each falling back to the other.
String resolveHome(Map<String, String> environment, {bool? windows}) {
  final order = (windows ?? Platform.isWindows)
      ? ['USERPROFILE', 'HOME']
      : ['HOME', 'USERPROFILE'];
  for (final key in order) {
    final value = environment[key];
    if (value != null && value.isNotEmpty) return value;
  }
  throw StateError('Cannot find the home directory: set HOME or USERPROFILE.');
}

class _Context {
  _Context({
    required this.out,
    required this.err,
    required this.environment,
    required this.workingDirectory,
  });

  final StringSink out;
  final StringSink err;
  final Map<String, String> environment;
  final String workingDirectory;
}

class _Runner extends CommandRunner<int> {
  _Runner(this.context)
      : super(
          'mobile_dev_kit',
          'Installs the mobile-dev-kit Agent Skills for Android, iOS and '
              'Flutter into AI coding tools.',
        ) {
    argParser.addFlag(
      'version',
      negatable: false,
      help: 'Print the version and exit.',
    );
    addCommand(_ListCommand(context));
    addCommand(_TargetsCommand(context));
    addCommand(_InstallCommand(context));
    addCommand(_UninstallCommand(context));
    addCommand(_DoctorCommand(context));
  }

  final _Context context;

  @override
  void printUsage() => context.out.writeln(usage);

  @override
  Future<int?> runCommand(ArgResults topLevelResults) async {
    if (topLevelResults.flag('version')) {
      context.out.writeln(packageVersion);
      return 0;
    }
    return super.runCommand(topLevelResults);
  }
}

class _ListCommand extends Command<int> {
  _ListCommand(this.context);

  final _Context context;

  @override
  void printUsage() => context.out.writeln(usage);

  @override
  String get name => 'list';

  @override
  String get description => 'List the bundled skills.';

  @override
  int run() {
    final width = bundledSkills.map((s) => s.name.length).reduce(_max);
    for (final skill in bundledSkills) {
      context.out.writeln('${skill.name.padRight(width)}  ${skill.summary}');
    }
    return 0;
  }
}

class _TargetsCommand extends Command<int> {
  _TargetsCommand(this.context);

  final _Context context;

  @override
  void printUsage() => context.out.writeln(usage);

  @override
  String get name => 'targets';

  @override
  String get description =>
      'Show each supported tool with its project and global skills folder.';

  @override
  int run() {
    final rows = [
      ['TOOL', 'PROJECT', 'GLOBAL', 'NAME'],
      for (final t in targets)
        [t.name, t.projectPath, '~/${t.globalPath}', t.label],
    ];
    final widths = [
      for (var c = 0; c < 3; c++) rows.map((r) => r[c].length).reduce(_max),
    ];
    for (final row in rows) {
      context.out.writeln(
        [
          for (var c = 0; c < 3; c++) row[c].padRight(widths[c]),
          row[3],
        ].join('  '),
      );
    }
    context.out
      ..writeln()
      ..writeln(
        'Default (no --tool): ${defaultTargetNames.join(', ')}. '
        '--tool $allTargetsName selects every tool; shared folders are '
        'written once.',
      );
    return 0;
  }
}

abstract class _SkillsCommand extends Command<int> {
  _SkillsCommand(this.context) {
    argParser
      ..addMultiOption(
        'tool',
        abbr: 't',
        help: 'Tool to install for. Repeat for several. '
            'Default: ${defaultTargetNames.join(', ')}.',
        allowed: [...targets.map((t) => t.name), allTargetsName],
      )
      ..addMultiOption(
        'skill',
        abbr: 's',
        help: 'Skill to act on. Repeat for several. Default: all.',
        allowed: [for (final s in bundledSkills) s.name],
      )
      ..addFlag(
        'global',
        abbr: 'g',
        negatable: false,
        help: 'Use the user-level folders in the home directory instead of '
            'the project.',
      )
      ..addFlag(
        'dry-run',
        abbr: 'n',
        negatable: false,
        help: 'Show what would change without writing anything.',
      )
      ..addOption(
        'dir',
        abbr: 'd',
        valueHelp: 'path',
        help: 'Project root (default: current directory). With --global, '
            'used as the home directory instead.',
      );
  }

  final _Context context;

  @override
  void printUsage() => context.out.writeln(usage);

  bool get global => argResults!.flag('global');
  bool get dryRun => argResults!.flag('dry-run');
  List<String> get selectedSkills => argResults!.multiOption('skill');

  void rejectExtraArguments() {
    if (argResults!.rest.isNotEmpty) {
      usageException('Unexpected argument: ${argResults!.rest.first}');
    }
  }

  Installer installer() {
    final dir = argResults!.option('dir');
    final resolvedDir = dir == null
        ? null
        : p.normalize(p.absolute(context.workingDirectory, dir));
    return Installer(
      projectRoot: global
          ? context.workingDirectory
          : resolvedDir ?? context.workingDirectory,
      home: global ? resolvedDir ?? resolveHome(context.environment) : '',
    );
  }

  List<SkillsLocation> locations(Installer installer) => installer.locations(
        selectTargets(argResults!.multiOption('tool')),
        global: global,
      );

  void report(List<SkillAction> actions, List<SkillsLocation> locations) {
    final prefix = dryRun ? '[dry-run] ' : '';
    for (final location in locations) {
      context.out
          .writeln('$prefix${location.path} (${location.tools.join(', ')})');
      for (final action in actions.where(
        (a) => p.dirname(a.directory) == location.path,
      )) {
        context.out.writeln(
          '  ${_label(action.kind, dryRun).padRight(20)} ${action.skill}',
        );
      }
    }
    final counts = <ActionKind, int>{};
    for (final a in actions) {
      counts[a.kind] = (counts[a.kind] ?? 0) + 1;
    }
    context.out.writeln(
      '$prefix${[
        for (final e in counts.entries) '${e.value} ${_label(e.key, dryRun)}',
      ].join(', ')}.',
    );
  }
}

class _InstallCommand extends _SkillsCommand {
  _InstallCommand(super.context) {
    argParser.addFlag(
      'force',
      abbr: 'f',
      negatable: false,
      help: 'Overwrite skill folders that were not installed by this tool.',
    );
  }

  @override
  String get name => 'install';

  @override
  String get description => 'Install skills into one or more tools.';

  @override
  int run() {
    rejectExtraArguments();
    final installer = this.installer();
    final locations = this.locations(installer);
    final actions = installer.install(
      locations,
      selected: selectedSkills,
      force: argResults!.flag('force'),
      dryRun: dryRun,
    );
    report(actions, locations);
    if (actions.any((a) => a.kind == ActionKind.conflict)) {
      context.err.writeln(
        'Some folders already exist and were not installed by mobile_dev_kit. '
        'They were left unchanged. Re-run with --force to overwrite them.',
      );
    }
    if (actions.any((a) => a.kind == ActionKind.notADirectory)) {
      context.err.writeln(
        'Some skill paths are symbolic links or files and were left '
        'unchanged. Remove them first if you want this tool to manage them.',
      );
    }
    return actions.any((a) => a.isSkipped) ? 1 : 0;
  }
}

class _UninstallCommand extends _SkillsCommand {
  _UninstallCommand(super.context) {
    argParser.addFlag(
      'force',
      abbr: 'f',
      negatable: false,
      help: 'Accepted for symmetry with install. Folders without a '
          'mobile_dev_kit marker are never removed.',
    );
  }

  @override
  String get name => 'uninstall';

  @override
  String get description =>
      'Remove skills that this tool installed. Other folders are never '
      'touched.';

  @override
  int run() {
    rejectExtraArguments();
    final installer = this.installer();
    final locations = this.locations(installer);
    final actions = installer.uninstall(
      locations,
      selected: selectedSkills,
      dryRun: dryRun,
    );
    report(actions, locations);
    if (actions.any((a) => a.kind == ActionKind.conflict)) {
      context.err.writeln(
        'Some folders were not installed by mobile_dev_kit and were left '
        'untouched.',
      );
    }
    if (actions.any((a) => a.kind == ActionKind.keptUserFiles)) {
      context.err.writeln(
        'Some folders contained files not installed by mobile_dev_kit. '
        'Those files and their folders were kept.',
      );
    }
    return 0;
  }
}

class _DoctorCommand extends Command<int> {
  _DoctorCommand(this.context) {
    argParser.addOption(
      'dir',
      abbr: 'd',
      valueHelp: 'path',
      help: 'Project root to inspect (default: current directory).',
    );
  }

  final _Context context;

  @override
  void printUsage() => context.out.writeln(usage);

  @override
  String get name => 'doctor';

  @override
  String get description =>
      'Show where skills are installed and whether they are outdated.';

  @override
  int run() {
    final dir = argResults!.option('dir');
    final installer = Installer(
      projectRoot: dir == null
          ? context.workingDirectory
          : p.normalize(p.absolute(context.workingDirectory, dir)),
      home: resolveHome(context.environment),
    );
    context.out.writeln('mobile_dev_kit $packageVersion');
    var anything = false;
    var outdated = 0;
    for (final scope in [false, true]) {
      for (final location in installer.locations(targets, global: scope)) {
        final found = installer.inspect(location);
        if (found.isEmpty) continue;
        anything = true;
        final managed = found.where((s) => s.isManaged).length;
        context.out.writeln(
          '\n${scope ? 'global ' : 'project'} ${location.path} '
          '(${location.tools.join(', ')}): '
          '$managed of ${bundledSkills.length} installed',
        );
        for (final skill in found) {
          final String status;
          if (!skill.isManaged) {
            status = 'not managed by mobile_dev_kit';
          } else if (skill.isOutdated) {
            status = 'outdated (${skill.installedVersion})';
            outdated++;
          } else {
            status = 'ok (${skill.installedVersion})';
          }
          context.out.writeln('  ${skill.skill.padRight(24)} $status');
        }
      }
    }
    if (!anything) {
      context.out.writeln(
        '\nNo skills found. Run: mobile_dev_kit install',
      );
    } else if (outdated > 0) {
      context.out.writeln(
        '\n$outdated outdated. Run the same install command again to update.',
      );
    }
    return 0;
  }
}

int _max(int a, int b) => a > b ? a : b;

String _label(ActionKind kind, bool dryRun) {
  if (!dryRun) {
    return switch (kind) {
      ActionKind.created => 'created',
      ActionKind.updated => 'updated',
      ActionKind.unchanged => 'unchanged',
      ActionKind.forced => 'overwritten',
      ActionKind.conflict => 'skipped (exists)',
      ActionKind.notADirectory => 'skipped (link/file)',
      ActionKind.removed => 'removed',
      ActionKind.keptUserFiles => 'removed, folder kept',
      ActionKind.notInstalled => 'not installed',
    };
  }
  return switch (kind) {
    ActionKind.created => 'would create',
    ActionKind.updated => 'would update',
    ActionKind.unchanged => 'unchanged',
    ActionKind.forced => 'would overwrite',
    ActionKind.conflict => 'would skip (exists)',
    ActionKind.notADirectory => 'would skip (link)',
    ActionKind.removed => 'would remove',
    ActionKind.keptUserFiles => 'would remove files',
    ActionKind.notInstalled => 'not installed',
  };
}
