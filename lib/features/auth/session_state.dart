// metadata_version: 1
// purpose: "Explicit session/lock states keep credential forms and headers consistent."
// owner: unassigned
// related_adrs: [ADR-0029, ADR-0014, ADR-0033]
import '../profile/profile.dart';

enum EntryPhase { login, register, locked, enroll, unlocked, recovery }

class SessionState {
  const SessionState({
    this.phase = EntryPhase.login,
    this.userId,
    this.profile,
    this.busy = false,
    this.message,
    this.replaceLegacy = false,
  });
  final EntryPhase phase;
  final String? userId, message;
  final AccountProfile? profile;
  final bool busy;
  final bool replaceLegacy;
  bool get signedIn => userId != null;
  SessionState copy({
    EntryPhase? phase,
    AccountProfile? profile,
    bool? busy,
    String? message,
    bool? replaceLegacy,
  }) => SessionState(
    phase: phase ?? this.phase,
    userId: userId,
    profile: profile ?? this.profile,
    busy: busy ?? this.busy,
    message: message,
    replaceLegacy: replaceLegacy ?? this.replaceLegacy,
  );
}
