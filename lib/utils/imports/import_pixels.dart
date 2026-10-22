// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';

import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/storage/storage_picker.dart';
import 'package:aid_diary/utils/imports/import_helpers.dart';
import 'package:aid_diary/utils/operation_outcome.dart';
import 'package:intl/intl.dart';

Future<OperationOutcome> importFromPixels(
    PickedFile selectedFile, Function(String) updateStatus) async {
  updateStatus("0%");

  var outcome = const OperationOutcome.succeeded();

  try {
    final bytes = await selectedFile.readBytes();
    if (bytes == null) return const OperationOutcome.failed();
    final jsonData = json.decode(utf8.decode(bytes.toList()));

    final totalEntries = jsonData.length;
    var processedEntries = 0;

    for (var entry in jsonData) {
      if (entry['type'] == 'Mood') {
        DateTime timeCreated = DateFormat("yyyy-MM-dd").parse(entry['date']);
        DateTime timeModified = DateTime.now();

        if (!EntriesProvider.instance.hasEntryAtTimestamp(timeCreated)) {
          // Average multiple scores within a single Pixels entry
          int avgMood =
              (entry['scores'] as List<dynamic>).reduce((a, b) => a + b) ~/
                  entry['scores'].length;
          int mappedMood = avgMood - 3;

          await EntriesProvider.instance.add(
              Entry(
                  text: entry['notes'] ?? '',
                  mood: mappedMood,
                  timeCreate: timeCreated,
                  timeModified: timeModified),
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
