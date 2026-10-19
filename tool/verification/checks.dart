// metadata_version: 1
// purpose: Execute configured checks while keeping tooling and application suites distinct.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008, ADR-0009]
import 'dart:io';

import 'command.dart';
import 'context.dart';
import 'model.dart';
import 'sdk.dart';
import 'test_results.dart';

Future<List<Check>> runChecks(
  Context c, {
  Future<CommandResult> Function(String, List<String>, String, int) runner =
      execute,
}) async {
  final results = <Check>[];
  for (final entry in c.policy['checks'].entries) {
    final id = entry.key, spec = Map<String, dynamic>.from(entry.value);
    final args = List<String>.from(spec['args']);
    if (spec.containsKey('host_args')) {
      final extra = spec['host_args'][Platform.operatingSystem];
      if (extra == null) {
        results.add(
          Check(id, 'BLOCKED', 'No suite configuration for this host'),
        );
        continue;
      }
      args.addAll(List<String>.from(extra));
    }
    if (spec.containsKey('paths')) {
      final paths = List<String>.from(spec['paths']);
      final missing = paths.where(
        (p) => !Directory('${c.root}/$p').existsSync(),
      );
      if (missing.isNotEmpty) {
        results.add(
          Check(id, 'BLOCKED', 'Missing paths: ${missing.join(', ')}'),
        );
        continue;
      }
      args.addAll(paths);
    }
    if (spec.containsKey('directory')) {
      final directory = Directory(safePath(c.root, spec['directory']));
      final excludes = List<String>.from(spec['exclude']);
      final paths =
          !directory.existsSync()
                ? <String>[]
                : directory
                      .listSync(recursive: true)
                      .whereType<File>()
                      .map(
                        (f) => f.path
                            .substring(c.root.length + 1)
                            .replaceAll('\\', '/'),
                      )
                      .where(
                        (p) =>
                            p.endsWith('_test.dart') &&
                            !excludes.any(p.startsWith),
                      )
                      .toList()
            ..sort();
      if (paths.isEmpty) {
        results.add(Check(id, 'BLOCKED', 'Missing required test suite'));
        continue;
      }
      if (id == 'application') args.addAll(paths);
    }
    stdout.writeln('RUN $id');
    final r = await runner(
      executable(c.sdk, spec['tool']),
      args,
      c.root,
      spec['timeout_seconds'],
    );
    results.add(
      spec.containsKey('directory') ? testResult(id, r) : commandCheck(id, r),
    );
  }
  return results;
}
