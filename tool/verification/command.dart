// metadata_version: 1
// purpose: Run bounded child processes and preserve their exit status and command evidence.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008, ADR-0009]
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'model.dart';

class CommandResult {
  CommandResult(
    this.code,
    this.output,
    this.seconds, {
    this.blocked = false,
    this.command = const [],
  });
  final int code;
  final String output;
  final double seconds;
  final bool blocked;
  final List<String> command;
}

Future<CommandResult> execute(
  String executable,
  List<String> args,
  String root,
  int timeout,
) async {
  final clock = Stopwatch()..start();
  if (Platform.isWindows &&
      executable.toLowerCase().endsWith('.bat') &&
      [executable, ...args].any((v) => RegExp(r'[&|<>^%!\r\n]').hasMatch(v))) {
    throw const FormatException('Unsafe batch command argument');
  }
  try {
    final process = await Process.start(
      executable,
      args,
      workingDirectory: root,
      runInShell:
          Platform.isWindows && executable.toLowerCase().endsWith('.bat'),
    );
    final output = process.stdout.transform(utf8.decoder).join();
    final errors = process.stderr.transform(utf8.decoder).join();
    int code;
    try {
      code = await process.exitCode.timeout(Duration(seconds: timeout));
    } on TimeoutException {
      if (Platform.isWindows) {
        await Process.run('taskkill', ['/PID', '${process.pid}', '/T', '/F']);
      } else {
        process.kill();
      }
      await process.exitCode;
      return CommandResult(
        1,
        'Command timed out',
        clock.elapsedMilliseconds / 1000,
        command: [executable, ...args],
      );
    }
    final text = '${await output}\n${await errors}';
    return CommandResult(
      code,
      text,
      clock.elapsedMilliseconds / 1000,
      command: [executable, ...args],
    );
  } on ProcessException catch (e) {
    return CommandResult(
      2,
      'Executable unavailable: ${e.executable}',
      clock.elapsedMilliseconds / 1000,
      blocked: true,
      command: [executable, ...args],
    );
  }
}

Check commandCheck(String id, CommandResult result) => Check(
  id,
  result.blocked
      ? 'BLOCKED'
      : result.code == 0
      ? 'PASS'
      : 'FAIL',
  result.code == 0 ? 'Command completed' : result.output,
  seconds: result.seconds,
  command: result.command,
);
