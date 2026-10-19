// metadata_version: 1
// purpose: "Actual entry interactions, state identity, system appearance and responsive layout."
// owner: unassigned
// related_adrs: [ADR-0025, ADR-0035]
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macro_app/app/app.dart';
import 'package:macro_app/core/auth/auth_gateway.dart';
import 'package:macro_app/core/security/app_lock.dart';

import 'support/fakes.dart';

void main() {
  late FakeAuth auth;
  late FakeLock lock;
  setUp(() {
    auth = FakeAuth();
    lock = FakeLock();
  });
  Future<void> render(
    WidgetTester tester, {
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
          appLockProvider.overrideWithValue(lock),
        ],
        child: const MacroApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder field(String label) => find.widgetWithText(TextField, label);
  testWidgets(
    'signed out has Sign Up, credentials, no private remembered identity',
    (tester) async {
      await render(tester);
      expect(find.text('Sign Up'), findsOneWidget);
      expect(field('Email'), findsOneWidget);
      expect(find.text('King James'), findsNothing);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        null,
      );
      await tester.enterText(field('Email'), 'test@example.com');
      await tester.enterText(field('Password'), 'long password');
      await tester.pump();
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNotNull,
      );
      tester.binding.platformDispatcher.platformBrightnessTestValue =
          Brightness.dark;
      addTearDown(
        tester.binding.platformDispatcher.clearPlatformBrightnessTestValue,
      );
      await tester.pumpAndSettle();
      expect(find.text('test@example.com'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(find.text('King James'), findsOneWidget);
      expect(find.text('Sign Out'), findsOneWidget);
      expect(field('Email'), findsNothing);
      expect(field('Passcode'), findsOneWidget);
    },
  );
  testWidgets('Sign Up navigates to provisional real registration and back', (
    tester,
  ) async {
    await render(tester);
    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();
    expect(field('First name'), findsOneWidget);
    expect(field('Confirm password'), findsOneWidget);
    await tester.ensureVisible(find.text('Back to Log In'));
    await tester.tap(find.text('Back to Log In'));
    await tester.pumpAndSettle();
    expect(find.text('Sign Up'), findsOneWidget);
  });
  testWidgets(
    'tag toggles itself, masks on background; sign-out clears identity',
    (tester) async {
      auth.userId = 'saved';
      await render(tester);
      expect(find.text('#••••••'), findsOneWidget);
      await tester.tap(find.text('#••••••'));
      await tester.pump();
      expect(find.text('#QF4821'), findsOneWidget);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pump();
      expect(find.text('#••••••'), findsOneWidget);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sign Out'));
      await tester.pumpAndSettle();
      expect(find.text('King James'), findsNothing);
      expect(field('Email'), findsOneWidget);
    },
  );
  for (final size in [
    const Size(320, 568),
    const Size(844, 390),
    const Size(1440, 1000),
  ]) {
    testWidgets('scrolling and drawer at $size with 200% text', (tester) async {
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await render(tester, size: size);
      expect(tester.takeException(), null);
      await tester.tap(find.byTooltip('Open menu'));
      await tester.pumpAndSettle();
      expect(find.text('Settings'), findsOneWidget);
      await tester.tap(find.byTooltip('Close menu'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), null);
    });
  }
}
