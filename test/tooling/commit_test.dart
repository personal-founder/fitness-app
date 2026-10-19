// metadata_version: 1
// purpose: commit_test verifier regression coverage.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0009, ADR-0010, ADR-0011]
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/verification/changes.dart';
import '../../tool/verification/commit_message.dart';
import '../../tool/verification/ledger.dart';
import 'support.dart';

void main() {
  test('mode-only changes do not become fake text edits', () {
    final f = Fixture();
    addTearDown(f.dispose);
    f.file('mode.sh', 'echo fixture\n');
    f.commit();
    f.git.run(['update-index', '--chmod=+x', 'mode.sh']);
    final changes = stagedChanges(
      f.git,
      f.context().policy['limits'],
      f.git.parent,
    );
    expect(changes.single.action, 'Mode changed');
    expect(changes.single.added + changes.single.deleted, 0);
  });
  test('complete messages reconcile actual changed paths and line totals', () {
    final f = Fixture();
    addTearDown(f.dispose);
    f.file('a.txt', 'old\n');
    const adr = 'docs/adr/0007-shared-verifier.md';
    f.file(adr, File(adr).readAsStringSync());
    f.commit();
    f.file('a.txt', 'new\nmore\n');
    f.git.run(['add', '.']);
    final c = f.context(tree: f.git.tree);
    final changes = stagedChanges(f.git, c.policy['limits'], f.git.parent);
    final body = <String, String>{
      'File ledger':
          'Path | Action | Purpose and reason | LOC\n'
          'a.txt | Edited | Fix the text. | +2 -1 LOC\n'
          'Totals: 1 files; 1 edited; +2 -1 LOC; net +1.',
      'Verification':
          'Tree: ${c.identity['snapshot']}\nBase: ${c.identity['base']}',
      'Decisions and ADRs': 'a.txt | ADR-0007 | reused | Gate behavior.',
    };
    final message =
        'fix(tooling): verify candidate text\n\n${(c.policy['commit']['sections'] as List).map((s) => '$s\n${body[s] ?? '- No additional impact.'}\n').join('\n')}';
    expect(changes.single.added, 2);
    expect(messageErrors(message, c), isEmpty);
    expect(
      messageErrors(message.replaceFirst('+2 -1 LOC', '+20 -1 LOC'), c),
      isNotEmpty,
    );
    expect(
      messageErrors(
        message.replaceFirst('a.txt | Edited', 'missing | Edited'),
        c,
      ),
      isNotEmpty,
    );
    expect(
      messageErrors(message.replaceFirst('Rollback\n', ''), c),
      isNotEmpty,
    );
  });
  test('rename, removal, binary and whitespace paths come from NUL diffs', () {
    final f = Fixture();
    addTearDown(f.dispose);
    f.file('old name.txt', 'same\n');
    f.file('remove.txt', 'gone\n');
    f.commit();
    f.git.run(['mv', 'old name.txt', 'new name.txt']);
    f.git.run(['rm', 'remove.txt']);
    f.file('binary.bin').writeAsBytesSync([0, 1, 2]);
    f.git.run(['add', '.']);
    final changes = stagedChanges(
      f.git,
      f.context().policy['limits'],
      f.git.parent,
    );
    expect(
      changes.singleWhere((c) => c.action == 'Renamed').display,
      'old name.txt -> new name.txt',
    );
    final binary = changes.singleWhere((c) => c.binary);
    expect(binary.newBytes, 3);
    final rows = changes
        .map(
          (c) =>
              '${c.display} | ${c.action} | '
              'Reason; old=${c.oldBytes}B new=${c.newBytes}B | '
              '${c.binary ? 'LOC: N/A (binary)' : '+${c.added} -${c.deleted} LOC'}',
        )
        .join('\n');
    final ledger =
        'File ledger\n$rows\nTotals: 3 files; 1 added, 1 removed, '
        '1 renamed; +0 -1 LOC; net -1.\nVerification';
    expect(
      ledgerErrors(
        ledger,
        changes,
        allowedActions: List<String>.from(
          f.context().policy['commit']['actions'],
        ),
      ),
      isEmpty,
    );
  });
}
