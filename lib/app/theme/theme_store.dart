// metadata_version: 1
// purpose: Persist non-sensitive appearance using existing native SQLite or browser preferences.
// owner: unassigned
// related_adrs: [ADR-0022, ADR-0035]
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/database/local_preferences.dart';
import '../../core/database/preferences_database.dart';

abstract interface class ThemeStore {
  Future<String?> read();
  Future<void> write(String mode);
}

const themePreferenceKey = 'appearance.theme';
final themeStoreProvider = Provider<ThemeStore>(
  (ref) =>
      throw StateError('Theme persistence must be initialized at startup.'),
);

ThemeStore openThemeStore() {
  final database = openLocalPreferences();
  return database == null ? BrowserThemeStore() : DriftThemeStore(database);
}

class DriftThemeStore implements ThemeStore {
  DriftThemeStore(this.database);
  final PreferencesDatabase database;
  @override
  Future<String?> read() => database.read(themePreferenceKey);
  @override
  Future<void> write(String mode) => database.write(themePreferenceKey, mode);
}

class BrowserThemeStore implements ThemeStore {
  final preferences = SharedPreferencesAsync();
  @override
  Future<String?> read() => preferences.getString(themePreferenceKey);
  @override
  Future<void> write(String mode) =>
      preferences.setString(themePreferenceKey, mode);
}
