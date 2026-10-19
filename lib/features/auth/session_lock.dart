// metadata_version: 1
// purpose: Gate local unlock and enrollment with account-bound validation.
// owner: unassigned
// related_adrs: [ADR-0032, ADR-0033]
part of 'session_controller.dart';

extension SessionLockActions on SessionController {
  Future<void> unlock(String pin, {bool biometric = false}) => _run(() async {
    if (current.phase != EntryPhase.locked ||
        current.userId != gateway.userId) {
      throw const AuthFailure('Sign in again to continue.');
    }
    if (!await lock.enrolled(current.userId!)) {
      throw const AuthFailure('Sign in again to set a passcode.');
    }
    final valid = biometric
        ? await lock.biometric()
        : await lock.verify(current.userId!, pin);
    if (!valid) throw const AuthFailure('Not unlocked. Try again or sign out.');
    return current.copy(phase: EntryPhase.unlocked, busy: false);
  });
  Future<void> enroll(String pin) => _run(() async {
    if (current.phase != EntryPhase.enroll ||
        current.userId != gateway.userId) {
      throw const AuthFailure('Sign in again to set a passcode.');
    }
    final tag = current.profile?.tag;
    final error = PinPolicy.enrollmentError(pin, tag);
    if (error != null) throw AuthFailure(error);
    await lock.enroll(
      current.userId!,
      pin,
      tag: tag!,
      replaceLegacy: current.replaceLegacy,
    );
    return current.copy(
      phase: EntryPhase.locked,
      busy: false,
      replaceLegacy: false,
    );
  });
}
