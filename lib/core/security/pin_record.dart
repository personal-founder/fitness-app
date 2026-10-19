// metadata_version: 1
// purpose: "Versioned, account-scoped secure record; corrupt/unknown formats fail closed."
// owner: unassigned
// related_adrs: [ADR-0018, ADR-0033, ADR-0032]
import 'dart:convert';

class PinRecord {
  PinRecord(
    this.salt,
    this.verifier, {
    this.failures = 0,
    this.blockedUntil = 0,
    this.version = 2,
  });
  final String salt, verifier;
  final int version;
  int failures, blockedUntil;
  String encode() => jsonEncode({
    'v': version,
    if (version == 2) 'length': 4,
    'salt': salt,
    'hash': verifier,
    'failures': failures,
    'until': blockedUntil,
  });
  factory PinRecord.decode(String value) {
    final data = jsonDecode(value) as Map<String, dynamic>;
    if ((data['v'] != 1 && data['v'] != 2) ||
        (data['v'] == 2 && data['length'] != 4) ||
        base64Decode(data['salt'] as String).length != 32 ||
        base64Decode(data['hash'] as String).length != 32 ||
        (data['failures'] as int) < 0) {
      throw const FormatException('Lock record');
    }
    return PinRecord(
      data['salt'] as String,
      data['hash'] as String,
      failures: data['failures'] as int,
      blockedUntil: data['until'] as int,
      version: data['v'] as int,
    );
  }
}
