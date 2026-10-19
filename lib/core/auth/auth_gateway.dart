// metadata_version: 1
// purpose: "Backend boundary. Missing configuration fails explicitly, never logs in a demo."
// owner: unassigned
// related_adrs: [ADR-0014, ADR-0042]
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/registration.dart';
import '../../features/profile/profile.dart';

final authGatewayProvider = Provider<AuthGateway>((ref) => UnconfiguredAuth());
// Non-sensitive bootstrap feedback; account credentials never belong here.
final initialAuthNoticeProvider = Provider<String?>((ref) => null);

abstract interface class AuthGateway {
  String? get userId;
  Stream<bool> get changes; // true only for a password-recovery event.
  Future<void> signIn(String email, String password);
  Future<bool> register(
    Registration data,
  ); // false means verification required.
  Future<void> signOut();
  Future<void> recover(String email);
  Future<void> changePassword(String password);
  Future<AccountProfile> profile();
}

class UnconfiguredAuth implements AuthGateway {
  @override
  String? get userId => null;
  @override
  Stream<bool> get changes => const Stream.empty();
  Never unavailable() =>
      throw const AuthFailure('Connect Supabase to use accounts.');
  @override
  Future<void> signIn(String email, String password) async => unavailable();
  @override
  Future<bool> register(Registration data) async => unavailable();
  @override
  Future<void> signOut() async => unavailable();
  @override
  Future<void> recover(String email) async => unavailable();
  @override
  Future<void> changePassword(String password) async => unavailable();
  @override
  Future<AccountProfile> profile() async => unavailable();
}

class AuthFailure implements Exception {
  const AuthFailure(this.message);
  final String message;
}
