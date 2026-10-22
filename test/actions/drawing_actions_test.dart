// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['integration'])
library;

import 'dart:convert';
import 'dart:io';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/storage/in_memory_file_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import '../support/diary_app_harness.dart';

void main() {
  DiaryAppHarness().register();
  final actions = AppActions(devBuild: true);
  late InMemoryFileStore stored;
  setUp(() {
    stored = InMemoryFileStore();
    ImageStorage.instance.invalidateCache();
    ImageStorage.instance.overrideStores(stored, InMemoryFileStore());
  });
  tearDown(() => ImageStorage.instance.clearStoreOverrides());
  final spec = jsonEncode({
    'width': 64,
    'height': 64,
    'strokes': [
      {
        'color': 0xff000000,
        'width': 4,
        'points': [
          [.1, .1],
          [.9, .9]
        ]
      }
    ]
  });
  test('headless drawing action attaches a readable PNG to the existing entry',
      () async {
    final entry =
        await actions.run('entry.create', {'text': 'A sketch'}) as Map;
    final result = await actions
        .run('drawing.attach', {'id': entry['id'], 'spec': spec}) as Map;
    final name = result['name'] as String;
    final bytes = await stored.read(name);
    expect(img.decodePng(bytes!)!.width, 64);
    expect(
        EntryImagesProvider.instance.images
            .where((image) => image.entryId == entry['id'])
            .single
            .imgPath,
        name);
  });
  test('headless export refuses overwriting an existing file', () async {
    final folder = await Directory.systemTemp.createTemp('aid_drawing_export');
    addTearDown(() => folder.delete(recursive: true));
    final path = '${folder.path}/sketch.png';
    await actions.run('drawing.export', {'spec': spec, 'path': path});
    final bytes = await File(path).readAsBytes();
    await expectLater(
        actions.run('drawing.export', {'spec': spec, 'path': path}),
        throwsA(isA<Exception>()));
    expect(await File(path).readAsBytes(), bytes);
  });
}
