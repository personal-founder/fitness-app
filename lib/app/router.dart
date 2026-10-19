// metadata_version: 1
// purpose: "Route guards derive from verified session state, never a URL or preview button."
// owner: unassigned
// related_adrs: [ADR-0030, ADR-0045]
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/session_controller.dart';
import '../features/auth/session_state.dart';
import '../features/welcome/welcome_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier(0);
  ref.listen(sessionProvider, (_, _) => refresh.value++);
  final router = GoRouter(
    initialLocation: '/login',
    refreshListenable: refresh,
    redirect: (context, route) {
      final phase = ref.read(sessionProvider).phase;
      final target = switch (phase) {
        EntryPhase.login => '/login',
        EntryPhase.register => '/sign-up',
        EntryPhase.locked || EntryPhase.enroll => '/lock',
        EntryPhase.unlocked => '/dashboard',
        EntryPhase.recovery => '/recovery',
      };
      return route.uri.path == target ? null : target;
    },
    routes: [
      for (final path in [
        '/login',
        '/sign-up',
        '/lock',
        '/dashboard',
        '/ready',
        '/recovery',
      ])
        GoRoute(path: path, builder: (_, _) => const WelcomePage()),
    ],
  );
  ref.onDispose(() {
    router.dispose();
    refresh.dispose();
  });
  return router;
});
