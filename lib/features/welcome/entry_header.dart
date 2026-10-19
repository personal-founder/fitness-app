// metadata_version: 1
// purpose: "Header action always follows session state; hamburger opens a real left drawer."
// owner: unassigned
// related_adrs: [ADR-0013, ADR-0038]
import 'package:flutter/material.dart';

import '../../app/theme/palette.dart';

class EntryHeader extends StatelessWidget {
  const EntryHeader({
    super.key,
    required this.signedIn,
    required this.registering,
    required this.onAction,
    this.busy = false,
  });
  final bool signedIn, registering, busy;
  final VoidCallback onAction;
  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            color: p.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: p.dark ? p.border : Colors.white),
          ),
          child: IconButton(
            tooltip: 'Open menu',
            icon: const Icon(Icons.menu),
            color: p.text,
            iconSize: 27,
            constraints: const BoxConstraints.tightFor(width: 50, height: 48),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: OutlinedButton(
            onPressed: busy ? null : onAction,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(98, 48),
              foregroundColor: p.dark ? p.text : p.action,
              backgroundColor: p.dark ? p.surface : const Color(0xb3c6ddff),
              side: BorderSide(color: p.dark ? p.border : Colors.white),
            ),
            child: Text(
              signedIn
                  ? 'Sign Out'
                  : registering
                  ? 'Log In'
                  : 'Sign Up',
            ),
          ),
        ),
      ],
    );
  }
}
