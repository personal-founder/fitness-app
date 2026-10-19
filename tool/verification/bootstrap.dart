// metadata_version: 1
// purpose: Restore pinned packages before running isolated YAML-aware verification.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008, ADR-0009]
import 'dart:io';

import 'command.dart';
import 'git.dart';
import 'model.dart';
import 'options.dart';
import 'policy.dart';
import 'sdk.dart';
import 'staging.dart';
import 'temporary.dart';
import 'output.dart';
import 'working.dart';
import 'bootstrap_report.dart';

Future<int> bootstrap(List<String> args) async {
  final options = Options.parse(args);
  if (options['shard'] != null &&
      options['shard'] != Platform.operatingSystem) {
    throw const FormatException('Shard must match the actual runner host');
  }
  for (final key in ['message', 'evidence-dir', 'aggregate']) {
    if (options[key] != null) {
      options.values[key] = File(options[key]!).absolute.path;
    }
  }
  final source = Git(Directory.current.path)
      .run(['rev-parse', '--show-toplevel'])
      .trim();
  final git = Git(source);
  final output = reportPath(source, options['output']);
  final stage = options.staged ? exportStage(git) : exportWorking(git);
  final root = stage.directory.path;
  try {
    final policy = Policy.load(root);
    final sdk = flutterSdk(options),
        versions = sdkVersions(flutterSdk(options));
    final pin = policy['toolchain'];
    if (versions['flutter'] != pin['flutter'] ||
        versions['dart'] != pin['dart'] ||
        Platform.version.split(' ').first != pin['dart'] ||
        versions['revision'] != pin['flutter_revision']) {
      throw StateError('Installed Flutter/Dart does not match policy pins');
    }
    final lock = File('$root/pubspec.lock').readAsBytesSync();
    stdout.writeln('RUN dependencies');
    final restore = await execute(
      executable(sdk, 'flutter'),
      List<String>.from(pin['restore']),
      root,
      pin['timeout_seconds'],
    );
    if (restore.code != 0) {
      final c = commandCheck('dependencies', restore);
      saveBootstrapFailure(source, output, c);
      stderr.writeln('${c.status}: dependencies; see $output');
      return gateExit([c]);
    }
    if (!_same(lock, File('$root/pubspec.lock').readAsBytesSync())) {
      throw StateError('Dependency restoration changed the lockfile');
    }
    verifyMaterialization(stage, git);
    final context = Directory.systemTemp.createTempSync('macro-context-');
    try {
      final input = '${context.path}/context.json';
      writeJson(input, {
        'root': root,
        'source': source,
        'tree': options.staged ? stage.tree : null,
        'parent': stage.parent,
        'inputs': stage.inputs,
        'options': options.toJson(),
        'sdk': sdk,
        'versions': versions,
        'output': File(output).absolute.path,
        'restore_seconds': restore.seconds,
      });
      final result = await Process.start(
        executable(sdk, 'dart'),
        ['tool/verification/worker.dart', input],
        workingDirectory: root,
        mode: ProcessStartMode.inheritStdio,
      );
      return await result.exitCode;
    } finally {
      deleteTemporary(context, 'macro-context-');
    }
  } finally {
    deleteTemporary(stage.directory, 'macro-verify-');
    if (git.parent != stage.parent ||
        stage.tree.isNotEmpty && git.tree != stage.tree) {
      throw StateError(
        'Candidate or parent changed before returning the gate result',
      );
    }
  }
}

bool _same(List<int> a, List<int> b) =>
    a.length == b.length &&
    Iterable<int>.generate(a.length).every((i) => a[i] == b[i]);
