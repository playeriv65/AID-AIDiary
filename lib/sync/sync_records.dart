// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/models/day_weather.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/entry_link.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/models/tag_category.dart';
import 'package:aid_diary/providers/weather_provider.dart';
import 'package:aid_diary/sync/sync_schema.dart';
import 'package:aid_diary/utils/diary_day.dart';
import 'package:aid_diary/utils/entry_preview.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// One item as it travels between devices: its kind, id and when it last
/// changed, with its fields, or none when it was deleted.
///
/// Fields are the table's own columns, so a device that knows more columns
/// sends them along and one that knows fewer ignores the rest. Local row ids
/// never leave the device; references are item ids.
class SyncRecord {
  const SyncRecord(this.kind, this.id, this.modified, this.data);

  final SyncKind kind;
  final String id;

  /// Milliseconds since the epoch.
  final int modified;

  /// Null for a deleted item.
  final Map<String, Object?>? data;

  bool get deleted => data == null;

  Map<String, Object?> toJson() => {
        'kind': kind.name,
        'id': id,
        'modified': modified,
        if (data != null) 'data': data,
      };

  factory SyncRecord.fromJson(Map<String, Object?> json) => SyncRecord(
      SyncKind.byName(json['kind'] as String),
      json['id'] as String,
      json['modified'] as int,
      (json['data'] as Map?)?.cast<String, Object?>());

  /// The photos of an entry record, as (id, file name).
  List<({String id, String file})> get photos => [
        for (final image in (data?[_images] as List? ?? const []))
          (id: image['id'] as String, file: image['file'] as String),
      ];
}

const String _tags = 'tags';
const String _images = 'images';
const String _category = 'category';
const String _entry = 'entry';
const String _refs = 'refs';

/// Reads the item [id] of [kind] as a record stamped [modified]; a deleted
/// record when there is no such item.
Future<SyncRecord> exportRecord(
    DatabaseExecutor db, SyncKind kind, String id, int modified) async {
  final rows = await db.query(kind.table,
      where: '$syncIdColumn = ?', whereArgs: [id], limit: 1);
  if (rows.isEmpty) return SyncRecord(kind, id, modified, null);
  final row = rows.single;
  final rowId = row['id'] as int;
  final data = _ownFields(row);

  switch (kind) {
    case SyncKind.category || SyncKind.weather:
      break;
    case SyncKind.passage:
      data.remove(PassageFields.entryId);
      data[_entry] =
          await _idOf(db, entriesTable, row[PassageFields.entryId] as int?);
    case SyncKind.tag:
      data.remove(TagFields.categoryId);
      data[_category] = await _idOf(
          db, tagCategoriesTable, row[TagFields.categoryId] as int?);
    case SyncKind.template:
      data[_tags] = [
        for (final link in await db.rawQuery('''
SELECT t.$syncIdColumn AS tag FROM $templateTagsTable l
JOIN $tagsTable t ON t.id = l.${TemplateTagFields.tagId}
WHERE l.${TemplateTagFields.templateId} = ? ORDER BY l.id''', [rowId]))
          link['tag'],
      ];
    case SyncKind.entry:
      data[_tags] = [
        for (final link in await db.rawQuery('''
SELECT t.$syncIdColumn AS tag, l.${EntryTagFields.value} AS value,
       l.${EntryTagFields.timeCreate} AS time_create
FROM $entryTagsTable l JOIN $tagsTable t ON t.id = l.${EntryTagFields.tagId}
WHERE l.${EntryTagFields.entryId} = ? ORDER BY l.id''', [rowId]))
          {
            'tag': link['tag'],
            'value': link['value'],
            'time_create': link['time_create'],
          },
      ];
      data[_images] = [
        for (final image in await db.query(imagesTable,
            where: '${EntryImageFields.entryId} = ?',
            whereArgs: [rowId],
            orderBy: '${EntryImageFields.imgRank}, id'))
          {
            'id': image[syncIdColumn],
            'file': image[EntryImageFields.imgPath],
            'rank': image[EntryImageFields.imgRank],
            'time_create': image[EntryImageFields.timeCreate],
          },
      ];
      data[_refs] = [
        for (final ref in await db.query(entryRefsTable,
            where: '${EntryRefFields.entryId} = ?',
            whereArgs: [rowId],
            orderBy: '${EntryRefFields.rank}, id'))
          {
            for (final field in [
              EntryRefFields.target,
              EntryRefFields.quote,
              EntryRefFields.quoteStart,
              EntryRefFields.rank,
              EntryRefFields.timeCreate,
            ])
              field: ref[field],
          },
      ];
  }
  return SyncRecord(kind, id, modified, data);
}

Map<String, Object?> _ownFields(Map<String, Object?> row) =>
    Map.of(row)..removeWhere((key, _) => key == 'id' || key == syncIdColumn);

Future<String?> _idOf(DatabaseExecutor db, String table, int? rowId) async {
  if (rowId == null) return null;
  final rows = await db.query(table,
      columns: [syncIdColumn], where: 'id = ?', whereArgs: [rowId]);
  return rows.firstOrNull?[syncIdColumn] as String?;
}

