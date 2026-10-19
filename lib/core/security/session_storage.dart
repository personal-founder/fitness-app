// metadata_version: 1
// purpose: "Supabase persistence: native OS storage; memory-only on unsupported platforms."
// owner: unassigned
// related_adrs: [ADR-0020, ADR-0021]
import 'package:supabase_flutter/supabase_flutter.dart';

import 'vault.dart';

class ProtectedSessionStorage extends LocalStorage {
  ProtectedSessionStorage({Vault? vault}) : _vault = vault ?? PlatformVault();
  final Vault _vault;
  String? _memory;
  static const _key = 'macro.auth.session.v1';
  @override
  Future<void> initialize() async {}
  @override
  Future<String?> accessToken() async =>
      supportsLocalLock ? _vault.read(_key) : _memory;
  @override
  Future<bool> hasAccessToken() async => await accessToken() != null;
  @override
  Future<void> persistSession(String persistSessionString) async {
    if (supportsLocalLock) {
      await _vault.write(_key, persistSessionString);
    } else {
      _memory = persistSessionString;
    }
  }

  @override
  Future<void> removePersistedSession() async {
    _memory = null;
    if (supportsLocalLock) await _vault.delete(_key);
  }
}
