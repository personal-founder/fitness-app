// metadata_version: 1
// purpose: hooks_test verifier regression coverage.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0009, ADR-0010, ADR-0011]
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/verification/hook_install.dart';
import 'support.dart';

void main() {
  test(
    'hooks reject invalid candidates/messages and accept a valid fixture',
    () {
      final f = Fixture();
      addTearDown(f.dispose);
      for (final name in ['pre-commit', 'commit-msg']) {
        f.file('.githooks/$name', File('.githooks/$name').readAsStringSync());
      }
      f.file('tool/verify.dart', '''
import 'dart:io';
void main(List<String> args) {
  if (File('candidate.txt').readAsStringSync() != 'valid') { exitCode = 1; return; }
  final msg = args.where((a) => a.startsWith('--message='));
  if (msg.isNotEmpty && !File(msg.single.substring(10)).readAsStringSync().contains('acceptable')) exitCode = 1;
}
''');
      f.file('candidate.txt', 'broken');
      f.git.run(['add', '.']);
      final index = f.git.tree;
      configureHooks(f.root, install: true, sdkRoot: sdkRoot());
      ProcessResult commit(String message) => Process.runSync('git', [
        'commit',
        '-qm',
        message,
      ], workingDirectory: f.root);
      expect(commit('acceptable fixture').exitCode, isNot(0));
      expect(f.git.tree, index);
      f.file('candidate.txt', 'valid');
      f.git.run(['add', '.']);
      expect(commit('incomplete fixture').exitCode, isNot(0));
      expect(commit('acceptable fixture').exitCode, 0);
      configureHooks(f.root, install: false);
      expect(
        f.git.run([
          'config',
          '--get',
          'core.hooksPath',
        ], allowFailure: true).trim(),
        isEmpty,
      );
    },
  );
  test('existing hook configuration is preserved rather than overwritten', () {
    final f = Fixture();
    addTearDown(f.dispose);
    f.git.run(['config', 'core.hooksPath', 'custom-hooks']);
    expect(
      () => configureHooks(f.root, install: true, sdkRoot: sdkRoot()),
      throwsStateError,
    );
    expect(
      f.git.run(['config', '--get', 'core.hooksPath']).trim(),
      'custom-hooks',
    );
  });
}
