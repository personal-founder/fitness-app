// metadata_version: 1
// purpose: Seed concrete source-specific review methods without inventing verified compliance.
// owner: unassigned
// related_adrs: [ADR-0006, ADR-0008]
import 'model.dart';

Json requirementDefaults(Json record) {
  final source = record['source'] as String;
  var method =
      'Review task authorization, scope and source changes against this instruction; inspect exact verifier evidence.';
  String? evidence;
  var enforcement = 'manual';
  if (source.endsWith('file-metadata.md')) {
    method = 'Run policy:files; manually confirm purpose, owner, placement and provenance against the actual file.';
    evidence = 'test/tooling/metadata_test.dart';
    enforcement = 'partial';
  } else if (source.endsWith('atomic-and-adr-policy.md')) {
    method = 'Run ADR structure/reference checks; review one independently reversible choice, authority and traceability.';
    evidence = 'test/tooling/adr_test.dart';
    enforcement = 'partial';
  } else if (source.endsWith('commit-standard.md')) {
    method = 'Run staged gate and commit-msg checks; reconcile Git ledger and review rationale, risks and exclusions.';
    evidence = 'test/tooling/commit_test.dart';
    enforcement = 'partial';
  } else if (source.endsWith('verification.md')) {
    method = 'Run verifier regression tests; inspect snapshot-bound check results, installed hooks and native-runner evidence.';
    evidence = 'docs/changes/verification-implementation.md';
    enforcement = 'partial';
  } else if (source.endsWith('engineering-improvements.md')) {
    method = 'Compare tracker acceptance criteria with recorded test outcomes, available artifacts and hosted-run evidence.';
    evidence = 'docs/changes/verification-implementation.md';
    enforcement = 'partial';
  } else if (source.endsWith('engineering-standards.md')) {
    method = 'Review implementation evidence for applicable security, privacy, recovery and release controls; run relevant negative tests.';
  } else if (source.endsWith('core-principles.md')) {
    method = 'Review actual diff for reuse/cohesion and preserved contracts; run relevant behavior and regression checks.';
  }
  if ((record['rule'] as String).contains('File size')) {
    method = 'Run policy:files and policy:documentation; inspect the size exception and its governing ADR.';
    evidence = 'test/tooling/metadata_test.dart';
    enforcement = 'partial';
  }
  return {
    'verification': method,
    'evidence': evidence,
    'enforcement': enforcement,
    'status': 'unverified',
  };
}
