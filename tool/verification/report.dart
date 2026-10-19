// metadata_version: 1
// purpose: Persist snapshot-bound check evidence and print a concise gate summary.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008, ADR-0009]
import 'dart:io';

import 'context.dart';
import 'model.dart';
import 'diagnostics.dart';

void saveReport(Context c, List<Check> checks) {
  final result = gateExit(checks);
  final report = <String, dynamic>{
    'schema_version': 1,
    'identity': c.identity,
    'runner': Platform.operatingSystem,
    'gate_exit': result,
    'created_at': DateTime.now().toUtc().toIso8601String(),
    'checks': checks.map((v) => v.toJson()).toList(),
    'source': Platform.environment['GITHUB_ACTIONS'] == 'true'
        ? 'github-actions'
        : 'local',
    'run_id': Platform.environment['GITHUB_RUN_ID'],
    'shard': c.options['shard'],
    'limitations': [
      'Structural checks do not verify manual requirements, live backend security, devices, signing or publication.',
      for (final check in checks.where((v) => v.status != 'PASS'))
        '${check.id}: ${check.status}',
    ],
  };
  writeJson(c.output, report);
  for (final check in checks) {
    stdout.writeln(
      '${check.status.padRight(7)} ${check.id}: '
      '${redacted(check.detail).split('\n').first}',
    );
  }
  stdout.writeln('Gate exit $result; evidence: ${c.output}');
}
