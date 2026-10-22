// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['integration'])
library;

import 'dart:io';

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/config_provider.dart';
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
  late Directory folder;

  setUp(() async {
    stored = InMemoryFileStore();
    // Names repeat from test to test: bytes cached under them are stale.
    ImageStorage.instance.invalidateCache();
    ImageStorage.instance.overrideStores(stored, InMemoryFileStore());
    folder = await Directory.systemTemp.createTemp('aid_media');
  });

  tearDown(() async {
    ImageStorage.instance.clearStoreOverrides();
    await folder.delete(recursive: true);
  });

  Future<Map<String, Object?>> run(String id,
          [Map<String, Object?> args = const {},
          bool confirmed = false]) async =>
      (await actions.run(id, args, confirmed: confirmed))
          as Map<String, Object?>;

  Matcher refused(String code) =>
      throwsA(isA<ActionException>().having((e) => e.code, 'code', code));

  /// A picture of [width] by [height] pixels on disk.
  Future<String> picture(String name, int width, int height) async {
    final file = File('${folder.path}/$name');
    await file
        .writeAsBytes(img.encodeJpg(img.Image(width: width, height: height)));
    return file.path;
  }

  Future<int> entry() async =>
      (await run('entry.create', {'text': 'With media'}))['id'] as int;

  Future<List<Object?>> attachments(int id) async =>
      (await run('entry.attachments', {'id': '$id'}))['attachments']
          as List<Object?>;

  test('photos are attached, listed with their size, and compressed', () async {
    final id = await entry();
    expect(await attachments(id), isEmpty);

    // Larger than the medium quality allows, so it is shrunk like the GUI does.
    final big = await picture('big.jpg', 2400, 1200);
    final result = await run('entry.attach', {'id': '$id', 'path': big});
    final photo = (result['attachments'] as List).single as Map;
    expect(photo, containsPair('kind', 'photo'));
    expect(photo, containsPair('index', 0));
    final maxWidth =
        ConfigProvider.imageQualityMaxSizeMapping[ImageQuality.medium]!;
    expect(photo['width'], maxWidth.toInt());
    expect(photo['height'], maxWidth.toInt() ~/ 2);
    expect(photo['size'],
        await stored.read(photo['name'] as String).then((b) => b!.length));
    // The picked file is not touched.
    expect(img.decodeJpg(await File(big).readAsBytes())!.width, 2400);

    await run('entry.attach',
        {'id': '$id', 'path': await picture('small.jpg', 100, 50)});
    final names = [
      for (final item in await attachments(id)) (item as Map)['name']
    ];
    expect(names, hasLength(2));
    expect(names.first, photo['name'], reason: 'new attachments go last');
    expect(
        await run('entry.get', {'id': '$id'}), containsPair('attachments', 2));
  });

  test('sound and video are stored as they are', () async {
    final id = await entry();
    final voice = File('${folder.path}/note.m4a')..writeAsBytesSync([1, 2, 3]);
    final clip = File('${folder.path}/clip.mp4')..writeAsBytesSync([4, 5]);
    await run('entry.attach', {'id': '$id', 'path': voice.path});
    await run('entry.attach', {'id': '$id', 'path': clip.path});
    final listed = (await attachments(id)).cast<Map>();
    expect([for (final item in listed) item['kind']], ['audio', 'video']);
    expect([for (final item in listed) item['size']], [3, 2]);
    expect(listed.first.containsKey('width'), isFalse);
  });

  test('files that are not media or are missing are refused', () async {
    final id = await entry();
    final text = File('${folder.path}/notes.txt')..writeAsStringSync('hi');
    await expectLater(
        () => run('entry.attach', {'id': '$id', 'path': text.path}),
        refused('bad_args'));
    await expectLater(
        () => run('entry.attach',
            {'id': '$id', 'path': '${folder.path}/missing.jpg'}),
        refused('not_found'));
    expect(await attachments(id), isEmpty);
    expect(await stored.list(), isEmpty);
  });

  test('attachments are reordered and removed with their files', () async {
    final id = await entry();
    for (final (name, width) in [('a.jpg', 30), ('b.jpg', 40), ('c.jpg', 50)]) {
      await run('entry.attach',
          {'id': '$id', 'path': await picture(name, width, 20)});
    }
    List<Object?> widths(List<Object?> items) =>
        [for (final item in items) (item as Map)['width']];
    expect(widths(await attachments(id)), [30, 40, 50]);

    final reordered =
        await run('entry.reorder_attachments', {'id': '$id', 'order': '2,0,1'});
    expect(widths(reordered['attachments'] as List), [50, 30, 40]);
    expect(widths(await attachments(id)), [50, 30, 40]);
    for (final wrong in ['0,1', '0,1,1', '0,1,3', 'a,b,c', '-1,0,1']) {
      await expectLater(
          () => run('entry.reorder_attachments', {'id': '$id', 'order': wrong}),
          refused('bad_args'),
          reason: wrong);
    }

    final removedName = ((await attachments(id))[1] as Map)['name'];
    await expectLater(() => run('entry.detach', {'id': '$id', 'index': '1'}),
        refused('needs_confirmation'));
    await expectLater(
        () => run('entry.detach', {'id': '$id', 'index': '3'}, true),
        refused('not_found'));
    final left = await run('entry.detach', {'id': '$id', 'index': '1'}, true);
    expect(widths(left['attachments'] as List), [50, 40]);
    expect(await stored.exists(removedName as String), isFalse);
    expect(EntryImagesProvider.instance.images, hasLength(2));
  });

  test('an attachment is saved as a file, and never over one', () async {
    final id = await entry();
    await run('entry.attach',
        {'id': '$id', 'path': await picture('one.jpg', 64, 32)});
    final name = ((await attachments(id)).single as Map)['name'] as String;

    final copy = File('${folder.path}/copy.jpg');
    await run('entry.export_attachment',
        {'id': '$id', 'index': '0', 'path': copy.path});
    expect(await copy.readAsBytes(), await stored.read(name));
    await expectLater(
        () => run('entry.export_attachment',
            {'id': '$id', 'index': '0', 'path': copy.path}),
        refused('write_failed'));
    await expectLater(
        () => run('entry.export_attachment',
            {'id': '$id', 'index': '1', 'path': '${folder.path}/x.jpg'}),
        refused('not_found'));
  });

  test('a zip export carries the media of the entry', () async {
    final id = await entry();
    await run('entry.attach',
        {'id': '$id', 'path': await picture('one.jpg', 64, 32)});
    final name = ((await attachments(id)).single as Map)['name'] as String;
    final zip = File('${folder.path}/entry.zip');
    await run('entry.export', {'id': '$id', 'format': 'zip', 'path': zip.path});
    expect(
        String.fromCharCodes(await zip.readAsBytes()), contains('media/$name'));
  });
}
