// metadata_version: 1
// purpose: Validate metadata, ADR, commit, command, platform, and exception registries.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008, ADR-0009]
import 'policy.dart';
import 'schema.dart';

void validateRegistries(Policy p) {
  final meta = p['metadata'], adr = p['adr'], commit = p['commit'];
  keys(meta, {
    'required',
    'optional',
    'version',
    'sidecar_suffix',
    'adrs',
    'template',
  });
  strings(meta['required']);
  strings(meta['optional']);
  positive(meta['version']);
  for (final k in ['sidecar_suffix', 'adrs', 'template']) {
    if (meta[k] is! String) throw FormatException('Invalid metadata $k');
  }
  keys(adr, {
    'required',
    'statuses',
    'implementations',
    'headings',
    'template_version',
    'index',
  });
  for (final k in ['required', 'statuses', 'implementations', 'headings']) {
    strings(adr[k]);
  }
  positive(adr['template_version']);
  if (adr['index'] is! String) throw const FormatException('Missing ADR index');
  keys(commit, {
    'types',
    'sections',
    'actions',
    'forbidden_patterns',
    'subject_max',
  });
  for (final k in ['types', 'sections', 'actions', 'forbidden_patterns']) {
    strings(commit[k]);
  }
  for (final pattern in commit['forbidden_patterns']) {
    RegExp(pattern);
  }
  positive(commit['subject_max']);
  keys(p['checks'], {
    'format',
    'analysis',
    'tooling',
    'application',
    'integration',
  });
  validateCommands(p['checks']);
  keys(p['platforms'], {'web', 'android', 'ios', 'windows', 'macos', 'linux'});
  validateCommands(p['platforms'], platforms: true);
  keys(p['exceptions'], {'files'});
  keys(p['requirements'], {'required', 'enforcements', 'statuses'});
  for (final key in ['required', 'enforcements', 'statuses']) {
    strings(p['requirements'][key]);
  }
  if (p['exceptions']['files'] is! List) {
    throw const FormatException('Invalid exception list');
  }
  for (final v in p['exceptions']['files']) {
    final e = Map<String, dynamic>.from(v);
    keys(e, {'path', 'max_lines', 'reason', 'adr'});
    positive(e['max_lines']);
    for (final k in ['path', 'reason', 'adr']) {
      if (e[k] is! String || (e[k] as String).isEmpty) {
        throw const FormatException('Incomplete exception');
      }
    }
  }
}
