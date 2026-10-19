// metadata_version: 1
// purpose: Show the active selected identity or an honest configuration/demo status.
// owner: unassigned
// related_adrs: [ADR-0034, ADR-0037, ADR-0044]
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/config.dart';
import '../auth/session_controller.dart';

class EntryStatus extends ConsumerWidget {
  const EntryStatus({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    if (!session.signedIn && AppConfig.configured && !AppConfig.preview) {
      return const SizedBox.shrink();
    }
    final name = session.profile?.displayName;
    final message = session.signedIn
        ? name == null
              ? 'Signed in'
              : 'Signed in as $name'
        : AppConfig.preview
        ? 'Demo account. Sign in to continue.'
        : 'Connect Supabase to use accounts.';
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(message, textAlign: TextAlign.center),
    );
  }
}
