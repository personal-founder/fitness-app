// metadata_version: 1
// purpose: Exercise real demo/session controllers with controlled flag persistence.
// owner: unassigned
// related_adrs: [ADR-0044, ADR-0042, ADR-0025]
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macro_app/core/auth/auth_gateway.dart';
import 'package:macro_app/core/security/app_lock.dart';
import 'package:macro_app/features/auth/demo_lock.dart';
import 'package:macro_app/features/auth/demo_session_store.dart';
import 'package:macro_app/features/auth/design_preview.dart';
import 'package:macro_app/features/auth/session_controller.dart';
import 'package:macro_app/features/auth/session_state.dart';

class MemoryDemoSessionStore implements DemoSessionStore {
  bool signedIn = false, brokenRead = false, brokenWrite = false;
  int writes = 0;
  Completer<void>? pending;
  @override
  Future<bool> readSignedIn() async {
    if (brokenRead) throw StateError('unavailable');
    return signedIn;
  }

  @override
  Future<void> writeSignedIn(bool value) async {
    writes++;
    if (pending != null) await pending!.future;
    if (brokenWrite) throw StateError('unavailable');
    signedIn = value;
  }
}

class DemoHarness {
  DemoHarness(this.store);
  final MemoryDemoSessionStore store;
  late DemoAuth auth;
  late ProviderContainer container;
  SessionState get value => container.read(sessionProvider);
  SessionController get controller => container.read(sessionProvider.notifier);
  Future<void> start() async {
    auth = DemoAuth(store);
    final notice = await auth.restore();
    container = ProviderContainer(
      overrides: [
        authGatewayProvider.overrideWithValue(auth),
        initialAuthNoticeProvider.overrideWithValue(notice),
        appLockProvider.overrideWithValue(DemoLock()),
      ],
    );
    container.read(sessionProvider);
    // Microtasks work in widget tests without waiting on the fake timer clock.
    await Future<void>.value();
    await controller.restore();
  }

  void close() => container.dispose();
}
