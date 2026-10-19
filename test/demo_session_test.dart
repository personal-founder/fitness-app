// metadata_version: 1
// purpose: Prove the demo identity requires credentials and restores only into the locked phase.
// owner: unassigned
// related_adrs: [ADR-0044, ADR-0042, ADR-0025]
import 'package:flutter_test/flutter_test.dart';
import 'package:macro_app/core/auth/auth_gateway.dart';
import 'package:macro_app/features/auth/registration.dart';
import 'package:macro_app/features/auth/session_controller.dart';
import 'package:macro_app/features/auth/session_state.dart';

import 'support/demo_harness.dart';

void main() {
  test(
    'credentials -> PIN -> unlock -> relock -> restore -> sign-out -> restore',
    () async {
      final store = MemoryDemoSessionStore();
      var demo = DemoHarness(store);
      await demo.start();
      expect(demo.value.phase, EntryPhase.login);
      expect(demo.value.profile, null);
      for (final credentials in [
        ('wrong@gmail.com', 'demo123'),
        ('demo@gmail.com', 'Demo123'),
        ('demo@gmail.com', 'demo123 '),
      ]) {
        await demo.controller.signIn(credentials.$1, credentials.$2);
        expect(demo.value.signedIn, false);
      }
      expect(store.writes, 0);
      await demo.controller.signIn(' DEMO@GMAIL.COM ', 'demo123');
      expect(demo.value.phase, EntryPhase.locked);
      expect(demo.value.profile!.displayName, 'King James');
      for (final pin in ['4821', '0000', '12345']) {
        await demo.controller.unlock(pin);
        expect(demo.value.phase, EntryPhase.locked);
      }
      await demo.controller.unlock('', biometric: true);
      expect(demo.value.phase, EntryPhase.locked);
      await demo.controller.unlock('1234');
      expect(demo.value.phase, EntryPhase.unlocked);
      demo.controller.background();
      expect(demo.value.phase, EntryPhase.locked);
      demo.close();
      demo = DemoHarness(store);
      await demo.start();
      expect(demo.value.phase, EntryPhase.locked);
      await demo.controller.signOut();
      expect(demo.value.profile, null);
      expect(store.signedIn, false);
      demo.close();
      demo = DemoHarness(store);
      await demo.start();
      expect(demo.value.phase, EntryPhase.login);
      await demo.controller.signIn('demo@gmail.com', 'demo123');
      expect(demo.value.phase, EntryPhase.locked);
      demo.close();
    },
  );
  test(
    'public demo credentials do not authenticate production or weaken sign-up',
    () async {
      await expectLater(
        UnconfiguredAuth().signIn('demo@gmail.com', 'demo123'),
        throwsA(isA<AuthFailure>()),
      );
      expect(
        const Registration('A', 'B', 'demo@gmail.com', 'demo123').valid,
        false,
      );
    },
  );
}
