// metadata_version: 1
// purpose: Load the versioned configuration graph and reject missing or unsafe references.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008, ADR-0009]
import 'dart:io';

import 'model.dart';
import 'policy_schema.dart';
import 'schema.dart';
import 'exception_parts.dart';

class Policy {
  Policy._(this.root, this.main, this.registries, this.files);
  final String root;
  final Json main;
  final Map<String, Json> registries;
  final List<String> files;
  Json operator [](String key) => registries[key]!;
  static Policy load(String root) {
    try {
      return _load(root);
    } on FileSystemException catch (e) {
      throw FormatException('Missing/unreadable policy reference: ${e.path}');
    } on TypeError {
      throw const FormatException('Policy fields have invalid types');
    }
  }

  static Policy _load(String root) {
    const entry = 'config/engineering-policy.json';
    final main = readJson(safePath(root, entry));
    keys(main, {
      'schema_version',
      'registries',
      'requirements_dir',
      'policy_sources',
    });
    if (main['schema_version'] != 1) {
      throw const FormatException('Unsupported policy schema');
    }
    strings(main['policy_sources']);
    final refs = Map<String, dynamic>.from(main['registries'] as Map);
    keys(refs, {
      'toolchain',
      'limits',
      'metadata',
      'adr',
      'commit',
      'checks',
      'platforms',
      'exceptions',
      'requirements',
    });
    final files = <String>[entry];
    final registries = <String, Json>{};
    for (final e in refs.entries) {
      if (e.value is! String) throw const FormatException('Invalid registry');
      final path = safePath(root, e.value as String);
      registries[e.key] = readJson(path);
      files.add(e.value as String);
    }
    registries['exceptions'] = exceptionParts(
      root,
      registries['exceptions']!,
      files,
    );
    final requirementDir = Directory(safePath(root, main['requirements_dir']));
    if (!requirementDir.existsSync()) {
      throw const FormatException('Missing requirement register');
    }
    files.addAll(
      requirementDir.listSync().whereType<File>().map(
        (f) => f.path
            .substring(Directory(root).absolute.path.length + 1)
            .replaceAll('\\', '/'),
      ),
    );
    final policy = Policy._(root, main, registries, files);
    validatePolicy(policy);
    return policy;
  }
}
