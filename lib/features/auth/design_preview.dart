// metadata_version: 1
// purpose: Isolated synthetic account adapter selected only by compile-time preview.
// owner: unassigned
// related_adrs: [ADR-0034, ADR-0044, ADR-0042]
import '../../core/auth/auth_gateway.dart';
import '../profile/profile.dart';
import 'demo_session_store.dart';
import 'registration.dart';

class DemoAuth extends UnconfiguredAuth {
  DemoAuth(this.store);
  static const id = 'preview-only';
  final DemoSessionStore store;
  @override
  String? userId;
  Future<String?> restore() async {
    try {
      userId = await store.readSignedIn() ? id : null;
      return null;
    } catch (_) {
      userId = null;
      return 'Demo session could not be loaded. Sign in again to retry.';
    }
  }

  @override
  Future<void> signIn(String email, String password) async {
    if (email.trim().toLowerCase() != 'demo@gmail.com' ||
        password != 'demo123') {
      throw const AuthFailure('Email or password is incorrect.');
    }
    await _persist(true);
    userId = id;
  }

  Future<void> _persist(bool signedIn) async {
    try {
      await store.writeSignedIn(signedIn);
    } catch (_) {
      throw const AuthFailure('Demo session could not be saved. Please retry.');
    }
  }

  @override
  Future<void> signOut() async {
    await _persist(false);
    userId = null;
  }

  @override
  Future<bool> register(Registration data) async => throw const AuthFailure(
    'Demo mode cannot create accounts. Use the demo sign-in.',
  );

  @override
  Future<AccountProfile> profile() async {
    if (userId == null) throw const AuthFailure('Sign in to continue.');
    return const AccountProfile(
      firstName: 'Demo',
      lastName: 'Account',
      nickname: 'King James',
      useNickname: true,
      tag: '#QF4821',
    );
  }
}
