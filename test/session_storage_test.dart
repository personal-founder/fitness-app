// metadata_version: 1
// purpose: "Native persistence contract and unsupported-host memory-only fallback."
// owner: unassigned
// related_adrs: [ADR-0025]
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macro_app/core/security/session_storage.dart';
import 'package:macro_app/core/security/pkce_storage.dart';

import 'support/fakes.dart';

void main() {
  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
  });
  test(
    'native sessions survive adapter replacement and are deleted at logout',
    () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;
      final vault = MemoryVault();
      final storage = ProtectedSessionStorage(vault: vault);
      await storage.persistSession('synthetic serialized session');
      expect(
        await ProtectedSessionStorage(vault: vault).accessToken(),
        'synthetic serialized session',
      );
      await storage.removePersistedSession();
      expect(await storage.hasAccessToken(), false);
    },
  );
  test('unsupported hosts never write session to disk', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    final vault = MemoryVault();
    final storage = ProtectedSessionStorage(vault: vault);
    await storage.persistSession('synthetic session');
    expect(vault.data, isEmpty);
    expect(await storage.hasAccessToken(), true);
    expect(await ProtectedSessionStorage(vault: vault).hasAccessToken(), false);
  });
  test(
    'native PKCE verifier uses the same protected boundary and removes itself',
    () async {
      final vault = MemoryVault();
      final storage = ProtectedPkceStorage(vault: vault);
      await storage.setItem(key: 'test', value: 'synthetic verifier');
      expect(await storage.getItem(key: 'test'), 'synthetic verifier');
      await storage.removeItem(key: 'test');
      expect(vault.data, isEmpty);
    },
  );
}
