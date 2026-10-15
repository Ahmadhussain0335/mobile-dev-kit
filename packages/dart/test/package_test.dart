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

  final skillsDir = p.join('..', '..', 'skills');
  test(
    'embedded skills match the repository skills folder',
    () async {
      final result = await Process.run(
        Platform.resolvedExecutable,
        ['run', 'tool/embed_skills.dart', '--check'],
      );
      expect(result.exitCode, 0, reason: '${result.stdout}${result.stderr}');
    },
    skip:
        Directory(skillsDir).existsSync() ? false : 'not inside the repository',
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
