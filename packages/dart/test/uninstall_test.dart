import 'dart:convert';
import 'dart:io';

import 'package:mobile_dev_kit/mobile_dev_kit.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import 'helpers.dart';

void main() {
  late Sandbox box;
  setUp(() => box = Sandbox());

  test('removes everything it installed', () async {
    await box.run(['install']);
    final result = await box.run(['uninstall']);

    expect(result.exitCode, 0, reason: result.err);
    expect(box.filesUnder(box.inProject('.claude/skills')), isEmpty);
    expect(box.filesUnder(box.inProject('.agents/skills')), isEmpty);
    expect(Directory(box.inProject('.claude/skills/mobile-mvvm')).existsSync(),
        isFalse);
  });

  test('dry run removes nothing', () async {
    await box.run(['install', '-t', 'claude']);
    final before = box.filesUnder(box.project.path);

    final result = await box.run(['uninstall', '-t', 'claude', '--dry-run']);

    expect(result.out, contains('would remove'));
    expect(box.filesUnder(box.project.path), before);
  });

  test('never touches folders without a marker, even with --force', () async {
    final dir = box.inProject('.claude/skills/mobile-security');
    Directory(dir).createSync(recursive: true);
    File(p.join(dir, 'SKILL.md')).writeAsStringSync('mine');

    final result = await box.run(['uninstall', '-t', 'claude', '--force']);

    expect(result.exitCode, 0);
    expect(File(p.join(dir, 'SKILL.md')).readAsStringSync(), 'mine');
  });

  test('keeps files the user added and their folder', () async {
    await box.run(['install', '-t', 'claude', '-s', 'mobile-kotlin']);
    final dir = box.inProject('.claude/skills/mobile-kotlin');
    File(p.join(dir, 'references', 'team-notes.md')).writeAsStringSync('ours');

    final result =
        await box.run(['uninstall', '-t', 'claude', '-s', 'mobile-kotlin']);

    expect(result.out, contains('removed, folder kept'));
    expect(box.filesUnder(dir), ['references/team-notes.md']);
  });

  test('ignores marker paths that point outside the skill folder', () async {
    await box.run(['install', '-t', 'claude', '-s', 'mobile-java']);
    final victim = File(p.join(box.root.path, 'victim.txt'))
      ..writeAsStringSync('safe');
    final markerFile =
        File(box.inProject('.claude/skills/mobile-java/$markerFileName'));
    final marker =
        jsonDecode(markerFile.readAsStringSync()) as Map<String, Object?>;
    markerFile.writeAsStringSync(jsonEncode({
      ...marker,
      'files': ['../../../../victim.txt'],
    }));

    final result =
        await box.run(['uninstall', '-t', 'claude', '-s', 'mobile-java']);

    expect(result.exitCode, 1);
    expect(result.err, contains('outside'));
    expect(victim.readAsStringSync(), 'safe');
  });

  test('refuses to follow a symlinked folder inside a skill', () async {
    await box.run(['install', '-t', 'claude', '-s', 'mobile-swift']);
    final dir = box.inProject('.claude/skills/mobile-swift');
    final refs = Directory(p.join(dir, 'references'));
    final names = refs.listSync().map((e) => p.basename(e.path)).toList();
    final elsewhere = Directory(p.join(box.root.path, 'elsewhere'))
      ..createSync();
    for (final name in names) {
      File(p.join(elsewhere.path, name)).writeAsStringSync('not yours');
    }
    refs.deleteSync(recursive: true);
    Link(refs.path).createSync(elsewhere.path);

    final result =
        await box.run(['uninstall', '-t', 'claude', '-s', 'mobile-swift']);

    expect(result.exitCode, 1);
    expect(result.err, contains('symbolic link'));
    expect(box.filesUnder(elsewhere.path), (names..sort()));
    expect(File(p.join(dir, 'SKILL.md')).existsSync(), isTrue,
        reason: 'nothing is deleted when any path is unsafe');
  }, testOn: '!windows');

  test('reports skills that were never installed', () async {
    final result =
        await box.run(['uninstall', '-t', 'cursor', '-s', 'mobile-mvc']);

    expect(result.exitCode, 0);
    expect(result.out, contains('not installed'));
  });
}
