// metadata_version: 1
// purpose: Exercise PIN syntax, leading zeros and tag exclusions at the shared boundary.
// owner: unassigned
// related_adrs: [ADR-0032, ADR-0025]
import 'package:flutter_test/flutter_test.dart';
import 'package:macro_app/core/auth/auth_gateway.dart';
import 'package:macro_app/core/security/app_lock.dart';
import 'package:macro_app/core/security/pin_policy.dart';

import 'support/fakes.dart';

void main() {
  test('four numeric digits only, preserving leading zeros', () {
    for (final pin in ['1234', '0007', '0000']) {
      expect(PinPolicy.validSyntax(pin), true);
    }
    for (final pin in ['', '123', '12345', '12a4', ' 1234', '１２３４']) {
      expect(PinPolicy.validSyntax(pin), false);
    }
  });
  test('tag must exist and its numeric suffix is forbidden', () {
    expect(PinPolicy.enrollmentError('1234', '#QF4821'), null);
    expect(PinPolicy.enrollmentError('4821', '#QF4821'), isNotNull);
    expect(PinPolicy.enrollmentError('0007', '#AB0007'), isNotNull);
    expect(PinPolicy.enrollmentError('0008', '#AB0007'), null);
    expect(PinPolicy.enrollmentError('1234', null), isNotNull);
    expect(PinPolicy.enrollmentError('1234', 'invalid'), isNotNull);
  });
  test('native enrollment enforces policy even without the UI', () async {
    final vault = MemoryVault();
    final lock = NativeAppLock(vault);
    for (final pin in ['4821', '12345', '123456', 'abcd']) {
      await expectLater(
        lock.enroll('A', pin, tag: '#QF4821'),
        throwsA(isA<AuthFailure>()),
      );
    }
    expect(vault.data, isEmpty);
  });
}
