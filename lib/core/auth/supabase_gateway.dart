// metadata_version: 1
// purpose: "Genuine Supabase operations; backend error details never reach UI or logs."
// owner: unassigned
// related_adrs: [ADR-0014]
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../app/config.dart';
import '../../features/auth/registration.dart';
import '../../features/profile/profile.dart';
import 'auth_gateway.dart';

class SupabaseGateway implements AuthGateway {
  SupabaseGateway(this.client);
  final SupabaseClient client;
  String? get redirect =>
      AppConfig.redirect.isEmpty ? null : AppConfig.redirect;
  @override
  String? get userId => client.auth.currentUser?.id;
  @override
  Stream<bool> get changes => client.auth.onAuthStateChange.map(
    (event) => event.event == AuthChangeEvent.passwordRecovery,
  );
  @override
  Future<void> signIn(String email, String password) async {
    await client.auth.signInWithPassword(
      email: email.trim().toLowerCase(),
      password: password,
    );
  }

  @override
  Future<bool> register(Registration data) async {
    if (!data.valid) throw const AuthFailure('Check your account details.');
    final result = await client.auth.signUp(
      email: data.email.trim().toLowerCase(),
      password: data.password,
      emailRedirectTo: redirect,
      data: {
        'first_name': data.first.trim(),
        'last_name': data.last.trim(),
        'nickname': data.nickname.trim(),
        'display_name_mode': data.useNickname ? 'nickname' : 'full_name',
      },
    );
    return result.session != null;
  }

  @override
  Future<void> signOut() => client.auth.signOut(scope: SignOutScope.local);
  @override
  Future<void> recover(String email) => client.auth.resetPasswordForEmail(
    email.trim().toLowerCase(),
    redirectTo: redirect,
  );
  @override
  Future<void> changePassword(String password) async {
    await client.auth.updateUser(UserAttributes(password: password));
  }

  @override
  Future<AccountProfile> profile() async => AccountProfile.fromJson(
    await client
        .from('profiles')
        .select('first_name,last_name,nickname,display_name_mode,account_tag')
        .eq('id', userId!)
        .single(),
  );
}
