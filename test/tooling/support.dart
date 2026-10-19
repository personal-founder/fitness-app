// metadata_version: 1
// purpose: support verifier regression coverage.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008, ADR-0009]
import 'dart:io';

import '../../tool/verification/context.dart';
import '../../tool/verification/git.dart';
import '../../tool/verification/model.dart';
import '../../tool/verification/policy.dart';
import '../../tool/verification/temporary.dart';

class Fixture {
  Fixture() : dir = Directory.systemTemp.createTempSync('macro-gate-test-') {
    git.run(['init', '-q']);
    git.run(['config', 'user.name', 'Verification Test']);
    git.run(['config', 'user.email', 'verification@example.invalid']);
  }
  final Directory dir;
  String get root => dir.path;
  Git get git => Git(root);
  File file(String path, [String? text]) {
    final f = File('$root/$path');
    if (text != null) {
      f.parent.createSync(recursive: true);
      f.writeAsStringSync(text);
    }
    return f;
  }

  void commit() {
    git.run(['add', '.']);
    git.run(['commit', '-qm', 'fixture baseline']);
  }

  Context context({List<String>? files, List<String>? changed, String? tree}) {
    final policy = Policy.load(Directory.current.path);
    final identity = <String, dynamic>{
      'snapshot': tree ?? 'fixture',
      'kind': tree == null ? 'working' : 'staged',
      'parent': git.parent,
      'base': git.parent,
      'policy_digest': 'policy',
      'lock_digest': 'lock',
      'versions': {'flutter': 'fixture', 'dart': 'fixture'},
    };
    return Context(
      {
        'root': root,
        'source': root,
        'parent': git.parent,
        'tree': tree,
        'options': <String, String>{},
        'sdk': sdkRoot(),
        'versions': identity['versions'],
        'output': '$root/output/report.json',
      },
      policy,
      identity,
      files ?? git.files,
      changed ?? git.files,
    );
  }

  void dispose() => deleteTemporary(dir, 'macro-gate-test-');
}

String sdkRoot() {
  final config = readJson('.dart_tool/package_config.json');
  final flutter = (config['packages'] as List).firstWhere(
    (p) => p['name'] == 'flutter',
  );
  final uri = Directory.current.uri
      .resolve('.dart_tool/')
      .resolve(flutter['rootUri']);
  return Directory.fromUri(uri).parent.parent.path;
}

String sourceHeader(String purpose) =>
    '// metadata_version: 1\n'
    '// purpose: $purpose\n// owner: unassigned\n'
    '// related_adrs: [ADR-0007]\n';

void copyPolicy(Fixture f) {
  Directory('${f.root}/config/policy/requirements').createSync(recursive: true);
  final paths = Policy.load(Directory.current.path).files;
  for (final p in paths) {
    f.file(p, File(p).readAsStringSync());
  }
}
