// metadata_version: 1
// purpose: Run host-appropriate release builds and retain unsupported-target blockages.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008, ADR-0009]
import 'dart:io';

import 'command.dart';
import 'context.dart';
import 'model.dart';
import 'sdk.dart';
import 'native_tools.dart';

Future<List<Check>> runBuilds(
  Context c, {
  Future<CommandResult> Function(String, List<String>, String, int) runner =
      execute,
}) async {
  final checks = <Check>[];
  for (final entry in c.policy['platforms'].entries) {
    final spec = Map<String, dynamic>.from(entry.value);
    final id = 'build:${entry.key}';
    final shard = c.options['shard'];
    if (shard != null && shard != Platform.operatingSystem) {
      throw const FormatException('Shard must match the actual runner host');
    }
    if (!(spec['hosts'] as List).contains(Platform.operatingSystem)) {
      checks.add(
        Check(id, 'BLOCKED', 'Requires ${spec['hosts']} runner evidence'),
      );
      continue;
    }
    stdout.writeln('RUN $id');
    final result = await runner(
      executable(c.sdk, 'flutter'),
      List<String>.from(spec['args']),
      c.root,
      spec['timeout_seconds'],
    );
    final missing = result.code != 0 && nativeToolsMissing(result.output);
    checks.add(
      missing
          ? Check(
              id,
              'BLOCKED',
              'Native build prerequisites unavailable:\n${result.output}',
              seconds: result.seconds,
              command: result.command,
            )
          : commandCheck(id, result),
    );
  }
  return checks;
}
