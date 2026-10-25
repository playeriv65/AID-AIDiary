// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:typed_data';

import 'package:aid_diary/models/day_weather.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/utils/activity_tags.dart';
import 'package:aid_diary/utils/diary_day.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/storage/storage_picker.dart';
import 'package:aid_diary/utils/imports/import_helpers.dart';
import 'package:aid_diary/utils/operation_outcome.dart';
import 'package:aid_diary/utils/local_time.dart';

Future<OperationOutcome> importFromJson(PickedFile selectedFile,
    AppLocalizations l10n, Function(String) updateStatus) async {
  updateStatus("0%");

  var outcome = const OperationOutcome.succeeded();

  try {
    final bytes = await selectedFile.readBytes();
    if (bytes == null) return const OperationOutcome.failed();

    await addImportedEntries(decodeJsonEntries(bytes, l10n), updateStatus);
  } catch (error) {
    outcome = OperationOutcome.failed(error);
  }

  return finishImport(updateStatus, outcome);
}

/// Entries from a JSON export. One from an older version may name an
/// activity, which becomes a tag.
List<ImportedEntry> decodeJsonEntries(Uint8List bytes, AppLocalizations l10n) {
  final jsonData = json.decode(utf8.decode(bytes.toList()));

  return [
    for (var entry in jsonData)
      ImportedEntry(
        Entry(
            title: entry['title'] as String? ?? '',
            text: entry['text'],
            mood: entry['mood'] as int?,
            timeCreate: parseLocalTime(entry['timeCreated']),
            utcOffset: entry['utcOffsetMinutes'] as int?,
            day: DiaryDay.parse(entry['diaryDate'] as String?),
            timeModified: parseLocalTime(entry['timeModified']),
            // Optional, like everything below.
            location: switch (entry['location']) {
              final Map place => EntryLocation(
                  name: place['name'] as String?,
                  latitude: (place['latitude'] as num?)?.toDouble(),
                  longitude: (place['longitude'] as num?)?.toDouble()),
              _ => null,
            },
            isHidden: entry['isHidden'] == true,
            openAt: switch (entry['openAt']) {
              final String at => parseLocalTime(at),
              _ => null,
            }),
        weather: switch (entry['weather']) {
          final Map weather => EntryWeather(
              code: weather['code'] as int,
              temperature: (weather['temperature'] as num).toDouble()),
          _ => null,
        },
        tags: [
          for (final tag in entry['tags'] as List? ?? const [])
            (name: tag['name'] as String, value: tag['value'] as String?),
          if (ActivityTag.byName(entry['activity'] as String?)
              case final activity?)
            (name: activity.label(l10n), value: null),
        ],
        source: switch (entry['importSource']) {
          final Map source => ImportedSource(
              format: source['format'] as String,
              id: source['id'] as String,
              hash: source['hash'] as String,
              json: json.encode(source['metadata'])),
          _ => null,
        },
        photos: [
          for (final photo in entry['photos'] as List? ?? const [])
            _photo(photo as Map),
        ],
        images: [
          if (entry['images'] != null)
            for (var image in entry['images'])
              EntryImage(
                  entryId: null,
                  imgPath: image['imgPath'],
                  imgRank: image['imgRank'] as int,
                  timeCreate: parseLocalTime(image['timeCreated'])),
        ],
      ),
  ];
}

ImportedPhoto _photo(Map photo) {
  final name = photo['name'] as String;
  final bytes = base64.decode(photo['base64'] as String);
  if (name.isEmpty || bytes.isEmpty) {
    throw const FormatException('Invalid JSON import attachment');
  }
  return ImportedPhoto(name, () async => bytes);
}
