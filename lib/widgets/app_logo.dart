// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:material_ui/material_ui.dart';

/// The app's notebook mark, drawn like the launcher icon (see
/// tool/icon/export_icon.py) in the theme's colors so it sits beside text.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 24});

  /// Height of the mark; it is a little narrower than tall.
  final double size;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return CustomPaint(
      size: Size(size * _NotebookPainter.width / _NotebookPainter.height, size),
      painter: _NotebookPainter(
          page: cs.primary, rings: cs.onSurface, marks: cs.onPrimary),
    );
  }
}

class _NotebookPainter extends CustomPainter {
  _NotebookPainter(
      {required this.page, required this.rings, required this.marks});

  final Color page;
  final Color rings;
  final Color marks;

  // The icon's glyph in its own units: rings stick out 58 left of the page.
  static const width = 458.0;
  static const height = 500.0;
  static const _pageLeft = 58.0;
  static const _pageWidth = 400.0;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.height / height);
    RRect pill(double x, double y, double w, double h, double r) =>
        RRect.fromRectAndRadius(Rect.fromLTWH(x, y, w, h), Radius.circular(r));

    canvas.drawRRect(
        pill(_pageLeft, 0, _pageWidth, height, 56), Paint()..color = page);
    final ringPaint = Paint()..color = rings;
    const gap = (height - 160) / 3;
    for (var i = 0; i < 4; i++) {
      canvas.drawRRect(pill(0, 80 + i * gap - 22, 116, 44, 22), ringPaint);
    }
    final markPaint = Paint()..color = marks;
    for (final (i, w) in [(0, 220.0), (1, 160.0)]) {
      canvas.drawRRect(
          pill(_pageLeft + 100, 96 + i * 88.0, w, 40, 20), markPaint);
    }
    // Four-point sparkle, its edges curving in.
    const cx = _pageLeft + _pageWidth - 104, cy = height - 104, r = 60.0;
    const k = r * 0.22;
    canvas.drawPath(
        Path()
          ..moveTo(cx, cy - r)
          ..quadraticBezierTo(cx + k, cy - k, cx + r, cy)
          ..quadraticBezierTo(cx + k, cy + k, cx, cy + r)
          ..quadraticBezierTo(cx - k, cy + k, cx - r, cy)
          ..quadraticBezierTo(cx - k, cy - k, cx, cy - r)
          ..close(),
        markPaint);
  }

  @override
  bool shouldRepaint(_NotebookPainter old) =>
      old.page != page || old.rings != rings || old.marks != marks;
}