Future<int?> _rowIdOf(DatabaseExecutor db, String table, String? id) async {
  if (id == null) return null;
  final rows = await db.query(table,
      columns: ['id'], where: '$syncIdColumn = ?', whereArgs: [id]);
  return rows.firstOrNull?['id'] as int?;
}

/// Writes records into the database. Photo files are fetched before and
/// removed after, outside the transaction: [fileOf] names the local file of
/// each new photo, and [orphanedFiles] collects files no row uses any more.
class RecordWriter {
  RecordWriter(this.db, {required this.fileOf});

  final DatabaseExecutor db;
  final String Function(String photoId) fileOf;
  final Set<String> orphanedFiles = {};
  final Map<String, Set<String>> _columns = {};

  /// Records must come categories first, then tags, templates and entries,
  /// so references find what they point to.
  Future<void> apply(SyncRecord record) async {
    if (record.deleted) return _delete(record.kind, record.id);
    final data = record.kind == SyncKind.entry
        ? await _fromOlderVersion(record.data!)
        : record.data!;
    final passageEntry = record.kind == SyncKind.passage
        ? await _rowIdOf(db, entriesTable, data[_entry] as String?)
        : null;
    // A passage whose entry is gone for good has nothing to belong to.
    if (record.kind == SyncKind.passage && passageEntry == null) return;
    final rowId = await _upsert(record.kind.table, record.id, {
      ...data,
      if (record.kind == SyncKind.tag)
        TagFields.categoryId:
            await _rowIdOf(db, tagCategoriesTable, data[_category] as String?),
      if (passageEntry != null) PassageFields.entryId: passageEntry,
    });
    switch (record.kind) {
      case SyncKind.category ||
            SyncKind.tag ||
            SyncKind.passage ||
            SyncKind.weather:
        break;
      case SyncKind.template:
        await db.delete(templateTagsTable,
            where: '${TemplateTagFields.templateId} = ?', whereArgs: [rowId]);
        for (final tag in (data[_tags] as List? ?? const [])) {
          final tagRow = await _rowIdOf(db, tagsTable, tag as String);
          if (tagRow == null) continue;
          await db.insert(templateTagsTable, {
            TemplateTagFields.templateId: rowId,
            TemplateTagFields.tagId: tagRow,
          });
        }
      case SyncKind.entry:
        await _writeEntryTags(rowId, data[_tags] as List? ?? const []);
        await _writeEntryImages(rowId, record.photos, data[_images] as List);
        await db.delete(entryRefsTable,
            where: '${EntryRefFields.entryId} = ?', whereArgs: [rowId]);
        for (final ref in data[_refs] as List? ?? const []) {
          await db.insert(entryRefsTable, {
            ...(ref as Map).cast<String, Object?>(),
            EntryRefFields.entryId: rowId,
          });
        }
    }
  }

  /// An entry from a device before database version 17 has its title as the
  /// first line of its text and its weather on it.
  Future<Map<String, Object?>> _fromOlderVersion(
      Map<String, Object?> data) async {
    if (data.containsKey(EntryFields.title)) return data;
    final (:title, :body) = splitEntryTitle(data[EntryFields.text] as String);
    final code = data[EntryFields.weatherCode] as int?;
    final temperature = data[EntryFields.temperature] as num?;
    final day = DiaryDay.parse(data[EntryFields.diaryDate] as String?);
    if (code != null && temperature != null && day != null) {
      final location = EntryLocation(
          latitude: (data[EntryFields.latitude] as num?)?.toDouble(),
          longitude: (data[EntryFields.longitude] as num?)?.toDouble(),
          name: data[EntryFields.locationName] as String?);
      await WeatherProvider.write(
          db,
          day,
          weatherPlaceOf(location.isEmpty ? null : location),
          EntryWeather(code: code, temperature: temperature.toDouble()),
          WeatherSource.queried);
    }
    return {...data, EntryFields.title: title, EntryFields.text: body};
  }

  /// Inserts or updates the item's row with the columns the table has.
  Future<int> _upsert(
      String table, String id, Map<String, Object?> data) async {
    final columns = _columns[table] ??= {
      for (final column in await db.rawQuery('PRAGMA table_info($table)'))
        column['name'] as String,
    }..removeAll(['id', syncIdColumn]);
    final values = {
      for (final column in columns)
        if (data.containsKey(column)) column: data[column],
    };
    final existing = await _rowIdOf(db, table, id);
    if (existing != null) {
      await db.update(table, values, where: 'id = ?', whereArgs: [existing]);
      return existing;
    }
    return db.insert(table, {...values, syncIdColumn: id});
  }

