import 'dart:convert';
import 'dart:io';

import 'package:mobile_dev_kit/mobile_dev_kit.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import 'helpers.dart';

void main() {
  late Sandbox box;
  setUp(() => box = Sandbox());

  test('default install writes every skill to .claude and .agents', () async {
    final result = await box.run(['install']);

    expect(result.exitCode, 0, reason: result.err);
    for (final folder in ['.claude/skills', '.agents/skills']) {
      for (final skill in bundledSkills) {
        final dir = box.inProject('$folder/${skill.name}');
        expect(
          box.filesUnder(dir),
          [...skill.files.keys, markerFileName]..sort(),
          reason: dir,
        );
        expect(
          File(p.join(dir, 'SKILL.md')).readAsStringSync(),
          skill.files['SKILL.md'],
        );
      }
    }
    expect(Directory(box.inProject('.github')).existsSync(), isFalse);
  });

  test('marker records the version and files', () async {
    await box.run(['install', '--skill', 'mobile-code-review']);

    final marker = jsonDecode(
      File(box.inProject('.claude/skills/mobile-code-review/$markerFileName'))
          .readAsStringSync(),
    ) as Map<String, Object?>;
    expect(marker['installedBy'], 'mobile_dev_kit');
    expect(marker['version'], packageVersion);
    expect(marker['files'], contains('SKILL.md'));
  });

  test('dry run writes nothing', () async {
    final result = await box.run(['install', '--tool', 'all', '--dry-run']);

    expect(result.exitCode, 0);
    expect(result.out, contains('would create'));
    expect(box.project.listSync(), isEmpty);
  });

  test('second install reports unchanged', () async {
    await box.run(['install', '-t', 'claude']);
    final result = await box.run(['install', '-t', 'claude']);

    expect(result.exitCode, 0);
    expect(result.out, contains('${bundledSkills.length} unchanged'));
  });

  test('--skill limits the install', () async {
    await box.run(
        ['install', '-t', 'cursor', '-s', 'swift-ios', '-s', 'dart-flutter']);

    expect(
      Directory(box.inProject('.cursor/skills'))
          .listSync()
          .map((e) => p.basename(e.path))
          .toSet(),
      {'swift-ios', 'dart-flutter'},
    );
  });

  test('--tool all writes each shared folder once', () async {
    final result = await box.run(['install', '--tool', 'all']);

    expect(result.exitCode, 0, reason: result.err);
    for (final folder in [
      '.claude/skills',
      '.agents/skills',
      '.github/skills',
      '.cursor/skills',
      '.windsurf/skills',
    ]) {
      expect(Directory(box.inProject(folder)).listSync().length,
          bundledSkills.length);
    }
    expect(
        result.out.split('\n').where((l) => l.contains('.agents')).length, 1);
  });

  test('--global installs into the home directory', () async {
    final result = await box.run(['install', '--global', '-t', 'antigravity']);

    expect(result.exitCode, 0, reason: result.err);
    expect(
      File(box.inHome('.gemini/config/skills/mobile-mvvm/SKILL.md'))
          .existsSync(),
      isTrue,
    );
    expect(box.project.listSync(), isEmpty);
  });

  test('--dir installs into another project root', () async {
    final other = Directory(p.join(box.root.path, 'other'))..createSync();
    final result =
        await box.run(['install', '-t', 'copilot', '--dir', other.path]);

    expect(result.exitCode, 0);
    expect(Directory(p.join(other.path, '.github', 'skills')).existsSync(),
        isTrue);
    expect(box.project.listSync(), isEmpty);
  });

  group('existing folders', () {
    late String dir;
    setUp(() {
      dir = box.inProject('.claude/skills/mobile-code-review');
      Directory(dir).createSync(recursive: true);
      File(p.join(dir, 'SKILL.md')).writeAsStringSync('my own skill');
      File(p.join(dir, 'notes.md')).writeAsStringSync('keep me');
    });

    test('are not overwritten without --force', () async {
      final result = await box.run(['install', '-t', 'claude']);

      expect(result.exitCode, 1);
      expect(result.err, contains('--force'));
      expect(File(p.join(dir, 'SKILL.md')).readAsStringSync(), 'my own skill');
      expect(File(p.join(dir, markerFileName)).existsSync(), isFalse);
      expect(
        File(box.inProject('.claude/skills/mobile-security/SKILL.md'))
            .existsSync(),
        isTrue,
        reason: 'other skills are still installed',
      );
    });

    test('are overwritten with --force, keeping unrelated files', () async {
      final result = await box.run(['install', '-t', 'claude', '--force']);

      expect(result.exitCode, 0, reason: result.err);
      expect(result.out, contains('overwritten'));
      expect(
        File(p.join(dir, 'SKILL.md')).readAsStringSync(),
        skillByName('mobile-code-review')!.files['SKILL.md'],
      );
      expect(File(p.join(dir, 'notes.md')).readAsStringSync(), 'keep me');
      expect(File(p.join(dir, markerFileName)).existsSync(), isTrue);
    });
  });

  test('update removes files dropped from the bundle', () async {
    await box.run(['install', '-t', 'claude', '-s', 'mobile-mvi']);
    final dir = box.inProject('.claude/skills/mobile-mvi');
    final markerFile = File(p.join(dir, markerFileName));
    final marker =
        jsonDecode(markerFile.readAsStringSync()) as Map<String, Object?>;
    File(p.join(dir, 'references', 'old.md')).writeAsStringSync('stale');
    markerFile.writeAsStringSync(jsonEncode({
      ...marker,
      'version': '0.9.0',
      'files': [...(marker['files']! as List), 'references/old.md'],
    }));

    final result =
        await box.run(['install', '-t', 'claude', '-s', 'mobile-mvi']);

    expect(result.out, contains('updated'));
    expect(File(p.join(dir, 'references', 'old.md')).existsSync(), isFalse);
    expect(
      (jsonDecode(markerFile.readAsStringSync()) as Map)['version'],
      packageVersion,
    );
  });

  test('symbolic links are never followed or replaced', () async {
    final elsewhere = Directory(p.join(box.root.path, 'elsewhere'))
      ..createSync();
    File(p.join(elsewhere.path, 'SKILL.md')).writeAsStringSync('linked');
    Directory(box.inProject('.claude/skills')).createSync(recursive: true);
    Link(box.inProject('.claude/skills/swift-ios')).createSync(elsewhere.path);

    final result = await box
        .run(['install', '-t', 'claude', '-s', 'swift-ios', '--force']);

    expect(result.exitCode, 1);
    expect(result.out, contains('skipped (link/file)'));
    expect(box.filesUnder(elsewhere.path), ['SKILL.md']);
  }, testOn: '!windows');

  group('usage errors', () {
    test('unknown tool exits 64 and lists valid tools', () async {
      final result = await box.run(['install', '--tool', 'vscode']);

      expect(result.exitCode, usageExitCode);
      expect(result.err, contains('"vscode" is not an allowed value'));
      expect(result.err, contains('claude'));
      expect(box.project.listSync(), isEmpty);
    });

    test('unknown skill exits 64', () async {
      final result = await box.run(['install', '--skill', 'nope']);

      expect(result.exitCode, usageExitCode);
      expect(box.project.listSync(), isEmpty);
    });

    test('extra arguments exit 64', () async {
      final result = await box.run(['install', 'claude']);

      expect(result.exitCode, usageExitCode);
      expect(result.err, contains('Unexpected argument'));
    });
  });

  group('top level', () {
    test('--version prints the package version', () async {
      final result = await box.run(['--version']);

      expect(result.exitCode, 0);
      expect(result.out.trim(), packageVersion);
    });

    test('--help lists the commands', () async {
      final result = await box.run(['--help']);

      expect(result.exitCode, 0);
      for (final command in [
        'list',
        'targets',
        'install',
        'uninstall',
        'doctor'
      ]) {
        expect(result.out, contains(command));
      }
    });

    test('list prints every skill', () async {
      final result = await box.run(['list']);

      for (final skill in bundledSkills) {
        expect(result.out, contains(skill.name));
      }
    });

    test('targets prints every tool', () async {
      final result = await box.run(['targets']);

      for (final target in targets) {
        expect(result.out, contains(target.name));
      }
    });
  });
}
