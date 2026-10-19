// metadata_version: 1
// purpose: "Drift/SQLite stores non-sensitive UI preferences only; never sessions or PINs."
// owner: unassigned
// related_adrs: [ADR-0022]
import 'package:drift/drift.dart';

class PreferencesDatabase extends GeneratedDatabase {
  PreferencesDatabase(super.executor);
  @override
  int get schemaVersion => 1;
  @override
  Iterable<TableInfo<Table, Object?>> get allTables => const [];
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (_) => customStatement(
      'CREATE TABLE preferences ('
      'key TEXT PRIMARY KEY, value TEXT NOT NULL)',
    ),
  );
  Future<String?> read(String key) async {
    final row = await customSelect(
      'SELECT value FROM preferences WHERE key = ?',
      variables: [Variable.withString(key)],
    ).getSingleOrNull();
    return row?.read<String>('value');
  }

  Future<void> write(String key, String value) => customStatement(
    'INSERT INTO preferences(key, value) VALUES (?, ?) '
    'ON CONFLICT(key) DO UPDATE SET value = excluded.value',
    [key, value],
  );
  Future<void> clear() => customStatement('DELETE FROM preferences');
}
