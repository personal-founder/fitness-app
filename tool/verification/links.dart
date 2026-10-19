// metadata_version: 1
// purpose: Check local documentation links and heading references within the repository.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008]
import 'dart:io';

import 'model.dart';

List<String> linkErrors(String root, String path) {
  if (!path.endsWith('.md')) return [];
  final errors = <String>[], file = File(safePath(root, path));
  final text = file.readAsStringSync();
  for (final m in RegExp(r'\[[^\]]+\]\(([^)]+)\)').allMatches(text)) {
    final target = m[1]!;
    if (RegExp(r'^[a-zA-Z][a-zA-Z0-9+.-]*:').hasMatch(target) ||
        target.contains('<')) {
      continue;
    }
    final pair = target.split('#');
    try {
      final base = file.parent.uri.resolve(Uri.decodeComponent(pair.first));
      final repo = Directory(root).absolute.uri.path;
      if (!base.path.startsWith(repo)) {
        throw const FormatException('Outside root');
      }
      final linked = File.fromUri(base);
      if (Directory.fromUri(base).existsSync() && pair.length == 1) continue;
      if (!linked.existsSync()) {
        errors.add('Broken link: $target');
        continue;
      }
      if (pair.length > 1 && linked.path.endsWith('.md')) {
        final anchors = RegExp(r'^#{1,6} (.+)$', multiLine: true)
            .allMatches(linked.readAsStringSync())
            .map(
              (h) => h[1]!
                  .toLowerCase()
                  .replaceAll(RegExp(r'[^\w\s-]'), '')
                  .replaceAll(' ', '-'),
            );
        if (!anchors.contains(pair[1])) errors.add('Broken anchor: $target');
      }
    } on FormatException {
      errors.add('Unsafe link: $target');
    }
  }
  return errors;
}
