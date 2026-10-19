// metadata_version: 1
// purpose: Parse format-safe metadata and validate required fields and decision coverage.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008]
import 'dart:io';

import 'package:yaml/yaml.dart';

import 'model.dart';
import 'policy.dart';
import 'schema.dart';
import 'native_header.dart';

Json? fileMetadata(String root, String path, Policy policy) {
  final target = File(safePath(root, path));
  final suffix = policy['metadata']['sidecar_suffix'] as String;
  final sidecar = File('${target.path}$suffix');
  String? raw;
  if (path.endsWith(suffix)) {
    raw = target.readAsStringSync();
  } else {
    String? text;
    try {
      text = target.readAsStringSync();
    } on FileSystemException {
      text = null;
    }
    if (text != null && text.startsWith('---\n')) {
      raw = text.split(RegExp(r'^---\s*$', multiLine: true))[1];
    } else if (text != null && text.startsWith('---\r\n')) {
      raw = text.split(RegExp(r'^---\s*$', multiLine: true))[1];
    } else if (text != null) {
      raw = nativeHeader(text, {
        ...List<String>.from(policy['metadata']['required']),
        ...List<String>.from(policy['metadata']['optional']),
      });
    }
    if (sidecar.existsSync()) {
      if (raw != null) {
        throw const FormatException('Duplicate metadata sources');
      }
      raw = sidecar.readAsStringSync();
    }
  }
  if (raw == null) return null;
  final parsed = loadYaml(raw);
  if (parsed is! Map) throw const FormatException('Metadata must be a mapping');
  return Map<String, dynamic>.from(parsed);
}

List<String> metadataErrors(
  String root,
  String path,
  Policy p,
  Set<String> ids,
) {
  final m = fileMetadata(root, path, p), errors = <String>[];
  if (m == null) return ['Missing metadata'];
  try {
    final suffix = p['metadata']['sidecar_suffix'] as String;
    final isSidecar = path.endsWith(suffix);
    final expectedTarget =
        (isSidecar ? path.substring(0, path.length - suffix.length) : path)
            .split('/')
            .last;
    if ((isSidecar || File('${safePath(root, path)}$suffix').existsSync()) &&
        m['target'] != expectedTarget) {
      errors.add('Sidecar describes the wrong file');
    }
    keys(
      m,
      Set<String>.from(p['metadata']['required']),
      Set<String>.from(p['metadata']['optional']),
    );
    if (m['metadata_version'] != p['metadata']['version'] ||
        m['purpose'] is! String ||
        (m['purpose'] as String).trim().isEmpty ||
        m['owner'] is! String ||
        (m['owner'] as String).trim().isEmpty) {
      errors.add('Invalid metadata values');
    }
    strings(m['related_adrs']);
    for (final id in m['related_adrs']) {
      if (!ids.contains(id)) errors.add('Unknown ADR: $id');
    }
    if ((m['related_adrs'] as List).isEmpty) errors.add('No decision coverage');
    if (path.endsWith(p['metadata']['sidecar_suffix']) &&
        (m['target'] is! String ||
            !File(safePath(File(safePath(root, path)).parent.path, m['target']))
                .existsSync())) {
      errors.add('Missing sidecar target');
    }
  } on FormatException catch (e) {
    errors.add(e.message);
  }
  return errors;
}
