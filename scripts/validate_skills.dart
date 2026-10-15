// Lints every skill under skills/ against the Agent Skills spec and the
// house rules of this pack.
//
// Usage (from the repository root):
//   dart run scripts/validate_skills.dart [skills-dir]
//
// Exits with code 1 if any error is found. Warnings do not fail the run.

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

const maxSkillLines = 500;
// The Agent Skills spec allows 1024 characters; this pack keeps descriptions
// short because every description is loaded into every session.
const maxDescriptionLength = 600;
const targetDescriptionLength = (min: 300, max: 500);
const maxNameLength = 64;
const expectedLicense = 'MIT';
const expectedPack = 'mobile-dev-kit';

const allowedFrontmatterKeys = {
  'name',
  'description',
  'license',
  'compatibility',
  'metadata',
  'allowed-tools',
};

const requiredSections = [
  'When to use',
  'Workflow',
  'Rules',
  'Anti-patterns',
  'Checklist',
  'Related skills',
];

// Skill text must stay tool-agnostic. Checked outside code spans only, so
// real APIs such as android.database.Cursor stay usable in examples.
const productNames = [
  'Claude',
  'Anthropic',
  'Codex',
  'ChatGPT',
  'OpenAI',
  'GPT',
  'Gemini',
  'Copilot',
  'Cursor',
  'Windsurf',
  'Codeium',
  'Antigravity',
];

final kebabCase = RegExp(r'^[a-z0-9]+(-[a-z0-9]+)*$');
final semver = RegExp(r'^\d+\.\d+\.\d+$');
final markdownLink = RegExp(r'\]\(([^)\s]+)(?:\s+"[^"]*")?\)');
final fencedBlock = RegExp(
  r'^(```|~~~).*?^\1',
  multiLine: true,
  dotAll: true,
);
final inlineCode = RegExp(r'`[^`\n]*`');
final heading2 = RegExp(r'^## (.+?)\s*$', multiLine: true);
final backticked = RegExp(r'`([a-z0-9-]+)`');

class Report {
  final errors = <String>[];
  final warnings = <String>[];
  final descriptionLengths = <String, int>{};

  void error(String where, String message) => errors.add('$where: $message');
  void warn(String where, String message) => warnings.add('$where: $message');
}

void main(List<String> args) {
  final repoRoot = p.dirname(p.dirname(p.fromUri(Platform.script)));
  final skillsDir = Directory(
    args.isNotEmpty ? args.first : p.join(repoRoot, 'skills'),
  );
  if (!skillsDir.existsSync()) {
    stderr.writeln('Skills directory not found: ${skillsDir.path}');
    exit(1);
  }

  final skillDirs = skillsDir.listSync().whereType<Directory>().toList()
    ..sort((a, b) => a.path.compareTo(b.path));
  final skillNames = skillDirs.map((d) => p.basename(d.path)).toSet();
  final report = Report();

  for (final dir in skillDirs) {
    validateSkill(dir, skillNames, report);
  }
  if (args.isEmpty) checkSkillIndexes(repoRoot, skillNames, report);

  stdout.writeln('Description lengths:');
  for (final entry in report.descriptionLengths.entries) {
    stdout.writeln('  ${entry.value.toString().padLeft(4)}  ${entry.key}');
  }
  for (final w in report.warnings) {
    stdout.writeln('WARN  $w');
  }
  for (final e in report.errors) {
    stdout.writeln('ERROR $e');
  }
  stdout.writeln(
    '${skillDirs.length} skill(s) checked: '
    '${report.errors.length} error(s), ${report.warnings.length} warning(s).',
  );
  exit(report.errors.isEmpty ? 0 : 1);
}

