// metadata_version: 1
// purpose: Display an intentionally empty dashboard within the existing app shell.
// owner: unassigned
// related_adrs: [ADR-0045, ADR-0013]
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/session_controller.dart';
import '../welcome/background_layer.dart';
import '../welcome/entry_drawer.dart';
import '../welcome/entry_header.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionProvider);
    return Scaffold(
      drawer: const EntryDrawer(),
      body: BackgroundLayer(
        child: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
                child: EntryHeader(
                  signedIn: true,
                  registering: false,
                  busy: state.busy,
                  onAction: ref.read(sessionProvider.notifier).signOut,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
