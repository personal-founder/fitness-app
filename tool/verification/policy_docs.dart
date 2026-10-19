// metadata_version: 1
// purpose: Compare each published size-bound row with its executable policy values.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008, ADR-0009]
import 'dart:io';

import 'context.dart';
import 'model.dart';

Check policyDocumentation(Context c) {
  final problems = <String>[];
  final limits = c.policy['limits'];
  final standards = File('${c.root}/docs/engineering-standards.md');
  if (!standards.existsSync()) {
    return Check(
      'policy:documentation',
      'BLOCKED',
      'Missing engineering standards',
    );
  }
  final text = standards.readAsStringSync();
  const labels = {
    'code': 'Human-maintained code',
    'markdown': 'Markdown documentation',
    'adr': 'Complete ADRs',
  };
  for (final kind in labels.keys) {
    final row = text.split('\n').where((line) => line.contains(labels[kind]!));
    final target = limits[kind]['target'] as int;
    final extension = limits[kind]['extension'] as int;
    final expected = 'Fewer than ${target + 1} lines: maximum $target';
    if (row.length != 1 ||
        !row.single.contains(expected) ||
        (kind != 'adr' &&
            !row.single.contains('${target + 1}–$extension lines inclusive'))) {
      problems.add('$kind size bounds differ from published standards');
    }
  }
  final template = File('${c.root}/${c.policy['metadata']['template']}');
  if (!template.existsSync()) problems.add('Missing ADR template');
  return Check(
    'policy:documentation',
    problems.isEmpty ? 'PASS' : 'FAIL',
    problems.isEmpty
        ? 'Policy limits align with published standards'
        : problems.join('\n'),
  );
}
