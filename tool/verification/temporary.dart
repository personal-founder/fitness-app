// metadata_version: 1
// purpose: temporary verification responsibility.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008, ADR-0009]
import 'dart:io';

void deleteTemporary(Directory directory, String prefix) {
  if (!directory.existsSync()) return;
  final resolved = Directory(directory.resolveSymbolicLinksSync());
  final parent = Directory.systemTemp.resolveSymbolicLinksSync();
  final actualParent = resolved.parent.path.toLowerCase();
  final name = resolved.uri.pathSegments.where((v) => v.isNotEmpty).last;
  final active = Directory.current.resolveSymbolicLinksSync().toLowerCase();
  if (actualParent != parent.toLowerCase() || !name.startsWith(prefix)) {
    throw StateError('Refusing cleanup outside owned temporary directory');
  }
  if (active == resolved.path.toLowerCase() ||
      active.startsWith(
        '${resolved.path.toLowerCase()}${Platform.pathSeparator}',
      )) {
    throw StateError(
      'Refusing cleanup of the active workspace or its ancestor',
    );
  }
  directory.deleteSync(recursive: true);
}
