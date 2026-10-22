// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['integration'])
library;

import 'dart:io';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/models/photo_suggestion.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/services/local_photo_suggestions.dart';
import 'package:aid_diary/storage/in_memory_file_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import '../support/diary_app_harness.dart';

void main() {
  DiaryAppHarness().register();
  late Directory folder;
  late _Photos source;
  late InMemoryFileStore stored;
  late DateTime photoTime;
  setUp(() async {
    folder = await Directory.systemTemp.createTemp('aid_local_photos');
    final bytes = img.encodeJpg(img.Image(width: 32, height: 32));
    final a = await File('${folder.path}/a.jpg').writeAsBytes(bytes);
    final b = await File('${folder.path}/b.jpg').writeAsBytes(bytes);
    photoTime = DateTime.now().subtract(const Duration(days: 1));
    source = _Photos([a.path, b.path], photoTime);
    stored = InMemoryFileStore();
    ImageStorage.instance.invalidateCache();
    ImageStorage.instance.overrideStores(stored, InMemoryFileStore());
  });
  tearDown(() async {
    ImageStorage.instance.clearStoreOverrides();
    await folder.delete(recursive: true);
  });
  test('metadata scan and dismissal never copy or import original images',
      () async {
    final service = LocalPhotoSuggestions(source: source);
    final cards = await service.scan();
    expect(cards.single.photos, hasLength(2));
    expect(source.copies, 0);
    expect(await stored.list(), isEmpty);
    expect(EntryStore.instance.entries, isEmpty);
    await service.dismiss(cards.single.id);
    expect(await service.scan(), isEmpty);
    expect(source.copies, 0);
  });
  test('selected card creates a dated entry and keeps both originals',
      () async {
    final service = LocalPhotoSuggestions(source: source);
    final card = (await service.scan()).single;
    final entry = await service.create(card.id, text: 'A day outside');
    expect(entry.day, DateTime(photoTime.year, photoTime.month, photoTime.day));
    expect(entry.timeCreate.isAfter(photoTime), isTrue);
    expect(EntryImagesProvider.instance.getForEntry(entry), hasLength(2));
    expect(source.copies, 2);
    expect(source.releases, 2);
    expect(source.paths.every((path) => File(path).existsSync()), isTrue);
    expect(await service.scan(), isEmpty);
    source.paths.addAll(['new-photo-c', 'new-photo-d']);
    final later = (await service.scan()).single;
    expect(
        later.photos.map((photo) => photo.id), ['new-photo-c', 'new-photo-d']);
  });
  test('location opt-out strips geotags even if a source supplies them',
      () async {
    source.includeLocation = true;
    final service = LocalPhotoSuggestions(source: source);
    expect((await service.scan()).single.placed, isNull);
    await ConfigProvider.instance.set(Settings.photoSuggestionsLocation, true);
    expect((await service.scan()).single.placed!.latitude, 30);
  });
  test('failed selected import removes only its newly staged files', () async {
    final sentinel = img.encodeJpg(img.Image(width: 8, height: 8));
    await stored.write('a.jpg', sentinel);
    final service = LocalPhotoSuggestions(source: source);
    final card = (await service.scan()).single;
    source.failSecond = true;
    await expectLater(
        service.create(card.id), throwsA(isA<FileSystemException>()));
    expect(EntryStore.instance.entries, isEmpty);
    expect(await stored.list(), ['a.jpg']);
    expect(await stored.read('a.jpg'), sentinel);
    expect(source.paths.every((path) => File(path).existsSync()), isTrue);
  });
  test('desktop metadata scan stays in the explicitly selected folder',
      () async {
    await ConfigProvider.instance.set(Settings.localPhotoFolder, folder.path);
    final nested = await Directory('${folder.path}/nested').create();
    await File('${nested.path}/ignored.jpg').writeAsBytes([1, 2, 3]);
    final source = DevicePhotoSource();
    final photos = await source.recent(
        after: DateTime.now().subtract(const Duration(days: 7)),
        locations: false);
    expect(photos, hasLength(2));
    for (final photo in photos) {
      final path = await source.copyForImport(photo.id);
      await source.releaseCopy(path);
      expect(await File(path).exists(), isTrue);
    }
    await expectLater(source.copyForImport('${nested.path}/ignored.jpg'),
        throwsA(isA<FileSystemException>()));
  });
}

class _Photos implements LocalPhotoSource {
  _Photos(this.paths, this.taken);
  final List<String> paths;
  final DateTime taken;
  int copies = 0;
  int releases = 0;
  bool failSecond = false;
  bool includeLocation = false;
  @override
  Future<List<LocalPhoto>> recent(
          {required DateTime after, required bool locations}) async =>
      [
        for (final path in paths)
          LocalPhoto(
              id: path,
              taken: taken,
              latitude: includeLocation ? 30 : null,
              longitude: includeLocation ? 120 : null)
      ];
  @override
  Future<String> copyForImport(String id) async {
    copies++;
    if (failSecond && copies == 2) {
      throw const FileSystemException('Photo unavailable');
    }
    return id;
  }

  @override
  Future<void> releaseCopy(String path) async {
    releases++;
  }
}
