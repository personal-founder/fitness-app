// metadata_version: 1
// purpose: Prove initialization failures remain explicit incomplete evidence.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0011]
import 'package:flutter_test/flutter_test.dart';

import '../../tool/verification/bootstrap_report.dart';
import '../../tool/verification/model.dart';
import '../../tool/verification/receipts.dart';
import 'support.dart';

void main() {
  test('bootstrap diagnostics cannot be reused as passing evidence', () {
    final f = Fixture();
    addTearDown(f.dispose);
    final path = '${f.root}/report.json';
    saveBootstrapFailure(
      f.root,
      path,
      Check('dependencies', 'BLOCKED', 'Missing SDK'),
    );
    final report = readJson(path);
    expect(report['gate_exit'], 2);
    expect(report['identity']['snapshot'], isNull);
    expect(report['limitations'], isNotEmpty);
    expect(() => receiptChecks(report, f.context()), throwsFormatException);
  });
}
