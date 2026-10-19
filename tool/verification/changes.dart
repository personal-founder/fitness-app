// metadata_version: 1
// purpose: Read staged path actions and numerical changes from NUL-delimited Git output.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008, ADR-0011]
import 'dart:convert';

import 'git.dart';
import 'model.dart';
import 'raw_changes.dart';

class Change {
  Change(
    this.path,
    this.action,
    this.added,
    this.deleted, {
    this.oldPath,
    this.binary = false,
    this.oldBytes = 0,
    this.newBytes = 0,
    this.lfsOid,
  });
  final String path, action;
  final String? oldPath;
  final int added, deleted;
  final bool binary;
  final int oldBytes, newBytes;
  final String? lfsOid;
  String get display {
    final label = oldPath == null ? path : '$oldPath -> $path';
    return RegExp(r'[|\r\n\t]').hasMatch(label)
        ? jsonEncode(label).replaceAll('|', r'\u007c')
        : label;
  }
}

List<Change> stagedChanges(Git git, Json limits, String base) {
  final flags = [
    'diff',
    '--cached',
    ...git.diffFlags(limits),
    if (base.isNotEmpty) base,
  ];
  final names = git.run([...flags, '--name-status', '-z']).split('\x00');
  final raw = rawChanges(git, flags);
  final numbers = git.run([...flags, '--numstat', '-z']).split('\x00');
  final stats = <String, (int, int, bool)>{};
  for (var i = 0; i < numbers.length && numbers[i].isNotEmpty; i++) {
    final fields = numbers[i].split('\t');
    final renamed = fields[2].isEmpty;
    final path = renamed ? numbers[i + 2] : fields.skip(2).join('\t');
    if (renamed) i += 2;
    stats[path] = (
      int.tryParse(fields[0]) ?? 0,
      int.tryParse(fields[1]) ?? 0,
      fields[0] == '-',
    );
  }
  final result = <Change>[];
  for (var i = 0; i < names.length && names[i].isNotEmpty; i++) {
    final status = names[i], old = names[++i];
    final renamed = status.startsWith('R') || status.startsWith('C');
    final path = renamed ? names[++i] : old;
    final stat = stats[path] ?? (0, 0, false);
    var action = switch (status[0]) {
      'A' => 'Added',
      'D' => 'Removed',
      'R' => 'Renamed',
      'C' => 'Copied',
      'T' => 'Type changed',
      _ => 'Edited',
    };
    final modes = raw[path]!;
    if (action == 'Edited' &&
        stat.$1 == 0 &&
        stat.$2 == 0 &&
        modes.oldMode != modes.newMode) {
      action = 'Mode changed';
    }
    result.add(
      Change(
        path,
        action,
        stat.$1,
        stat.$2,
        oldPath: renamed ? old : null,
        binary: stat.$3,
        oldBytes: stat.$3 ? modes.size(git, old: true) : 0,
        newBytes: stat.$3 ? modes.size(git) : 0,
        lfsOid: modes.lfs(git),
      ),
    );
  }
  return result;
}
