// metadata_version: 1
// purpose: Validate ADR identity, lifecycle fields, headings, and references.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008]
import 'dart:io';

import 'metadata.dart';
import 'model.dart';
import 'policy.dart';
import 'schema.dart';

Map<String, String> adrIds(String root, Policy p) {
  final directory = Directory(safePath(root, p['metadata']['adrs']));
  final result = <String, String>{};
  if (!directory.existsSync()) return result;
  for (final f in directory.listSync().whereType<File>()) {
    final match = RegExp(r'^(\d{4})-[\w-]+\.md$')
        .firstMatch(f.uri.pathSegments.last);
    if (match == null) continue;
    final id = 'ADR-${match[1]}';
    if (result.containsKey(id)) throw FormatException('Duplicate ADR $id');
    result[id] = f.path;
  }
  return result;
}

List<String> adrErrors(String root, String path, Policy p, Set<String> ids) {
  final m = fileMetadata(root, path, p);
  if (m == null) return ['ADR metadata absent'];
  final errors = <String>[], rule = p['adr'];
  for (final key in rule['required']) {
    if (!m.containsKey(key)) errors.add('Missing ADR field: $key');
  }
  if (!(rule['statuses'] as List).contains(m['status'])) {
    errors.add('ADR status');
  }
  if (!(rule['implementations'] as List).contains(m['implementation'])) {
    errors.add('ADR implementation state');
  }
  if (m['template_version'] != rule['template_version']) {
    errors.add('ADR template');
  }
  if (path != p['metadata']['template']) {
    final filename = path.split('/').last;
    if (m['id'] != 'ADR-${filename.split('-').first}') {
      errors.add('ADR identity');
    }
    final date = m['date'].toString(),
        parsed = DateTime.tryParse(m['date'].toString());
    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(date) ||
        parsed == null ||
        parsed.toIso8601String().substring(0, 10) != date) {
      errors.add('ADR date');
    }
    for (final key in ['title', 'decision_basis']) {
      if (m[key] is! String || (m[key] as String).trim().isEmpty) {
        errors.add('Missing $key');
      }
    }
  }
  for (final key in ['supersedes', 'superseded_by']) {
    try {
      strings(m[key]);
      for (final id in m[key]) {
        if (!ids.contains(id) || id == m['id']) errors.add('ADR relationship');
      }
    } on FormatException {
      errors.add('Invalid ADR relationships');
    }
  }
  final text = File(safePath(root, path)).readAsStringSync();
  final headings = RegExp(
    r'^## (.+)$',
    multiLine: true,
  ).allMatches(text).map((m) => m[1]!.trim()).toList();
  if (headings.join('|') != (rule['headings'] as List).join('|')) {
    errors.add('Missing or reordered ADR sections');
  }
  if (path != p['metadata']['template'] &&
      RegExp(r'<[^>\n]+>|ADR-NNNN').hasMatch(text)) {
    errors.add('ADR placeholders');
  }
  return errors;
}
