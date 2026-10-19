// metadata_version: 1
// purpose: Keep literal asset paths representable without allowing email prose.
// owner: unassigned
// related_adrs: [ADR-0011, ADR-0047]
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/verification/changes.dart';
import '../../tool/verification/commit_message.dart';
import 'support.dart';

void main() {
  test('asset at-sign paths round-trip while email prose remains forbidden', () {
    final f = Fixture();
    addTearDown(f.dispose);
    // Reuse an existing fixture decision rather than inventing an approved ID.
    const known = 'docs/adr/0007-shared-verifier.md';
    f.file(known, File(known).readAsStringSync());
    f.commit();
    const path = 'Icon-App-20x20@2x.png';
    f.file(path, 'synthetic text fixture\n');
    f.git.run(['add', '.']);
    final c = f.context(tree: f.git.tree);
    final change = stagedChanges(
      f.git,
      c.policy['limits'],
      f.git.parent,
    ).single;
    expect(jsonDecode(change.display), path);
    expect(change.display, contains(r'\u0040'));
    final body = {
      'File ledger':
          '${change.display} | Added | Record the fixture. | +1 -0 LOC\n'
          'Totals: 1 files; 1 added; +1 -0 LOC; net +1.',
      'Verification': '${c.identity['snapshot']} ${c.identity['base']}',
      'Decisions and ADRs': '${change.display} | ADR-0007 | Reused.',
    };
    final message =
        'test(tooling): preserve platform asset path ledgers\n\n'
        '${(c.policy['commit']['sections'] as List).map((s) => '$s\n${body[s] ?? 'No additional impact.'}\n').join('\n')}';
    expect(messageErrors(message, c), isEmpty);
    expect(
      messageErrors(
        message.replaceFirst('No additional impact.', 'person@example.com'),
        c,
      ),
      contains('Forbidden attribution or unresolved placeholder'),
    );
  });
}
