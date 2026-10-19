// metadata_version: 1
// purpose: "One accessible primary action for credentials, enrollment and local unlock."
// owner: unassigned
// related_adrs: [ADR-0013]
import 'package:flutter/material.dart';

import '../../app/theme/palette.dart';

class ContinueButton extends StatelessWidget {
  const ContinueButton({super.key, this.onPressed, this.busy = false});
  final VoidCallback? onPressed;
  final bool busy;
  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: busy ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: p.action,
          disabledBackgroundColor: p.disabled,
          disabledForegroundColor: Colors.white,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 54),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        ),
        child: busy
            ? const SizedBox(
                height: 23,
                width: 23,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                children: [
                  Text('Continue', style: TextStyle(fontSize: 18)),
                  Icon(Icons.arrow_forward, size: 24),
                ],
              ),
      ),
    );
  }
}
