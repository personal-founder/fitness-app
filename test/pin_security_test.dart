// metadata_version: 1
// purpose: "Verify real derivation plus persisted rate limits, corruption and account isolation."
// owner: unassigned
// related_adrs: [ADR-0025, ADR-0032]
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:macro_app/core/auth/auth_gateway.dart';
import 'package:macro_app/core/security/app_lock.dart';
import 'package:macro_app/core/security/pin_derivation.dart';

import 'support/fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'real KDF is salted, deterministic and rejects a different PIN',
    () async {
      final salt = base64Encode(List.filled(32, 7));
      final verifier = await derivePin('1234', salt);
      expect(verifier, await derivePin('1234', salt));
      expect(equalVerifier(verifier, await derivePin('4321', salt)), false);
      expect(
        equalVerifier(
          verifier,
          await derivePin('1234', base64Encode(List.filled(32, 8))),
        ),
        false,
      );
      expect(base64Decode(verifier).length, 32);
    },
  );
  test(
    'failed attempts persist across instances and throttle before derivation',
    () async {
      final vault = MemoryVault();
      var derives = 0;
      var clock = DateTime.utc(2026, 10, 19);
      Future<String> derive(String pin, String salt) async {
        derives++;
        return base64Encode(List.filled(32, pin == '1234' ? 1 : 2));
      }

      var lock = NativeAppLock(vault, derive: derive, clock: () => clock);
      await lock.enroll('A', '1234', tag: '#QF4821');
      expect(vault.data.values.single, isNot(contains('1234')));
      for (var i = 0; i < 5; i++) {
        expect(await lock.verify('A', '0000'), false);
      }
      lock = NativeAppLock(vault, derive: derive, clock: () => clock);
      final previous = derives;
      await expectLater(lock.verify('A', '1234'), throwsA(isA<AuthFailure>()));
      expect(derives, previous);
      clock = clock.add(const Duration(minutes: 6));
      expect(await lock.verify('A', '1234'), true);
      expect(await lock.enrolled('B'), false);
      await lock.clear('A');
      expect(await lock.enrolled('A'), false);
    },
  );
  test(
    'invalid enrollment and corrupt records fail without unlocking',
    () async {
      final vault = MemoryVault();
      final lock = NativeAppLock(vault);
      await expectLater(
        lock.enroll('A', '123', tag: '#QF4821'),
        throwsA(isA<AuthFailure>()),
      );
      await vault.write(lock.key('A'), '{broken');
      await expectLater(lock.verify('A', '1234'), throwsFormatException);
    },
  );
}
