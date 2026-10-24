// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['integration'])
library;

import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/models/tag_category.dart';
import 'package:aid_diary/models/tag_icon_type.dart';
import 'package:aid_diary/models/template.dart';
import 'package:aid_diary/sync/sync_schema.dart';
import 'package:aid_diary/utils/generated/tag_icon_registry.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Database db;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    sqfliteFfiInit();
  });

  setUp(() async {
    db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    AppDatabase.instance.database = db;
  });

  tearDown(() async {
    AppDatabase.instance.database = null;
    await db.close();
  });

  Future<Map<String, int>> changes() async => {
        for (final row in await db.query(syncChangesTable))
          '${row['kind']}:${row[syncIdColumn]}': row['changed_at'] as int,
      };

  Future<int> addEntry(String text) => db.insert(entriesTable, {
        EntryFields.text: text,
        EntryFields.timeCreate: '2026-10-20T09:00:00.000',
        EntryFields.timeModified: '2026-10-20T09:00:00.000',
      });

  Future<String> idOf(String table, int rowId) async => (await db.query(table,
          columns: [syncIdColumn], where: 'id = ?', whereArgs: [rowId]))
      .single[syncIdColumn] as String;

  group('a new database', () {
    setUp(() => AppDatabase.instance.createSchema(db));

    test('finds the entries whose changes have not gone up', () async {
      final waiting = await addEntry('waiting');
      final sent = await addEntry('sent');
      await db.delete(syncChangesTable,
          where: '$syncIdColumn = ?',
          whereArgs: [await idOf(entriesTable, sent)]);
      expect(await pendingEntryIds(db), {waiting});
      await clearSyncState(db);
      expect(await pendingEntryIds(db), isEmpty);
    });

    test('gives new rows an id and records them', () async {
      final entry = await idOf(entriesTable, await addEntry('hello'));

      expect(entry, matches(RegExp(r'^[0-9a-f]{32}$')));
      expect((await changes()).keys, ['entry:$entry']);
    });

    test('records an entry when its photos or tags change', () async {
      final entryRow = await addEntry('hello');
      final entry = await idOf(entriesTable, entryRow);
      final tagRow = await db.insert(tagsTable, {
        TagFields.name: 'walk',
        TagFields.tagType: TagType.label.toInt(),
      });
      await db.delete(syncChangesTable);

      await db.insert(entryTagsTable, {
        EntryTagFields.entryId: entryRow,
        EntryTagFields.tagId: tagRow,
      });
      expect((await changes()).keys, ['entry:$entry']);

      await db.delete(syncChangesTable);
      final imageRow = await db.insert(imagesTable, {
        EntryImageFields.entryId: entryRow,
        EntryImageFields.imgPath: 'a.jpg',
        EntryImageFields.imgRank: 0,
      });
      expect(await idOf(imagesTable, imageRow), isNotEmpty);
      expect((await changes()).keys, ['entry:$entry']);
    });

    test('keeps the id of a deleted item as a change', () async {
      final row = await addEntry('gone');
      final entry = await idOf(entriesTable, row);
      await db.delete(syncChangesTable);

      await db.delete(entriesTable, where: 'id = ?', whereArgs: [row]);

      expect((await changes()).keys, ['entry:$entry']);
    });

    test('records a template when its tags change', () async {
      final template = await db.insert(templatesTable, {
        TemplatesFields.name: 'Daily',
      });
      final tag = await db.insert(tagsTable, {
        TagFields.name: 'walk',
        TagFields.tagType: TagType.label.toInt(),
      });
      await db.delete(syncChangesTable);

      await db.insert(templateTagsTable, {
        TemplateTagFields.templateId: template,
        TemplateTagFields.tagId: tag,
      });

      expect((await changes()).keys,
          ['template:${await idOf(templatesTable, template)}']);
    });

    test('records nothing while remote items are written', () async {
      await withoutRecording(db, (txn) async {
        await txn.insert(entriesTable, {
          syncIdColumn: 'remote-entry',
          EntryFields.text: 'from the cloud',
          EntryFields.timeCreate: '2026-10-20T09:00:00.000',
          EntryFields.timeModified: '2026-10-20T09:00:00.000',
        });
      });

      expect(await changes(), isEmpty);
      await addEntry('local again');
      expect(await changes(), hasLength(1));
    });

    test('marks every item for a diary that starts syncing', () async {
      await addEntry('one');
      await db.insert(tagsTable, {
        TagFields.name: 'walk',
        TagFields.tagType: TagType.label.toInt(),
      });
      await db.delete(syncChangesTable);

      await markAllChanged(db);

      expect((await changes()).keys.map((key) => key.split(':').first),
          unorderedEquals(['entry', 'tag']));
    });
  });

  test('an upgraded diary gets ids and built-in ids for its defaults',
      () async {
    await AppDatabase.instance.createVersion10Schema(db);
    final favorite = await db.insert(tagsTable, {
      TagFields.name: 'Favorite',
      TagFields.tagType: TagType.label.toInt(),
      TagFields.icon: TagIconKey.favorite,
      TagFields.iconType: TagIconType.materialIcon.toInt(),
    });
    final ownTag = await db.insert(tagsTable, {
      TagFields.name: 'Mine',
      TagFields.tagType: TagType.label.toInt(),
    });
    final written = await addEntry('my day');

    await AppDatabase.instance.upgradeSchema(db, 10, 11);

    expect(
        await idOf(tagsTable, favorite), 'builtin-tag-${TagIconKey.favorite}');
    expect(await idOf(tagsTable, ownTag), matches(RegExp(r'^[0-9a-f]{32}$')));
    expect(
        await idOf(entriesTable, written), matches(RegExp(r'^[0-9a-f]{32}$')));
    // Changes are recorded from here on; the upgrade itself sends nothing.
    expect(await changes(), isEmpty);
  });

  test('a diary from before packs gets the item versions table', () async {
    await AppDatabase.instance.createSchema(db);
    await db.execute('DROP TABLE $syncItemsTable');
    await db.insert(syncSeenTable, {'path': 'items/old', 'version': 'v1'});
    final entry = await addEntry('kept');

    await AppDatabase.instance.upgradeSchema(db, 11, 12);

    expect(await db.query(syncItemsTable), isEmpty);
    expect(await db.query(syncSeenTable), isEmpty);
    expect(await db.query(entriesTable, where: 'id = ?', whereArgs: [entry]),
        hasLength(1));
  });

  test('version 12 adds transfer state without touching diary changes',
      () async {
    await AppDatabase.instance.createSchema(db);
    await db.execute('DROP TABLE sync_media_tasks');
    await db.execute('DROP TABLE sync_media_objects');
    await addEntry('kept locally');
    final before = await changes();
    await AppDatabase.instance.upgradeSchema(db, 12, 13);
    expect(await db.query('sync_media_tasks'), isEmpty);
    expect(await db.query('sync_media_objects'), isEmpty);
    expect(await changes(), before);
    expect(await db.query(entriesTable), hasLength(1));
  });

  test('version 14 drops the starter tags and categories nobody used',
      () async {
    await AppDatabase.instance.createSchema(db);
    Future<int> row(
        String table, String syncId, Map<String, Object?> values) async {
      final id = await db.insert(table, values);
      await db.update(table, {syncIdColumn: syncId},
          where: 'id = ?', whereArgs: [id]);
      return id;
    }

    Future<int> category(String syncId) =>
        row(tagCategoriesTable, syncId, {'name': syncId});
    Future<int> tag(String syncId, {int? category}) => row(tagsTable, syncId, {
          TagFields.name: syncId,
          TagFields.tagType: TagType.label.toInt(),
          TagFields.categoryId: category,
        });

    final emotions = await category('builtin-category-a');
    final activities = await category('builtin-category-b');
    await tag('builtin-tag-calm', category: emotions);
    final exercise = await tag('builtin-tag-run', category: activities);
    await tag('builtin-tag-favorite');
    final mine = await tag('mine');
    final entry = await addEntry('ran today');
    await db.insert(entryTagsTable, {
      EntryTagFields.entryId: entry,
      EntryTagFields.tagId: exercise,
      EntryTagFields.timeCreate: '2026-10-23T09:00:00.000',
    });

    await AppDatabase.instance.upgradeSchema(db, 14, 15);

    final tags = [
      for (final row in await db.query(tagsTable)) row[TagFields.id],
    ];
    expect(tags, unorderedEquals([exercise, mine]));
    final categories = [
      for (final row in await db.query(tagCategoriesTable)) row['id'],
    ];
    expect(categories, [activities]);
  });
}
