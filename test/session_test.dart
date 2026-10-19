// metadata_version: 1
// purpose: "Account transitions and denied/racing unlocks verified outside widget internals."
// owner: unassigned
// related_adrs: [ADR-0025, ADR-0032]
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:macro_app/features/auth/registration.dart';
import 'package:macro_app/features/auth/session_controller.dart';
import 'package:macro_app/features/auth/session_state.dart';

import 'support/fakes.dart';
import 'support/session_harness.dart';

void main() {
  late FakeAuth auth;
  late FakeLock lock;
  late SessionHarness harness;
  Future<SessionController> start() => harness.start();
  SessionState value() => harness.value;
  setUp(() {
    harness = SessionHarness();
    auth = harness.auth;
    lock = harness.lock;
  });
  tearDown(() => harness.close());
  test('credentials -> locked -> unlocked -> background -> logout', () async {
    final controller = await start();
    expect(value().phase, EntryPhase.login);
    await controller.signIn('test@example.com', 'synthetic password');
    expect(value().phase, EntryPhase.locked);
    expect(value().profile!.displayName, 'King James');
    await controller.unlock('1234');
    expect(value().phase, EntryPhase.unlocked);
    controller.background();
    expect(value().phase, EntryPhase.locked);
    await controller.signOut();
    expect(value().signedIn, false);
    expect(value().profile, null);
    expect(lock.hasPin, false);
    expect(auth.signOuts, 1);
  });
  test('restoration locks and missing verifier requires enrollment', () async {
    auth.userId = 'saved';
    lock.hasPin = false;
    final controller = await start();
    expect(value().phase, EntryPhase.enroll);
    await controller.enroll('1234');
    expect(value().phase, EntryPhase.locked);
  });
  test('wrong passcode and canceled biometrics never unlock', () async {
    auth.userId = 'saved';
    lock.accepted = false;
    final controller = await start();
    await controller.unlock('0000');
    expect(value().phase, EntryPhase.locked);
    await controller.unlock('', biometric: true);
    expect(value().phase, EntryPhase.locked);
    expect(value().message, isNotNull);
  });
  test('late successful unlock after background is discarded', () async {
    auth.userId = 'saved';
    lock.pending = Completer<bool>();
    final controller = await start();
    final request = controller.unlock('1234');
    controller.background();
    lock.pending!.complete(true);
    await request;
    expect(value().phase, EntryPhase.locked);
  });
  test(
    'parallel sign-in submits only once; errors omit backend details',
    () async {
      auth.pending = Completer<void>();
      auth.fail = true;
      final controller = await start();
      final first = controller.signIn('test@example.com', 'synthetic password');
      await controller.signIn('test@example.com', 'synthetic password');
      expect(auth.signIns, 1);
      auth.pending!.complete();
      await first;
      expect(value().signedIn, false);
      expect(value().message, isNot(contains('sensitive')));
    },
  );
  test('unverified registration does not grant a session', () async {
    auth.verificationRequired = true;
    final controller = await start();
    await controller.register(
      const Registration('A', 'B', 'test@example.com', 'long password'),
    );
    expect(value().signedIn, false);
    expect(value().message, contains('verify'));
  });
  test(
    'vault failure fails closed; unsupported host never invents PIN',
    () async {
      auth.userId = 'saved';
      lock.brokenStorage = true;
      final controller = await start();
      expect(value().phase, EntryPhase.locked);
      lock.supported = false;
      await controller.restore();
      expect(value().phase, EntryPhase.unlocked);
    },
  );
  test('recovery response does not expose whether account exists', () async {
    final controller = await start();
    await controller.recover('test@example.com');
    final message = value().message;
    auth.fail = true;
    await controller.recover('test@example.com');
    expect(value().message, message);
  });
}
