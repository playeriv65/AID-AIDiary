// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:math' as math;
import 'package:aid_diary/config_provider.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

/// Original vector patterns, drawn behind content and excluded from hit tests
/// and semantics. Decoration never changes or exports the entry's text.
class LetterPaper extends StatelessWidget {
  const LetterPaper({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigProvider>();
    return RepaintBoundary(
        child: CustomPaint(
            key: const ValueKey('letter-paper'),
            painter: LetterPaperPainter(
                style: config.get(Settings.paperStyle),
                decoration: config.get(Settings.paperDecoration),
                scheme: Theme.of(context).colorScheme),
            child: child));
  }
}

class LetterPaperPainter extends CustomPainter {
  const LetterPaperPainter(
      {required this.style, required this.decoration, required this.scheme});
  final String style;
  final String decoration;
  final ColorScheme scheme;
  @override
  void paint(Canvas canvas, Size size) {
    final dark = scheme.brightness == Brightness.dark;
    final base = Color.alphaBlend(
        scheme.primary.withValues(alpha: style == 'tinted' ? 0.10 : 0.025),
        scheme.surface);
    canvas.drawRect(Offset.zero & size, Paint()..color = base);
    final rule = Paint()
      ..strokeWidth = 0.7
      ..color = scheme.outline.withValues(alpha: dark ? 0.17 : 0.14);
    if (style == 'lined' || style == 'grid') {
      const spacing = 28.0;
      for (var y = spacing; y < size.height; y += spacing) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), rule);
      }
      if (style == 'grid') {
        for (var x = spacing; x < size.width; x += spacing) {
          canvas.drawLine(Offset(x, 0), Offset(x, size.height), rule);
        }
      }
    }
    // Small corner motifs leave the writing column unobstructed.
    final ink = scheme.tertiary.withValues(alpha: dark ? 0.34 : 0.28);
    canvas.save();
    canvas.translate(size.width - 64, 8);
    switch (decoration) {
      case 'botanical':
        final stem = Paint()
          ..color = ink
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.8;
        canvas.drawPath(
            Path()
              ..moveTo(5, 66)
              ..quadraticBezierTo(38, 40, 42, 0),
            stem);
        for (var i = 0; i < 4; i++) {
          final y = 12.0 + i * 12;
          final x = 40 - i * 5.0;
          canvas.drawPath(
              Path()
                ..moveTo(x, y)
                ..quadraticBezierTo(x - 23, y - 12, x - 17, y + 2)
                ..quadraticBezierTo(x - 6, y + 10, x, y),
              Paint()..color = ink);
          canvas.drawPath(
              Path()
                ..moveTo(x, y + 6)
                ..quadraticBezierTo(x + 20, y - 5, x + 13, y + 9)
                ..quadraticBezierTo(x + 5, y + 15, x, y + 6),
              Paint()..color = ink);
        }
      case 'stars':
        for (final (x, y, radius) in [
          (12.0, 14.0, 10.0),
          (40.0, 38.0, 7.0),
          (15.0, 60.0, 5.0)
        ]) {
          final star = Path();
          for (var i = 0; i < 10; i++) {
            final angle = -math.pi / 2 + math.pi * i / 5;
            final r = i.isEven ? radius : radius * 0.45;
            final px = x + math.cos(angle) * r;
            final py = y + math.sin(angle) * r;
            if (i == 0) {
              star.moveTo(px, py);
            } else {
              star.lineTo(px, py);
            }
          }
          canvas.drawPath(star..close(), Paint()..color = ink);
        }
      case 'washi':
        canvas.rotate(0.32);
        final tape = RRect.fromRectAndRadius(
            const Rect.fromLTWH(-14, 10, 78, 23), const Radius.circular(2));
        canvas.drawRRect(tape, Paint()..color = ink);
        canvas.save();
        canvas.clipRRect(tape);
        final stripe = Paint()
          ..color = scheme.surface.withValues(alpha: .38)
          ..strokeWidth = 3;
        for (var x = -30.0; x < 90; x += 12) {
          canvas.drawLine(Offset(x, 10), Offset(x + 18, 33), stripe);
        }
        canvas.restore();
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(LetterPaperPainter oldDelegate) =>
      style != oldDelegate.style ||
      decoration != oldDelegate.decoration ||
      scheme != oldDelegate.scheme;
}
