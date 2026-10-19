// metadata_version: 1
// purpose: metadata_test verifier regression coverage.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008, ADR-0011]
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/verification/metadata.dart';
import '../../tool/verification/file_checks.dart';
import 'support.dart';

void main() {
  test('a sidecar cannot claim a different existing file', () {
    final f = Fixture();
    addTearDown(f.dispose);
    final p = f.context().policy;
    f.file('a.json', '{}');
    f.file('other.json', '{}');
    f.file(
      'a.json.meta.yaml',
      'metadata_version: 1\npurpose: Wrong target.\n'
          'owner: unassigned\nrelated_adrs: [ADR-0007]\ntarget: other.json\n',
    );
    expect(
      metadataErrors(f.root, 'a.json', p, {'ADR-0007'}),
      contains('Sidecar describes the wrong file'),
    );
  });
  test('metadata validates native headers and commentless sidecars', () {
    final f = Fixture();
    addTearDown(f.dispose);
    final p = f.context().policy;
    f.file(
      'a.dart',
      '${sourceHeader('Test one responsibility')}void main() {}',
    );
    expect(metadataErrors(f.root, 'a.dart', p, {'ADR-0007'}), isEmpty);
    f.file(
      'config.yaml',
      '${sourceHeader('Native header').replaceAll('//', '#')}name: unrelated_payload\nitems: [1, 2]\n',
    );
    expect(metadataErrors(f.root, 'config.yaml', p, {'ADR-0007'}), isEmpty);
    f.file('a.json', '{}');
    f.file(
      'a.json.meta.yaml',
      'metadata_version: 1\npurpose: Describe config.\n'
          'owner: unassigned\nrelated_adrs: [ADR-0007]\ntarget: a.json\n',
    );
    expect(metadataErrors(f.root, 'a.json', p, {'ADR-0007'}), isEmpty);
    expect(
      metadataErrors(f.root, 'a.json.meta.yaml', p, {'ADR-0007'}),
      isEmpty,
    );
    f.file('a.dart.meta.yaml', 'purpose: duplicate');
    expect(() => fileMetadata(f.root, 'a.dart', p), throwsFormatException);
  });
  test('missing ownership, unknown decisions, bad sidecars and YAML fail', () {
    final f = Fixture();
    addTearDown(f.dispose);
    final p = f.context().policy;
    f.file(
      'bad.dart',
      '// metadata_version: 1\n// purpose: Test\n'
          '// related_adrs: [ADR-9999]\n',
    );
    expect(metadataErrors(f.root, 'bad.dart', p, {}), isNotEmpty);
    f.file(
      'bad.meta.yaml',
      'metadata_version: 1\npurpose: Test\n'
          'owner: unassigned\nrelated_adrs: [ADR-0007]\ntarget: absent\n',
    );
    expect(
      metadataErrors(f.root, 'bad.meta.yaml', p, {'ADR-0007'}),
      isNotEmpty,
    );
    f.file('broken.md', '---\npurpose: [unterminated\n---\n# Broken');
    expect(() => fileMetadata(f.root, 'broken.md', p), throwsA(anything));
  });
  test('untouched violations are visible; changed violations block', () {
    final f = Fixture();
    addTearDown(f.dispose);
    f.file('old.dart', 'old file');
    f.file('new.dart', 'new file');
    final checks = inspectFiles(f.context(changed: ['new.dart']));
    expect(checks.first.status, 'FAIL');
    expect(checks.first.detail, contains('new.dart'));
    expect(checks.last.status, 'PASS');
    expect(checks.last.detail, contains('old.dart'));
  });
  test('the ADR limit cannot be overridden by a general size exception', () {
    final f = Fixture();
    addTearDown(f.dispose);
    const path = 'docs/adr/0007-shared-verifier.md';
    f.file(path, File(path).readAsStringSync() + List.filled(250, '\n').join());
    final c = f.context();
    c.policy['exceptions']['files'].add({
      'path': path,
      'max_lines': 800,
      'reason': 'Not permitted for ADRs',
      'adr': 'ADR-0007',
    });
    expect(inspectFiles(c).first.detail, contains('lines'));
  });
}
