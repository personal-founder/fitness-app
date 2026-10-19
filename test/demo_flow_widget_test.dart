// metadata_version: 1
// purpose: Exercise email/PIN/sign-out and sign-up navigation through the routed demo UI.
// owner: unassigned
// related_adrs: [ADR-0044, ADR-0042, ADR-0025, ADR-0045]
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macro_app/app/app.dart';
import 'package:macro_app/app/router.dart';

import 'package:macro_app/features/dashboard/dashboard_page.dart';

import 'support/demo_harness.dart';

void main() {
  Future<DemoHarness> render(WidgetTester tester) async {
    final demo = DemoHarness(MemoryDemoSessionStore());
    await demo.start();
    addTearDown(demo.close);
    tester.view.physicalSize = const Size(390, 960);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: demo.container,
        child: const MacroApp(),
      ),
    );
    await tester.pumpAndSettle();
    return demo;
  }

  Finder field(String label) => find.widgetWithText(TextField, label);
  Future<void> login(WidgetTester tester, String password) async {
    await tester.enterText(field('Email'), 'demo@gmail.com');
    await tester.enterText(field('Password'), password);
    await tester.pump();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
  }

  testWidgets('login, rejected credentials, PIN, sign-out and sign-in again', (
    tester,
  ) async {
    final demo = await render(tester);
    demo.container.read(routerProvider).go('/dashboard');
    await tester.pumpAndSettle();
    expect(field('Email'), findsOneWidget);
    expect(find.text('King James'), findsNothing);
    await login(tester, 'wrong');
    expect(find.text('Email or password is incorrect.'), findsOneWidget);
    expect(find.text('King James'), findsNothing);
    await login(tester, 'demo123');
    expect(find.text('Signed in as King James'), findsOneWidget);
    expect(find.text('Enter Passcode'), findsOneWidget);
    demo.container.read(routerProvider).go('/dashboard');
    await tester.pumpAndSettle();
    expect(field('Passcode'), findsOneWidget);
    await tester.enterText(field('Passcode'), '1234');
    await tester.pump();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.byType(DashboardPage), findsOneWidget);
    expect(field('Passcode'), findsNothing);
    expect(find.textContaining('Your account is ready.'), findsNothing);
    expect(
      demo.container
          .read(routerProvider)
          .routeInformationProvider
          .value
          .uri
          .path,
      '/dashboard',
    );
    demo.container.read(routerProvider).go('/lock');
    await tester.pumpAndSettle();
    expect(find.byType(DashboardPage), findsOneWidget);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(find.byType(DashboardPage), findsNothing);
    expect(field('Passcode'), findsOneWidget);
    await tester.tap(find.text('Sign Out'));
    await tester.pumpAndSettle();
    expect(field('Email'), findsOneWidget);
    expect(find.textContaining('Signed in as'), findsNothing);
    await login(tester, 'demo123');
    await tester.tap(find.text('Sign Out'));
    await tester.pumpAndSettle();
    expect(field('Email'), findsOneWidget);
    expect(demo.store.signedIn, false);
  });
  testWidgets('Sign Up and back preserve the approved navigation', (
    tester,
  ) async {
    await render(tester);
    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();
    expect(field('First name'), findsOneWidget);
    await tester.ensureVisible(find.text('Back to Log In'));
    await tester.tap(find.text('Back to Log In'));
    await tester.pumpAndSettle();
    expect(field('Email'), findsOneWidget);
  });
}
