// metadata_version: 1
// purpose: Verify source-preserving working exports and guarded report/temporary paths.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0009]
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/verification/working.dart';
import '../../tool/verification/temporary.dart';
import '../../tool/verification/output.dart';
import 'support.dart';

void main() {
  test('cleanup refuses an active temporary verification workspace', () {
    final f = Fixture();
    addTearDown(f.dispose);
    final directory = Directory.systemTemp.createTempSync('macro-verify-');
    addTearDown(() => deleteTemporary(directory, 'macro-verify-'));
    final helper = File('tool/verification/temporary.dart').absolute.uri;
    final script = f.file(
      'guard.dart',
      "import 'dart:io'; import '$helper'; "
          "void main(){try{deleteTemporary(Directory.current,'macro-verify-');exitCode=1;} on StateError{exitCode=0;}}",
    );
    final dart =
        '${sdkRoot()}/bin/cache/dart-sdk/bin/dart${Platform.isWindows ? '.exe' : ''}';
    final result = Process.runSync(dart, [
      script.path,
    ], workingDirectory: directory.path);
    expect(result.exitCode, 0);
    expect(directory.existsSync(), isTrue);
  });
  test(
    'working export protects source and detects regenerated copied inputs',
    () {
      final f = Fixture();
      addTearDown(f.dispose);
      f.file('lib/a.dart', 'original');
      f.file('.gitignore', 'output/\n');
      f.commit();
      final candidate = exportWorking(f.git);
      try {
        verifyMaterialization(candidate, f.git);
        File('${candidate.directory.path}/lib/a.dart')
            .writeAsStringSync('regenerated');
        expect(() => verifyMaterialization(candidate, f.git), throwsStateError);
        expect(f.file('lib/a.dart').readAsStringSync(), 'original');
      } finally {
        deleteTemporary(candidate.directory, 'macro-verify-');
      }
    },
  );
  test('reports cannot overwrite project files or tracked output', () {
    final f = Fixture();
    addTearDown(f.dispose);
    f.file('source.dart', 'original');
    f.file('.gitignore', 'output/\n');
    f.commit();
    expect(
      () => reportPath(f.root, '${f.root}/source.dart'),
      throwsFormatException,
    );
    expect(reportPath(f.root, null), contains('verification'));
    Directory('${f.root}/output/verification').createSync(recursive: true);
    expect(
      reportPath(f.root, '${f.root}/output/verification/report.json'),
      contains('report.json'),
    );
    expect(f.file('source.dart').readAsStringSync(), 'original');
    expect(
      () => deleteTemporary(Directory.current, 'macro-verify-'),
      throwsStateError,
    );
  });
}
