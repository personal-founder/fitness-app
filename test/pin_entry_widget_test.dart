// metadata_version: 1
// purpose: Prove enrollment confirmation and tag rejection through the actual entry controls.
// owner: unassigned
// related_adrs: [ADR-0032, ADR-0025]
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fakes.dart';
import 'support/render_entry.dart';

void main() {
  testWidgets('enrollment requires four matching digits distinct from tag', (
    tester,
  ) async {
    final lock = FakeLock()..hasPin = false;
    await renderEntry(tester, FakeAuth()..userId = 'saved', lock: lock);
    Future<void> input(String pin, String confirmation) async {
      await tester.enterText(entryField('Passcode'), pin);
      await tester.enterText(entryField('Confirm passcode'), confirmation);
      await tester.pump();
    }

    bool enabled() =>
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed !=
        null;
    await input('123', '123');
    expect(enabled(), false);
    await input('1234', '4321');
    expect(enabled(), false);
    await input('4821', '4821');
    expect(enabled(), false);
    expect(find.textContaining('cannot match'), findsOneWidget);
    await input('1234', '1234');
    expect(enabled(), true);
    await tester.ensureVisible(find.text('Continue'));
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(lock.hasPin, true);
    expect(find.text('Enter Passcode'), findsOneWidget);
  });
}
