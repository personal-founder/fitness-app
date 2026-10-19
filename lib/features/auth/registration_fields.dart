// metadata_version: 1
// purpose: "Provisional registration arrangement uses approved entry components only."
// owner: unassigned
// related_adrs: [ADR-0029, ADR-0014]
import 'package:flutter/material.dart';

import 'credential_draft.dart';
import 'entry_field.dart';

class RegistrationFields extends StatelessWidget {
  const RegistrationFields({
    super.key,
    required this.draft,
    required this.enabled,
  });
  final CredentialDraft draft;
  final bool enabled;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      EntryField(
        label: 'First name',
        controller: draft.first,
        enabled: enabled,
        autofill: AutofillHints.givenName,
      ),
      EntryField(
        label: 'Last name',
        controller: draft.last,
        enabled: enabled,
        autofill: AutofillHints.familyName,
      ),
      EntryField(
        label: 'Nickname (optional)',
        controller: draft.nickname,
        enabled: enabled,
      ),
      CheckboxListTile(
        value: draft.useNickname,
        contentPadding: EdgeInsets.zero,
        title: const Text('Display my nickname'),
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: enabled
            ? (value) => draft.selectNickname(value ?? false)
            : null,
      ),
    ],
  );
}
