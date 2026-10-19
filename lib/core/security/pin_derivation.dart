// metadata_version: 1
// purpose: "Derive a salted verifier off the UI isolate; no plaintext PIN is persisted."
// owner: unassigned
// related_adrs: [ADR-0018]
import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';

const pinIterations = 600000;
Future<String> derivePin(String pin, String salt) =>
    compute(_derive, [pin, salt]);
Future<String> _derive(List<String> values) async {
  final algorithm = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: pinIterations,
    bits: 256,
  );
  final key = await algorithm.deriveKey(
    secretKey: SecretKey(utf8.encode(values[0])),
    nonce: base64Decode(values[1]),
  );
  return base64Encode(await key.extractBytes());
}

bool equalVerifier(String left, String right) {
  final a = base64Decode(left), b = base64Decode(right);
  if (a.length != b.length) return false;
  var difference = 0;
  for (var i = 0; i < a.length; i++) {
    difference |= a[i] ^ b[i];
  }
  return difference == 0;
}
