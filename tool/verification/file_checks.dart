// metadata_version: 1
// purpose: Block changed-file policy defects and report untouched adoption findings.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008]
import 'dart:convert';
import 'dart:io';

import 'adr_checks.dart';
import 'context.dart';
import 'links.dart';
import 'metadata.dart';
import 'model.dart';

List<Check> inspectFiles(Context c) {
  final errors = <String>[], legacy = <String>[];
  final ids = adrIds(c.root, c.policy);
  final limits = c.policy['limits'],
      exceptions = c.policy['exceptions']['files'];
  final changed = c.changed.toSet();
  final index = File(safePath(c.root, c.policy['adr']['index']));
  final indexText = index.existsSync() ? index.readAsStringSync() : '';
  for (final path in c.files) {
    if ((limits['exclude_prefixes'] as List).any((v) => path.startsWith(v))) {
      continue;
    }
    final file = File(safePath(c.root, path));
    if (!file.existsSync()) continue;
    final findings = <String>[];
    try {
      findings.addAll(metadataErrors(c.root, path, c.policy, ids.keys.toSet()));
      final adr =
          ids.values.contains(file.path) ||
          path == c.policy['metadata']['template'];
      if (adr) {
        findings.addAll(adrErrors(c.root, path, c.policy, ids.keys.toSet()));
        if (path != c.policy['metadata']['template'] &&
            !indexText.contains(path.split('/').last)) {
          findings.add('ADR index');
        }
      }
      final bytes = file.readAsBytesSync();
      if (!bytes.contains(0)) {
        try {
          final text = utf8.decode(bytes);
          final lines = const LineSplitter().convert(text).length;
          final type = adr
              ? 'adr'
              : path.endsWith('.md') || path.endsWith('.txt')
              ? 'markdown'
              : 'code';
          final generated =
              (limits['generated_patterns'] as List).any(
                (v) => path.endsWith(v),
              ) &&
              fileMetadata(c.root, path, c.policy)?['generated_by'] is String;
          final bound = limits[type] as Map;
          final exception = (exceptions as List).where(
            (e) => e['path'] == path,
          );
          if (!generated && lines > bound['target']) {
            final allowed =
                !adr &&
                exception.length == 1 &&
                lines <= exception.single['max_lines'] &&
                ids.containsKey(exception.single['adr']) &&
                (exception.single['reason'] as String).trim().isNotEmpty;
            if (!allowed) {
              findings.add('$lines lines; target ${bound['target']}');
            }
          }
          if (RegExp(
            r'^(<<<<<<<|=======|>>>>>>>)',
            multiLine: true,
          ).hasMatch(text)) {
            findings.add('Conflict markers');
          }
          findings.addAll(linkErrors(c.root, path));
        } on FormatException {
          /* Binary assets use sidecars without text checks. */
        }
      }
    } catch (e) {
      findings.add('Invalid file metadata/structure: $e');
    }
    for (final error in findings) {
      (changed.contains(path) ? errors : legacy).add('$path: $error');
    }
  }
  return [
    Check(
      'policy:files',
      errors.isEmpty ? 'PASS' : 'FAIL',
      errors.isEmpty ? 'Changed files satisfy policy' : errors.join('\n'),
    ),
    Check(
      'policy:legacy',
      'PASS',
      '${legacy.length} existing findings (not compliance):\n${legacy.join('\n')}',
    ),
  ];
}
