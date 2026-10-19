// metadata_version: 1
// purpose: Coordinate policy, app, build, commit, and platform evidence checks.
// owner: unassigned
// related_adrs: [ADR-0006, ADR-0007, ADR-0010]
import 'dart:io';

import 'aggregate.dart';
import 'commit_message.dart';
import 'context.dart';
import 'model.dart';
import 'receipts.dart';
import 'report.dart';
import 'run_gate.dart';
import 'diagnostics.dart';
import 'bootstrap_report.dart';

Future<void> main(List<String> args) async {
  Context? c;
  Json? input;
  try {
    input = readJson(args.single);
    c = await Context.load(input);
    final checks = <Check>[];
    final opts = c.options;
    if (opts['message'] != null) {
      final cached = receiptChecks(readJson(c.output), c);
      final errors = messageErrors(
        File(opts['message']!).readAsStringSync(),
        c,
      );
      checks.addAll(combine(c, cached));
      checks.add(
        Check(
          'commit:message',
          errors.isEmpty ? 'PASS' : 'FAIL',
          errors.isEmpty
              ? 'Message and complete ledger verified'
              : errors.join('\n'),
        ),
      );
      c.data['output'] = '${c.output}.message.json';
    } else if (opts['aggregate'] != null) {
      checks.addAll(combine(c, importReceipts(opts['aggregate']!, c)));
    } else {
      checks.addAll(await runGate(c));
    }
    if (!await c.unchanged()) {
      checks.add(Check('snapshot:final', 'FAIL', 'Snapshot/parent changed'));
    }
    saveReport(c, checks);
    exitCode = gateExit(checks);
  } catch (e) {
    final check = Check(
      'verification',
      e is FormatException ? 'INVALID' : 'BLOCKED',
      '$e',
    );
    if (c != null) {
      saveReport(c, [check]);
    } else {
      stderr.writeln(redacted(check.detail));
      if (input?['output'] is String) {
        saveBootstrapFailure(input!['source'], input['output'], check);
      }
    }
    exitCode = gateExit([check]);
  }
}
