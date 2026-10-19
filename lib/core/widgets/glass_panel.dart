// metadata_version: 1
// purpose: "Shared soft surface with bounded elevation and no expensive backdrop blur."
// owner: unassigned
// related_adrs: [ADR-0013]
import 'package:flutter/material.dart';

import '../../app/theme/palette.dart';

class GlassPanel extends StatelessWidget {
  const GlassPanel({super.key, required this.child, this.padding = 20});
  final Widget child;
  final double padding;
  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: p.dark ? p.border : Colors.white),
        boxShadow: [
          BoxShadow(
            color: p.accent.withValues(alpha: p.dark ? .04 : .10),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Material(type: MaterialType.transparency, child: child),
    );
  }
}
