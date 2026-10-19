// metadata_version: 1
// purpose: Prove actual drawer appearance controls preserve forms and honor OS/reset behavior.
// owner: unassigned
// related_adrs: [ADR-0035, ADR-0025]
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macro_app/app/theme/theme_controller.dart';

import 'support/fakes.dart';
import 'support/render_entry.dart';

void main() {
  testWidgets(
    'drawer override, system changes and reset preserve typed credentials',
    (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
      final container = await renderEntry(tester, FakeAuth());
      await tester.enterText(entryField('Email'), 'synthetic@example.com');
      await tester.enterText(entryField('Password'), 'synthetic password');
      await tester.tap(find.byTooltip('Open menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();
      expect(find.text('Theme: System'), findsOneWidget);
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(container.read(themeProvider).mode, ThemeMode.dark);
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
      await tester.pumpAndSettle();
      expect(tester.widget<Switch>(find.byType(Switch)).value, true);
      await tester.tap(find.text('Reset to System Default'));
      await tester.pumpAndSettle();
      expect(container.read(themeProvider).mode, ThemeMode.system);
      expect(tester.widget<Switch>(find.byType(Switch)).value, false);
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      await tester.pumpAndSettle();
      expect(tester.widget<Switch>(find.byType(Switch)).value, true);
      await tester.tap(find.byTooltip('Close menu'));
      await tester.pumpAndSettle();
      expect(find.text('synthetic@example.com'), findsOneWidget);
      expect(find.text('synthetic password'), findsOneWidget);
    },
  );
  testWidgets('appearance does not discard a partially typed PIN', (
    tester,
  ) async {
    final auth = FakeAuth()..userId = 'saved';
    final container = await renderEntry(tester, auth);
    await tester.enterText(entryField('Passcode'), '12');
    await container.read(themeProvider.notifier).choose(ThemeMode.dark);
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(entryField('Passcode')).controller!.text,
      '12',
    );
  });
}
