// metadata_version: 1
// purpose: UI demonstration only; never used for real account authentication.
// owner: unassigned
// related_adrs: [ADR-0034]
import '../../core/auth/auth_gateway.dart';
import '../../core/security/app_lock.dart';
import 'design_preview.dart';

class DemoLock implements AppLock {
  @override
  bool get supported => true;
  @override
  Future<bool> enrolled(String id) async => id == DemoAuth.id;
  @override
  Future<bool> requiresReauthentication(String id) async => false;
  @override
  Future<void> enroll(
    String id,
    String pin, {
    required String tag,
    bool replaceLegacy = false,
  }) async => throw const AuthFailure('Demo account setup is unavailable.');
  @override
  Future<bool> verify(String id, String pin) async =>
      id == DemoAuth.id && pin == '1234';
  @override
  Future<bool> biometric() async => false;
  @override
  Future<void> clear(String id) async {}
}
