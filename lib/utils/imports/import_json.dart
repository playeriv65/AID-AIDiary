// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:typed_data';

import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/storage/storage_picker.dart';
import 'package:aid_diary/utils/imports/import_helpers.dart';
import 'package:aid_diary/utils/operation_outcome.dart';
import 'package:aid_diary/utils/local_time.dart';

Future<OperationOutcome> importFromJson(Function(String) updateStatus) async {
  updateStatus("0%");

  var outcome = const OperationOutcome.succeeded();

  try {
    final selectedFile = await StoragePicker.pickFile(
        allowedExtensions: ['json'], mimeTypes: ['application/json']);
    if (selectedFile == null) return const OperationOutcome.cancelled();

    final bytes = await selectedFile.readBytes();
    if (bytes == null) return const OperationOutcome.failed();

    await addImportedEntries(decodeJsonEntries(bytes), updateStatus);
  } catch (error) {
    outcome = OperationOutcome.failed(error);
  }

  return finishImport(updateStatus, outcome);
}

List<ImportedEntry> decodeJsonEntries(Uint8List bytes) {
  final jsonData = json.decode(utf8.decode(bytes.toList()));

  return [
    for (var entry in jsonData)
      ImportedEntry(
        Entry(
            text: entry['text'],
            mood: entry['mood'] as int?,
            timeCreate: parseLocalTime(entry['timeCreated']),
            timeModified: parseLocalTime(entry['timeModified']),
            // Written by our own JSON export; absent in older files.
            location: switch (entry['location']) {
              final Map place => EntryLocation(
                  name: place['name'] as String?,
                  latitude: (place['latitude'] as num?)?.toDouble(),
                  longitude: (place['longitude'] as num?)?.toDouble()),
              _ => null,
            },
            weather: switch (entry['weather']) {
              final Map weather => EntryWeather(
                  code: weather['code'] as int,
                  temperature: (weather['temperature'] as num).toDouble()),
              _ => null,
            },
            activity: EntryActivity.fromName(entry['activity'] as String?),
            openAt: switch (entry['openAt']) {
              final String at => parseLocalTime(at),
              _ => null,
            }),
        images: [
          // Support old imgPath field
          if (entry['imgPath'] != null)
            EntryImage(
                entryId: null,
                imgPath: entry['imgPath'],
                imgRank: 0,
                timeCreate: DateTime.now()),
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
