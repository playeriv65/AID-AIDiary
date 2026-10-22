// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:typed_data';

import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/storage/storage_picker.dart';
import 'package:aid_diary/utils/imports/import_helpers.dart';
import 'package:aid_diary/utils/operation_outcome.dart';

Future<OperationOutcome> importFromMyBrain(
    PickedFile selectedFile, Function(String) updateStatus) async {
  updateStatus("0%");

  var outcome = const OperationOutcome.succeeded();

  try {
    final bytes = await selectedFile.readBytes();
    if (bytes == null) return const OperationOutcome.failed();

    await addImportedEntries(decodeMyBrainEntries(bytes), updateStatus);
  } catch (error) {
    outcome = OperationOutcome.failed(error);
  }

  return finishImport(updateStatus, outcome);
}

List<ImportedEntry> decodeMyBrainEntries(Uint8List bytes) {
  const moodMap = {
    'TERRIBLE': -2,
    'BAD': -1,
    'OKAY': 0,
    'GOOD': 1,
    'AWESOME': 2,
  };

  final jsonData = json.decode(utf8.decode(bytes.toList()));
  final diary = jsonData['diary'] as List<dynamic>;

  return [
    for (var entry in diary)
      ImportedEntry(Entry(
        text: [
          if (entry['title'] != null) "# ${entry['title']}",
          if (entry['content'] != null) entry['content'] as String,
        ].join("\n\n"),
        mood: entry['mood'] != null ? moodMap[entry['mood']] : null,
        timeCreate: DateTime.fromMillisecondsSinceEpoch(entry['createdDate'],
                isUtc: true)
            .toLocal(),
        timeModified: DateTime.fromMillisecondsSinceEpoch(entry['updatedDate'],
                isUtc: true)
            .toLocal(),
      )),
  ];
}
