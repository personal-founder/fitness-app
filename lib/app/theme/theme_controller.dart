// metadata_version: 1
// purpose: Follow System by default and retain usable manual appearance on storage failure.
// owner: unassigned
// related_adrs: [ADR-0035]
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme_store.dart';

class ThemePreference {
  const ThemePreference({
    this.mode = ThemeMode.system,
    this.saving = false,
    this.error,
  });
  final ThemeMode mode;
  final bool saving;
  final String? error;
}

Future<ThemePreference> loadTheme(ThemeStore store) async {
  try {
    final stored = await store.read();
    return ThemePreference(
      mode: ThemeMode.values.firstWhere(
        (mode) => mode.name == stored,
        orElse: () => ThemeMode.system,
      ),
    );
  } catch (_) {
    return const ThemePreference(
      error: 'Appearance could not be loaded. Using System.',
    );
  }
}

final initialThemeProvider = Provider<ThemePreference>(
  (ref) => const ThemePreference(),
);
final themeProvider = NotifierProvider<ThemeController, ThemePreference>(
  ThemeController.new,
);

class ThemeController extends Notifier<ThemePreference> {
  bool _disposed = false;
  @override
  ThemePreference build() {
    ref.onDispose(() => _disposed = true);
    return ref.read(initialThemeProvider);
  }

  Future<void> choose(ThemeMode mode) async {
    if (state.saving) return;
    state = ThemePreference(mode: mode, saving: true);
    try {
      await ref.read(themeStoreProvider).write(mode.name);
      if (!_disposed) state = ThemePreference(mode: mode);
    } catch (_) {
      if (!_disposed) {
        state = ThemePreference(
          mode: mode,
          error: 'Appearance could not be saved. Choose again to retry.',
        );
      }
    }
  }
}
