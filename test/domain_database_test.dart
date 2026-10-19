// metadata_version: 1
// purpose: "Real SQLite persistence and pure registration/display contracts."
// owner: unassigned
// related_adrs: [ADR-0025]
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macro_app/core/database/preferences_database.dart';
import 'package:macro_app/features/auth/registration.dart';
import 'package:macro_app/features/profile/profile.dart';

void main() {
  test('SQLite preferences upsert, special characters, and clear', () async {
    final db = PreferencesDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    expect(await db.read('appearance'), null);
    await db.write('appearance', 'system');
    await db.write('appearance', 'dark');
    expect(await db.read('appearance'), 'dark');
    await db.write("key'; DROP TABLE preferences;--", 'safe');
    expect(await db.read("key'; DROP TABLE preferences;--"), 'safe');
    await db.clear();
    expect(await db.read('appearance'), null);
  });
  test('nickname choice falls back only when nickname is absent', () {
    const profile = AccountProfile(
      firstName: 'A',
      lastName: 'B',
      tag: '#QF0001',
      nickname: 'King James',
      useNickname: true,
    );
    expect(profile.displayName, 'King James');
    expect(profile.tag, '#QF0001');
    const fallback = AccountProfile(
      firstName: 'A',
      lastName: 'B',
      tag: '#QF0001',
      nickname: ' ',
      useNickname: true,
    );
    expect(fallback.displayName, 'A B');
  });
  test(
    'registration rejects short passwords and invalid nickname preference',
    () {
      expect(
        const Registration('A', 'B', 'test@example.com', 'short').valid,
        false,
      );
      expect(const Registration('A', 'B', 'bad', 'long password').valid, false);
      expect(
        const Registration(
          'A',
          'B',
          'test@example.com',
          'long password',
          useNickname: true,
        ).valid,
        false,
      );
      expect(
        const Registration('A', 'B', 'test@example.com', 'long password').valid,
        true,
      );
    },
  );
}
