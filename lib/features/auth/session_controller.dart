// metadata_version: 1
// purpose: "Serializes auth work and discards late unlocks after background/account changes."
// owner: unassigned
// related_adrs: [ADR-0029, ADR-0014, ADR-0033, ADR-0034, ADR-0042]
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_gateway.dart';
import '../../core/security/app_lock.dart';
import '../../core/security/pin_policy.dart';
import 'session_state.dart';
import 'registration.dart';
part 'session_actions.dart';
part 'session_restore.dart';
part 'session_lock.dart';

final sessionProvider = NotifierProvider<SessionController, SessionState>(
  SessionController.new,
);

class SessionController extends Notifier<SessionState> {
  int _epoch = 0;
  bool _disposed = false;
  AuthGateway get gateway => ref.read(authGatewayProvider);
  AppLock get lock => ref.read(appLockProvider);
  String? get initialNotice => ref.read(initialAuthNoticeProvider);
  SessionState get current => state;
  void update(SessionState value) => state = value;
  @override
  SessionState build() {
    ref.onDispose(() {
      _disposed = true;
      _epoch++;
    });
    final subscription = gateway.changes.listen(
      (recovery) {
        if (gateway.userId == null && state.signedIn) {
          _epoch++;
          state = const SessionState();
        } else if (recovery) {
          _epoch++;
          state = SessionState(
            phase: EntryPhase.recovery,
            userId: gateway.userId,
          );
        } else if (!state.busy && gateway.userId != state.userId) {
          unawaited(restore());
        }
      },
      onError: (Object error, StackTrace stack) {
        if (!_disposed) {
          state = state.copy(
            busy: false,
            message: 'Account connection interrupted. Check your connection and try again.',
          );
        }
      },
    );
    ref.onDispose(subscription.cancel);
    Future.microtask(() {
      // The SDK replays an initial recovery event; do not overwrite its route.
      if (!_disposed && state.phase != EntryPhase.recovery) restore();
    });
    return const SessionState(busy: true);
  }

  Future<void> restore() async {
    if (_disposed) return;
    final fresh = state.replaceLegacy && state.userId == gateway.userId;
    if (gateway.userId != null) {
      state = SessionState(userId: gateway.userId, phase: EntryPhase.locked);
    }
    await _run(() => _load(freshSignIn: fresh), allowBusy: true);
  }

  Future<void> _run(
    Future<SessionState> Function() action, {
    bool allowBusy = false,
  }) async {
    if (state.busy && !allowBusy) return;
    final ticket = ++_epoch;
    state = state.copy(busy: true);
    try {
      final next = await action();
      if (!_disposed && ticket == _epoch) {
        if (next.userId == gateway.userId) {
          state = next;
        } else {
          unawaited(restore());
        }
      }
    } catch (error) {
      if (!_disposed && ticket == _epoch) {
        final message = error is AuthFailure
            ? error.message
            : 'Unable to complete this request. Check your details and connection.';
        state = state.userId == gateway.userId
            ? state.copy(busy: false, message: message)
            : SessionState(
                userId: gateway.userId,
                phase: gateway.userId == null
                    ? EntryPhase.login
                    : EntryPhase.locked,
                message: message,
              );
      }
    }
  }

  void background() {
    if (state.signedIn && lock.supported) {
      _epoch++;
      state = state.copy(
        phase: state.phase == EntryPhase.enroll
            ? EntryPhase.enroll
            : EntryPhase.locked,
        busy: false,
      );
    }
  }
}
