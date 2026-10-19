// metadata_version: 1
// purpose: receipt_test verifier regression coverage.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008, ADR-0011]
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/verification/aggregate.dart';
import '../../tool/verification/model.dart';
import '../../tool/verification/receipts.dart';
import 'support.dart';

void main() {
  Json report(dynamic c, List<Check> checks) => {
    'schema_version': 1,
    'identity': c.identity,
    'runner': Platform.operatingSystem,
    'gate_exit': gateExit(checks),
    'created_at': DateTime.now().toUtc().toIso8601String(),
    'checks': checks.map((v) => v.toJson()).toList(),
    'source': 'local',
    'run_id': null,
    'shard': null,
  };

  test('full matching evidence passes; missing and failed evidence cannot', () {
    final f = Fixture();
    addTearDown(f.dispose);
    final c = f.context();
    final all = requiredChecks(c)
        .map((id) => Check(id, 'PASS', 'fixture'))
        .toList();
    expect(gateExit(combine(c, all)), 0);
    expect(
      gateExit(combine(c, all.where((v) => v.id != 'build:ios').toList())),
      2,
    );
    expect(
      gateExit(combine(c, [...all, Check('analysis', 'FAIL', 'error')])),
      1,
    );
  });
  test('stale snapshot, parent, policy and toolchain reports are rejected', () {
    final f = Fixture();
    addTearDown(f.dispose);
    final c = f.context();
    for (final key in ['snapshot', 'parent', 'policy_digest', 'versions']) {
      final value = report(c, [Check('format', 'PASS', 'fixture')]);
      value['identity'] = {...c.identity, key: 'stale'};
      expect(() => receiptChecks(value, c), throwsFormatException);
    }
  });
  test(
    'malformed, expired, inconsistent or impossible-host evidence fails',
    () {
      final f = Fixture();
      addTearDown(f.dispose);
      final c = f.context();
      final pass = report(c, [Check('format', 'PASS', 'fixture')]);
      expect(receiptChecks(pass, c).single.status, 'PASS');
      for (final bad in [
        {...pass, 'schema_version': 5},
        {...pass, 'gate_exit': 1},
        {...pass, 'created_at': '2000-01-01T00:00:00Z'},
        {...pass, 'checks': 'wrong shape'},
        {
          ...pass,
          'created_at': DateTime.now()
              .toUtc()
              .add(const Duration(days: 2))
              .toIso8601String(),
        },
        {
          ...pass,
          'checks': [Check('build:ios', 'PASS', 'fixture').toJson()],
          'runner': 'windows',
        },
      ]) {
        expect(() => receiptChecks(bad, c), throwsFormatException);
      }
    },
  );
}
