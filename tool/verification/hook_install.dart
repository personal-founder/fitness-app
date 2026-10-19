// metadata_version: 1
// purpose: Activate and remove local gate hooks while preserving existing configuration.
// owner: unassigned
// related_adrs: [ADR-0006, ADR-0007, ADR-0010]
import 'dart:io';

import 'git.dart';
import 'model.dart';
import 'schema.dart';
import 'options.dart';
import 'sdk.dart';

void configureHooks(String root, {required bool install, String? sdkRoot}) {
  final git = Git(root);
  final current = git.run([
    'config',
    '--local',
    '--get',
    'core.hooksPath',
  ], allowFailure: true).trim();
  final inherited = git.run([
    'config',
    '--get',
    'core.hooksPath',
  ], allowFailure: true).trim();
  final gitDir = git.run(['rev-parse', '--absolute-git-dir']).trim();
  final state = File('$gitDir/macro-verification-hooks.json');
  if (install) {
    if (state.existsSync()) {
      final saved = readJson(state.path);
      keys(saved, {'previous', 'inherited', 'previous_sdk', 'installed_sdk'});
      if (current == '.githooks') {
        stdout.writeln('Verification hooks already active');
        return;
      }
      throw StateError('Hook configuration changed since installation');
    }
    final defaults = Directory('$gitDir/hooks');
    if (inherited.isNotEmpty && inherited != '.githooks' ||
        defaults.existsSync() &&
            defaults.listSync().whereType<File>().any(
              (f) => !f.path.endsWith('.sample'),
            )) {
      throw StateError(
        'Existing hooks detected; integrate them before installation',
      );
    }
    for (final name in ['pre-commit', 'commit-msg']) {
      if (!File('$root/.githooks/$name').existsSync()) {
        throw StateError('Missing tracked hook $name');
      }
      if (!Platform.isWindows) {
        Process.runSync('chmod', ['+x', '$root/.githooks/$name']);
      }
    }
    final previousSdk = git.run([
      'config',
      '--local',
      '--get',
      'macro.verifySdk',
    ], allowFailure: true).trim();
    final sdk = (sdkRoot ?? flutterSdk(Options({}))).replaceAll('\\', '/');
    writeJson(state.path, {
      'previous': current,
      'inherited': inherited,
      'previous_sdk': previousSdk,
      'installed_sdk': sdk,
    });
    git.run(['config', '--local', 'macro.verifySdk', sdk]);
    git.run(['config', '--local', 'core.hooksPath', '.githooks']);
    stdout.writeln('Activated .githooks for this checkout');
  } else {
    if (!state.existsSync() || current != '.githooks') {
      throw StateError('No unchanged installation to remove');
    }
    final installed = readJson(state.path)['installed_sdk'];
    final currentSdk = git.run([
      'config',
      '--local',
      '--get',
      'macro.verifySdk',
    ], allowFailure: true).trim();
    if (installed != currentSdk) {
      throw StateError('SDK hook configuration changed; preserving your edits');
    }
    final previous = readJson(state.path)['previous'] as String;
    if (previous.isEmpty) {
      git.run(['config', '--local', '--unset', 'core.hooksPath']);
    } else {
      git.run(['config', '--local', 'core.hooksPath', previous]);
    }
    final previousSdk = readJson(state.path)['previous_sdk'] as String;
    if (previousSdk.isEmpty) {
      git.run(['config', '--local', '--unset', 'macro.verifySdk']);
    } else {
      git.run(['config', '--local', 'macro.verifySdk', previousSdk]);
    }
    state.deleteSync();
    stdout.writeln('Restored prior hook configuration');
  }
}
