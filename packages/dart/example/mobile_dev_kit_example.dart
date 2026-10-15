// Installs two skills for Claude Code and Cursor into a temporary project,
// prints what happened, then removes them again.
//
// Most users run the command line instead:
//   mobile_dev_kit install --tool claude --tool cursor
import 'dart:io';

import 'package:mobile_dev_kit/mobile_dev_kit.dart';

void main() {
  final project = Directory.systemTemp.createTempSync('mobile_dev_kit_demo');
  try {
    final installer = Installer(projectRoot: project.path, home: project.path);
    final locations = installer.locations(
      selectTargets(['claude', 'cursor']),
      global: false,
    );

    final installed = installer.install(
      locations,
      selected: ['mobile-code-review', 'mobile-security'],
    );
    for (final action in installed) {
      stdout.writeln('${action.kind.name.padRight(10)} ${action.directory}');
    }

    final removed = installer.uninstall(locations);
    stdout.writeln(
      'Removed ${removed.where((a) => a.kind == ActionKind.removed).length} '
      'skill folders.',
    );
  } finally {
    project.deleteSync(recursive: true);
  }
}
