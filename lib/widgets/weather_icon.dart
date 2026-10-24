// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:math';

import 'package:aid_diary/utils/entry_context_display.dart';
import 'package:material_ui/material_ui.dart';

/// Weather in colour, as a forecast shows it: a yellow sun, white or grey
/// clouds with an outline that holds on any background, blue rain and snow.
/// Partly cloudy keeps its sun; overcast is two grey clouds.
class WeatherIcon extends StatelessWidget {
  const WeatherIcon(this.code, {super.key, this.size = 24});

  /// The WMO weather code.
  final int code;
  final double size;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size.square(size),
        painter: _WeatherPainter(weatherKind(code)),
      );
}

const _sun = Color(0xFFFFB300);
const _cloud = Color(0xFFF1F5F9);
const _greyCloud = Color(0xFFB8C4D0);
const _darkCloud = Color(0xFF7D8B99);
const _outline = Color(0xFF7A8899);
const _water = Color(0xFF2F8CF0);
const _snow = Color(0xFF7CC4F5);

class _WeatherPainter extends CustomPainter {
  _WeatherPainter(this.kind);

  final WeatherKind kind;

  /// A cloud in the 24-unit box, its base at [bottom], scaled about its
  /// middle by [scale] and moved by [dx].
  Path _cloudPath({double bottom = 17, double scale = 1, double dx = 0}) {
    final shape = Path.combine(
        PathOperation.union,
        Path.combine(
            PathOperation.union,
            Path()
              ..addOval(
                  Rect.fromCircle(center: const Offset(8.5, 13), radius: 3.5)),
            Path()
              ..addOval(
                  Rect.fromCircle(center: const Offset(13, 10.5), radius: 5))),
        Path.combine(
            PathOperation.union,
            Path()
              ..addOval(Rect.fromCircle(
                  center: const Offset(17.5, 13.5), radius: 3.5)),
            Path()
              ..addRRect(
                  RRect.fromLTRBR(5, 13, 21, 17, const Radius.circular(2)))));
    final matrix = Matrix4.identity()
      ..translateByDouble(12 + dx, bottom, 0, 1)
      ..scaleByDouble(scale, scale, 1, 1)
      ..translateByDouble(-12, -17, 0, 1);
    return shape.transform(matrix.storage);
  }

  void _drawCloud(Canvas canvas, Path cloud, Color fill) {
    canvas.drawPath(cloud, Paint()..color = fill);
    canvas.drawPath(
        cloud,
        Paint()
          ..color = _outline
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1);
  }

  void _drawSun(Canvas canvas, Offset center, double radius) {
    final rays = Paint()
      ..color = _sun
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 8; i++) {
      final angle = i * pi / 4;
      final direction = Offset(cos(angle), sin(angle));
      canvas.drawLine(center + direction * (radius + 1.8),
          center + direction * (radius + 3.6), rays);
    }
    canvas.drawCircle(center, radius, Paint()..color = _sun);
  }

  /// Short slanted strokes under a raised cloud.
  void _drawFalling(Canvas canvas, Color color, double length) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;
    for (final x in [8.0, 12.5, 17.0]) {
      canvas.drawLine(
          Offset(x, 16.5), Offset(x - length / 3, 16.5 + length), paint);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24);
    switch (kind) {
      case WeatherKind.clear:
        _drawSun(canvas, const Offset(12, 12), 5);
      case WeatherKind.partlyCloudy:
        _drawSun(canvas, const Offset(15.5, 8), 3.6);
        _drawCloud(canvas, _cloudPath(bottom: 19, scale: 0.85, dx: -2), _cloud);
      case WeatherKind.cloudy:
        _drawCloud(
            canvas, _cloudPath(bottom: 14, scale: 0.75, dx: 3), _darkCloud);
        _drawCloud(
            canvas, _cloudPath(bottom: 19, scale: 0.9, dx: -1.5), _greyCloud);
      case WeatherKind.fog:
        _drawCloud(canvas, _cloudPath(bottom: 13, scale: 0.85), _greyCloud);
        final lines = Paint()
          ..color = _darkCloud
          ..strokeWidth = 1.8
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(const Offset(5, 16.5), const Offset(19, 16.5), lines);
        canvas.drawLine(const Offset(7, 20), const Offset(17, 20), lines);
      case WeatherKind.drizzle:
        _drawCloud(canvas, _cloudPath(bottom: 14), _cloud);
        final drops = Paint()..color = _water;
        for (final x in [8.0, 12.5, 17.0]) {
          canvas.drawCircle(Offset(x, 18), 1.2, drops);
          canvas.drawCircle(Offset(x - 1.5, 21.5), 1.2, drops);
        }
      case WeatherKind.rain:
        _drawCloud(canvas, _cloudPath(bottom: 14), _cloud);
        _drawFalling(canvas, _water, 5);
      case WeatherKind.snow:
        _drawCloud(canvas, _cloudPath(bottom: 14), _cloud);
        final flakes = Paint()
          ..color = _snow
          ..strokeWidth = 1.3
          ..strokeCap = StrokeCap.round;
        for (final center in const [
          Offset(8, 18.5),
          Offset(12.5, 21),
          Offset(17, 18.5)
        ]) {
          for (var i = 0; i < 3; i++) {
            final angle = i * pi / 3;
            final arm = Offset(cos(angle), sin(angle)) * 1.8;
            canvas.drawLine(center - arm, center + arm, flakes);
          }
        }
      case WeatherKind.storm:
        _drawCloud(canvas, _cloudPath(bottom: 14), _darkCloud);
        final bolt = Path()
          ..moveTo(13.5, 13)
          ..lineTo(9.5, 18.5)
          ..lineTo(12.2, 18.5)
          ..lineTo(10.5, 23)
          ..lineTo(15.5, 16.8)
          ..lineTo(12.8, 16.8)
          ..lineTo(14.5, 13)
          ..close();
        canvas.drawPath(bolt, Paint()..color = _sun);
    }
  }

  @override
  bool shouldRepaint(_WeatherPainter oldDelegate) => oldDelegate.kind != kind;
}
