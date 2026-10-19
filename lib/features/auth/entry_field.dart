// metadata_version: 1
// purpose: "Consistent labeled fields with password-manager and keyboard semantics."
// owner: unassigned
// related_adrs: [ADR-0029, ADR-0014, ADR-0032]
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/security/pin_policy.dart';

class EntryField extends StatelessWidget {
  const EntryField({
    super.key,
    required this.label,
    required this.controller,
    this.icon,
    this.secret = false,
    this.email = false,
    this.pin = false,
    this.newPassword = false,
    this.enabled = true,
    this.autofill,
  });
  final String label;
  final TextEditingController controller;
  final IconData? icon;
  final bool secret, email, pin, newPassword, enabled;
  final String? autofill;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon == null ? null : Icon(icon, size: 22),
      ),
      obscureText: secret || pin,
      autocorrect: !secret && !email && !pin,
      enableSuggestions: !secret && !email && !pin,
      maxLength: pin
          ? PinPolicy.length
          : secret
          ? 128
          : email
          ? 254
          : 80,
      buildCounter: (
        _, {
        required currentLength,
        required isFocused,
        maxLength,
      }) => null,
      keyboardType: pin
          ? TextInputType.number
          : email
          ? TextInputType.emailAddress
          : null,
      inputFormatters: pin ? [FilteringTextInputFormatter.digitsOnly] : null,
      textInputAction: TextInputAction.next,
      autofillHints: pin
          ? null
          : [
              if (autofill != null)
                autofill!
              else if (email)
                AutofillHints.email
              else if (secret)
                newPassword
                    ? AutofillHints.newPassword
                    : AutofillHints.password,
            ],
    ),
  );
}
