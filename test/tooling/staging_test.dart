// metadata_version: 1
// purpose: staging_test verifier regression coverage.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008, ADR-0009]
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/verification/staging.dart';
import '../../tool/verification/digest.dart';
import '../../tool/verification/temporary.dart';
import 'support.dart';

void main() {
  late Fixture f;
  setUp(() => f = Fixture());
  tearDown(() => f.dispose());

  test('unverified LFS materialization fails closed', () {
    f.file(
      'asset.bin',
      'version https://git-lfs.github.com/spec/v1\n'
          'oid sha256:${List.filled(64, 'a').join()}\nsize 123\n',
    );
    f.git.run(['add', '.']);
    expect(() => exportStage(f.git), throwsStateError);
  });

  test(
    'staged export ignores an unstaged repair and preserves both inputs',
    () {
      f.file('lib/a.dart', 'original\n');
      f.commit();
      f.file('lib/a.dart', 'broken staged\n');
      f.git.run(['add', 'lib/a.dart']);
      final before = f.git.tree;
      f.file('lib/a.dart', 'fixed but unstaged\n');
      final stage = exportStage(f.git);
      try {
        expect(f.file('lib/a.dart').readAsStringSync(), 'fixed but unstaged\n');
        expect(f.git.tree, before);
        final exported = stage.directory.uri.resolve('lib/a.dart').toFilePath();
        expect(File(exported).readAsStringSync(), 'broken staged\n');
      } finally {
        deleteTemporary(stage.directory, 'macro-verify-');
      }
    },
  );

  test(
    'a staged context becomes stale after index or parent changes',
    () async {
      f.file('a', 'first');
      f.commit();
      f.file('a', 'second');
      f.git.run(['add', '.']);
      final c = f.context(tree: f.git.tree);
      expect(await c.unchanged(), isTrue);
      f.file('a', 'third');
      f.git.run(['add', '.']);
      expect(await c.unchanged(), isFalse);
    },
  );

  test('working snapshot detects modified and newly added inputs', () async {
    f.file('a', 'first');
    f.commit();
    final c = f.context();
    c.identity['snapshot'] = await hashFiles(f.root, c.files);
    expect(await c.unchanged(), isTrue);
    f.file('new', 'untracked');
    expect(await c.unchanged(), isFalse);
  });
}
