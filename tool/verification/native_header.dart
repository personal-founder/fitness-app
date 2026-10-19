// metadata_version: 1
// purpose: Extract only metadata comments without consuming the underlying YAML, SQL, or code document.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008]
String? nativeHeader(String text, Set<String> allowed) {
  final lines = text.split('\n').take(30).toList();
  final prefix = RegExp(r'^\s*(?://|#|--)\s?');
  final start = lines.indexWhere(
    (l) =>
        prefix.hasMatch(l) &&
        l.replaceFirst(prefix, '').startsWith('metadata_version:'),
  );
  if (start < 0) return null;
  final fields = <String>[];
  for (final line in lines.skip(start)) {
    if (!prefix.hasMatch(line)) break;
    final content = line.replaceFirst(prefix, '').trim();
    if (!content.contains(':') || !allowed.contains(content.split(':').first)) {
      break;
    }
    fields.add(content);
  }
  return fields.join('\n');
}
