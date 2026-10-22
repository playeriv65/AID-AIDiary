// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:typed_data';
import 'package:aid_diary/models/drawing.dart';
import 'package:aid_diary/services/drawing_renderer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

void main() {
  test('strokes render without a GUI to a clean PNG with expected ink',
      () async {
    final document = DrawingDocument(width: 64, height: 64, strokes: [
      const DrawingStroke(
          color: 0xff000000,
          width: 6,
          points: [DrawingPoint(.1, .5), DrawingPoint(.9, .5)])
    ]);
    final bytes = await DrawingRenderer.png(document);
    final image = img.decodePng(bytes)!;
    expect((image.width, image.height), (64, 64));
    expect(image.getPixel(32, 31).r, lessThan(30));
    expect(image.getPixel(2, 2).r, 255);
    final chunks = <String>[];
    for (var offset = 8; offset < bytes.length;) {
      final length = ByteData.sublistView(bytes).getUint32(offset);
      chunks.add(ascii.decode(bytes.sublist(offset + 4, offset + 8)));
      offset += 12 + length;
    }
    expect(chunks, everyElement(isIn(['IHDR', 'IDAT', 'IEND'])));
  });

  test('pressure and eraser strokes preserve local geometry', () {
    final document = DrawingDocument(width: 100, height: 100, strokes: [
      const DrawingStroke(
          color: 0xff000000,
          width: 12,
          points: [DrawingPoint(.1, .5), DrawingPoint(.9, .5)]),
      const DrawingStroke(
          color: 0xffffffff,
          width: 20,
          points: [DrawingPoint(.5, .4), DrawingPoint(.5, .6)]),
    ]);
    final decoded = DrawingDocument.fromJson(document.toJson());
    final image = img.decodePng(DrawingRenderer.render(decoded))!;
    expect(image.getPixel(49, 49).r, 255);
    expect(image.getPixel(20, 49).r, lessThan(30));
  });

  test('component outlines export headlessly without reconstructing UI state',
      () {
    final document = DrawingDocument(width: 64, height: 64, strokes: [
      const DrawingStroke(color: 0xff000000, width: 4, points: [
        DrawingPoint(.5, .5)
      ], outline: [
        DrawingPoint(.25, .25),
        DrawingPoint(.75, .25),
        DrawingPoint(.75, .75),
        DrawingPoint(.25, .75)
      ])
    ]);
    final image = img.decodePng(DrawingRenderer.render(document))!;
    expect(image.getPixel(32, 32).r, 0);
    expect(image.getPixel(2, 2).r, 255);
  });

  test('malformed and excessive drawing input fails before allocating an image',
      () {
    for (final spec in [
      {'width': 4096, 'height': 4096, 'strokes': []},
      {
        'strokes': [
          {
            'points': [
              [double.nan, .2]
            ],
            'width': 2
          }
        ]
      },
      {
        'strokes': [
          {
            'points': [
              [1.2, .2]
            ],
            'width': 2
          }
        ]
      },
      {
        'strokes': [
          {
            'points': [
              [.2, .2]
            ],
            'width': -1
          }
        ]
      },
      {
        'strokes': [
          {'points': [], 'width': 2}
        ]
      },
    ]) {
      expect(() => DrawingDocument.fromJson(spec), throwsFormatException);
    }
  });
}
