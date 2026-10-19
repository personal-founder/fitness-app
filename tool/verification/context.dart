// metadata_version: 1
// purpose: Bind verification inputs to the snapshot, parent, policy, and lockfile.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008, ADR-0009]
import 'dart:io';

import 'digest.dart';
import 'git.dart';
import 'model.dart';
import 'options.dart';
import 'policy.dart';

class Context {
  Context(this.data, this.policy, this.identity, this.files, this.changed);
  final Json data, identity;
  final Policy policy;
  final List<String> files, changed;
  String get root => data['root'];
  String get source => data['source'];
  String get output => data['output'];
  String get sdk => data['sdk'];
  Options get options => Options(Map<String, String>.from(data['options']));
  static Future<Context> load(Json data) async {
    final root = data['root'] as String, git = Git(data['source']);
    final policy = Policy.load(root), staged = data['tree'] != null;
    final files = List<String>.from(data['inputs']);
    final contentDigest = await hashFiles(root, files);
    final opts = Options(Map<String, String>.from(data['options']));
    final base = opts['base'] == 'empty'
        ? git.run(['hash-object', '-t', 'tree', '--stdin']).trim()
        : opts['base'] == null
        ? (data['parent'] as String).isEmpty
              ? git.run(['hash-object', '-t', 'tree', '--stdin']).trim()
              : data['parent'] as String
        : git.run(['rev-parse', '--verify', '${opts['base']}^{commit}']).trim();
    final identity = <String, dynamic>{
      'snapshot': data['tree'] ?? contentDigest,
      'content_digest': contentDigest,
      'kind': staged ? 'staged' : 'working',
      'parent': data['parent'],
      'base': base,
      'policy_digest': await hashFiles(root, policy.files),
      'lock_digest': await hashBytes(
        File('$root/pubspec.lock').readAsBytesSync(),
      ),
      'versions': data['versions'],
    };
    return Context(
      data,
      policy,
      identity,
      files,
      git.changed(staged: staged, base: base.isEmpty ? null : base),
    );
  }

  Future<bool> unchanged() async {
    final git = Git(source);
    final copyUnchanged =
        identity['content_digest'] == null ||
        await hashFiles(root, files) == identity['content_digest'];
    return copyUnchanged &&
        git.parent == data['parent'] &&
        (data['tree'] != null
            ? git.tree == data['tree']
            : await hashFiles(source, files) == identity['snapshot'] &&
                  git.files.toSet().difference(files.toSet()).isEmpty);
  }
}
