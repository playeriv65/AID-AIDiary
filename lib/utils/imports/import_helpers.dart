// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:typed_data';
import 'dart:math' show min;

import 'package:aid_diary/models/day_weather.dart';
import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/database/entry_tag_dao.dart';
import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/database/import_source_dao.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/providers/weather_provider.dart';
import 'package:aid_diary/utils/entry_preview.dart';
import 'package:aid_diary/utils/operation_outcome.dart';
import 'package:path/path.dart' as p;

/// A photo inside an import file, read only when its entry is added.
class ImportedPhoto {
  const ImportedPhoto(this.name, this.read);

  /// The file name in the import, which gives the photo's type.
  final String name;
  final Future<Uint8List?> Function() read;
}

/// The external identity and exact revision, independent of its date/time.
class ImportedSource {
  const ImportedSource(
      {required this.format,
      required this.id,
      required this.hash,
      required this.json});
  final String format;
  final String id;
  final String hash;
  final String json;
}

/// An entry decoded from an import file, before it reaches the database.
/// [images] are already in the image folder and carry no entry id until the
/// entry is added; [photos] are stored as new images then.
class ImportedEntry {
  const ImportedEntry(this.entry,
      {this.images = const [],
      this.photos = const [],
      this.tags = const [],
      this.source,
      this.favorite = false,
      this.weather});

  final Entry entry;

  /// The weather the other journal kept with the entry; it becomes the
  /// imported weather of its day at its place.
  final EntryWeather? weather;
  final List<EntryImage> images;
  final List<ImportedPhoto> photos;

  /// Tag names, matched to existing tags regardless of case and created as
  /// labels when missing, each with an optional value.
  final List<({String name, String? value})> tags;
  final bool favorite;
  final ImportedSource? source;
}

Future<void> addImportedEntries(
    List<ImportedEntry> importedEntries, Function(String) updateStatus) async {
  final totalEntries = importedEntries.length;
  var processedEntries = 0;
  await EntriesProvider.instance.complete;
  final taken = {
    for (final entry in EntriesProvider.instance.entries) entry.timeCreate
  };
  final tags = _TagResolver();

  for (final imported in importedEntries) {
    final source = imported.source;
    final shouldAdd = source == null
        ? taken.add(imported.entry.timeCreate)
        : !await ImportSourceDao.contains(
            source.format, source.id, source.hash);
    if (shouldAdd) {
      final entry = titledByHeading(imported.entry);
      final addedEntry = await EntriesProvider.instance.add(
          entry.copy(
              location: entry.location?.withSource(LocationSource.imported)),
          skipUpdate: true);
      try {
        for (final image in imported.images) {
          await EntryImagesProvider.instance
              .add(image.copy(entryId: addedEntry.id), skipUpdate: true);
        }
        // The UI sorts descending; photos follow existing images in the
        // source order rather than appearing reversed.
        var rank = imported.images.isEmpty
            ? imported.photos.length - 1
            : imported.images.map((image) => image.imgRank).reduce(min) - 1;
        for (final photo in imported.photos) {
          final bytes = await photo.read();
          if (bytes == null || bytes.isEmpty) {
            if (source != null) {
              throw StateError('An import attachment could not be read');
            }
            continue;
          }
          final name = await ImageStorage.instance.create(null, bytes,
              currTime: addedEntry.timeCreate,
              skipExternalUpload: true,
              fileExtension: p.extension(photo.name).isEmpty
                  ? '.jpg'
                  : p.extension(photo.name).toLowerCase());
          if (name == null) {
            if (source != null) {
              throw StateError('An import attachment could not be stored');
            }
            continue;
          }
          await EntryImagesProvider.instance.add(
              EntryImage(
                  entryId: addedEntry.id,
                  imgPath: name,
                  imgRank: rank--,
                  timeCreate: addedEntry.timeCreate),
              skipUpdate: true);
        }
        for (final tag in imported.tags) {
          final tagId = await tags.idFor(tag.name);
          if (tagId == null) continue;
          await EntryTagDao.add(EntryTag(
              entryId: addedEntry.id!,
              tagId: tagId,
              value: tag.value,
              timeCreate: addedEntry.timeCreate));
        }
        if (imported.favorite) {
          final favorite = await TagsProvider.instance.ensureFavoriteTag();
          await EntryTagDao.add(EntryTag(
              entryId: addedEntry.id!,
              tagId: favorite.id!,
              timeCreate: addedEntry.timeCreate));
        }
        if (imported.weather case final weather?) {
          await WeatherProvider.write(
              AppDatabase.instance.database!,
              addedEntry.day,
              weatherPlaceOf(addedEntry.location),
              weather,
              WeatherSource.imported);
        }
        if (source != null) {
          await ImportSourceDao.add(
              format: source.format,
              id: source.id,
              hash: source.hash,
              entryId: addedEntry.id!,
              json: source.json);
        }
      } catch (_) {
        if (source != null) await EntryStore.instance.erase(addedEntry);
        rethrow;
      }
    }
    processedEntries += 1;
    updateStatus("${((processedEntries / totalEntries) * 100).round()}%");
  }
  await tags.orderMadeByUse();
  await WeatherProvider.instance.load();
}

