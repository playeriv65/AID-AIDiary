// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:ui' as ui;
import 'package:aid_diary/models/drawing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:perfect_freehand/perfect_freehand.dart' as freehand;
import 'package:scribble/scribble.dart' as scribble;

/// Scribble owns pointer handling, pressure normalization, smoothing, erasing
/// and history. Only normalized numeric geometry crosses into headless actions.
class DrawingCanvasController extends scribble.ScribbleNotifier {
  DrawingCanvasController() : super(widths: const [3], maxHistoryLength: 50) {
    _lastSketch = currentSketch;
    addListener(_sketchChanged);
  }
  late scribble.Sketch _lastSketch;
  int revision = 0;
  int _pointCount = 0;
  int _ink = 0xff263238;
  bool _eraser = false;
  bool _inverted = false;
  bool get isEmpty => value.lines.isEmpty;

  void _sketchChanged() {
    if (identical(_lastSketch, currentSketch)) return;
    _lastSketch = currentSketch;
    _pointCount = currentSketch.lines
        .fold(0, (count, line) => count + line.points.length);
    revision++;
  }

  void configure(
      {required int color, required double width, required bool stylusOnly}) {
    _ink = color;
    _eraser = color == 0xffffffff;
    if (_eraser) {
      setEraser();
    } else {
      setColor(Color(color));
    }
    // Scribble's outline diameter is twice its selected line width.
    setStrokeWidth(width / 2);
    setAllowedPointersMode(stylusOnly
        ? scribble.ScribblePointerMode.penOnly
        : scribble.ScribblePointerMode.all);
  }

  @override
  void onPointerDown(PointerDownEvent event) {
    if (value is scribble.Drawing &&
        event.kind != ui.PointerDeviceKind.invertedStylus &&
        (currentSketch.lines.length >= 2000 || _pointCount >= 19998)) {
      return;
    }
    if (event.kind == ui.PointerDeviceKind.invertedStylus) {
      _inverted = true;
      setEraser();
    }
    super.onPointerDown(event);
  }

  @override
  void onPointerUpdate(PointerMoveEvent event) {
    final state = value;
    if (state is scribble.Drawing &&
        _pointCount + (state.activeLine?.points.length ?? 0) >= 19998) {
      return;
    }
    super.onPointerUpdate(event);
  }

  void _restoreTool() {
    if (!_inverted) return;
    _inverted = false;
    if (_eraser) {
      setEraser();
    } else {
      setColor(Color(_ink));
    }
  }

  @override
  void onPointerUp(PointerUpEvent event) {
    super.onPointerUp(event);
    _restoreTool();
  }

  @override
  void onPointerCancel(PointerCancelEvent event) {
    super.onPointerCancel(event);
    _restoreTool();
  }

  void end() {
    final state = value;
    if (state is scribble.Drawing && state.activeLine != null) {
      value = state.copyWith(
          sketch: scribble.Sketch(
              lines: [...state.sketch.lines, state.activeLine!]),
          activeLine: null,
          activePointerIds: []);
    }
  }

  DrawingDocument get document => DrawingDocument(strokes: [
        for (final line in value.lines)
          DrawingStroke(
              color: line.color,
              width: line.width * 2,
              points: [
                for (final p in line.points)
                  DrawingPoint((p.x / 1600).clamp(0, 1),
                      (p.y / 1200).clamp(0, 1), p.pressure.clamp(.05, 1))
              ],
              outline: _outline(line)),
      ]);

  List<DrawingPoint> _outline(scribble.SketchLine line) {
    final polygon = freehand.getStroke([
      for (final p in line.points) freehand.PointVector(p.x, p.y, p.pressure)
    ],
        options: freehand.StrokeOptions(
            size: line.width * 2,
            simulatePressure: line.points
                .every((p) => p.pressure == line.points.first.pressure)));
    if (polygon.length < 2) return [];
    // Match Scribble's quadratic outline with short numeric segments. The PNG
    // exporter can fill this polygon without Flutter, a canvas or dart:ui.
    final flattened = <DrawingPoint>[];
    void add(double x, double y) => flattened
        .add(DrawingPoint((x / 1600).clamp(0, 1), (y / 1200).clamp(0, 1)));
    var previous = polygon.first;
    add(previous.dx, previous.dy);
    for (var i = 1; i < polygon.length - 1; i++) {
      final control = polygon[i];
      final end = (control + polygon[i + 1]) / 2;
      for (var step = 1; step <= 3; step++) {
        final t = step / 3;
        final s = 1 - t;
        add(s * s * previous.dx + 2 * s * t * control.dx + t * t * end.dx,
            s * s * previous.dy + 2 * s * t * control.dy + t * t * end.dy);
      }
      previous = ui.Offset(end.dx, end.dy);
    }
    return flattened;
  }

  @override
  void dispose() {
    removeListener(_sketchChanged);
    super.dispose();
  }
}

class DrawingCanvas extends StatefulWidget {
  const DrawingCanvas(
      {super.key,
      required this.controller,
      required this.color,
      required this.width,
      this.stylusOnly = false,
      this.enabled = true});
  final DrawingCanvasController controller;
  final int color;
  final double width;
  final bool stylusOnly;
  final bool enabled;
  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  void _configure() => widget.controller.configure(
      color: widget.color, width: widget.width, stylusOnly: widget.stylusOnly);
  @override
  void initState() {
    super.initState();
    _configure();
  }

  @override
  void didUpdateWidget(DrawingCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller ||
        oldWidget.color != widget.color ||
        oldWidget.width != widget.width ||
        oldWidget.stylusOnly != widget.stylusOnly) {
      _configure();
    }
  }

  @override
  Widget build(BuildContext context) => AspectRatio(
      aspectRatio: 4 / 3,
      child: ClipRect(
          child: FittedBox(
              child: SizedBox(
                  width: 1600,
                  height: 1200,
                  child: ColoredBox(
                      color: Colors.white,
                      child: IgnorePointer(
                          ignoring: !widget.enabled,
                          child: scribble.Scribble(
                              key: const ValueKey('drawing-canvas'),
                              notifier: widget.controller,
                              drawPen: false,
                              drawEraser: false)))))));
}
