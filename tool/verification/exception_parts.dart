// metadata_version: 1
// purpose: Load bounded exception fragments without duplicating policy values.
// owner: unassigned
// related_adrs: [ADR-0008]
import 'model.dart';
import 'schema.dart';

Json exceptionParts(String root, Json entry, List<String> files) {
  keys(entry, {'files'}, {'includes'});
  if (entry['files'] is! List) {
    throw const FormatException('Exception array required');
  }
  final merged = List<dynamic>.from(entry['files']);
  if (entry.containsKey('includes')) {
    strings(entry['includes']);
    for (final ref in entry['includes']) {
      if (files.contains(ref)) {
        throw const FormatException('Duplicate policy reference');
      }
      final part = readJson(safePath(root, ref));
      keys(part, {'files'});
      if (part['files'] is! List) {
        throw const FormatException('Exception fragment array required');
      }
      merged.addAll(part['files']);
      files.add(ref);
    }
  }
  final paths = <String>{};
  for (final row in merged) {
    if (row is! Map || row['path'] is! String || !paths.add(row['path'])) {
      throw const FormatException('Invalid or duplicate exception path');
    }
    safePath(root, row['path']);
  }
  return {'files': merged};
}
