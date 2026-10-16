import 'dart:io';

import 'package:mobile_dev_kit/mobile_dev_kit.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  test('packageVersion matches pubspec.yaml', () {
    final pubspec =
        loadYaml(File('pubspec.yaml').readAsStringSync()) as YamlMap;
    expect(packageVersion, pubspec['version']);
  });

  test('bundled skills have names, descriptions and a SKILL.md', () {
    expect(bundledSkills, isNotEmpty);
    for (final skill in bundledSkills) {
      expect(skill.description, isNotEmpty, reason: skill.name);
      expect(skill.files, contains('SKILL.md'), reason: skill.name);
      expect(skill.files['SKILL.md'], contains('name: ${skill.name}\n'));
      for (final path in skill.files.keys) {
        expect(p.posix.isRelative(path) && !path.contains('..'), isTrue,
            reason: path);
      }
    }
  });

  // Compares content, not formatting, so it runs on every supported SDK. The
  // exact generated file is checked by `dart run tool/embed_skills.dart --check`
  // in CI on the stable SDK, because formatter output differs between versions.
  final skillsDir = Directory(p.join('..', '..', 'skills'));
  test(
    'embedded skills match the repository skills folder',
    () {
      final onDisk = <String, Map<String, String>>{};
      for (final dir in skillsDir.listSync().whereType<Directory>()) {
        if (!File(p.join(dir.path, 'SKILL.md')).existsSync()) continue;
        onDisk[p.basename(dir.path)] = {
          for (final file in dir.listSync(recursive: true).whereType<File>())
            if (!p.basename(file.path).startsWith('.'))
              p.split(p.relative(file.path, from: dir.path)).join('/'):
                  file.readAsStringSync().replaceAll('\r\n', '\n'),
        };
      }

      final embedded = {for (final s in bundledSkills) s.name: s.files};
      expect(
        embedded.keys.toSet(),
        onDisk.keys.toSet(),
        reason: 'run: dart run tool/embed_skills.dart',
      );
      for (final name in onDisk.keys) {
        expect(
          embedded[name],
          onDisk[name],
          reason: '$name is stale; run: dart run tool/embed_skills.dart',
        );
      }
    },
    skip: skillsDir.existsSync() ? false : 'not inside the repository',
  );
}
