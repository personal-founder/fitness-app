// metadata_version: 1
// purpose: "Synthetic adapters for deterministic tests; production never imports this file."
// owner: unassigned
// related_adrs: [ADR-0025, ADR-0032, ADR-0033]
import 'dart:async';

import 'package:macro_app/core/auth/auth_gateway.dart';
import 'package:macro_app/core/security/app_lock.dart';
import 'package:macro_app/core/security/vault.dart';
import 'package:macro_app/features/auth/registration.dart';
import 'package:macro_app/features/profile/profile.dart';

class FakeAuth implements AuthGateway {
  @override
  String? userId;
  bool fail = false, verificationRequired = false, profileFailure = false;
  int signIns = 0, signOuts = 0;
  Completer<void>? pending;
  final events = StreamController<bool>.broadcast();
  Stream<bool>? eventSource;
  @override
  Stream<bool> get changes => eventSource ?? events.stream;
  @override
  Future<void> signIn(String email, String password) async {
    signIns++;
    if (pending != null) await pending!.future;
    if (fail) throw Exception('sensitive server detail');
    userId = 'synthetic-user';
    events.add(false);
  }

  @override
  Future<bool> register(Registration data) async {
    if (verificationRequired) return false;
    await signIn(data.email, data.password);
    return true;
  }

  @override
  Future<void> signOut() async {
    if (fail) throw Exception('offline');
    signOuts++;
    userId = null;
    events.add(false);
  }

  @override
  Future<void> recover(String email) async {
    if (fail) throw Exception('Account existence detail');
  }

  @override
  Future<void> changePassword(String password) async {}
  @override
  Future<AccountProfile> profile() async {
    if (profileFailure) throw Exception('offline profile');
    return const AccountProfile(
      firstName: 'Synthetic',
      lastName: 'Person',
      nickname: 'King James',
      useNickname: true,
      tag: '#QF4821',
    );
  }
}

class FakeLock implements AppLock {
  @override
  bool supported = true;
  bool hasPin = true, accepted = true, brokenStorage = false, legacy = false;
  int attempts = 0;
  Completer<bool>? pending;
  @override
  Future<bool> enrolled(String id) async {
    if (brokenStorage) throw Exception('vault unavailable');
    return hasPin;
  }

  @override
  Future<bool> requiresReauthentication(String id) async => legacy;
  @override
  Future<void> enroll(
    String id,
    String pin, {
    required String tag,
    bool replaceLegacy = false,
  }) async {
    if (legacy && !replaceLegacy) throw const AuthFailure('Reauthenticate');
    legacy = false;
    hasPin = true;
  }

  @override
  Future<bool> verify(String id, String pin) async {
    attempts++;
    return pending == null ? accepted : pending!.future;
  }

  @override
  Future<bool> biometric() async => accepted;
  @override
  Future<void> clear(String id) async {
    hasPin = false;
  }
}

class MemoryVault implements Vault {
  final data = <String, String>{};
  @override
  Future<String?> read(String key) async => data[key];
  @override
  Future<void> write(String key, String value) async {
    data[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    data.remove(key);
  }
}
