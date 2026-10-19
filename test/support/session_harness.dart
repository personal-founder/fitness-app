// metadata_version: 1
// purpose: Share deterministic account-controller setup and cleanup across tests.
// owner: unassigned
// related_adrs: [ADR-0025]
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macro_app/core/auth/auth_gateway.dart';
import 'package:macro_app/core/security/app_lock.dart';
import 'package:macro_app/features/auth/session_controller.dart';
import 'package:macro_app/features/auth/session_state.dart';

import 'fakes.dart';

class SessionHarness {
  final auth = FakeAuth(), lock = FakeLock();
  late ProviderContainer container;
  SessionState get value => container.read(sessionProvider);
  Future<SessionController> start() async {
    container = ProviderContainer(
      overrides: [
        authGatewayProvider.overrideWithValue(auth),
        appLockProvider.overrideWithValue(lock),
      ],
    );
    final controller = container.read(sessionProvider.notifier);
    await Future<void>.delayed(Duration.zero);
    return controller;
  }

  Future<void> close() async {
    container.dispose();
    await auth.events.close();
  }
}
