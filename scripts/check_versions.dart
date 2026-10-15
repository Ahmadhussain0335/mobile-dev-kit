// Fails if the version number differs anywhere it is declared.
//
// Usage (from the repository root):
//   dart run scripts/check_versions.dart
//
// Optional files (the npm package, the Dart package) are checked only when
// they exist, so the script works at every phase of the project.

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

final repoRoot = p.dirname(p.dirname(p.fromUri(Platform.script)));

class Source {
  const Source(this.path, this.read, {this.optional = false});

  final String path;
  final List<String> Function(String content) read;
  final bool optional;
}

List<String> jsonField(String content, List<Object> keyPath) {
  Object? node = jsonDecode(content);
  for (final key in keyPath) {
    if (key is String && node is Map) {
      node = node[key];
    } else if (key is int && node is List && key < node.length) {
      node = node[key];
    } else {
      return const [];
    }
  }
  return node is String ? [node] : const [];
}

List<String> jsonVersion(String content) => jsonField(content, ['version']);

/// Marketplace entries normally leave `version` to plugin.json; if one sets
/// it anyway, it must match.
List<String> marketplaceVersions(String content) {
  final data = jsonDecode(content) as Map<String, Object?>;
  final plugins = (data['plugins'] as List?) ?? const [];
  return [
    for (final plugin in plugins)
      if (plugin is Map && plugin['version'] is String)
        plugin['version'] as String,
  ];
}

List<String> pubspecVersion(String content) {
  final version = (loadYaml(content) as YamlMap)['version'];
  return version is String ? [version] : const [];
}

List<String> changelogVersion(String content) {
  final match = RegExp(
    r'^## \[?(\d+\.\d+\.\d+)\]?',
    multiLine: true,
  ).firstMatch(content);
  return match == null ? const [] : [match.group(1)!];
}

List<String> dartVersionConstant(String content) {
  final match = RegExp(
    r'''packageVersion\s*=\s*['"](\d+\.\d+\.\d+)['"]''',
  ).firstMatch(content);
  return match == null ? const [] : [match.group(1)!];
}

final sources = <Source>[
  Source('.claude-plugin/plugin.json', jsonVersion),
  Source('.claude-plugin/marketplace.json', marketplaceVersions),
  Source('.codex-plugin/plugin.json', jsonVersion),
  Source('.cursor-plugin/plugin.json', jsonVersion),
  Source('plugin.json', jsonVersion),
  Source('gemini-extension.json', jsonVersion),
  Source('CHANGELOG.md', changelogVersion),
  Source('packages/dart/pubspec.yaml', pubspecVersion, optional: true),
  Source('packages/dart/CHANGELOG.md', changelogVersion, optional: true),
  Source(
    'packages/dart/lib/src/version.dart',
    dartVersionConstant,
    optional: true,
  ),
  Source('packages/npm/package.json', jsonVersion, optional: true),
];

/// Files whose version list may be empty (the field is optional there).
const mayBeEmpty = {'.claude-plugin/marketplace.json'};

void main() {
  final found = <String, String>{};
  final errors = <String>[];

  for (final source in sources) {
    final file = File(p.join(repoRoot, source.path));
    if (!file.existsSync()) {
      if (!source.optional) errors.add('${source.path}: file not found');
      continue;
    }
    final List<String> versions;
    try {
      versions = source.read(file.readAsStringSync());
    } on FormatException catch (e) {
      errors.add('${source.path}: cannot parse (${e.message})');
      continue;
    }
    if (versions.isEmpty && !mayBeEmpty.contains(source.path)) {
      errors.add('${source.path}: no version found');
    }
    for (final (i, v) in versions.indexed) {
      found[versions.length == 1 ? source.path : '${source.path}[$i]'] = v;
    }
  }

  final skillsDir = Directory(p.join(repoRoot, 'skills'));
  for (final dir in skillsDir.listSync().whereType<Directory>()) {
    final skill = File(p.join(dir.path, 'SKILL.md'));
    if (!skill.existsSync()) continue;
    final match = RegExp(
      r'''^\s+version:\s*["']?(\d+\.\d+\.\d+)["']?\s*$''',
      multiLine: true,
    ).firstMatch(skill.readAsStringSync());
    final rel = p.relative(skill.path, from: repoRoot);
    if (match == null) {
      errors.add('$rel: no metadata.version found');
    } else {
      found[rel] = match.group(1)!;
    }
  }

  final distinct = found.values.toSet();
  if (distinct.length > 1) {
    final counts = <String, int>{};
    for (final v in found.values) {
      counts[v] = (counts[v] ?? 0) + 1;
    }
    final expected =
        counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
    for (final entry in found.entries) {
      if (entry.value != expected) {
        errors.add('${entry.key}: ${entry.value}, expected $expected');
      }
    }
  }

  for (final e in errors) {
    stdout.writeln('ERROR $e');
  }
  if (errors.isEmpty) {
    stdout.writeln(
      'All ${found.length} version declarations are ${distinct.single}.',
    );
  }
  exit(errors.isEmpty ? 0 : 1);
}
