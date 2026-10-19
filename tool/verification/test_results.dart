// metadata_version: 1
// purpose: Reject empty, skipped, or failing test suites from machine-readable events.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008, ADR-0009]
import 'dart:convert';

import 'model.dart';
import 'command.dart';
import 'native_tools.dart';

Check testResult(String id, CommandResult result) {
  if (result.blocked) return commandCheck(id, result);
  var passed = 0, skipped = 0, failed = 0;
  for (final line in const LineSplitter().convert(result.output)) {
    try {
      final e = jsonDecode(line);
      if (e is Map && e['type'] == 'testDone' && e['hidden'] != true) {
        if (e['skipped'] == true) {
          skipped++;
        } else if (e['result'] == 'success') {
          passed++;
        } else {
          failed++;
        }
      }
    } on FormatException {
      /* Flutter may emit non-event startup text. */
    }
  }
  if (result.code != 0 && passed == 0 && nativeToolsMissing(result.output)) {
    return Check(
      id,
      'BLOCKED',
      result.output,
      seconds: result.seconds,
      command: result.command,
    );
  }
  final status = result.code != 0 || failed > 0 || skipped > 0
      ? 'FAIL'
      : passed == 0
      ? 'BLOCKED'
      : 'PASS';
  return Check(
    id,
    status,
    '$passed passed, $failed failed, $skipped skipped. '
    '${status == 'PASS' ? '' : result.output}',
    seconds: result.seconds,
    command: result.command,
  );
}
