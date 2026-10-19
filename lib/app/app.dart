// metadata_version: 1
// purpose: "One application/router for every generated platform target."
// owner: unassigned
// related_adrs: [ADR-0028, ADR-0035]
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';

class MacroApp extends ConsumerWidget {
  const MacroApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
    title: 'Macro App',
    debugShowCheckedModeBanner: false,
    theme: appTheme(Brightness.light),
    darkTheme: appTheme(Brightness.dark),
    themeMode: ref.watch(themeProvider).mode,
    routerConfig: ref.watch(routerProvider),
  );
}
