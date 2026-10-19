// metadata_version: 1
// purpose: adr_test verifier regression coverage.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008, ADR-0011]
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/verification/adr_checks.dart';
import '../../tool/verification/links.dart';
import 'support.dart';

void main() {
  const path = 'docs/adr/0007-shared-verifier.md';
  test('ADR required structure and identity are checked', () {
    final f = Fixture();
    addTearDown(f.dispose);
    final p = f.context().policy;
    final good = File(path).readAsStringSync().replaceAll('\r\n', '\n');
    f.file(path, good);
    final known = {'ADR-0002', 'ADR-0003', 'ADR-0004', 'ADR-0005'};
    expect(adrErrors(f.root, path, p, known), isEmpty);
    for (final text in [
      good.replaceFirst('status: accepted', 'status: invented'),
      good.replaceFirst('## Decision\n', '## Unknown\n'),
      good.replaceFirst('id: ADR-0007', 'id: ADR-9999'),
      good.replaceFirst(
        RegExp(r'implementation: \w+'),
        'implementation: invalid',
      ),
      good.replaceFirst('date: "2026-10-19"', 'date: "2026-02-31"'),
    ]) {
      f.file(path, text);
      expect(text, isNot(good));
      expect(adrErrors(f.root, path, p, known), isNotEmpty);
    }
  });
  test('duplicate ADR numbers are rejected', () {
    final f = Fixture();
    addTearDown(f.dispose);
    f.file('docs/adr/0001-one.md', '# One');
    f.file('docs/adr/0001-two.md', '# Two');
    expect(() => adrIds(f.root, f.context().policy), throwsFormatException);
  });
  test('local references and heading anchors must resolve', () {
    final f = Fixture();
    addTearDown(f.dispose);
    f.file('target.md', '# Target\n## Some heading\n');
    f.file('source.md', '# Source\n[ok](target.md#some-heading)');
    expect(linkErrors(f.root, 'source.md'), isEmpty);
    f.file('source.md', '# Source\n[bad](target.md#absent)');
    expect(linkErrors(f.root, 'source.md'), isNotEmpty);
    f.file('source.md', '# Source\n[bad](missing.md)');
    expect(linkErrors(f.root, 'source.md'), isNotEmpty);
  });
}
