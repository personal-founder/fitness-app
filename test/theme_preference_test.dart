// metadata_version: 1
// purpose: Verify System defaults, persisted overrides, reset and recoverable storage failures.
// owner: unassigned
// related_adrs: [ADR-0035, ADR-0025]
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macro_app/app/theme/theme_controller.dart';
import 'package:macro_app/app/theme/theme_store.dart';
import 'package:macro_app/core/database/preferences_database.dart';

import 'support/memory_theme_store.dart';

void main() {
  test(
    'default System; override survives container restart; reset persists',
    () async {
      final store = MemoryThemeStore();
      Future<ProviderContainer> start() async => ProviderContainer(
        overrides: [
          themeStoreProvider.overrideWithValue(store),
          initialThemeProvider.overrideWithValue(await loadTheme(store)),
        ],
      );
      var container = await start();
      expect(container.read(themeProvider).mode, ThemeMode.system);
      await container.read(themeProvider.notifier).choose(ThemeMode.dark);
      expect(store.value, 'dark');
      container.dispose();
      container = await start();
      expect(container.read(themeProvider).mode, ThemeMode.dark);
      await container.read(themeProvider.notifier).choose(ThemeMode.light);
      expect(store.value, 'light');
      await container.read(themeProvider.notifier).choose(ThemeMode.system);
      container.dispose();
      container = await start();
      expect(container.read(themeProvider).mode, ThemeMode.system);
      container.dispose();
    },
  );
  test(
    'read and write failures remain usable, report errors and retry',
    () async {
      final store = MemoryThemeStore()..broken = true;
      final initial = await loadTheme(store);
      expect(initial.mode, ThemeMode.system);
      expect(initial.error, isNotNull);
      final container = ProviderContainer(
        overrides: [
          themeStoreProvider.overrideWithValue(store),
          initialThemeProvider.overrideWithValue(initial),
        ],
      );
      addTearDown(container.dispose);
      final controller = container.read(themeProvider.notifier);
      await controller.choose(ThemeMode.dark);
      expect(container.read(themeProvider).mode, ThemeMode.dark);
      expect(container.read(themeProvider).error, isNotNull);
      store.broken = false;
      await controller.choose(ThemeMode.dark);
      expect(container.read(themeProvider).error, null);
      store.value = 'unrecognized';
      expect((await loadTheme(store)).mode, ThemeMode.system);
    },
  );
  test('theme adapter writes through the real SQLite boundary', () async {
    final database = PreferencesDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final store = DriftThemeStore(database);
    expect(await store.read(), null);
    await store.write('dark');
    expect(await database.read(themePreferenceKey), 'dark');
    await store.write('system');
    expect((await loadTheme(store)).mode, ThemeMode.system);
  });
}