/// Finds tags by name for an import, creating the missing ones once.
class _TagResolver {
  final Map<String, int?> _ids = {
    for (final tag in TagsProvider.instance.tags)
      tag.name.trim().toLowerCase(): tag.id
  };

  /// How many imported entries use each tag this import made.
  final Map<int, int> _uses = {};

  Future<int?> idFor(String name) async {
    final id = await _find(name);
    if (id != null && _uses.containsKey(id)) _uses[id] = _uses[id]! + 1;
    return id;
  }

  /// Places the tags this import made after those the diary had, most used
  /// first. That starts their order; from then on the user arranges it.
  Future<void> orderMadeByUse() async {
    if (_uses.isEmpty) return;
    final made = TagsProvider.instance.tags
        .where((tag) => _uses.containsKey(tag.id))
        .toList();
    final first = made.map((tag) => tag.sortOrder).reduce(min);
    final byUse = [...made]..sort((a, b) {
        final more = _uses[b.id]!.compareTo(_uses[a.id]!);
        return more != 0 ? more : a.sortOrder.compareTo(b.sortOrder);
      });
    await TagsProvider.instance.batchUpdateTags([
      for (final (index, tag) in byUse.indexed)
        tag.copy(sortOrder: first + index),
    ]);
  }

  Future<int?> _find(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return null;
    final key = trimmed.toLowerCase();
    if (_ids.containsKey(key)) return _ids[key];
    final now = DateTime.now();
    await TagsProvider.instance.add(Tag(
        name: trimmed,
        tagType: TagType.label,
        timeCreate: now,
        timeModified: now));
    final created = TagsProvider.instance.tags.lastWhere(
        (tag) => tag.name == trimmed,
        orElse: () => throw StateError('Tag $trimmed was not created'));
    _uses[created.id!] = 0;
    return _ids[key] = created.id;
  }
}

Future<OperationOutcome> finishImport(
    Function(String) updateStatus, OperationOutcome outcome) async {
  await EntriesProvider.instance.load();
  await EntryImagesProvider.instance.load();
  await TagsProvider.instance.load();
  if (ImageStorage.instance.usingExternalLocation()) {
    try {
      await ImageStorage.instance
          .syncImageFolder(true, updateStatus: updateStatus);
    } catch (error) {
      return outcome.failed ? outcome : OperationOutcome.failed(error);
    }
  }
  return outcome;
}

DateTime diariumIdToDateTime(int ticks) {
  const int ticksAtUnixEpoch = 621355968000000000;
  final usSinceEpoch = ((ticks - ticksAtUnixEpoch) / 10).round();
  return DateTime.fromMicrosecondsSinceEpoch(usSinceEpoch, isUtc: false);
}

DateTime convertWithOffset(int millisUtc, String tzOffset) {
  final utc = DateTime.fromMillisecondsSinceEpoch(millisUtc, isUtc: true);
  final sign = tzOffset.startsWith('-') ? -1 : 1;
  final parts = tzOffset.substring(1).split(':');
  final hours = int.parse(parts[0]);
  final minutes = int.parse(parts[1]);
  final offsetDuration = Duration(
    hours: hours * sign,
    minutes: minutes * sign,
  );
  return utc.add(offsetDuration);
}

DateTime parseDaybookLocal(String s) {
  final match = RegExp(
    r'^(\d{4})-(\d{2})-(\d{2})-(\d{2}):(\d{2})$',
  ).firstMatch(s);

  if (match == null) {
    throw FormatException("Invalid Daybook date: $s");
  }

  return DateTime(
    int.parse(match[1]!),
    int.parse(match[2]!),
    int.parse(match[3]!),
    int.parse(match[4]!),
    int.parse(match[5]!),
  );
}
