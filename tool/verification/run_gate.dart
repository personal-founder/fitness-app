// metadata_version: 1
// purpose: Compose the complete gate with controlled process injection for meaningful regression fixtures.
// owner: unassigned
// related_adrs: [ADR-0007]
import 'aggregate.dart';
import 'builds.dart';
import 'checks.dart';
import 'command.dart';
import 'context.dart';
import 'file_checks.dart';
import 'model.dart';
import 'policy_docs.dart';
import 'receipts.dart';
import 'requirements.dart';
import 'sdk.dart';

typedef Runner = Future<CommandResult> Function(
  String,
  List<String>,
  String,
  int,
);

Future<List<Check>> runGate(Context c, {Runner runner = execute}) async {
  final checks = <Check>[
    Check(
      'dependencies',
      'PASS',
      'Pinned lockfile restored',
      seconds: (c.data['restore_seconds'] as num? ?? 0).toDouble(),
      command: [
        executable(c.sdk, 'flutter'),
        ...List<String>.from(c.policy['toolchain']['restore']),
      ],
    ),
  ];
  checks.addAll(inspectFiles(c));
  checks.add(await requirementCheck(c));
  checks.add(policyDocumentation(c));
  final whitespace = await runner(
    'git',
    [
      'diff',
      if (c.options.staged) '--cached',
      '--check',
      if ((c.identity['base'] as String).isNotEmpty) c.identity['base'],
    ],
    c.source,
    c.policy['toolchain']['timeout_seconds'],
  );
  checks.add(commandCheck('git:whitespace', whitespace));
  checks.addAll(await runChecks(c, runner: runner));
  checks.addAll(await runBuilds(c, runner: runner));
  checks.add(
    Check(
      'snapshot',
      await c.unchanged() ? 'PASS' : 'FAIL',
      'Candidate and parent checked after verification',
    ),
  );
  final external = c.options['evidence-dir'];
  return external == null
      ? checks
      : combine(c, [...checks, ...importReceipts(external, c)]);
}
