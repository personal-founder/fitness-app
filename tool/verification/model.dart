// metadata_version: 1
// purpose: Define gate outcomes, JSON serialization, and safe repository-relative paths.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008, ADR-0009]
import 'dart:convert';
import 'dart:io';

import 'diagnostics.dart';

typedef Json = Map<String, dynamic>;

class Check {
  Check(
    this.id,
    this.status,
    this.detail, {
    this.seconds = 0,
    this.command = const [],
  });
  final String id, status, detail;
  final double seconds;
  final List<String> command;
  Json toJson() => {
    'id': id,
    'status': status,
    'detail': redacted(detail),
    'seconds': seconds,
    'command': command.map(redacted).toList(),
  };
}

int gateExit(Iterable<Check> checks) {
  final states = checks.map((c) => c.status).toSet();
  if (states.contains('INVALID')) return 3;
  if (states.contains('FAIL')) return 1;
  if (states.contains('BLOCKED')) return 2;
  return states.isNotEmpty && states.every((s) => s == 'PASS') ? 0 : 2;
}

Json readJson(String path) =>
    Map<String, dynamic>.from(jsonDecode(File(path).readAsStringSync()) as Map);

void writeJson(String path, Object value) {
  File(path).parent.createSync(recursive: true);
  File(path)
      .writeAsStringSync(const JsonEncoder.withIndent('  ').convert(value));
}

String safePath(String root, String relative) {
  final base = Directory(root).absolute.uri;
  final uri = base.resolveUri(Uri(path: relative));
  if (relative.isEmpty ||
      Uri.parse(relative).isAbsolute ||
      relative.startsWith('/') ||
      relative.contains('\\') ||
      relative.split('/').contains('..') ||
      uri.scheme != 'file' ||
      !uri.path.startsWith(base.path)) {
    throw FormatException('Path escapes repository: $relative');
  }
  return File.fromUri(uri).path;
}
