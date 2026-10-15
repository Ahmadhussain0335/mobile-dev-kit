import 'package:mobile_dev_kit/mobile_dev_kit.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  group('selectTargets', () {
    test('defaults to claude and agents', () {
      expect(selectTargets([]).map((t) => t.name), defaultTargetNames);
    });

    test('all selects every target', () {
      expect(selectTargets(['all']).length, targets.length);
    });

    test('unknown tool throws with the valid names', () {
      expect(
        () => selectTargets(['vscode']),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('claude'),
          ),
        ),
      );
    });
  });

  group('Target.resolve', () {
    final claude = targetByName('claude')!;

    test('project path is inside the project root', () {
      expect(
        claude.resolve(global: false, projectRoot: '/work/app', home: '/h'),
        p.join('/work/app', '.claude', 'skills'),
      );
    });

    test('global path is inside the home directory', () {
      expect(
        targetByName('antigravity')!
            .resolve(global: true, projectRoot: '/work/app', home: '/h'),
        p.join('/h', '.gemini', 'config', 'skills'),
      );
    });
  });

  test('tools sharing a folder resolve to one location', () {
    final installer = Installer(projectRoot: '/work/app', home: '/h');
    final project = installer.locations(targets, global: false);
    final paths = project.map((l) => l.path).toList();
    expect(paths.toSet().length, paths.length);
    final agents = project
        .singleWhere((l) => l.path.endsWith(p.join('.agents', 'skills')));
    expect(agents.tools,
        containsAll(['codex', 'gemini', 'antigravity', 'agents']));
  });

  test('every target name is unique and paths are relative', () {
    expect(targets.map((t) => t.name).toSet().length, targets.length);
    for (final t in targets) {
      expect(p.posix.isRelative(t.projectPath), isTrue, reason: t.name);
      expect(p.posix.isRelative(t.globalPath), isTrue, reason: t.name);
    }
  });

  group('resolveHome', () {
    test('prefers HOME outside Windows', () {
      expect(
        resolveHome({'HOME': '/u', 'USERPROFILE': r'C:\u'}, windows: false),
        '/u',
      );
    });

    test('prefers USERPROFILE on Windows', () {
      expect(
        resolveHome({'HOME': '/u', 'USERPROFILE': r'C:\u'}, windows: true),
        r'C:\u',
      );
    });

    test('falls back to the other variable', () {
      expect(resolveHome({'USERPROFILE': r'C:\u'}, windows: false), r'C:\u');
    });

    test('throws when neither is set', () {
      expect(() => resolveHome({}, windows: false), throwsStateError);
    });
  });
}
