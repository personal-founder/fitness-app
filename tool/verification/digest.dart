// metadata_version: 1
// purpose: Hash exact input bytes using the existing maintained cryptography library.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008, ADR-0009]
import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';

import 'model.dart';

Future<String> hashBytes(List<int> value) async =>
    (await Sha256().hash(value)).bytes
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();

Future<String> hashFiles(String root, Iterable<String> paths) async {
  final rows = <String>[];
  final sorted = paths.toSet().toList()..sort();
  for (final path in sorted) {
    final file = File(safePath(root, path));
    final type = FileSystemEntity.typeSync(file.path, followLinks: false);
    if (type == FileSystemEntityType.link) {
      throw StateError('Symlink input cannot be validated safely: $path');
    }
    if (file.existsSync()) {
      rows.add(jsonEncode([path, await hashBytes(file.readAsBytesSync())]));
    }
  }
  return hashBytes(utf8.encode(rows.join('\n')));
}
