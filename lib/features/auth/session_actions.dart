// metadata_version: 1
// purpose: "Account actions share the controller's serialized request and race protections."
// owner: unassigned
// related_adrs: [ADR-0029, ADR-0014, ADR-0033]
part of 'session_controller.dart';

extension AccountActions on SessionController {
  void showRegistration(bool register) {
    if (current.signedIn || current.busy) return;
    update(
      SessionState(phase: register ? EntryPhase.register : EntryPhase.login),
    );
  }

  Future<void> signIn(String email, String password) => _run(() async {
    if (!validEmail(email) || password.isEmpty || password.length > 128) {
      throw const AuthFailure('Enter your email and password.');
    }
    await gateway.signIn(email, password);
    return _load(freshSignIn: true);
  });
  Future<void> register(Registration data) => _run(() async {
    if (!data.valid) throw const AuthFailure('Check your account details.');
    final signedIn = await gateway.register(data);
    return signedIn
        ? await _load()
        : const SessionState(
            message: 'Check your email to verify your account, then sign in.',
          );
  });
  Future<void> signOut() => _run(() async {
    final id = current.userId;
    await gateway.signOut();
    if (id != null && lock.supported) await lock.clear(id);
    return const SessionState();
  });
  Future<void> recover(String email) => _run(() async {
    if (!validEmail(email)) throw const AuthFailure('Enter your email first.');
    try {
      await gateway.recover(email);
    } catch (_) {
      // Identical result prevents account enumeration through recovery errors.
    }
    return current.copy(
      busy: false,
      message: 'If an account matches, a recovery email will arrive shortly.',
    );
  });
  Future<void> changePassword(String password) => _run(() async {
    if (current.phase != EntryPhase.recovery ||
        password.length < 12 ||
        password.length > 128) {
      throw const AuthFailure('Use a password of 12–128 characters.');
    }
    await gateway.changePassword(password);
    await gateway.signOut();
    return const SessionState(
      message: 'Password updated. Sign in to continue.',
    );
  });
}
