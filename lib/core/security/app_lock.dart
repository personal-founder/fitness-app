// metadata_version: 1
// purpose: "Native lock boundary with persistent throttling; OS compromise is out of scope."
// owner: unassigned
// related_adrs: [ADR-0018, ADR-0019, ADR-0032, ADR-0033]
import 'dart:convert';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

import '../auth/auth_gateway.dart';
import 'pin_derivation.dart';
import 'pin_record.dart';
import 'pin_policy.dart';
import 'vault.dart';

final appLockProvider = Provider<AppLock>(
  (ref) => NativeAppLock(PlatformVault()),
);

abstract interface class AppLock {
  bool get supported;
  Future<bool> enrolled(String id);
  Future<bool> requiresReauthentication(String id);
  Future<void> enroll(
    String id,
    String pin, {
    required String tag,
    bool replaceLegacy = false,
  });
  Future<bool> verify(String id, String pin);
  Future<bool> biometric();
  Future<void> clear(String id);
}

class NativeAppLock implements AppLock {
  NativeAppLock(
    this.vault, {
    this.derive = derivePin,
    DateTime Function()? clock,
  }) : now = clock ?? DateTime.now;
  final Vault vault;
  final Future<String> Function(String, String) derive;
  final DateTime Function() now;
  bool _busy = false;
  String key(String id) => 'macro.lock.v1.$id';
  @override
  bool get supported => supportsLocalLock;
  @override
  Future<bool> enrolled(String id) async {
    final value = await vault.read(key(id));
    return value != null && PinRecord.decode(value).version == 2;
  }

  @override
  Future<bool> requiresReauthentication(String id) async {
    final value = await vault.read(key(id));
    return value != null && PinRecord.decode(value).version == 1;
  }

  @override
  Future<void> enroll(
    String id,
    String pin, {
    required String tag,
    bool replaceLegacy = false,
  }) async {
    final error = PinPolicy.enrollmentError(pin, tag);
    if (error != null) throw AuthFailure(error);
    if (await enrolled(id) ||
        (await requiresReauthentication(id) && !replaceLegacy)) {
      throw const AuthFailure('Sign out to reset your passcode.');
    }
    final salt = base64Encode(
      List.generate(32, (_) => Random.secure().nextInt(256)),
    );
    await vault.write(
      key(id),
      PinRecord(salt, await derive(pin, salt)).encode(),
    );
  }

  @override
  Future<bool> verify(String id, String pin) async {
    if (_busy) return false;
    _busy = true;
    try {
      final record = PinRecord.decode((await vault.read(key(id)))!);
      if (record.version != 2) {
        throw const AuthFailure('Sign in again to update your passcode.');
      }
      if (!PinPolicy.validSyntax(pin)) return false;
      if (record.blockedUntil > now().millisecondsSinceEpoch) {
        throw const AuthFailure(
          'Too many attempts. Wait five minutes or sign out.',
        );
      }
      // Reserve an attempt before KDF work, including crashes/restarts.
      record.failures++;
      if (record.failures >= 5) {
        record.blockedUntil = now()
            .add(const Duration(minutes: 5))
            .millisecondsSinceEpoch;
      }
      await vault.write(key(id), record.encode());
      final valid = equalVerifier(
        await derive(pin, record.salt),
        record.verifier,
      );
      if (valid) {
        record.failures = 0;
        record.blockedUntil = 0;
      }
      await vault.write(key(id), record.encode());
      return valid;
    } finally {
      _busy = false;
    }
  }

  @override
  Future<bool> biometric() async =>
      supported &&
      await LocalAuthentication().authenticate(
        localizedReason: 'Unlock Macro App',
        // Windows Hello chooses its own device factors; mobile/Apple require biometrics.
        biometricOnly: defaultTargetPlatform != TargetPlatform.windows,
      );
  @override
  Future<void> clear(String id) => vault.delete(key(id));
}
