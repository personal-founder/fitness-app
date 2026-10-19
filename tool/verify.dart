// metadata_version: 1
// purpose: Start the shared verification gate and record initialization failures.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008, ADR-0009]
import 'dart:io';

import 'verification/bootstrap.dart';
import 'verification/model.dart';
import 'verification/output.dart';
import 'verification/options.dart';
import 'verification/git.dart';
import 'verification/diagnostics.dart';
import 'verification/bootstrap_report.dart';

Future<void> main(List<String> args) async {
  try {
    exitCode = await bootstrap(args);
  } on FormatException catch (e) {
    stderr.writeln(redacted('INVALID: ${e.message}'));
    exitCode = 3;
    recordFailure(args, e, exitCode);
  } catch (e) {
    stderr.writeln(redacted('BLOCKED: $e'));
    exitCode = 2;
    recordFailure(args, e, exitCode);
  }
}

void recordFailure(List<String> args, Object error, int code) {
  try {
    final root = Git(Directory.current.path)
        .run(['rev-parse', '--show-toplevel'])
        .trim();
    String? supplied;
    try {
      supplied = Options.parse(args)['output'];
    } on FormatException {
      /* Use safe default. */
    }
    final output = reportPath(root, supplied);
    saveBootstrapFailure(
      root,
      output,
      Check('bootstrap', code == 3 ? 'INVALID' : 'BLOCKED', '$error'),
    );
  } catch (_) {
    /* Reporting failure must never hide the original failed gate. */
  }
}
