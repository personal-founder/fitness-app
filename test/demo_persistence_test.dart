// metadata_version: 1
// purpose: Verify demo persistence failures, restoration and serialized submissions.
// owner: unassigned
// related_adrs: [ADR-0042, ADR-0025]
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:macro_app/features/auth/session_controller.dart';
import 'package:macro_app/features/auth/session_state.dart';

import 'support/demo_harness.dart';

void main() {
  test('failed read defaults to login with retry feedback', () async {
    final store = MemoryDemoSessionStore()..brokenRead = true;
    final demo = DemoHarness(store);
    await demo.start();
    addTearDown(demo.close);
    expect(demo.value.phase, EntryPhase.login);
    expect(demo.value.message, contains('could not be loaded'));
    await demo.controller.signIn('demo@gmail.com', 'demo123');
    expect(demo.value.phase, EntryPhase.locked);
  });
  test('failed writes cannot report successful sign-in or sign-out', () async {
    final store = MemoryDemoSessionStore()..brokenWrite = true;
    final demo = DemoHarness(store);
    await demo.start();
    addTearDown(demo.close);
    await demo.controller.signIn('demo@gmail.com', 'demo123');
    expect(demo.value.signedIn, false);
    expect(demo.value.message, contains('Please retry'));
    store.brokenWrite = false;
    await demo.controller.signIn('demo@gmail.com', 'demo123');
    store.brokenWrite = true;
    await demo.controller.signOut();
    expect(demo.value.phase, EntryPhase.locked);
    expect(store.signedIn, true);
    expect(demo.value.message, contains('Please retry'));
    store.brokenWrite = false;
    await demo.controller.signOut();
    expect(demo.value.signedIn, false);
    expect(store.signedIn, false);
  });
  test('duplicate pending sign-in writes the flag only once', () async {
    final store = MemoryDemoSessionStore()..pending = Completer<void>();
    final demo = DemoHarness(store);
    await demo.start();
    addTearDown(demo.close);
    final first = demo.controller.signIn('demo@gmail.com', 'demo123');
    await demo.controller.signIn('demo@gmail.com', 'demo123');
    expect(store.writes, 1);
    expect(demo.value.signedIn, false);
    store.pending!.complete();
    await first;
    expect(demo.value.phase, EntryPhase.locked);
  });
}
