// metadata_version: 1
// purpose: Reject invalid or incompatible verification command-line options.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008, ADR-0009]
import 'model.dart';

class Options {
  Options(this.values);
  final Map<String, String> values;
  String? operator [](String name) => values[name];
  bool get staged => values.containsKey('staged');
  static Options parse(List<String> args) {
    final values = <String, String>{};
    const allowed = {
      'staged',
      'message',
      'flutter-sdk',
      'output',
      'evidence-dir',
      'shard',
      'aggregate',
      'base',
    };
    for (final arg in args) {
      if (!arg.startsWith('--')) throw FormatException('Unknown argument $arg');
      final pair = arg.substring(2).split('=');
      final key = pair.first;
      if (!allowed.contains(key) ||
          values.containsKey(key) ||
          (key == 'staged' ? pair.length != 1 : pair.length < 2)) {
        throw FormatException('Invalid option $arg');
      }
      final value = key == 'staged' ? '' : pair.skip(1).join('=');
      if (key != 'staged' && value.isEmpty) {
        throw FormatException('Empty option $key');
      }
      values[key] = value;
    }
    if (values.containsKey('shard') &&
        !{'windows', 'linux', 'macos'}.contains(values['shard'])) {
      throw const FormatException('Unsupported shard host');
    }
    if (values.containsKey('message') && !values.containsKey('staged')) {
      throw const FormatException('Commit messages require --staged');
    }
    if (values.containsKey('shard') && values.containsKey('aggregate')) {
      throw const FormatException('Shard and aggregate are mutually exclusive');
    }
    if (values.containsKey('message') &&
        (values.containsKey('shard') || values.containsKey('aggregate'))) {
      throw const FormatException(
        'Message validation cannot be sharded/aggregated',
      );
    }
    return Options(values);
  }

  Json toJson() => values;
}
