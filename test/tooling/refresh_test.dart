// metadata_version: 1
// purpose: Prove requirement refresh preserves its records across repeated authoring runs.
// owner: unassigned
// related_adrs: [ADR-0006, ADR-0008]
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/verification/policy.dart';
import 'support.dart';

void main() {
  test('requirement refresh is idempotent with native path separators', () {
    final f = Fixture();
    addTearDown(f.dispose);
    copyPolicy(f);
    for (final path in Policy.load('.').main['policy_sources']) {
      f.file(path, File(path).readAsStringSync());
    }
    final script = File('tool/refresh_requirements.dart').absolute.path;
    final dart =
        '${sdkRoot()}/bin/cache/dart-sdk/bin/dart${Platform.isWindows ? '.exe' : ''}';
    ProcessResult refresh() =>
        Process.runSync(dart, [script], workingDirectory: f.root);
    expect(refresh().exitCode, 0);
    final directory = Directory('${f.root}/config/policy/requirements');
    final before = {
      for (final file in directory.listSync().whereType<File>())
        file.uri.pathSegments.last: file.readAsStringSync(),
    };
    expect(before, isNotEmpty);
    expect(refresh().exitCode, 0);
    expect({
      for (final file in directory.listSync().whereType<File>())
        file.uri.pathSegments.last: file.readAsStringSync(),
    }, before);
  });
}
