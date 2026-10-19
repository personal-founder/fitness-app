// metadata_version: 1
// purpose: Verify the public QR contract, locked sharing and lifecycle/account privacy.
// owner: unassigned
// related_adrs: [ADR-0036, ADR-0037, ADR-0025]
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:macro_app/features/profile/friend_code.dart';
import 'package:macro_app/features/profile/profile.dart';
import 'package:macro_app/features/auth/session_controller.dart';
import 'package:macro_app/features/auth/session_state.dart';

import 'support/fakes.dart';
import 'support/render_entry.dart';

void main() {
  test('friend URI round trips only a public tag and protocol version', () {
    final uri = Uri.parse(friendCode('#QF4821'));
    expect(uri.scheme, 'macroapp');
    expect(uri.host, 'friend');
    expect(uri.queryParameters, {'v': '1', 'tag': '#QF4821'});
    expect(uri.fragment, isEmpty);
    expect(() => friendCode('private-or-invalid'), throwsFormatException);
  });
  testWidgets('locked avatar opens QR; background closes; forgot is a no-op', (
    tester,
  ) async {
    final auth = FakeAuth()..userId = 'saved';
    final container = await renderEntry(tester, auth);
    expect(find.text('Enter Passcode'), findsOneWidget);
    expect(find.text('Use Device Biometrics'), findsOneWidget);
    expect(find.text('Signed in as King James'), findsOneWidget);
    await tester.tap(find.text('Forgot Passcode?'));
    await tester.pumpAndSettle();
    expect(container.read(sessionProvider).phase, EntryPhase.locked);
    await tester.tap(find.byTooltip('Show profile QR code'));
    await tester.pumpAndSettle();
    expect(find.byType(QrImageView), findsOneWidget);
    expect(find.text('#QF4821'), findsOneWidget);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pumpAndSettle();
    expect(find.byType(QrImageView), findsNothing);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(find.text('#••••••'), findsOneWidget);
  });
  testWidgets(
    'QR dismisses on account change; footer uses selected full name',
    (tester) async {
      final auth = FakeAuth()..userId = 'saved';
      final container = await renderEntry(tester, auth);
      await tester.tap(find.byTooltip('Show profile QR code'));
      await tester.pumpAndSettle();
      container
          .read(sessionProvider.notifier)
          .update(
            const SessionState(
              userId: 'different',
              phase: EntryPhase.locked,
              profile: AccountProfile(
                firstName: 'Another',
                lastName: 'Person',
                nickname: 'Ignored',
                useNickname: false,
                tag: '#AB0007',
              ),
            ),
          );
      await tester.pumpAndSettle();
      expect(find.byType(QrImageView), findsNothing);
      expect(find.text('Signed in as Another Person'), findsOneWidget);
      container.read(sessionProvider.notifier).update(const SessionState());
      await tester.pumpAndSettle();
      expect(find.byTooltip('Show profile QR code'), findsNothing);
      expect(find.textContaining('Signed in as'), findsNothing);
    },
  );
}
