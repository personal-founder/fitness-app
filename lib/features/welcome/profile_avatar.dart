// metadata_version: 1
// purpose: "Vector silhouette fallback preserves the reference crop without photo permissions."
// owner: unassigned
// related_adrs: [ADR-0013]
import 'package:flutter/material.dart';

import '../../app/theme/palette.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});
  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Semantics(
      label: 'Default profile image',
      image: true,
      child: Container(
        width: 160,
        height: 160,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: p.dark ? const Color(0xffeeedf0) : const Color(0xfff8fbff),
          border: Border.all(
            color: p.accent.withValues(alpha: .32),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: p.accent.withValues(alpha: p.dark ? .18 : .25),
              blurRadius: 14,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipOval(child: CustomPaint(painter: _Silhouette(p.dark))),
      ),
    );
  }
}

class _Silhouette extends CustomPainter {
  _Silhouette(this.dark);
  final bool dark;
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          colors: dark
              ? const [Color(0xffa1a5ad), Color(0xff777b83)]
              : const [Color(0xffe8eef7), Color(0xffcad5e5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(rect),
    );
    final fill = Paint()..color = Color(dark ? 0xff53565f : 0xff98a7bf);
    canvas.drawCircle(
      Offset(size.width * .5, size.height * .39),
      size.width * .16,
      fill,
    );
    canvas.drawOval(
      Rect.fromLTWH(
        size.width * .18,
        size.height * .59,
        size.width * .64,
        size.height * .63,
      ),
      fill,
    );
  }

  @override
  bool shouldRepaint(_Silhouette oldDelegate) => dark != oldDelegate.dark;
}
