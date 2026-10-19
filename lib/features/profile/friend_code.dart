// metadata_version: 1
// purpose: Version the future friendship QR contract without exposing private identifiers.
// owner: unassigned
// related_adrs: [ADR-0036]
String friendCode(String tag) {
  if (!RegExp(r'^#[A-Z]{2}[0-9]{4}$').hasMatch(tag)) {
    throw const FormatException('Account tag');
  }
  return Uri(
    scheme: 'macroapp',
    host: 'friend',
    queryParameters: {'v': '1', 'tag': tag},
  ).toString();
}
