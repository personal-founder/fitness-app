// metadata_version: 1
// purpose: Render the actual routed application with controlled account and appearance adapters.
// owner: unassigned
// related_adrs: [ADR-0025]
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macro_app/app/app.dart';
import 'package:macro_app/app/theme/theme_controller.dart';
import 'package:macro_app/app/theme/theme_store.dart';
import 'package:macro_app/core/auth/auth_gateway.dart';
import 'package:macro_app/core/security/app_lock.dart';

import 'fakes.dart';
import 'memory_theme_store.dart';

Future<ProviderContainer> renderEntry(
  WidgetTester tester,
  FakeAuth auth, {
  FakeLock? lock,
  Size size = const Size(390, 844),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
  addTearDown(auth.events.close);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authGatewayProvider.overrideWithValue(auth),
        appLockProvider.overrideWithValue(lock ?? FakeLock()),
        themeStoreProvider.overrideWithValue(MemoryThemeStore()),
        initialThemeProvider.overrideWithValue(const ThemePreference()),
      ],
      child: const MacroApp(),
    ),
  );
  await tester.pumpAndSettle();
  return ProviderScope.containerOf(tester.element(find.byType(MacroApp)));
}

Finder entryField(String label) => find.widgetWithText(TextField, label);
