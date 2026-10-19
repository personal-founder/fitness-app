// metadata_version: 1
// purpose: "Starting tokens from the approved raster handoff, with readable action colors."
// owner: unassigned
// related_adrs: [ADR-0013]
import 'package:flutter/material.dart';

class Palette {
  const Palette(this.dark);
  final bool dark;
  Color get background => Color(dark ? 0xff1f2024 : 0xfff5f9ff);
  Color get surface => Color(dark ? 0xe02b2d31 : 0xd1ffffff);
  Color get input => Color(dark ? 0xff292b2f : 0xa6f7faff);
  Color get text => Color(dark ? 0xfff3f4f7 : 0xff071b42);
  Color get secondary => Color(dark ? 0xffb0b8c5 : 0xff60738e);
  Color get border => Color(dark ? 0xff464a52 : 0xffd9e4f2);
  Color get accent => Color(dark ? 0xffc84a5a : 0xff2384eb);
  Color get action => Color(dark ? 0xffa93648 : 0xff136ac3);
  Color get disabled => Color(dark ? 0xff41444c : 0xff9aa6b9);
  List<Color> get waves => dark
      ? const [Color(0xff302329), Color(0xff45252d), Color(0xff5a2b32)]
      : const [Color(0xffdcebff), Color(0xffc6ddff), Color(0xff9fc7fa)];
  static Palette of(BuildContext context) =>
      Palette(Theme.of(context).brightness == Brightness.dark);
}
