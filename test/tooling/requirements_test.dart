// metadata_version: 1
// purpose: requirements_test verifier regression coverage.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0009, ADR-0010, ADR-0011]
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/verification/requirements.dart';
import 'support.dart';

void main() {
  test(
    'mandatory rules need a source-matching register and real evidence',
    () async {
      final f = Fixture();
      addTearDown(f.dispose);
      f.file('rules.md', '# Rules\n\n- MUST preserve privacy.\n');
      f.file('config/policy/requirements/rules.jsonl', '');
      final c = f.context();
      c.policy.main['policy_sources'] = ['rules.md'];
      final source = (await inventory(f.root, ['rules.md'])).single;
      final record = {
        ...source,
        'verification': 'Review privacy evidence',
        'evidence': null,
        'enforcement': 'manual',
        'status': 'unverified',
      };
      final file = f.file(
        'config/policy/requirements/rules.jsonl',
        '${jsonEncode(record)}\n',
      );
      expect((await requirementCheck(c)).status, 'PASS');
      file.writeAsStringSync(
        '${jsonEncode({...record, 'status': 'verified'})}\n',
      );
      expect((await requirementCheck(c)).status, 'INVALID');
      file.writeAsStringSync('${jsonEncode(record)}\n');
      f.file(
        'rules.md',
        '# Rules\n\n- MUST preserve privacy.\n- MUST test access.\n',
      );
      expect((await requirementCheck(c)).status, 'FAIL');
    },
  );
  test(
    'evidence cannot hide a changed parent or extra failing final check',
    () async {
      final f = Fixture();
      addTearDown(f.dispose);
      f.file('a', 'one');
      f.commit();
      final c = f.context(tree: f.git.tree);
      f.file('b', 'two');
      f.commit();
      expect(await c.unchanged(), isFalse);
    },
  );
}
