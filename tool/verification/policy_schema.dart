// metadata_version: 1
// purpose: Validate policy limits and toolchain settings before commands execute.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008, ADR-0009]
import 'policy.dart';
import 'schema.dart';
import 'registry_schema.dart';

void validatePolicy(Policy p) {
  final tool = p['toolchain'];
  keys(tool, {
    'flutter',
    'dart',
    'flutter_revision',
    'repository',
    'restore',
    'timeout_seconds',
    'evidence_max_age_seconds',
    'evidence_future_skew_seconds',
  });
  for (final k in ['flutter', 'dart', 'flutter_revision', 'repository']) {
    if (tool[k] is! String || (tool[k] as String).isEmpty) {
      throw FormatException('Missing toolchain $k');
    }
  }
  strings(tool['restore']);
  if ((tool['restore'] as List).take(2).join(' ') != 'pub get' ||
      !(tool['restore'] as List).contains('--enforce-lockfile')) {
    throw const FormatException('Dependency restore must enforce the lockfile');
  }
  positive(tool['timeout_seconds']);
  positive(tool['evidence_max_age_seconds']);
  positive(tool['evidence_future_skew_seconds']);
  final limits = p['limits'];
  keys(limits, {
    'code',
    'markdown',
    'adr',
    'code_extensions',
    'exclude_prefixes',
    'generated_patterns',
    'diff_algorithm',
    'rename_threshold',
  });
  for (final name in ['code', 'markdown', 'adr']) {
    final rule = Map<String, dynamic>.from(limits[name]);
    keys(rule, {'target', 'extension'});
    positive(rule['target']);
    positive(rule['extension']);
    if ((rule['target'] as int) > (rule['extension'] as int)) {
      throw const FormatException('Reversed size bounds');
    }
  }
  for (final k in [
    'code_extensions',
    'exclude_prefixes',
    'generated_patterns',
  ]) {
    strings(limits[k]);
  }
  if (!{
    'myers',
    'minimal',
    'patience',
    'histogram',
  }.contains(limits['diff_algorithm'])) {
    throw const FormatException('Unsupported diff algorithm');
  }
  positive(limits['rename_threshold']);
  if ((limits['rename_threshold'] as int) > 100) {
    throw const FormatException('Invalid rename threshold');
  }
  validateRegistries(p);
}
