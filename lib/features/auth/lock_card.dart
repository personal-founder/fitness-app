// metadata_version: 1
// purpose: "Separate app PIN enrollment/unlock; biometrics are delegated to the operating system."
// owner: unassigned
// related_adrs: [ADR-0018, ADR-0019, ADR-0032, ADR-0034, ADR-0037]
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/config.dart';
import '../../core/security/pin_policy.dart';
import '../../core/widgets/continue_button.dart';
import 'entry_field.dart';
import 'session_controller.dart';
import 'session_state.dart';

class LockCard extends ConsumerStatefulWidget {
  const LockCard({super.key});
  @override
  ConsumerState<LockCard> createState() => _LockCardState();
}

class _LockCardState extends ConsumerState<LockCard>
    with WidgetsBindingObserver {
  final pin = TextEditingController(), confirm = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    pin.addListener(_changed);
    confirm.addListener(_changed);
  }

  void _changed() => setState(() {});
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    pin.dispose();
    confirm.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      pin.clear();
      confirm.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sessionProvider),
        action = ref.read(sessionProvider.notifier);
    final enroll = state.phase == EntryPhase.enroll;
    final policyError = enroll
        ? PinPolicy.enrollmentError(pin.text, state.profile?.tag)
        : null;
    final valid =
        PinPolicy.validSyntax(pin.text) &&
        (!enroll || (pin.text == confirm.text && policyError == null));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Text(
            enroll ? 'Set a four-digit passcode' : 'Enter Passcode',
            textAlign: TextAlign.center,
          ),
        ),
        EntryField(
          label: 'Passcode',
          controller: pin,
          icon: Icons.lock,
          pin: true,
          enabled: !state.busy,
        ),
        if (enroll)
          EntryField(
            label: 'Confirm passcode',
            controller: confirm,
            pin: true,
            enabled: !state.busy,
          ),
        ContinueButton(
          busy: state.busy,
          onPressed: !valid
              ? null
              : () async {
                  final value = pin.text;
                  if (enroll) {
                    await action.enroll(value);
                  } else {
                    await action.unlock(value);
                  }
                  if (mounted) {
                    pin.clear();
                    confirm.clear();
                  }
                },
        ),
        if (!enroll)
          TextButton.icon(
            onPressed: state.busy || AppConfig.preview
                ? null
                : () => action.unlock('', biometric: true),
            icon: const Icon(Icons.fingerprint),
            label: const Text('Use Device Biometrics'),
          ),
        if (enroll) ...[
          const Text(
            'Stored only on this device.',
            textAlign: TextAlign.center,
          ),
          if (state.profile == null)
            TextButton(
              onPressed: state.busy ? null : action.restore,
              child: const Text('Retry loading account tag'),
            )
          else if (pin.text.length == PinPolicy.length && policyError != null)
            Text(policyError, textAlign: TextAlign.center),
        ] else
          // Explicitly requested inactive control; recovery is tracked in the work record.
          TextButton(onPressed: () {}, child: const Text('Forgot Passcode?')),
      ],
    );
  }
}
