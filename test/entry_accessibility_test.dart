// metadata_version: 1
// purpose: Exercise expanded appearance and QR layouts with large text on a narrow viewport.
// owner: unassigned
// related_adrs: [ADR-0035, ADR-0036, ADR-0025]
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:macro_app/features/auth/session_controller.dart';

import 'support/fakes.dart';
import 'support/render_entry.dart';

void main() {
  testWidgets('expanded settings and QR work at 320px and 200% text', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final container = await renderEntry(
      tester,
      FakeAuth()..userId = 'saved',
      size: const Size(320, 568),
    );
    await tester.tap(find.byTooltip('Open menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), null);
    await tester.ensureVisible(find.text('Reset to System Default'));
    await tester.tap(find.text('Reset to System Default'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byTooltip('Close menu'));
    await tester.tap(find.byTooltip('Close menu'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byTooltip('Show profile QR code'));
    await tester.tap(find.byTooltip('Show profile QR code'));
    await tester.pumpAndSettle();
    expect(find.byType(QrImageView), findsOneWidget);
    expect(tester.takeException(), null);
    await container.read(sessionProvider.notifier).signOut();
    await tester.pumpAndSettle();
    expect(find.byType(QrImageView), findsNothing);
    expect(find.textContaining('Signed in as'), findsNothing);
  });
}
