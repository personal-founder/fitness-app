// metadata_version: 1
// purpose: Verify SQLite preferences survive closing and reopening a real file.
// owner: unassigned
// related_adrs: [ADR-0022, ADR-0025]
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macro_app/core/database/preferences_database.dart';

void main() {
  test('preference survives reopening a temporary SQLite file', () async {
    final directory = await Directory.systemTemp.createTemp(
      'macro-prefs-test-',
    );
    final file = File('${directory.path}/preferences.sqlite');
    addTearDown(() async {
      if (await file.exists()) await file.delete();
      await directory.delete(); // Only our now-empty test directory; no recursive deletion.
    });
    final first = PreferencesDatabase(NativeDatabase(file));
    await first.write('appearance', 'system');
    await first.close();
    expect(await file.exists(), true);
    final reopened = PreferencesDatabase(NativeDatabase(file));
    try {
      expect(await reopened.read('appearance'), 'system');
    } finally {
      await reopened.close();
    }
  });
}
