// metadata_version: 1
// purpose: Require complete evidence and prevent a passing shard from masking failures.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008, ADR-0011]
import 'context.dart';
import 'model.dart';

Set<String> requiredChecks(Context c) => {
  'dependencies',
  'format',
  'analysis',
  'tooling',
  'application',
  'integration',
  'policy:files',
  'policy:legacy',
  'policy:requirements',
  'policy:documentation',
  'git:whitespace',
  'snapshot',
  for (final p in c.policy['platforms'].keys) 'build:$p',
};

List<Check> combine(Context c, List<Check> checks) {
  final result = <Check>[];
  for (final id in requiredChecks(c)) {
    final matches = checks.where((v) => v.id == id).toList();
    final fail = matches.where(
      (v) => v.status == 'FAIL' || v.status == 'INVALID',
    );
    if (fail.isNotEmpty) {
      result.add(fail.first);
    } else {
      final passes = matches.where((v) => v.status == 'PASS');
      result.add(
        passes.isNotEmpty
            ? passes.first
            : matches.isNotEmpty
            ? matches.first
            : Check(id, 'BLOCKED', 'Required evidence missing'),
      );
    }
  }
  result.addAll(
    checks.where(
      (v) => !requiredChecks(c).contains(v.id) && v.status != 'PASS',
    ),
  );
  return result;
}
