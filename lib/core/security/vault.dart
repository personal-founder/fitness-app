// metadata_version: 1
// purpose: "OS-backed native secret storage; never use this adapter for browser secrets."
// owner: unassigned
// related_adrs: [ADR-0020, ADR-0021]
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

bool get supportsLocalLock =>
    !kIsWeb &&
    {
      TargetPlatform.android,
      TargetPlatform.iOS,
      TargetPlatform.macOS,
      TargetPlatform.windows,
    }.contains(defaultTargetPlatform);

abstract interface class Vault {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

class PlatformVault implements Vault {
  final _storage = const FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.unlocked_this_device,
    ),
  );
  @override
  Future<String?> read(String key) => _storage.read(key: key);
  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);
  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}
