// metadata_version: 1
// purpose: Record incomplete initialization evidence without presenting it as a verified snapshot.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0011]
import 'dart:io';

import 'git.dart';
import 'model.dart';

void saveBootstrapFailure(String root, String output, Check check) {
  final git = Git(root);
  writeJson(output, {
    'schema_version': 1,
    'identity': {
      'kind': 'incomplete',
      'snapshot': null,
      'parent': git.parent,
      'index_observed': git.tree,
      'policy_digest': null,
      'lock_digest': null,
      'versions': {'running_dart': Platform.version},
    },
    'runner': Platform.operatingSystem,
    'gate_exit': gateExit([check]),
    'created_at': DateTime.now().toUtc().toIso8601String(),
    'checks': [check.toJson()],
    'source': Platform.environment['GITHUB_ACTIONS'] == 'true'
        ? 'github-actions'
        : 'local',
    'run_id': Platform.environment['GITHUB_RUN_ID'],
    'shard': null,
    'limitations': [
      'Initialization stopped before full snapshot/policy identity was established. This report cannot satisfy the gate.',
    ],
  });
}
