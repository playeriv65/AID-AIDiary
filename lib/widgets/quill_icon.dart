// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:material_ui/material_ui.dart';

/// A quill pen, drawn like an icon (24 units, the icon theme's colour):
/// Material's icon set has none.
class QuillIcon extends StatelessWidget {
  const QuillIcon({super.key, this.size});

  final double? size;

  @override
  Widget build(BuildContext context) {
    final theme = IconTheme.of(context);
    final side = size ?? theme.size ?? 24;
    return CustomPaint(
      size: Size.square(side),
      painter: _QuillPainter(theme.color ?? const Color(0xFF000000)),
    );
  }
}

class _QuillPainter extends CustomPainter {
  _QuillPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24);
    // The vane, with two notches along its lower edge.
    final vane = Path()
      ..moveTo(20.5, 3)
      ..cubicTo(13.5, 3.5, 7.5, 8.5, 6.5, 16.5)
      ..cubicTo(9, 16, 11.5, 15.2, 13.2, 13.8)
      ..lineTo(10.8, 13.6)
      ..cubicTo(13, 12.6, 15, 11.4, 16.6, 9.8)
      ..lineTo(14.2, 9.7)
      ..cubicTo(17, 8.2, 19.2, 6, 20.5, 3)
      ..close();
    canvas.drawPath(vane, Paint()..color = color);
    // The shaft, running out past the vane to the nib.
    canvas.drawLine(
        const Offset(19, 5),
        const Offset(4, 20.5),
        Paint()
          ..color = color
          ..strokeWidth = 1.6
          ..strokeCap = StrokeCap.round);
  }

  @override
  bool shouldRepaint(_QuillPainter oldDelegate) => oldDelegate.color != color;
}
