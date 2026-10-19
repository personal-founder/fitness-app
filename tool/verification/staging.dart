// metadata_version: 1
// purpose: Export exact indexed bytes into an owned temporary verification workspace.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008, ADR-0009]
import 'dart:io';
import 'dart:convert';

import 'git.dart';
import 'model.dart';
import 'temporary.dart';

class Stage {
  Stage(this.directory, this.tree, this.parent);
  final Directory directory;
  final String tree, parent;
  final Map<String, String> blobs = {};
  final List<String> inputs = [];
}

Stage exportStage(Git git) {
  final tree = git.tree, parent = git.parent;
  final directory = Directory.systemTemp.createTempSync('macro-verify-');
  final result = Stage(directory, tree, parent);
  try {
    for (final record in git.run(['ls-files', '--stage', '-z']).split('\x00')) {
      if (record.isEmpty) continue;
      final match = RegExp(r'^(\d+) ([a-f0-9]+) (\d)\t([\s\S]+)$')
          .firstMatch(record);
      if (match == null ||
          match[3] != '0' ||
          !{'100644', '100755'}.contains(match[1])) {
        throw StateError('Unsupported or conflicted index entry');
      }
      final file = File(safePath(directory.path, match[4]!));
      file.parent.createSync(recursive: true);
      final bytes = git.blob(match[2]!);
      if (utf8
          .decode(bytes.take(80).toList(), allowMalformed: true)
          .startsWith('version https://git-lfs.github.com/spec/v1')) {
        throw StateError(
          'LFS materialization requires verified object support',
        );
      }
      file.writeAsBytesSync(bytes);
      result.blobs[match[4]!] = match[2]!;
      result.inputs.add(match[4]!);
      if (!Platform.isWindows && match[1] == '100755') {
        final r = Process.runSync('chmod', ['+x', file.path]);
        if (r.exitCode != 0) {
          throw StateError('Cannot preserve executable mode');
        }
      }
    }
    if (tree != git.tree || parent != git.parent) {
      throw StateError('Index or parent changed during export');
    }
    return result;
  } catch (_) {
    deleteTemporary(directory, 'macro-verify-');
    rethrow;
  }
}
