// metadata_version: 1
// purpose: Expose explicit local hook installation and removal commands.
// owner: unassigned
// related_adrs: [ADR-0006, ADR-0007, ADR-0010]
import 'dart:io';

import 'verification/hook_install.dart';

void main(List<String> args) {
  try {
    if (args.length != 1 || !{'install', 'remove'}.contains(args.single)) {
      throw const FormatException('Use: dart tool/hooks.dart install|remove');
    }
    configureHooks(Directory.current.path, install: args.single == 'install');
  } catch (e) {
    stderr.writeln(e);
    exitCode = 3;
  }
}
