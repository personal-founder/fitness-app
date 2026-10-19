// metadata_version: 1
// purpose: diagnostics verification responsibility.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008, ADR-0009]
String redacted(String text) {
  var result = text.replaceAll(RegExp(r'\x1B\[[0-9;]*[A-Za-z]'), '');
  result = result.replaceAllMapped(
    RegExp(
      r'(password|token|secret|api[_-]?key|authorization)(\s*[:=]\s*)[^\s,}]+',
      caseSensitive: false,
    ),
    (m) => '${m[1]}${m[2]}[redacted]',
  );
  result = result.replaceAll(
    RegExp(r'eyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+'),
    '[redacted-jwt]',
  );
  return result.length > 65536
      ? '${result.substring(0, 65536)}\n[truncated]'
      : result;
}
