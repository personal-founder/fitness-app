// metadata_version: 1
// purpose: "Login, provisional registration and recovery share one real backend form."
// owner: unassigned
// related_adrs: [ADR-0029, ADR-0014]
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/continue_button.dart';
import 'credential_draft.dart';
import 'entry_field.dart';
import 'registration.dart';
import 'registration_fields.dart';
import 'session_controller.dart';
import 'session_state.dart';

class CredentialForm extends ConsumerStatefulWidget {
  const CredentialForm({super.key, required this.phase});
  final EntryPhase phase;
  @override
  ConsumerState<CredentialForm> createState() => _CredentialFormState();
}

class _CredentialFormState extends ConsumerState<CredentialForm>
    with WidgetsBindingObserver {
  final draft = CredentialDraft();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    draft.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) draft.clearSecrets();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sessionProvider),
        actions = ref.read(sessionProvider.notifier);
    final register = widget.phase == EntryPhase.register;
    final recovery = widget.phase == EntryPhase.recovery;
    return ListenableBuilder(
      listenable: draft,
      builder: (context, _) {
        final valid = recovery
            ? draft.password.text.length >= 12 &&
                  draft.password.text == draft.confirm.text
            : register
            ? draft.registration.valid &&
                  draft.password.text == draft.confirm.text
            : validEmail(draft.email.text) && draft.password.text.isNotEmpty;
        return AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (register)
                RegistrationFields(draft: draft, enabled: !state.busy),
              if (!recovery)
                EntryField(
                  label: 'Email',
                  controller: draft.email,
                  icon: Icons.person,
                  email: true,
                  enabled: !state.busy,
                ),
              EntryField(
                label: recovery ? 'New password' : 'Password',
                controller: draft.password,
                icon: Icons.lock,
                secret: true,
                newPassword: register || recovery,
                enabled: !state.busy,
              ),
              if (register || recovery) ...[
                EntryField(
                  label: 'Confirm password',
                  controller: draft.confirm,
                  secret: true,
                  newPassword: true,
                  enabled: !state.busy,
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text('Use 12–128 characters for your password.'),
                ),
              ],
              ContinueButton(
                busy: state.busy,
                onPressed: !valid
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();
                        if (recovery) {
                          await actions.changePassword(draft.password.text);
                        } else if (register) {
                          await actions.register(draft.registration);
                        } else {
                          await actions.signIn(
                            draft.email.text,
                            draft.password.text,
                          );
                        }
                        if (mounted) draft.clearSecrets();
                      },
              ),
              if (!register && !recovery)
                TextButton(
                  onPressed: state.busy || !validEmail(draft.email.text)
                      ? null
                      : () => actions.recover(draft.email.text),
                  child: const Text('Forgot password?'),
                ),
              if (register)
                TextButton(
                  onPressed: state.busy
                      ? null
                      : () => actions.showRegistration(false),
                  child: const Text('Back to Log In'),
                ),
            ],
          ),
        );
      },
    );
  }
}
