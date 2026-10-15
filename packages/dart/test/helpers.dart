import 'dart:io';

import 'package:mobile_dev_kit/mobile_dev_kit.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

/// Output and exit code of one CLI run.
class CliResult {
  CliResult(this.exitCode, this.out, this.err);

  final int exitCode;
  final String out;
  final String err;
}

/// A temporary project folder and home folder, deleted after each test.
class Sandbox {
  Sandbox() {
    root = Directory.systemTemp.createTempSync('mobile_dev_kit_test');
    project = Directory(p.join(root.path, 'project'))..createSync();
    home = Directory(p.join(root.path, 'home'))..createSync();
    addTearDown(() => root.deleteSync(recursive: true));
  }

  late final Directory root;
  late final Directory project;
  late final Directory home;

  Future<CliResult> run(List<String> args) async {
    final out = StringBuffer();
    final err = StringBuffer();
    final code = await runCli(
      args,
      out: out,
      err: err,
      environment: {'HOME': home.path, 'USERPROFILE': home.path},
      workingDirectory: project.path,
    );
    return CliResult(code, out.toString(), err.toString());
  }

  String inProject(String relative) =>
      p.joinAll([project.path, ...relative.split('/')]);

  String inHome(String relative) =>
      p.joinAll([home.path, ...relative.split('/')]);

  /// Every file below [dir], as forward-slash paths relative to it.
  List<String> filesUnder(String dir) {
    if (!Directory(dir).existsSync()) return const [];
    return Directory(dir)
        .listSync(recursive: true)
        .whereType<File>()
        .map((f) => p.split(p.relative(f.path, from: dir)).join('/'))
        .toList()
      ..sort();
  }
}
