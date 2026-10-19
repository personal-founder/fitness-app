// metadata_version: 1
// purpose: Resolve the local Flutter SDK and inspect its declared pinned versions.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008, ADR-0009]
import 'dart:io';

import 'model.dart';
import 'options.dart';

String flutterSdk(Options options) {
  final explicit =
      options['flutter-sdk'] ?? Platform.environment['FLUTTER_ROOT'];
  final inferred = File(Platform.resolvedExecutable)
      .parent
      .parent
      .parent
      .parent
      .parent
      .path;
  final candidates = <String>[
    ?explicit,
    inferred,
    for (final path in (Platform.environment['PATH'] ?? '').split(
      Platform.isWindows ? ';' : ':',
    ))
      Directory(path).parent.path,
  ];
  for (final root in candidates) {
    final bin = File('$root/bin/flutter${Platform.isWindows ? '.bat' : ''}');
    if (bin.existsSync()) return Directory(root).absolute.path;
    if (explicit == root) throw StateError('Flutter SDK is unavailable');
  }
  throw StateError('Flutter SDK not found; supply --flutter-sdk=<directory>');
}

Json sdkVersions(String root) {
  final data = readJson('$root/bin/cache/flutter.version.json');
  return {
    'flutter': data['frameworkVersion'],
    'dart': data['dartSdkVersion'],
    'revision': data['frameworkRevision'],
  };
}

String executable(String sdk, String name) => name == 'dart'
    ? '$sdk/bin/cache/dart-sdk/bin/dart${Platform.isWindows ? '.exe' : ''}'
    : '$sdk/bin/flutter${Platform.isWindows ? '.bat' : ''}';
