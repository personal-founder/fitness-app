// metadata_version: 1
// purpose: "Native PKCE verifiers use the OS vault; browser SDK storage holds verifier only."
// owner: unassigned
// related_adrs: [ADR-0020]
import 'package:supabase_flutter/supabase_flutter.dart';

import 'vault.dart';

class ProtectedPkceStorage extends GotrueAsyncStorage {
  ProtectedPkceStorage({Vault? vault}) : vault = vault ?? PlatformVault();
  final Vault vault;
  @override
  Future<String?> getItem({required String key}) => vault.read('pkce.$key');
  @override
  Future<void> setItem({required String key, required String value}) =>
      vault.write('pkce.$key', value);
  @override
  Future<void> removeItem({required String key}) => vault.delete('pkce.$key');
}
