// metadata_version: 1
// purpose: "Shared geometry and typography; live system appearance preserves widget state."
// owner: unassigned
// related_adrs: [ADR-0013]
import 'package:flutter/material.dart';

import 'palette.dart';

ThemeData appTheme(Brightness brightness) {
  final p = Palette(brightness == Brightness.dark);
  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    scaffoldBackgroundColor: p.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: p.action,
      brightness: brightness,
    ),
    textTheme: ThemeData(brightness: brightness).textTheme
        .apply(bodyColor: p.text, displayColor: p.text),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: p.input,
      hintStyle: TextStyle(color: p.secondary),
      labelStyle: TextStyle(color: p.secondary),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: BorderSide(color: p.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: BorderSide(color: p.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: BorderSide(color: p.action, width: 2),
      ),
    ),
  );
}