void validateSkill(Directory dir, Set<String> skillNames, Report report) {
  final folder = p.basename(dir.path);
  final skillFile = File(p.join(dir.path, 'SKILL.md'));
  final where = '$folder/SKILL.md';

  if (!skillFile.existsSync()) {
    report.error(folder, 'missing SKILL.md');
    return;
  }

  for (final file in dir.listSync(recursive: true).whereType<File>()) {
    checkAscii(file, p.relative(file.path, from: p.dirname(dir.path)), report);
  }

  final text = skillFile.readAsStringSync();
  final lines = text.split('\n');
  final lineCount = text.endsWith('\n') ? lines.length - 1 : lines.length;
  if (lineCount >= maxSkillLines) {
    report.error(where, '$lineCount lines, must be under $maxSkillLines');
  }

  final body = checkFrontmatter(text, folder, where, report);
  if (body == null) return;

  final headings = heading2.allMatches(body).map((m) => m.group(1)!).toSet();
  for (final section in requiredSections) {
    if (!headings.contains(section)) {
      report.error(where, 'missing section "## $section"');
    }
  }

  checkProductNames(body, where, report);
  checkLinks(dir, body, where, report);
  checkRelatedSkills(body, folder, skillNames, where, report);
  checkOrphanReferences(dir, body, where, report);

  for (final file in dir.listSync(recursive: true).whereType<File>()) {
    if (p.extension(file.path) != '.md' || file.path == skillFile.path) {
      continue;
    }
    final rel = p.relative(file.path, from: p.dirname(dir.path));
    final content = file.readAsStringSync();
    checkProductNames(content, rel, report);
    checkLinks(file.parent, content, rel, report);
  }
}

/// Returns the markdown body after the frontmatter, or null if the
/// frontmatter is unusable.
String? checkFrontmatter(
  String text,
  String folder,
  String where,
  Report report,
) {
  if (!text.startsWith('---\n')) {
    report.error(where, 'must start with YAML frontmatter ("---")');
    return null;
  }
  final end = text.indexOf('\n---\n', 4);
  if (end == -1) {
    report.error(where, 'frontmatter is not closed with "---"');
    return null;
  }

  final Object? yaml;
  try {
    yaml = loadYaml(text.substring(4, end));
  } on YamlException catch (e) {
    report.error(where, 'invalid YAML frontmatter: ${e.message}');
    return null;
  }
  if (yaml is! YamlMap) {
    report.error(where, 'frontmatter must be a YAML mapping');
    return null;
  }

  for (final key in yaml.keys) {
    if (!allowedFrontmatterKeys.contains(key)) {
      report.error(where, 'unknown frontmatter key "$key"');
    }
  }

  final name = yaml['name'];
  if (name is! String || name.isEmpty) {
    report.error(where, '"name" is required and must be a string');
  } else {
    if (name != folder) {
      report.error(where, 'name "$name" must match folder "$folder"');
    }
    if (!kebabCase.hasMatch(name)) {
      report.error(where, 'name "$name" must be kebab-case');
    }
    if (name.length > maxNameLength) {
      report.error(where, 'name longer than $maxNameLength characters');
    }
  }

  final description = yaml['description'];
  if (description is! String || description.trim().isEmpty) {
    report.error(where, '"description" is required and must be a string');
  } else {
    report.descriptionLengths[folder] = description.length;
    if (description.length > maxDescriptionLength) {
      report.error(
        where,
        'description is ${description.length} characters, '
        'max $maxDescriptionLength',
      );
    } else if (description.length < targetDescriptionLength.min ||
        description.length > targetDescriptionLength.max) {
      report.warn(
        where,
        'description is ${description.length} characters, target '
        '${targetDescriptionLength.min}-${targetDescriptionLength.max}',
      );
    }
  }

  if (yaml['license'] != expectedLicense) {
    report.error(where, 'license must be "$expectedLicense"');
  }

  final metadata = yaml['metadata'];
  if (metadata is! YamlMap) {
    report.error(where, '"metadata" mapping is required');
  } else {
    for (final key in metadata.keys) {
      if (metadata[key] is! String) {
        report.error(where, 'metadata.$key must be a string (quote it)');
      }
    }
    if ((metadata['author'] as Object?)?.toString().isEmpty ?? true) {
      report.error(where, 'metadata.author is required');
    }
    final version = metadata['version'];
    if (version is! String || !semver.hasMatch(version)) {
      report.error(where, 'metadata.version must be a semver string');
    }
    if (metadata['pack'] != expectedPack) {
      report.error(where, 'metadata.pack must be "$expectedPack"');
    }
  }

  return text.substring(end + 5);
}

