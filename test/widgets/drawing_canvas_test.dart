// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['widget'])
library;

import 'dart:ui' as ui;
import 'package:aid_diary/widgets/drawing_canvas.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:scribble/scribble.dart';
import 'package:aid_diary/models/drawing.dart';

void main() {
  testWidgets('stylus-only drawing ignores touch and supports undo',
      (tester) async {
    final controller = DrawingCanvasController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: Center(
                child: SizedBox(
                    width: 600,
                    child: DrawingCanvas(
                        controller: controller,
                        color: 0xff263238,
                        width: 8,
                        stylusOnly: true))))));
    final center =
        tester.getCenter(find.byKey(const ValueKey('drawing-canvas')));
    expect(find.byType(Scribble), findsOneWidget);
    final touch = await tester.createGesture(kind: ui.PointerDeviceKind.touch);
    await touch.down(center);
    await touch.moveBy(const Offset(30, 30));
    await touch.up();
    expect(controller.isEmpty, isTrue);
    final pen = await tester.createGesture(kind: ui.PointerDeviceKind.stylus);
    await pen.down(center);
    await pen.moveBy(const Offset(30, 30));
    await pen.up();
    await tester.pump();
    expect(controller.document.strokes, hasLength(1));
    expect(controller.document.strokes.single.points.length, greaterThan(1));
    final exported = DrawingDocument.fromJson(controller.document.toJson());
    expect(exported.strokes.single.outline.length, greaterThan(3));
    expect(controller.canUndo, isTrue);
    controller.undo();
    await tester.pump();
    expect(controller.isEmpty, isTrue);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
