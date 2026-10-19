// metadata_version: 1
// purpose: "Host-runnable synthetic-adapter journey; this does not validate live Supabase."
// owner: unassigned
// related_adrs: [ADR-0025, ADR-0032, ADR-0045]
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:macro_app/app/app.dart';
import 'package:macro_app/core/auth/auth_gateway.dart';
import 'package:macro_app/core/security/app_lock.dart';

import 'package:macro_app/features/dashboard/dashboard_page.dart';

import '../test/support/fakes.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('login, app passcode, unlock and sign-out', (tester) async {
    final auth = FakeAuth(), lock = FakeLock();
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
    await tester.enterText(
      find.widgetWithText(TextField, 'Email'),
      'test@example.com',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Password'),
      'long password',
    );
    await tester.pump();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('King James'), findsOneWidget);
    await tester.enterText(find.widgetWithText(TextField, 'Passcode'), '1234');
    await tester.pump();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.byType(DashboardPage), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
    await tester.tap(find.text('Sign Out'));
    await tester.pumpAndSettle();
    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.text('King James'), findsNothing);
  });
}