  Future<void> _writeEntryTags(int entryRow, List tags) async {
    await db.delete(entryTagsTable,
        where: '${EntryTagFields.entryId} = ?', whereArgs: [entryRow]);
    for (final link in tags) {
      final tagRow = await _rowIdOf(db, tagsTable, link['tag'] as String?);
      if (tagRow == null) continue;
      await db.insert(entryTagsTable, {
        EntryTagFields.entryId: entryRow,
        EntryTagFields.tagId: tagRow,
        EntryTagFields.value: link['value'],
        if (link['time_create'] != null)
          EntryTagFields.timeCreate: link['time_create'],
      });
    }
  }

  Future<void> _writeEntryImages(int entryRow,
      List<({String id, String file})> photos, List images) async {
    final existing = {
      for (final row in await db.query(imagesTable,
          where: '${EntryImageFields.entryId} = ?', whereArgs: [entryRow]))
        row[syncIdColumn] as String: row,
    };
    for (final (index, image) in images.indexed) {
      final id = image['id'] as String;
      final fields = {
        EntryImageFields.imgRank: image['rank'] ?? index,
        if (image['time_create'] != null)
          EntryImageFields.timeCreate: image['time_create'],
      };
      if (existing.remove(id) case final row?) {
        await db.update(imagesTable, fields,
            where: 'id = ?', whereArgs: [row['id']]);
      } else {
        // A photo that moved from another entry keeps its file.
        final moved = await db
            .query(imagesTable, where: '$syncIdColumn = ?', whereArgs: [id]);
        if (moved.isNotEmpty) {
          await db.update(
              imagesTable, {...fields, EntryImageFields.entryId: entryRow},
              where: 'id = ?', whereArgs: [moved.single['id']]);
        } else {
          await db.insert(imagesTable, {
            ...fields,
            syncIdColumn: id,
            EntryImageFields.entryId: entryRow,
            EntryImageFields.imgPath: fileOf(id),
          });
        }
      }
    }
    for (final row in existing.values) {
      await db.delete(imagesTable, where: 'id = ?', whereArgs: [row['id']]);
      orphanedFiles.add(row[EntryImageFields.imgPath] as String);
    }
  }

  Future<void> _delete(SyncKind kind, String id) async {
    final rowId = await _rowIdOf(db, kind.table, id);
    if (rowId == null) return;
    switch (kind) {
      case SyncKind.category:
        await db.update(tagsTable, {TagFields.categoryId: null},
            where: '${TagFields.categoryId} = ?', whereArgs: [rowId]);
      case SyncKind.tag:
        await db.delete(entryTagsTable,
            where: '${EntryTagFields.tagId} = ?', whereArgs: [rowId]);
        await db.delete(templateTagsTable,
            where: '${TemplateTagFields.tagId} = ?', whereArgs: [rowId]);
      case SyncKind.template:
        await db.delete(templateTagsTable,
            where: '${TemplateTagFields.templateId} = ?', whereArgs: [rowId]);
      case SyncKind.passage || SyncKind.weather:
        break;
      case SyncKind.entry:
        await db.delete(entryTagsTable,
            where: '${EntryTagFields.entryId} = ?', whereArgs: [rowId]);
        await db.delete(entryRefsTable,
            where: '${EntryRefFields.entryId} = ?', whereArgs: [rowId]);
        await db.delete(passagesTable,
            where: '${PassageFields.entryId} = ?', whereArgs: [rowId]);
        for (final image in await db.query(imagesTable,
            where: '${EntryImageFields.entryId} = ?', whereArgs: [rowId])) {
          orphanedFiles.add(image[EntryImageFields.imgPath] as String);
        }
        await db.delete(imagesTable,
            where: '${EntryImageFields.entryId} = ?', whereArgs: [rowId]);
    }
    await db.delete(kind.table, where: 'id = ?', whereArgs: [rowId]);
  }

  /// Files in [orphanedFiles] that no photo row uses after all.
  Future<List<String>> unusedFiles() async => [
        for (final file in orphanedFiles)
          if ((await db.query(imagesTable,
                  columns: ['id'],
                  where: '${EntryImageFields.imgPath} = ?',
                  whereArgs: [file],
                  limit: 1))
              .isEmpty)
            file,
      ];
}

/// Keeps a local entry that lost to a newer remote version as a new entry
/// in Recently deleted, sharing its photo files, so no writing is lost.
Future<void> keepLosingEntry(
    DatabaseExecutor db, SyncRecord local, String newId, DateTime now) async {
  final data = local.data!;
  final copy = SyncRecord(SyncKind.entry, newId, local.modified, {
    ...data,
    EntryFields.deletedAt: now.toIso8601String(),
    _images: [
      for (final (index, image) in local.photos.indexed)
        {'id': '$newId-$index', 'file': image.file, 'rank': index},
    ],
  });
  final files = {
    for (final (index, image) in local.photos.indexed)
      '$newId-$index': image.file,
  };
  await RecordWriter(db, fileOf: (id) => files[id]!).apply(copy);
}

/// Where to keep a remote photo locally: its own name, unless another photo
/// already has a file by that name.
String localNameFor(String photoId, String remoteName, bool nameTaken) =>
    nameTaken ? '$photoId${p.extension(remoteName)}' : remoteName;
