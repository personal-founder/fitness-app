// metadata_version: 1
// purpose: Reject stale, malformed, inconsistent, or impossible platform evidence.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008, ADR-0011]
import 'dart:convert';
import 'dart:io';

import 'context.dart';
import 'model.dart';
import 'schema.dart';

String canonical(Object? value) {
  if (value is Map) {
    final keys = value.keys.map((k) => k.toString()).toList()..sort();
    return '{${keys.map((k) => '${jsonEncode(k)}:${canonical(value[k])}').join(',')}}';
  }
  if (value is List) return '[${value.map(canonical).join(',')}]';
  return jsonEncode(value);
}

List<Check> receiptChecks(Json report, Context c) {
  try {
    return _receiptChecks(report, c);
  } on TypeError {
    throw const FormatException('Receipt fields have invalid types');
  }
}

List<Check> _receiptChecks(Json report, Context c) {
  keys(
    report,
    {
      'schema_version',
      'identity',
      'runner',
      'gate_exit',
      'created_at',
      'checks',
      'source',
      'run_id',
      'shard',
    },
    {'limitations'},
  );
  if (report.containsKey('limitations')) strings(report['limitations']);
  if (report['schema_version'] != 1 ||
      canonical(report['identity']) != canonical(c.identity) ||
      !{'windows', 'linux', 'macos'}.contains(report['runner']) ||
      !{'local', 'github-actions'}.contains(report['source'])) {
    throw const FormatException('Untrusted or stale receipt identity');
  }
  final created = DateTime.tryParse(report['created_at'].toString());
  final age = created == null
      ? null
      : DateTime.now().toUtc().difference(created);
  final maxAge = c.policy['toolchain']['evidence_max_age_seconds'] as int;
  final skew = c.policy['toolchain']['evidence_future_skew_seconds'] as int;
  if (age == null || age.inSeconds < -skew || age.inSeconds > maxAge) {
    throw const FormatException('Receipt is expired or future-dated');
  }
  final checks = <Check>[], seen = <String>{};
  for (final value in report['checks'] as List) {
    final v = Map<String, dynamic>.from(value);
    keys(v, {'id', 'status', 'detail', 'seconds', 'command'});
    strings(v['command']);
    if (v['id'] is! String ||
        !seen.add(v['id']) ||
        v['detail'] is! String ||
        !{'PASS', 'FAIL', 'BLOCKED', 'INVALID'}.contains(v['status']) ||
        v['seconds'] is! num ||
        v['seconds'] < 0) {
      throw const FormatException('Malformed receipt check');
    }
    if ((v['id'] as String).startsWith('build:') && v['status'] == 'PASS') {
      final platform = (v['id'] as String).substring(6);
      final spec = c.policy['platforms'][platform];
      if (spec == null || !(spec['hosts'] as List).contains(report['runner'])) {
        throw const FormatException('Receipt claims an impossible host build');
      }
    }
    checks.add(
      Check(
        v['id'],
        v['status'],
        v['detail'],
        seconds: (v['seconds'] as num).toDouble(),
        command: List<String>.from(v['command']),
      ),
    );
  }
  if (report['gate_exit'] != gateExit(checks)) {
    throw const FormatException('Receipt summary contradicts checks');
  }
  return checks;
}

List<Check> importReceipts(String path, Context c) {
  final directory = Directory(path);
  if (!directory.existsSync()) return [];
  return directory
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.json'))
      .expand((f) => receiptChecks(readJson(f.path), c))
      .toList();
}
