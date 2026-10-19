// metadata_version: 1
// purpose: Isolate working inputs and reject regeneration of candidate source during restoration.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0009, ADR-0031]
import 'dart:io';

import 'git.dart';
import 'model.dart';
import 'staging.dart';
import 'temporary.dart';

Stage exportWorking(Git git) {
  final directory = Directory.systemTemp.createTempSync('macro-verify-');
  final result = Stage(directory, '', git.parent);
  try {
    result.inputs.addAll(git.files);
    for (final path in result.inputs) {
      final source = File(safePath(git.root, path));
      final type = FileSystemEntity.typeSync(source.path, followLinks: false);
      if (type == FileSystemEntityType.link) {
        throw StateError('Working input is a symlink: $path');
      }
      if (!source.existsSync()) continue;
      final target = File(safePath(directory.path, path));
      target.parent.createSync(recursive: true);
      target.writeAsBytesSync(source.readAsBytesSync());
      result.blobs[path] = git.run([
        'hash-object',
        '--no-filters',
        target.path,
      ]).trim();
      if (!Platform.isWindows && (source.statSync().mode & 0x49) != 0) {
        final r = Process.runSync('chmod', ['+x', target.path]);
        if (r.exitCode != 0) {
          throw StateError('Cannot preserve executable input');
        }
      }
    }
    return result;
  } catch (_) {
    deleteTemporary(directory, 'macro-verify-');
    rethrow;
  }
}

void verifyMaterialization(Stage candidate, Git git) {
  for (final entry in candidate.blobs.entries) {
    final path = safePath(candidate.directory.path, entry.key);
    if (!File(path).existsSync() ||
        git.run(['hash-object', '--no-filters', path]).trim() != entry.value) {
      throw StateError(
        'Dependency restoration changed source input: ${entry.key}',
      );
    }
  }
  if (git.parent != candidate.parent ||
      candidate.tree.isNotEmpty && git.tree != candidate.tree) {
    throw StateError('Candidate or parent changed during preparation');
  }
}
