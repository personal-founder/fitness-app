// metadata_version: 1
// purpose: Read staged modes, binary sizes, and LFS identities without parsing filenames as whitespace.
// owner: unassigned
// related_adrs: [ADR-0007]
import 'dart:convert';

import 'git.dart';

class RawChange {
  RawChange(this.oldMode, this.newMode, this.oldOid, this.newOid);
  final String oldMode, newMode, oldOid, newOid;
  int size(Git git, {bool old = false}) {
    final oid = old ? oldOid : newOid;
    return RegExp(r'^0+$').hasMatch(oid)
        ? 0
        : int.parse(git.run(['cat-file', '-s', oid]).trim());
  }

  String? lfs(Git git) {
    final oid = RegExp(r'^0+$').hasMatch(newOid) ? oldOid : newOid;
    if (RegExp(r'^0+$').hasMatch(oid) ||
        int.parse(git.run(['cat-file', '-s', oid]).trim()) > 1024) {
      return null;
    }
    final text = utf8.decode(git.blob(oid), allowMalformed: true);
    if (!text.startsWith('version https://git-lfs.github.com/spec/v1')) {
      return null;
    }
    return RegExp(r'oid sha256:([a-f0-9]{64})').firstMatch(text)?[1];
  }
}

Map<String, RawChange> rawChanges(Git git, List<String> flags) {
  final fields = git
      .run([...flags, '--raw', '--no-abbrev', '-z'])
      .split('\x00');
  final result = <String, RawChange>{};
  for (var i = 0; i < fields.length && fields[i].isNotEmpty; i++) {
    final row = fields[i].substring(1).split(' ');
    final oldPath = fields[++i];
    final path = row[4].startsWith('R') || row[4].startsWith('C')
        ? fields[++i]
        : oldPath;
    result[path] = RawChange(row[0], row[1], row[2], row[3]);
  }
  return result;
}
