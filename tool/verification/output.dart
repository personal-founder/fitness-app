// metadata_version: 1
// purpose: output verification responsibility.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008, ADR-0009]
import 'dart:io';

String reportPath(String source, String? supplied) {
  final path = File(supplied ?? '$source/output/verification/latest.json')
      .absolute
      .path;
  final base = Directory(source).absolute.uri;
  final target = File(path).uri;
  final prefix = base.resolve('output/verification/');
  if (target.path.startsWith(base.path) &&
      !target.path.startsWith(prefix.path)) {
    throw const FormatException(
      'Reports inside the repository must use output/verification/',
    );
  }
  if (target.path.startsWith(base.path)) {
    final relative = target.path.substring(base.path.length);
    final ignored = Process.runSync('git', [
      'check-ignore',
      '-q',
      '--',
      relative,
    ], workingDirectory: source);
    if (ignored.exitCode != 0) {
      throw const FormatException(
        'In-repository reports must be ignored and untracked',
      );
    }
  }
  if (FileSystemEntity.typeSync(path, followLinks: false) ==
      FileSystemEntityType.link) {
    throw const FormatException('Report destination may not be a symlink');
  }
  var ancestor = File(path).parent;
  while (!ancestor.existsSync() && ancestor.path != ancestor.parent.path) {
    ancestor = ancestor.parent;
  }
  final resolved = Directory(ancestor.resolveSymbolicLinksSync()).absolute.uri
      .normalizePath()
      .toString();
  final original = ancestor.absolute.uri.normalizePath().toString();
  if ((Platform.isWindows ? resolved.toLowerCase() : resolved) !=
      (Platform.isWindows ? original.toLowerCase() : original)) {
    throw const FormatException('Report destination crosses a symbolic link');
  }
  return path;
}
