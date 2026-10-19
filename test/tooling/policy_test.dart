// metadata_version: 1
// purpose: policy_test verifier regression coverage.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008, ADR-0009]
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/verification/model.dart';
import '../../tool/verification/options.dart';
import '../../tool/verification/policy.dart';
import 'support.dart';

void main() {
  test('real configuration loads without duplicated validator values', () {
    final p = Policy.load('.');
    expect(p['limits']['adr']['target'], 249);
    expect(p['platforms'].length, 6);
  });
  test('exit statuses distinguish failure, blockage, invalid and pass', () {
    expect(gateExit([Check('a', 'PASS', '')]), 0);
    expect(gateExit([Check('a', 'BLOCKED', '')]), 2);
    expect(gateExit([Check('a', 'FAIL', ''), Check('b', 'BLOCKED', '')]), 1);
    expect(gateExit([Check('a', 'INVALID', '')]), 3);
    expect(gateExit([]), 2);
  });
  test('unknown, duplicate, empty and incompatible arguments fail', () {
    for (final args in [
      ['--unknown'],
      ['--staged', '--staged'],
      ['--output='],
      ['--message=msg'],
      ['--shard=linux', '--aggregate=x'],
    ]) {
      expect(() => Options.parse(args), throwsFormatException);
    }
  });
  test('unknown keys, schema versions and broken references fail', () {
    final f = Fixture();
    addTearDown(f.dispose);
    copyPolicy(f);
    final path = 'config/engineering-policy.json';
    final original = readJson(f.file(path).path);
    for (final bad in [
      {...original, 'schema_version': 999},
      {...original, 'unrecognized': true},
      {
        ...original,
        'registries': {...original['registries'], 'limits': '../outside'},
      },
    ]) {
      f.file(path, jsonEncode(bad));
      expect(() => Policy.load(f.root), throwsFormatException);
    }
  });
  test('missing, duplicate and unknown exception fragments fail', () {
    final f = Fixture();
    addTearDown(f.dispose);
    copyPolicy(f);
    for (final refs in [
      ['missing.json'],
      ['config/policy/exceptions.json'],
    ]) {
      f.file(
        'config/policy/exceptions.json',
        jsonEncode({'files': [], 'includes': refs}),
      );
      expect(() => Policy.load(f.root), throwsFormatException);
    }
  });
}
