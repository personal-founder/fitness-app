// metadata_version: 1
// purpose: Prove legacy records require fresh account credentials and fail closed.
// owner: unassigned
// related_adrs: [ADR-0033, ADR-0025]
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:macro_app/core/auth/auth_gateway.dart';
import 'package:macro_app/core/security/app_lock.dart';
import 'package:macro_app/core/security/pin_record.dart';
import 'package:macro_app/features/auth/session_controller.dart';
import 'package:macro_app/features/auth/session_state.dart';

import 'support/fakes.dart';
import 'support/session_harness.dart';

void main() {
  test(
    'v1 cannot verify or replace without explicit reauthentication',
    () async {
      final vault = MemoryVault();
      final bytes = base64Encode(List.filled(32, 7));
      final lock = NativeAppLock(vault, derive: (_, _) async => bytes);
      final original = PinRecord(bytes, bytes, version: 1).encode();
      await vault.write(lock.key('A'), original);
      expect(await lock.requiresReauthentication('A'), true);
      expect(await lock.enrolled('A'), false);
      await expectLater(lock.verify('A', '1234'), throwsA(isA<AuthFailure>()));
      await expectLater(
        lock.enroll('A', '1234', tag: '#QF4821'),
        throwsA(isA<AuthFailure>()),
      );
      expect(await vault.read(lock.key('A')), original);
      await lock.enroll('A', '1234', tag: '#QF4821', replaceLegacy: true);
      expect(await lock.requiresReauthentication('A'), false);
      expect(await lock.enrolled('A'), true);
      expect(jsonDecode((await vault.read(lock.key('A')))!)['length'], 4);
      expect(await lock.verify('A', '1234'), true);
    },
  );
  test(
    'restored legacy account signs out; new credentials authorize setup',
    () async {
      final harness = SessionHarness();
      addTearDown(harness.close);
      harness.auth.userId = 'saved';
      harness.lock
        ..legacy = true
        ..hasPin = false;
      final controller = await harness.start();
      expect(harness.value.signedIn, false);
      expect(harness.lock.legacy, true);
      await controller.signIn('test@example.com', 'synthetic password');
      expect(harness.value.phase, EntryPhase.enroll);
      expect(harness.value.replaceLegacy, true);
      await controller.enroll('1234');
      expect(harness.value.phase, EntryPhase.locked);
      expect(harness.lock.legacy, false);
    },
  );
  test('profile failure blocks enrollment and retry recovers', () async {
    final harness = SessionHarness();
    addTearDown(harness.close);
    harness.auth
      ..userId = 'saved'
      ..profileFailure = true;
    harness.lock.hasPin = false;
    final controller = await harness.start();
    await controller.enroll('1234');
    expect(harness.value.phase, EntryPhase.enroll);
    expect(harness.lock.hasPin, false);
    harness.auth.profileFailure = false;
    await controller.restore();
    await controller.enroll('4821');
    expect(harness.lock.hasPin, false);
    await controller.enroll('1234');
    expect(harness.lock.hasPin, true);
  });
  test(
    'legacy setup retains fresh authentication during a profile retry',
    () async {
      final harness = SessionHarness();
      addTearDown(harness.close);
      harness.auth.userId = 'saved';
      harness.lock
        ..legacy = true
        ..hasPin = false;
      final controller = await harness.start();
      harness.auth.profileFailure = true;
      await controller.signIn('test@example.com', 'synthetic password');
      expect(harness.value.profile, null);
      expect(harness.value.replaceLegacy, true);
      harness.auth.profileFailure = false;
      await controller.restore();
      expect(harness.value.phase, EntryPhase.enroll);
      await controller.enroll('1234');
      expect(harness.value.phase, EntryPhase.locked);
      expect(harness.auth.signOuts, 1);
    },
  );
}
