// metadata_version: 1
// purpose: Share the loaded identity explicitly and dismiss its QR on privacy boundaries.
// owner: unassigned
// related_adrs: [ADR-0036]
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/session_controller.dart';
import '../profile/profile_qr_dialog.dart';
import 'profile_avatar.dart';

class ProfileShare extends ConsumerStatefulWidget {
  const ProfileShare({super.key});
  @override
  ConsumerState<ProfileShare> createState() => _ProfileShareState();
}

class _ProfileShareState extends ConsumerState<ProfileShare>
    with WidgetsBindingObserver {
  DialogRoute<void>? _route;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void _dismiss() {
    final route = _route;
    _route = null;
    if (route?.isActive ?? false) route!.navigator!.removeRoute(route);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) _dismiss();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _dismiss());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    ref.listen(sessionProvider, (previous, next) {
      if (previous?.userId != next.userId ||
          previous?.profile != next.profile) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _dismiss());
      }
    });
    final profile = session.profile;
    if (!session.signedIn || profile == null) return const ProfileAvatar();
    return Tooltip(
      message: 'Show profile QR code',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () async {
            if (_route != null) return;
            final route = DialogRoute<void>(
              context: context,
              builder: (_) => ProfileQrDialog(profile: profile),
            );
            _route = route;
            await Navigator.of(context, rootNavigator: true).push(route);
            if (identical(_route, route)) _route = null;
          },
          child: const ProfileAvatar(),
        ),
      ),
    );
  }
}
