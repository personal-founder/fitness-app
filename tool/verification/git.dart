// metadata_version: 1
// purpose: Access Git snapshots and changes without staging or overwriting user files.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008, ADR-0009]
import 'dart:io';

class Git {
  Git(this.root);
  final String root;
  String run(List<String> args, {bool allowFailure = false}) {
    final r = Process.runSync('git', args, workingDirectory: root);
    if (r.exitCode != 0 && !allowFailure) {
      throw StateError('git ${args.first}: ${r.stderr}');
    }
    return r.stdout as String;
  }

  List<int> blob(String oid) {
    final r = Process.runSync(
      'git',
      ['cat-file', 'blob', oid],
      workingDirectory: root,
      stdoutEncoding: null,
    );
    if (r.exitCode != 0) throw StateError('Cannot export staged blob');
    return (r.stdout as List<int>);
  }

  String get parent =>
      run(['rev-parse', '--verify', 'HEAD'], allowFailure: true).trim();
  String get tree => run(['write-tree']).trim();
  List<String> get files =>
      run(['ls-files', '-co', '--exclude-standard', '-z'])
          .split('\x00')
          .where((s) => s.isNotEmpty)
          .toSet()
          .toList()
        ..sort();
  List<String> changed({bool staged = false, String? base}) {
    final args = [
      'diff',
      if (staged) '--cached',
      '--name-only',
      '-z',
      if (base != null) base else if (parent.isNotEmpty) 'HEAD',
    ];
    return {
      ...run(args).split('\x00'),
      if (!staged)
        ...run(['ls-files', '--others', '--exclude-standard', '-z'])
            .split('\x00'),
    }.where((s) => s.isNotEmpty).toList()..sort();
  }

  List<String> diffFlags(Map<String, dynamic> limits) => [
    '--no-ext-diff',
    '--no-textconv',
    '--diff-algorithm=${limits['diff_algorithm']}',
    '--find-renames=${limits['rename_threshold']}%',
  ];
}