void checkAscii(File file, String where, Report report) {
  final bytes = file.readAsBytesSync();
  var line = 1;
  final badLines = <int>{};
  for (final b in bytes) {
    if (b == 0x0A) {
      line++;
    } else if (b > 0x7E || (b < 0x20 && b != 0x09 && b != 0x0D)) {
      badLines.add(line);
    }
  }
  if (badLines.isNotEmpty) {
    final shown = badLines.take(10).join(', ');
    report.error(where, 'non-ASCII or control characters on line(s) $shown');
  }
}

String stripCode(String markdown) =>
    markdown.replaceAll(fencedBlock, '').replaceAll(inlineCode, '');

void checkProductNames(String markdown, String where, Report report) {
  final prose = stripCode(markdown);
  for (final product in productNames) {
    if (RegExp('\\b$product\\b').hasMatch(prose)) {
      report.error(where, 'mentions AI product "$product"; say "the agent"');
    }
  }
}

void checkLinks(Directory base, String markdown, String where, Report report) {
  for (final match in markdownLink.allMatches(stripCode(markdown))) {
    final target = match.group(1)!;
    if (target.startsWith('http://') ||
        target.startsWith('https://') ||
        target.startsWith('mailto:') ||
        target.startsWith('#')) {
      continue;
    }
    final path = target.split('#').first;
    if (!File(p.normalize(p.join(base.path, path))).existsSync()) {
      report.error(where, 'broken link "$target"');
    }
  }
}

void checkRelatedSkills(
  String body,
  String folder,
  Set<String> skillNames,
  String where,
  Report report,
) {
  final start = body.indexOf('## Related skills');
  if (start == -1) return;
  final next = body.indexOf('\n## ', start + 1);
  final section = body.substring(start, next == -1 ? body.length : next);
  for (final match in backticked.allMatches(section)) {
    final name = match.group(1)!;
    if (name == folder) {
      report.error(where, 'lists itself under Related skills');
    } else if (!skillNames.contains(name)) {
      report.warn(where, 'related skill "$name" does not exist (yet)');
    }
  }
}

void checkOrphanReferences(
  Directory dir,
  String body,
  String where,
  Report report,
) {
  final refsDir = Directory(p.join(dir.path, 'references'));
  if (!refsDir.existsSync()) return;
  final linked = markdownLink
      .allMatches(stripCode(body))
      .map((m) => p.normalize(m.group(1)!.split('#').first))
      .toSet();
  for (final file in refsDir.listSync(recursive: true).whereType<File>()) {
    final rel = p.relative(file.path, from: dir.path);
    if (!linked.contains(rel)) {
      report.error(where, '$rel is never linked, so it will never be loaded');
    }
  }
}

/// Skill lists that must name exactly the folders in skills/. Each pattern
/// captures the skill name from one list row.
final skillIndexes = <String, RegExp>{
  'README.md': RegExp(r'^\| \[`([a-z0-9-]+)`\]\(skills/', multiLine: true),
  'AGENTS.md': RegExp(r'^\| `skills/([a-z0-9-]+)`', multiLine: true),
  'GEMINI.md': RegExp(r'^- `([a-z0-9-]+)` --', multiLine: true),
};

void checkSkillIndexes(String repoRoot, Set<String> skillNames, Report report) {
  for (final MapEntry(key: file, value: pattern) in skillIndexes.entries) {
    final path = File(p.join(repoRoot, file));
    if (!path.existsSync()) {
      report.error(file, 'file not found');
      continue;
    }
    final listed = pattern
        .allMatches(path.readAsStringSync())
        .map((m) => m.group(1)!)
        .toSet();
    for (final missing in skillNames.difference(listed)) {
      report.error(file, 'skill table is missing "$missing"');
    }
    for (final extra in listed.difference(skillNames)) {
      report.error(file, 'skill table lists "$extra", which has no folder');
    }
  }
}
