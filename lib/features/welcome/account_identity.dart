// metadata_version: 1
// purpose: "Display-only identity; tag reveal is private UI state, never an auth factor."
// owner: unassigned
// related_adrs: [ADR-0013]
import 'package:flutter/material.dart';

import '../../app/theme/palette.dart';
import '../profile/profile.dart';

class AccountIdentity extends StatefulWidget {
  const AccountIdentity({super.key, this.profile, required this.title});
  final AccountProfile? profile;
  final String title;
  @override
  State<AccountIdentity> createState() => _AccountIdentityState();
}

class _AccountIdentityState extends State<AccountIdentity>
    with WidgetsBindingObserver {
  bool revealed = false;
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
    if (state != AppLifecycleState.resumed) setState(() => revealed = false);
  }

  @override
  void didUpdateWidget(AccountIdentity oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile != widget.profile) revealed = false;
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context), profile = widget.profile;
    return Column(
      children: [
        Text(
          profile?.displayName ?? widget.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: p.text,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (profile != null)
          SizedBox(
            height: 48,
            width: 160,
            child: TextButton(
              onPressed: () => setState(() => revealed = !revealed),
              child: Semantics(
                label: revealed
                    ? 'Account tag ${profile.tag}, tap to hide'
                    : 'Account tag hidden, tap to reveal',
                excludeSemantics: true,
                child: Text(
                  revealed ? profile.tag : '#••••••',
                  style: TextStyle(
                    color: p.secondary,
                    fontSize: 17,
                    letterSpacing: 1.3,
                  ),
                ),
              ),
            ),
          ),
        if (profile == null) const SizedBox(height: 28),
        Container(
          width: 46,
          height: 3,
          decoration: BoxDecoration(
            color: p.accent,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ],
    );
  }
}
