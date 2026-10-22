// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

class DrawingPoint {
  const DrawingPoint(this.x, this.y, [this.pressure = 1]);
  final double x;
  final double y;
  final double pressure;
  List<double> toJson() => [x, y, pressure];
}

class DrawingStroke {
  const DrawingStroke(
      {required this.color,
      required this.width,
      required this.points,
      this.outline = const []});
  final int color;
  final double width;
  final List<DrawingPoint> points;
  final List<DrawingPoint> outline;
  Map<String, Object?> toJson() => {
        'color': color,
        'width': width,
        'points': [for (final point in points) point.toJson()],
        if (outline.isNotEmpty)
          'outline': [for (final point in outline) point.toJson()]
      };
}

/// Coordinates are normalized; line widths are pixels on the exported canvas.
class DrawingDocument {
  const DrawingDocument(
      {this.width = 1600,
      this.height = 1200,
      this.background = 0xffffffff,
      required this.strokes});
  final int width;
  final int height;
  final int background;
  final List<DrawingStroke> strokes;
  Map<String, Object?> toJson() => {
        'width': width,
        'height': height,
        'background': background,
        'strokes': [for (final s in strokes) s.toJson()]
      };

  factory DrawingDocument.fromJson(Map<String, dynamic> json) {
    int integer(Object? value, int fallback, int low, int high) {
      final result = value ?? fallback;
      if (result is! int || result < low || result > high) {
        throw const FormatException('Invalid drawing dimensions or colour');
      }
      return result;
    }

    double number(Object? value, double low, double high) {
      if (value is! num || !value.isFinite || value < low || value > high) {
        throw const FormatException('Invalid drawing point or pen width');
      }
      return value.toDouble();
    }

    final width = integer(json['width'], 1600, 32, 4096);
    final height = integer(json['height'], 1200, 32, 4096);
    if (width * height > 8 * 1024 * 1024) {
      throw const FormatException('Drawing exceeds pixel limit');
    }
    final data = json['strokes'];
    if (data is! List || data.length > 2000) {
      throw const FormatException('Drawing strokes must be a bounded list');
    }
    var count = 0;
    var outlineCount = 0;
    final strokes = <DrawingStroke>[];
    for (final raw in data) {
      if (raw is! Map || raw['points'] is! List) {
        throw const FormatException('Invalid drawing stroke');
      }
      final points = raw['points'] as List;
      final outline = raw['outline'] ?? const [];
      if (outline is! List) {
        throw const FormatException('Invalid drawing outline');
      }
      outlineCount += outline.length;
      if (outlineCount > 700000) {
        throw const FormatException('Drawing exceeds outline limit');
      }
      count += points.length;
      if (points.isEmpty || count > 100000) {
        throw const FormatException('Drawing exceeds point limit');
      }
      strokes.add(DrawingStroke(
        color: integer(raw['color'], 0xff263238, 0, 0xffffffff),
        width: number(raw['width'] ?? 4, 0.5, 64),
        outline: [
          for (final point in outline)
            if (point is List && (point.length == 2 || point.length == 3))
              DrawingPoint(number(point[0], 0, 1), number(point[1], 0, 1))
            else
              throw const FormatException('Invalid drawing outline point')
        ],
        points: [
          for (final point in points)
            if (point is List && (point.length == 2 || point.length == 3))
              DrawingPoint(number(point[0], 0, 1), number(point[1], 0, 1),
                  number(point.length == 3 ? point[2] : 1, 0.05, 1))
            else
              throw const FormatException('Invalid drawing point')
        ],
      ));
    }
    return DrawingDocument(
        width: width,
        height: height,
        background: integer(json['background'], 0xffffffff, 0, 0xffffffff),
        strokes: strokes);
  }
}
