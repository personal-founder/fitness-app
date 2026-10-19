// metadata_version: 1
// purpose: Detect missing or stale mandatory-rule evidence records without claiming compliance.
// owner: unassigned
// related_adrs: [ADR-0006, ADR-0007, ADR-0010]
import 'dart:convert';
import 'dart:io';

import 'context.dart';
import 'digest.dart';
import 'model.dart';
import 'schema.dart';

Future<List<Json>> inventory(String root, List<String> sources) async {
  final records = <Json>[], seen = <String>{};
  for (final path in sources) {
    final lines = File(safePath(root, path)).readAsLinesSync();
    var fenced = false, content = false;
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.startsWith('# ')) content = true;
      if (line.startsWith('```')) {
        fenced = !fenced;
        continue;
      }
      if (!content || fenced || line.startsWith('#')) continue;
      if (!RegExp(r'^(?:- |\d+\. )|\b(?:MUST|must|required|Never|Do not)\b')
          .hasMatch(line)) {
        continue;
      }
      final id = await hashBytes(utf8.encode('$path\n$line'));
      if (seen.add(id)) {
        records.add({'id': id, 'source': path, 'line': i + 1, 'rule': line});
      }
    }
  }
  return records;
}

Future<Check> requirementCheck(Context c) async {
  try {
    final expected = await inventory(
      c.root,
      List<String>.from(c.policy.main['policy_sources']),
    );
    final found = <String, Json>{};
    final dir = Directory(safePath(c.root, c.policy.main['requirements_dir']));
    var unknown = 0;
    for (final file in dir.listSync().whereType<File>().where(
      (f) => f.path.endsWith('.jsonl'),
    )) {
      for (final line in file.readAsLinesSync().where((v) => v.isNotEmpty)) {
        final record = Map<String, dynamic>.from(jsonDecode(line));
        keys(record, Set<String>.from(c.policy['requirements']['required']));
        if (found.containsKey(record['id']) ||
            !(c.policy['requirements']['enforcements'] as List).contains(
              record['enforcement'],
            ) ||
            !(c.policy['requirements']['statuses'] as List).contains(
              record['status'],
            ) ||
            record['verification'] is! String ||
            (record['verification'] as String).isEmpty) {
          throw const FormatException('Invalid requirement record');
        }
        if (record['status'] == 'verified' &&
            (record['evidence'] is! String ||
                !File(safePath(c.root, record['evidence'])).existsSync())) {
          throw const FormatException('Verified rule lacks available evidence');
        }
        if (record['status'] == 'unverified') unknown++;
        found[record['id']] = record;
      }
    }
    if (found.length != expected.length ||
        expected.any(
          (v) =>
              found[v['id']] == null ||
              found[v['id']]!['source'] != v['source'] ||
              found[v['id']]!['rule'] != v['rule'] ||
              found[v['id']]!['line'] != v['line'],
        )) {
      return Check(
        'policy:requirements',
        'FAIL',
        'Mandatory-rule register is missing or stale; review and refresh it',
      );
    }
    return Check(
      'policy:requirements',
      'PASS',
      'Inventory complete: ${found.length} rules; $unknown visibly unverified. '
          'Inventory validation does not verify these requirements.',
    );
  } catch (e) {
    return Check('policy:requirements', 'INVALID', '$e');
  }
}
