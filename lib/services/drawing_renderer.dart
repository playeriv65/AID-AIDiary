// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';
import 'package:aid_diary/models/drawing.dart';
import 'package:image/image.dart' as img;

/// Pure raster export shared by the GUI and headless actions. PNG has no
/// author, software, comments or source file metadata.
class DrawingRenderer {
  static Future<Uint8List> png(DrawingDocument drawing) =>
      Isolate.run(() => render(drawing));

  static Uint8List render(DrawingDocument drawing) {
    final checked = DrawingDocument.fromJson(drawing.toJson());
    img.Color color(int argb) => img.ColorRgba8(
        (argb >> 16) & 255, (argb >> 8) & 255, argb & 255, (argb >> 24) & 255);
    final image =
        img.Image(width: checked.width, height: checked.height, numChannels: 4);
    img.fill(image, color: color(checked.background));
    for (final stroke in checked.strokes) {
      final ink = color(stroke.color);
      if (stroke.outline.isNotEmpty) {
        img.fillPolygon(image,
            vertices: [
              for (final p in stroke.outline)
                img.Point(p.x * (checked.width - 1), p.y * (checked.height - 1))
            ],
            color: ink);
        continue;
      }
      for (var i = 0; i < stroke.points.length; i++) {
        final point = stroke.points[i];
        final x = (point.x * (checked.width - 1)).round();
        final y = (point.y * (checked.height - 1)).round();
        final thickness = max(1, (stroke.width * point.pressure).round());
        img.fillCircle(image,
            x: x, y: y, radius: max(1, thickness ~/ 2), color: ink);
        if (i > 0) {
          final previous = stroke.points[i - 1];
          img.drawLine(image,
              x1: (previous.x * (checked.width - 1)).round(),
              y1: (previous.y * (checked.height - 1)).round(),
              x2: x,
              y2: y,
              color: ink,
              thickness: thickness,
              antialias: true);
        }
      }
    }
    return img.encodePng(image);
  }
}
