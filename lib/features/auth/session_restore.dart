// metadata_version: 1
// purpose: Load the current session profile and device lock requirement.
// owner: unassigned
// related_adrs: [ADR-0029, ADR-0020, ADR-0033, ADR-0042]
part of 'session_controller.dart';

extension SessionRestoration on SessionController {
  Future<SessionState> _load({bool freshSignIn = false}) async {
    final id = gateway.userId;
    if (id == null) {
      return SessionState(message: initialNotice);
    }
    final legacy = lock.supported && await lock.requiresReauthentication(id);
    if (legacy && !freshSignIn) {
      // Preserve the old record until account credentials authorize replacement.
      await gateway.signOut();
      return const SessionState(
        message: 'Sign in again to create your four-digit passcode.',
      );
    }
    final phase = !lock.supported
        ? EntryPhase.unlocked
        : await lock.enrolled(id)
        ? EntryPhase.locked
        : EntryPhase.enroll;
    try {
      final profile = await gateway.profile();
      return SessionState(
        userId: id,
        phase: phase,
        profile: profile,
        replaceLegacy: legacy && freshSignIn,
      );
    } catch (_) {
      return SessionState(
        userId: id,
        phase: phase,
        message: 'Profile unavailable. Check your connection and try again.',
        replaceLegacy: legacy && freshSignIn,
      );
    }
  }
}
