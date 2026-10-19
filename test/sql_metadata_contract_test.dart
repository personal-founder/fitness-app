// metadata_version: 1
// purpose: Verify the shared policy reader accepts valid SQL metadata comments.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0015]
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../tool/verification/adr_checks.dart';
import '../tool/verification/metadata.dart';
import '../tool/verification/policy.dart';

void main() {
  test('auth migrations have resolving native SQL comment metadata', () {
    final root = Directory.current.path;
    final policy = Policy.load(root);
    final ids = adrIds(root, policy).keys.toSet();
    for (final file in Directory(
      'supabase/migrations',
    ).listSync().whereType<File>()) {
      if (file.path.endsWith('.sql')) {
        expect(
          metadataErrors(root, file.path.replaceAll('\\', '/'), policy, ids),
          isEmpty,
        );
      }
    }
  });
}
