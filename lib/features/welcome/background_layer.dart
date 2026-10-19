// metadata_version: 1
// purpose: "Independent, editable vector art; reference PNGs are never bundled as UI."
// owner: unassigned
// related_adrs: [ADR-0013]
import 'package:flutter/material.dart';

import '../../app/theme/palette.dart';

class BackgroundLayer extends StatelessWidget {
  const BackgroundLayer({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      Positioned.fill(
        child: CustomPaint(painter: WavePainter(Palette.of(context))),
      ),
      child,
    ],
  );
}

class WavePainter extends CustomPainter {
  WavePainter(this.palette);
  final Palette palette;
  @override
  void paint(Canvas canvas, Size size) {
    final p = palette;
    canvas.drawRect(Offset.zero & size, Paint()..color = p.background);
    canvas.save();
    canvas.scale(size.width / 390, size.height / 844);
    final paths = [
      Path()
        ..moveTo(390, 125)
        ..cubicTo(242, 209, 286, 343, 167, 442)
        ..lineTo(390, 535)
        ..close(),
      Path()
        ..moveTo(0, 235)
        ..cubicTo(134, 285, 203, 424, 291, 463)
        ..lineTo(0, 536)
        ..close(),
      Path()
        ..moveTo(0, 302)
        ..cubicTo(110, 355, 130, 426, 239, 530)
        ..lineTo(0, 630)
        ..close(),
      Path()
        ..moveTo(390, 650)
        ..cubicTo(289, 707, 260, 768, 390, 811)
        ..close(),
      Path()
        ..moveTo(0, 678)
        ..cubicTo(205, 690, 315, 740, 390, 817)
        ..lineTo(390, 844)
        ..lineTo(0, 844)
        ..close(),
      Path()
        ..moveTo(0, 674)
        ..cubicTo(139, 690, 184, 740, 202, 844)
        ..lineTo(0, 844)
        ..close(),
      Path()
        ..moveTo(0, 747)
        ..cubicTo(70, 753, 126, 792, 163, 844)
        ..lineTo(0, 844)
        ..close(),
    ];
    for (var i = 0; i < paths.length; i++) {
      final color = p.waves[i % 3];
      canvas.drawPath(
        paths[i],
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color,
              color.withValues(alpha: p.dark ? 0.14 : 0.24),
            ],
          ).createShader(const Rect.fromLTWH(0, 150, 390, 694)),
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) =>
      oldDelegate.palette.dark != palette.dark;
}
