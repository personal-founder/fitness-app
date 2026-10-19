// metadata_version: 1
// purpose: Reconcile each commit ledger row and total against the actual staged diff.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008, ADR-0011]
import 'changes.dart';

List<String> ledgerErrors(
  String text,
  List<Change> changes, {
  required List<String> allowedActions,
}) {
  final errors = <String>[];
  final ledger = text.split('File ledger').last.split('Verification').first;
  final rows = ledger.split('\n').where((l) => l.contains(' | ')).toList();
  final matched = <String>{};
  for (final row in rows) {
    final parts = row.split(' | ').map((p) => p.trim()).toList();
    if (parts.first == 'Path') continue;
    if (parts.length != 4 || parts[2].isEmpty) {
      errors.add('Malformed ledger row');
      continue;
    }
    final found = changes.where((c) => c.display == parts[0]);
    if (found.length != 1 || !matched.add(parts[0])) {
      errors.add('Unexpected or duplicate ledger path: ${parts[0]}');
      continue;
    }
    final c = found.single;
    if (!allowedActions.contains(parts[1])) {
      errors.add('Unsupported ledger action');
    }
    if (c.action != parts[1]) errors.add('Wrong action: ${c.path}');
    if (c.binary) {
      if (!parts[3].contains('N/A') || !parts[3].contains('binary')) {
        errors.add('Binary LOC must be N/A: ${c.path}');
      }
      if (!parts[2].contains('old=${c.oldBytes}B new=${c.newBytes}B')) {
        errors.add('Binary purpose must include correct old/new byte sizes');
      }
    } else if (parts[3] != '+${c.added} -${c.deleted} LOC') {
      errors.add('Incorrect LOC: ${c.path}');
    }
    if (c.lfsOid != null && !parts[2].contains('LFS sha256:${c.lfsOid}')) {
      errors.add('LFS pointer must identify its asset object');
    }
  }
  if (matched.length != changes.length) errors.add('Incomplete file ledger');
  final added = changes.fold(0, (n, c) => n + c.added);
  final deleted = changes.fold(0, (n, c) => n + c.deleted);
  final totals = RegExp(
    r'Totals: (\d+) files?;[^\n]*\+(\d+) -(\d+) LOC; net ([+-]?\d+)',
  ).firstMatch(ledger);
  if (totals == null ||
      int.parse(totals[1]!) != changes.length ||
      int.parse(totals[2]!) != added ||
      int.parse(totals[3]!) != deleted ||
      int.parse(totals[4]!) != added - deleted) {
    errors.add('Incorrect ledger totals');
  }
  for (final action in changes.map((c) => c.action).toSet()) {
    final count = changes.where((c) => c.action == action).length;
    final word = switch (action) {
      'Edited' => 'edited',
      'Added' => 'added',
      'Removed' => 'removed',
      'Renamed' => 'renamed',
      'Copied' => 'copied',
      'Mode changed' => 'mode changed',
      _ => 'type changed',
    };
    if (totals != null && !RegExp('\\b$count $word\\b').hasMatch(totals[0]!)) {
      errors.add('Incorrect action total: $word');
    }
  }
  return errors;
}
