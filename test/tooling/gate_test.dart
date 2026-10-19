// metadata_version: 1
// purpose: Prove full orchestration and required-target aggregation with controlled processes.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0011]
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/verification/aggregate.dart';
import '../../tool/verification/command.dart';
import '../../tool/verification/digest.dart';
import '../../tool/verification/model.dart';
import '../../tool/verification/run_gate.dart';
import 'support.dart';

void main() {
  test(
    'complete orchestration passes only after all required evidence',
    () async {
      final f = Fixture();
      addTearDown(f.dispose);
      for (final p in [
        'lib/a.dart',
        'test/a_test.dart',
        'test/tooling/a_test.dart',
        'integration_test/a_test.dart',
        'tool/a.dart',
      ]) {
        f.file(p, '${sourceHeader('Controlled fixture')}// fixture\n');
      }
      const adr = 'docs/adr/0007-shared-verifier.md';
      f.file(adr, File(adr).readAsStringSync());
      f.file(
        'docs/engineering-standards.md',
        File('docs/engineering-standards.md').readAsStringSync(),
      );
      f.file('rules.md', '# Fixture\n');
      const template = 'docs/adr/adr-template.md';
      f.file(template, File(template).readAsStringSync());
      Directory('${f.root}/config/policy/requirements')
          .createSync(recursive: true);
      final c = f.context(changed: ['lib/a.dart']);
      c.policy.main['policy_sources'] = ['rules.md'];
      c.identity['snapshot'] = await hashFiles(f.root, c.files);
      Future<CommandResult> runner(
        String exe,
        List<String> args,
        String dir,
        int timeout,
      ) async => CommandResult(
        0,
        '{"type":"testDone","hidden":false,"skipped":false,"result":"success"}',
        0,
      );
      final partial = await runGate(c, runner: runner);
      expect(partial.where((v) => v.status == 'FAIL'), isEmpty);
      expect(gateExit(partial), 2);
      final foreign = partial
          .where((v) => v.id.startsWith('build:') && v.status == 'BLOCKED')
          .map((v) => Check(v.id, 'PASS', 'Controlled foreign runner'));
      expect(gateExit(combine(c, [...partial, ...foreign])), 0);
      expect(
        gateExit(
          combine(c, [
            ...partial,
            ...foreign,
            Check('snapshot:final', 'FAIL', 'Changed after checks'),
          ]),
        ),
        1,
      );
    },
  );
}
