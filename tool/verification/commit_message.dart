// metadata_version: 1
// purpose: Validate commit prose, sections, decision coverage, and candidate identity.
// owner: unassigned
// related_adrs: [ADR-0007, ADR-0008, ADR-0011]
import 'context.dart';
import 'changes.dart';
import 'git.dart';
import 'ledger.dart';
import 'adr_checks.dart';

List<String> messageErrors(String message, Context c) {
  final rule = c.policy['commit'], errors = <String>[];
  final lines = message.split('\n');
  final subject = lines.first;
  final types = (rule['types'] as List)
      .map((v) => RegExp.escape(v as String))
      .join('|');
  if (!RegExp('^(?:$types)(?:\\([a-z0-9_-]+\\))?!?: .+').hasMatch(subject) ||
      subject.length > rule['subject_max']) {
    errors.add('Invalid commit subject');
  }
  for (final pattern in rule['forbidden_patterns']) {
    if (RegExp(pattern, caseSensitive: false).hasMatch(message)) {
      errors.add('Forbidden attribution or unresolved placeholder');
    }
  }
  var previous = 0;
  for (final section in rule['sections']) {
    final found = lines.indexOf(section);
    if (lines.where((line) => line == section).length != 1) {
      errors.add('Section must occur exactly once: $section');
    }
    if (found <= previous || found + 1 >= lines.length) {
      errors.add('Missing/reordered section: $section');
    } else {
      final next = lines
          .skip(found + 1)
          .takeWhile((v) => !(rule['sections'] as List).contains(v))
          .join('\n')
          .trim();
      if (next.isEmpty) errors.add('Empty section: $section');
    }
    previous = found;
  }
  if (subject.contains('!:') && !message.contains('BREAKING CHANGE: ')) {
    errors.add('Breaking change requires a migration trailer');
  }
  final changes = stagedChanges(
    Git(c.source),
    c.policy['limits'],
    c.identity['base'],
  );
  errors.addAll(
    ledgerErrors(
      message,
      changes,
      allowedActions: List<String>.from(rule['actions']),
    ),
  );
  final known = adrIds(c.root, c.policy).keys.toSet();
  for (final change in changes) {
    final coverage = message
        .split('Decisions and ADRs')
        .last
        .split('Dependencies and downloads')
        .first;
    final rows = coverage
        .split('\n')
        .where(
          (row) => row.contains(change.path) || row.contains(change.display),
        );
    final referenced = rows
        .expand((row) => RegExp(r'ADR-\d{4}').allMatches(row).map((m) => m[0]!))
        .toList();
    if (referenced.isEmpty || referenced.any((id) => !known.contains(id))) {
      errors.add('Missing explicit decision coverage: ${change.path}');
    }
  }
  if (!message.contains(c.identity['snapshot']) ||
      !message.contains(c.identity['base'])) {
    errors.add('Message must name the validated tree and comparison base');
  }
  return errors;
}
