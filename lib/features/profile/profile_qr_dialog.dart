// metadata_version: 1
// purpose: Render a local scannable public tag with an accessible text alternative.
// owner: unassigned
// related_adrs: [ADR-0036]
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'friend_code.dart';
import 'profile.dart';

class ProfileQrDialog extends StatelessWidget {
  const ProfileQrDialog({super.key, required this.profile});
  final AccountProfile profile;
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(profile.displayName, textAlign: TextAlign.center),
    content: SizedBox(
      width: 260,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              label: 'Friend QR code for ${profile.tag}',
              image: true,
              child: ExcludeSemantics(
                child: QrImageView(
                  data: friendCode(profile.tag),
                  size: 240,
                  padding: const EdgeInsets.all(20),
                  backgroundColor: Colors.white,
                  eyeStyle: const QrEyeStyle(color: Colors.black),
                  dataModuleStyle: const QrDataModuleStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SelectableText(profile.tag),
            const SizedBox(height: 12),
            const Text(
              'Share your tag. Adding friends is coming in a future update.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Close'),
      ),
    ],
  );
}
