// metadata_version: 1
// purpose: Verify replayed recovery events and auth stream error handling.
// owner: unassigned
// related_adrs: [ADR-0025]
import 'package:flutter_test/flutter_test.dart';
import 'package:macro_app/features/auth/session_controller.dart';
import 'package:macro_app/features/auth/session_state.dart';

import 'support/session_harness.dart';

void main() {
  late SessionHarness harness;
  setUp(() {
    harness = SessionHarness();
  });
  tearDown(() => harness.close());
  test(
    'replayed recovery opens password update without being overwritten',
    () async {
      harness.auth.userId = 'saved';
      harness.auth.eventSource = Stream<bool>.value(true);
      final controller = await harness.start();
      expect(harness.value.phase, EntryPhase.recovery);
      await controller.changePassword('a long synthetic password');
      expect(harness.value.signedIn, false);
    },
  );
  test(
    'network auth-stream errors do not escape to the application zone',
    () async {
      await harness.start();
      harness.auth.events.addError(Exception('sensitive error detail'));
      await Future<void>.delayed(Duration.zero);
      expect(harness.value.message, contains('connection'));
      expect(harness.value.message, isNot(contains('sensitive')));
    },
  );
}
