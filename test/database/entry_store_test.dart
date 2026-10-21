// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['integration'])
library;

import 'dart:typed_data';

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/database/entry_dao.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/database/tag_dao.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/storage/in_memory_file_store.dart';
import 'package:aid_diary/utils/diary_day.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  final store = EntryStore.instance;
  final time = DateTime(2025, 6, 2, 9, 30);

  late Database database;
  late InMemoryFileStore imageFiles;

  Entry draftEntry({int? id, String text = 'draft', int? mood}) => Entry(
      id: id, text: text, mood: mood, timeCreate: time, timeModified: time);

  Future<void> reloadEverything() async {
    await store.load();
    await TagsProvider.instance.load();
    await EntryImagesProvider.instance.load();
  }

  Future<Tag> addTag(String name) => TagDao.add(Tag(
      name: name,
      tagType: TagType.label,
      timeCreate: time,
      timeModified: time));

  Future<EntryImage> writeImageFile(String name) async {
    await imageFiles.write(name, Uint8List.fromList(name.codeUnits));
    return EntryImage(
        entryId: null, imgPath: name, imgRank: 0, timeCreate: time);
  }

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    sqfliteFfiInit();
    // The store reads the Recently deleted retention period from it.
    await AppConfig.load();
  });

  setUp(() async {
    databaseFactory = databaseFactoryFfi;
    database = await databaseFactory.openDatabase(inMemoryDatabasePath);
    AppDatabase.instance.database = database;
    await AppDatabase.instance.createSchema(database);

    imageFiles = InMemoryFileStore();
    ImageStorage.instance.overrideStores(imageFiles, InMemoryFileStore());

    await reloadEverything();
  });

  tearDown(() async {
    ImageStorage.instance.clearStoreOverrides();
    AppDatabase.instance.database = null;
    await database.close();
  });

  test('persists an entry with its tags and images together', () async {
    final tag = await addTag('walk');
    await TagsProvider.instance.load();
    final image = await writeImageFile('photo.jpg');

    final saved = await store.beginDraft().save((_) => EntryDraft(
          entry: draftEntry(text: 'a good day', mood: 1),
          tags: [
            EntryTag(entryId: 0, tagId: tag.id!, value: '2', timeCreate: time)
          ],
          images: [image],
        ));

    await reloadEverything();

    expect(store.entries.single.id, saved.id);
    expect(store.entries.single.text, 'a good day');
    expect(store.entries.single.mood, 1);

    final entryTags = TagsProvider.instance.getEntryTagsForEntry(saved.id!);
    expect(entryTags.single.tagId, tag.id);
    expect(entryTags.single.value, '2');

    final entryImages =
        EntryImagesProvider.instance.getForEntry(store.entries.single);
    expect(entryImages.single.imgPath, 'photo.jpg');
  });

  test('reconciles tags and images on a later save', () async {
    final kept = await addTag('walk');
    final dropped = await addTag('run');
    await TagsProvider.instance.load();
    final keptImage = await writeImageFile('kept.jpg');
    final droppedImage = await writeImageFile('dropped.jpg');

    final session = store.beginDraft();
    final saved = await session.save((_) => EntryDraft(
          entry: draftEntry(),
          tags: [
            EntryTag(entryId: 0, tagId: kept.id!, timeCreate: time),
            EntryTag(entryId: 0, tagId: dropped.id!, timeCreate: time),
          ],
          images: [keptImage, droppedImage],
        ));

    final survivingImage = EntryImagesProvider.instance
        .getForEntry(store.entries.single)
        .firstWhere((image) => image.imgPath == 'kept.jpg');

    await session.save((_) => EntryDraft(
          entry: saved.copy(text: 'trimmed'),
          tags: [
            EntryTag(
                entryId: saved.id!,
                tagId: kept.id!,
                value: '4',
                timeCreate: time)
          ],
          images: [survivingImage],
        ));
    // The session may still be discarded, so the file waits for commit.
    expect(await imageFiles.exists('dropped.jpg'), isTrue);
    await session.commit();

    await reloadEverything();

    final entryTags = TagsProvider.instance.getEntryTagsForEntry(saved.id!);
    expect(entryTags.single.tagId, kept.id);
    expect(entryTags.single.value, '4');

    final entryImages =
        EntryImagesProvider.instance.getForEntry(store.entries.single);
    expect(entryImages.single.imgPath, 'kept.jpg');
    expect(await imageFiles.exists('dropped.jpg'), isFalse);
    expect(await imageFiles.exists('kept.jpg'), isTrue);
  });

  test('discarding a new entry removes it and its files', () async {
    final image = await writeImageFile('new.jpg');
    final session = store.beginDraft();
    await session.save((_) =>
        EntryDraft(entry: draftEntry(text: 'not keeping'), images: [image]));
    expect(store.entries, hasLength(1));

    await session.discard();
    await reloadEverything();

    expect(store.entries, isEmpty);
    expect(await store.deleted(), isEmpty);
    expect(await imageFiles.exists('new.jpg'), isFalse);
  });

  test('discarding an edit restores the entry, its tags and photos', () async {
    final tag = await addTag('walk');
    await TagsProvider.instance.load();
    final oldImage = await writeImageFile('old.jpg');
    final original = await store.beginDraft().save((_) => EntryDraft(
        entry: draftEntry(text: 'original', mood: 1),
        tags: [EntryTag(entryId: 0, tagId: tag.id!, timeCreate: time)],
        images: [oldImage]));

    final session = store.beginDraft(original);
    final added = await writeImageFile('added.jpg');
    await session.save((saved) => EntryDraft(
        entry: (saved ?? original).copy(text: 'changed', mood: 2),
        images: [added]));
    expect(store.entries.single.text, 'changed');

    await session.discard();
    await reloadEverything();

    final entry = store.entries.single;
    expect(entry.text, 'original');
    expect(entry.mood, 1);
    expect(TagsProvider.instance.getEntryTagsForEntry(entry.id!).single.tagId,
        tag.id);
    expect(EntryImagesProvider.instance.getForEntry(entry).single.imgPath,
        'old.jpg');
    expect(await imageFiles.exists('old.jpg'), isTrue);
    expect(await imageFiles.exists('added.jpg'), isFalse);
  });

  test('drops a desired tag that was deleted out from under the entry',
      () async {
    final tag = await addTag('walk');
    await TagsProvider.instance.load();

    final session = store.beginDraft();
    final saved = await session.save((_) => EntryDraft(
          entry: draftEntry(),
          tags: [EntryTag(entryId: 0, tagId: tag.id!, timeCreate: time)],
        ));

    await TagsProvider.instance.remove(tag);

    await session.save((_) => EntryDraft(
          entry: saved.copy(text: 'edited after tag deletion'),
          tags: [
            EntryTag(entryId: saved.id!, tagId: tag.id!, timeCreate: time)
          ],
        ));

    await reloadEverything();

    expect(store.entries.single.text, 'edited after tag deletion');
    expect(TagsProvider.instance.getEntryTagsForEntry(saved.id!), isEmpty);
  });

  test('leaves no entry behind when the tag write fails', () async {
    final tag = await addTag('walk');
    await TagsProvider.instance.load();
    await database.execute('DROP TABLE $entryTagsTable');

    await expectLater(
      store.beginDraft().save((_) => EntryDraft(
            entry: draftEntry(),
            tags: [EntryTag(entryId: 0, tagId: tag.id!, timeCreate: time)],
          )),
      throwsA(isA<DatabaseException>()),
    );

    expect(await database.query(entriesTable), isEmpty);
  });

  test('a session replays a save requested while another is in flight',
      () async {
    var entry = draftEntry(text: 'draft');
    var text = 'first edit';
    int? mood;
    var editAgain = true;
    late Future<Entry> secondSave;
    final session = store.beginDraft();

    EntryDraft buildDraft(Entry? saved) {
      if (saved != null) entry = saved;
      final draft = EntryDraft(
          entry: entry.copy(text: text, mood: mood, timeModified: time));
      if (editAgain) {
        editAgain = false;
        text = 'second edit';
        mood = 2;
        secondSave = session.save(buildDraft);
      }
      return draft;
    }

    expect((await session.save(buildDraft)).text, 'first edit');
    await secondSave;

    await reloadEverything();

    expect(store.entries, hasLength(1));
    expect(store.entries.single.text, 'second edit');
    expect(store.entries.single.mood, 2);
  });

  test(
      'a session coalesces saves requested while a write is in flight, '
      'keeping only the latest', () async {
    var droppedBuildCount = 0;
    late Future<Entry> droppedSave;
    late Future<Entry> finalSave;
    final session = store.beginDraft();

    EntryDraft buildDropped(Entry? saved) {
      droppedBuildCount += 1;
      return EntryDraft(entry: saved!.copy(text: 'dropped edit'));
    }

    EntryDraft buildFinal(Entry? saved) =>
        EntryDraft(entry: saved!.copy(text: 'final edit'));

    EntryDraft buildFirst(Entry? saved) {
      if (saved == null) {
        droppedSave = session.save(buildDropped);
        finalSave = session.save(buildFinal);
      }
      return EntryDraft(entry: draftEntry(text: 'first edit'));
    }

    final first = await session.save(buildFirst);
    final last = await finalSave;
    final droppedResult = await droppedSave;

    expect(first.text, 'first edit');
    expect(last.text, 'final edit');
    expect(droppedResult.text, 'final edit');
    expect(droppedBuildCount, 0);

    await reloadEverything();

    expect(store.entries, hasLength(1));
    expect(store.entries.single.text, 'final edit');
  });

  test('independent sessions save concurrently without interfering', () async {
    final sessionA = store.beginDraft();
    final sessionB = store.beginDraft();

    final firstFuture =
        sessionA.save((_) => EntryDraft(entry: draftEntry(text: 'first')));
    final secondFuture =
        sessionB.save((_) => EntryDraft(entry: draftEntry(text: 'second')));

    final first = await firstFuture;
    final second = await secondFuture;

    expect(second.id, isNot(first.id));

    await reloadEverything();

    expect(store.entries.map((entry) => entry.text),
        containsAll(['first', 'second']));
  });

  test('removes an entry with its tags, image rows, and image files', () async {
    final tag = await addTag('walk');
    await TagsProvider.instance.load();
    final image = await writeImageFile('photo.jpg');

    final saved = await store.beginDraft().save((_) => EntryDraft(
          entry: draftEntry(),
          tags: [EntryTag(entryId: 0, tagId: tag.id!, timeCreate: time)],
          images: [image],
        ));

    await store.erase(saved);
    await reloadEverything();

    expect(store.entries, isEmpty);
    expect(TagsProvider.instance.entryTags, isEmpty);
    expect(EntryImagesProvider.instance.images, isEmpty);
    expect(await imageFiles.exists('photo.jpg'), isFalse);
  });

  group('first-screen load', () {
    Future<void> writeDays(int count) async {
      for (var day = 1; day <= count; day++) {
        final at = DateTime(2025, 1, day, 9);
        await EntryDao.add(
            Entry(text: 'day $day', timeCreate: at, timeModified: at));
      }
    }

    test('shows the newest entries first and the rest after', () async {
      await writeDays(5);

      await store.load(firstScreen: 2);
      expect(store.entries.map((e) => e.text), ['day 5', 'day 4']);

      await store.complete;
      expect(store.entries, hasLength(5));
      expect(store.entries.last.text, 'day 1');
    });

    test('is complete at once when the diary fits the first screen', () async {
      await writeDays(2);

      await store.load(firstScreen: 5);
      expect(store.entries, hasLength(2));
    });

    test('keeps an entry added while the rest is read', () async {
      await writeDays(3);

      await store.load(firstScreen: 1);
      final added = await store.add(draftEntry(text: 'written now'));

      await store.complete;
      expect(store.entries, hasLength(4));
      expect(store.entries.map((e) => e.id), contains(added.id));
    });
  });

  test('entries group and sort by their stored diary day', () async {
    DiaryDay.startHour = 4;
    addTearDown(() => DiaryDay.startHour = 0);
    final late = await store.add(Entry(
        text: 'late',
        timeCreate: DateTime(2025, 6, 3, 1, 30),
        timeModified: DateTime(2025, 6, 3, 1, 30)));
    // Written now about a day long past.
    final recalled = await store.add(Entry(
        text: 'recalled',
        timeCreate: DateTime(2025, 6, 4, 9),
        timeModified: DateTime(2025, 6, 4, 9),
        day: DateTime(2025, 5, 1)));
    // The hours changing later moves neither.
    DiaryDay.startHour = 0;
    await reloadEverything();

    expect(store.getEntriesForDate(DateTime(2025, 6, 2)).single.id, late.id);
    expect(store.getEntriesForDate(DateTime(2025, 6, 3)), isEmpty);
    expect(
        store.getEntriesForDate(DateTime(2025, 5, 1)).single.id, recalled.id);
    expect(store.entries.map((e) => e.text), ['late', 'recalled']);
  });
}
