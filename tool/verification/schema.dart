// metadata_version: 1
// purpose: Validate configuration keys, scalar types, command shapes, and timeouts.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008, ADR-0009]
import 'model.dart';

void keys(Json value, Set<String> required, [Set<String> optional = const {}]) {
  final actual = value.keys.toSet();
  if (!actual.containsAll(required) ||
      actual.difference({...required, ...optional}).isNotEmpty) {
    throw FormatException('Invalid keys: ${value.keys.join(', ')}');
  }
}

void strings(Object? value) {
  if (value is! List || value.any((v) => v is! String || v.isEmpty)) {
    throw const FormatException('Expected a nonempty-string array');
  }
}

void positive(Object? value) {
  if (value is! int || value < 1) {
    throw const FormatException('Expected a positive integer');
  }
}

void validateCommands(Json commands, {bool platforms = false}) {
  for (final entry in commands.entries) {
    final v = Map<String, dynamic>.from(entry.value as Map);
    if (platforms) {
      keys(v, {'hosts', 'args', 'timeout_seconds'});
      strings(v['hosts']);
      if ((v['hosts'] as List).any(
        (h) => !{'windows', 'linux', 'macos'}.contains(h),
      )) {
        throw const FormatException('Unsupported host');
      }
    } else {
      keys(
        v,
        {'tool', 'args', 'timeout_seconds'},
        {'paths', 'directory', 'exclude', 'host_args'},
      );
      if (!{'dart', 'flutter'}.contains(v['tool'])) {
        throw const FormatException('Unsupported command tool');
      }
      if (v.containsKey('paths')) strings(v['paths']);
      if (v.containsKey('directory') && v['directory'] is! String) {
        throw const FormatException('Expected suite directory');
      }
      if (v.containsKey('exclude')) strings(v['exclude']);
      if (v.containsKey('host_args')) {
        final hostArgs = Map<String, dynamic>.from(v['host_args']);
        keys(hostArgs, {'windows', 'linux', 'macos'});
        for (final args in hostArgs.values) {
          strings(args);
        }
      }
    }
    strings(v['args']);
    if ((v['args'] as List).isEmpty) {
      throw const FormatException('Missing command arguments');
    }
    positive(v['timeout_seconds']);
  }
}
