import 'dart:convert';
import 'dart:io';

import 'package:mobile_dev_kit/mobile_dev_kit.dart';
import 'package:test/test.dart';

import 'helpers.dart';

void main() {
  late Sandbox box;
  setUp(() => box = Sandbox());

  test('reports nothing installed', () async {
    final result = await box.run(['doctor']);

    expect(result.exitCode, 0);
    expect(result.out, contains('No skills found'));
  });

  test('reports project and global installs', () async {
    await box.run(['install', '-t', 'claude']);
    await box
        .run(['install', '-t', 'copilot', '--global', '-s', 'mobile-swift']);

    final result = await box.run(['doctor']);

    expect(
        result.out,
        contains(
            '${bundledSkills.length} of ${bundledSkills.length} installed'));
    expect(result.out, contains('1 of ${bundledSkills.length} installed'));
    expect(result.out, contains('ok ($packageVersion)'));
  });

  test('flags outdated and unmanaged folders', () async {
    await box.run(['install', '-t', 'claude', '-s', 'mobile-mvvm']);
    final markerFile =
        File(box.inProject('.claude/skills/mobile-mvvm/$markerFileName'));
    final marker =
        jsonDecode(markerFile.readAsStringSync()) as Map<String, Object?>;
    markerFile.writeAsStringSync(jsonEncode({...marker, 'version': '0.1.0'}));
    Directory(box.inProject('.claude/skills/mobile-mvi')).createSync();

    final result = await box.run(['doctor']);

    expect(result.out, contains('outdated (0.1.0)'));
    expect(result.out, contains('not managed by mobile_dev_kit'));
  });
}
