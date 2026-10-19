// metadata_version: 1
// purpose: command_test verifier regression coverage.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008, ADR-0009]
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/verification/command.dart';
import '../../tool/verification/test_results.dart';
import 'support.dart';

void main() {
  test('commands report nonzero, unavailable and timeout without hanging', () async {
    final f = Fixture();
    addTearDown(f.dispose);
    final dart =
        '${sdkRoot()}/bin/cache/dart-sdk/bin/dart${Platform.isWindows ? '.exe' : ''}';
    final script = f.file(
      'exit.dart',
      'import "dart:io"; void main() => exit(7);',
    );
    final failed = await execute(dart, [script.path], f.root, 10);
    expect(commandCheck('failure', failed).status, 'FAIL');
    expect(failed.code, 7);
    final missing = await execute(
      '${f.root}/missing-executable',
      [],
      f.root,
      1,
    );
    expect(commandCheck('missing', missing).status, 'BLOCKED');
    script.writeAsStringSync(
      'import "dart:async"; void main() { Timer(Duration(seconds: 20), () {}); }',
    );
    final timed = await execute(dart, [script.path], f.root, 1);
    expect(timed.output, contains('timed out'));
  });
  test('zero-test and skipped suites cannot pass', () {
    expect(
      testResult(
        'native',
        CommandResult(
          1,
          "Cannot open include file: 'atlstr.h'\n"
          '{"type":"testDone","result":"error"}',
          0,
        ),
      ).status,
      'BLOCKED',
    );
    expect(testResult('tests', CommandResult(0, '', 0)).status, 'BLOCKED');
    const event =
        '{"type":"testDone","hidden":false,"skipped":true,"result":"success"}';
    expect(testResult('tests', CommandResult(0, event, 0)).status, 'FAIL');
    const good =
        '{"type":"testDone","hidden":false,"skipped":false,"result":"success"}';
    expect(testResult('tests', CommandResult(0, good, 0)).status, 'PASS');
    expect(testResult('tests', CommandResult(1, good, 0)).status, 'FAIL');
    expect(
      testResult(
        'tests',
        CommandResult(1, 'Unable to find suitable Visual Studio toolchain', 0),
      ).status,
      'BLOCKED',
    );
  });
}
