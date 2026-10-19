// metadata_version: 1
// purpose: Explicitly refresh source-linked rule records without claiming their implementation.
// owner: unassigned
// related_adrs: [ADR-0006, ADR-0008]
import 'dart:convert';
import 'dart:io';

import 'verification/model.dart';
import 'verification/policy.dart';
import 'verification/requirements.dart';
import 'verification/requirement_defaults.dart';

Future<void> main() async {
  final root = Directory.current.path;
  final policy = Policy.load(root);
  final directory = Directory(safePath(root, policy.main['requirements_dir']));
  final previous = <String, Json>{};
  final owned = directory
      .listSync()
      .whereType<File>()
      .where((f) => RegExp(r'mandatory-\d{4}\.jsonl$').hasMatch(f.path))
      .toList();
  for (final file in owned) {
    for (final line in file.readAsLinesSync().where((v) => v.isNotEmpty)) {
      final value = Map<String, dynamic>.from(jsonDecode(line));
      previous[value['id']] = value;
    }
  }
  final records = await inventory(
    root,
    List<String>.from(policy.main['policy_sources']),
  );
  final keep = <String>{};
  final width = policy['limits']['code']['target'] as int;
  for (var i = 0; i < records.length; i += width) {
    final name =
        'mandatory-${(i ~/ width + 1).toString().padLeft(4, '0')}.jsonl';
    final file = File('${directory.path}/$name');
    keep.add(name);
    final rows = records
        .skip(i)
        .take(width)
        .map(
          (record) => jsonEncode({
            ...requirementDefaults(record),
            ...?previous[record['id']],
            ...record,
          }),
        )
        .join('\n');
    file.writeAsStringSync('$rows\n');
    File('${file.path}.meta.yaml').writeAsStringSync(
      'metadata_version: 1\ntarget: $name\n'
      'purpose: Register mandatory-rule evidence without inferring compliance.\n'
      'owner: unassigned\nrelated_adrs: [ADR-0006, ADR-0008]\n'
      'generated_by: dart tool/refresh_requirements.dart\n',
    );
  }
  for (final file in owned.where(
    (f) => !keep.contains(f.uri.pathSegments.last),
  )) {
    file.deleteSync();
    final sidecar = File('${file.path}.meta.yaml');
    if (sidecar.existsSync()) sidecar.deleteSync();
  }
  stdout.writeln(
    'Registered ${records.length} mandatory source statements; unknown evidence stays unverified.',
  );
}
