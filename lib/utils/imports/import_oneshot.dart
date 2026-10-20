// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';

import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/storage/storage_picker.dart';
import 'package:aid_diary/utils/imports/import_helpers.dart';
import 'package:aid_diary/utils/operation_outcome.dart';

Future<OperationOutcome> importFromOneShot(
    Function(String) updateStatus) async {
  updateStatus("0%");

  var outcome = const OperationOutcome.succeeded();

  try {
    final selectedFile = await StoragePicker.pickFile(
        allowedExtensions: ['json'], mimeTypes: ['application/json']);
    if (selectedFile == null) return const OperationOutcome.cancelled();

    final bytes = await selectedFile.readBytes();
    if (bytes == null) return const OperationOutcome.failed();
    final jsonData = json.decode(utf8.decode(bytes.toList()));

    const happinessMapping = {
      "VERY_SAD": -2,
      "SAD": -1,
      "NEUTRAL": 0,
      "HAPPY": 1,
      "VERY_HAPPY": 2,
    };

    final totalEntries = jsonData.length;
    var processedEntries = 0;

    for (var entry in jsonData) {
      final createdTimestamp = entry['created'];
      final createdDateTime =
          DateTime.fromMillisecondsSinceEpoch(createdTimestamp * 1000);
      final mood = happinessMapping[entry['happiness']];

      if (!EntriesProvider.instance.hasEntryAtTimestamp(createdDateTime)) {
        var addedEntry = await EntriesProvider.instance.add(
            Entry(
                text: entry['textContent'],
                mood: mood,
                timeCreate: createdDateTime,
                timeModified: DateTime.now()),
            skipUpdate: true);
        if (entry['relativePath'] != null) {
          await EntryImagesProvider.instance.add(
              EntryImage(
                  entryId: addedEntry.id,
                  imgPath: entry['relativePath'],
                  imgRank: 0,
                  timeCreate: DateTime.now()),
              skipUpdate: true);
        }
      }
      processedEntries += 1;
      updateStatus("${((processedEntries / totalEntries) * 100).round()}%");
    }
  } catch (error) {
    outcome = OperationOutcome.failed(error);
  }

  return finishImport(updateStatus, outcome);
}
