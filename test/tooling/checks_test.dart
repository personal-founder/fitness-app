// metadata_version: 1
// purpose: checks_test verifier regression coverage.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008, ADR-0009]
import 'package:flutter_test/flutter_test.dart';

import 'dart:io';

import '../../tool/verification/checks.dart';
import '../../tool/verification/builds.dart';
import '../../tool/verification/command.dart';
import 'support.dart';

void main() {
  test(
    'integration selects the configured native device without a prompt',
    () async {
      final f = Fixture();
      addTearDown(f.dispose);
      f.file('integration_test/example_test.dart', '// fixture');
      final commands = <List<String>>[];
      await runChecks(
        f.context(),
        runner: (_, args, _, _) async {
          commands.add(args);
          return CommandResult(0, '{"type":"testDone","result":"success"}', 0);
        },
      );
      expect(
        commands.last,
        containsAllInOrder(['-d', Platform.operatingSystem]),
      );
    },
  );
  test('missing application suites cannot borrow tooling test results', () async {
    final f = Fixture();
    addTearDown(f.dispose);
    f.file('test/tooling/a_test.dart', '// fixture');
    final c = f.context();
    final results = await runChecks(
      c,
      runner: (_, args, _, _) async => CommandResult(
        0,
        '{"type":"testDone","hidden":false,"skipped":false,"result":"success"}',
        0,
      ),
    );
    expect(results.singleWhere((v) => v.id == 'tooling').status, 'PASS');
    expect(results.singleWhere((v) => v.id == 'application').status, 'BLOCKED');
    expect(results.singleWhere((v) => v.id == 'integration').status, 'BLOCKED');
  });
  test(
    'all targets remain represented; unsupported hosts stay blocked',
    () async {
      final f = Fixture();
      addTearDown(f.dispose);
      final results = await runBuilds(
        f.context(),
        runner: (_, _, _, _) async => CommandResult(0, 'fixture build', 0),
      );
      expect(results.length, 6);
      expect(results.where((v) => v.status == 'BLOCKED'), isNotEmpty);
      expect(results.where((v) => v.status == 'PASS'), isNotEmpty);
    },
  );
}
