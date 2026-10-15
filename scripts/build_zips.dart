// Builds upload-ready zips of the skills.
//
// Usage (from the repository root):
//   dart run scripts/build_zips.dart [output-dir]   # default: dist/
//
// dist/<skill>.zip holds one top-level <skill>/ folder with SKILL.md inside,
// the layout skill upload forms expect. dist/mobile-dev-kit-all-skills.zip
// holds every skill folder plus LICENSE, for downloading the whole set.
// Existing zips with the same names are overwritten; nothing is deleted.

import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;

const allSkillsZip = 'mobile-dev-kit-all-skills.zip';

void main(List<String> args) {
  final repoRoot = p.dirname(p.dirname(p.fromUri(Platform.script)));
  final skillsDir = Directory(p.join(repoRoot, 'skills'));
  final outDir = Directory(
    args.isNotEmpty ? args.first : p.join(repoRoot, 'dist'),
  )..createSync(recursive: true);

  final skillDirs = skillsDir
      .listSync()
      .whereType<Directory>()
      .where((d) => File(p.join(d.path, 'SKILL.md')).existsSync())
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));
  if (skillDirs.isEmpty) {
    stderr.writeln('No skills found in ${skillsDir.path}');
    exit(1);
  }

  final everything = Archive();
  for (final dir in skillDirs) {
    final name = p.basename(dir.path);
    final single = Archive();
    for (final entry in skillFiles(dir)) {
      final zipPath = '$name/${entry.relative}';
      single.addFile(ArchiveFile.bytes(zipPath, entry.bytes));
      everything.addFile(ArchiveFile.bytes(zipPath, entry.bytes));
    }
    write(p.join(outDir.path, '$name.zip'), single);
  }
  final license = File(p.join(repoRoot, 'LICENSE'));
  everything.addFile(ArchiveFile.bytes('LICENSE', normalized(license)));
  write(p.join(outDir.path, allSkillsZip), everything);

  stdout.writeln(
    'Wrote ${skillDirs.length + 1} zips to '
    '${p.relative(outDir.path, from: repoRoot)}/',
  );
}

class SkillFile {
  SkillFile(this.relative, this.bytes);

  final String relative;
  final List<int> bytes;
}

/// Files of a skill folder, sorted, with forward-slash paths. Dotfiles are
/// skipped.
List<SkillFile> skillFiles(Directory dir) {
  final files = dir
      .listSync(recursive: true)
      .whereType<File>()
      .where(
        (f) => !p
            .split(p.relative(f.path, from: dir.path))
            .any((part) => part.startsWith('.')),
      )
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));
  return [
    for (final f in files)
      SkillFile(
        p.split(p.relative(f.path, from: dir.path)).join('/'),
        normalized(f),
      ),
  ];
}

/// File bytes with CRLF converted to LF, so zips built on Windows match.
List<int> normalized(File file) =>
    utf8.encode(file.readAsStringSync().replaceAll('\r\n', '\n'));

void write(String path, Archive archive) {
  File(path).writeAsBytesSync(ZipEncoder().encodeBytes(archive));
}
