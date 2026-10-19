// metadata_version: 1
// purpose: "Entry composition and lifecycle locking shared with the blank dashboard."
// owner: unassigned
// related_adrs: [ADR-0013, ADR-0036, ADR-0037, ADR-0045]
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/glass_panel.dart';
import '../dashboard/dashboard_page.dart';
import '../auth/credential_form.dart';
import '../auth/lock_card.dart';
import '../auth/session_controller.dart';
import '../auth/session_state.dart';
import 'account_identity.dart';
import 'background_layer.dart';
import 'entry_drawer.dart';
import 'entry_header.dart';
import 'entry_status.dart';
import 'profile_share.dart';

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({super.key});
  @override
  ConsumerState<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final session = ref.read(sessionProvider);
    if (state == AppLifecycleState.resumed &&
        session.signedIn &&
        !session.busy &&
        session.phase != EntryPhase.unlocked) {
      ref.read(sessionProvider.notifier).restore();
    }
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      ref.read(sessionProvider.notifier).background();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sessionProvider),
        action = ref.read(sessionProvider.notifier);
    if (state.phase == EntryPhase.unlocked) return const DashboardPage();
    final register = state.phase == EntryPhase.register;
    final title = register
        ? 'Create account'
        : state.phase == EntryPhase.recovery
        ? 'Reset password'
        : 'Macro App';
    return Scaffold(
      drawer: const EntryDrawer(),
      body: BackgroundLayer(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 20, 18, 80),
                    child: Column(
                      children: [
                        EntryHeader(
                          signedIn: state.signedIn,
                          registering: register,
                          busy: state.busy,
                          onAction: state.signedIn
                              ? action.signOut
                              : () => action.showRegistration(!register),
                        ),
                        SizedBox(
                          height: (constraints.maxHeight * .065).clamp(24, 60),
                        ),
                        AccountIdentity(
                          key: ValueKey(state.userId),
                          profile: state.profile,
                          title: title,
                        ),
                        const SizedBox(height: 18),
                        const ProfileShare(),
                        const SizedBox(height: 24),
                        GlassPanel(
                          child:
                              state.signedIn &&
                                  state.phase != EntryPhase.recovery
                              ? const LockCard()
                              : CredentialForm(
                                  key: ValueKey(state.phase),
                                  phase: state.phase,
                                ),
                        ),
                        if (state.message != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Semantics(
                              liveRegion: true,
                              child: Text(
                                state.message!,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        const EntryStatus(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
