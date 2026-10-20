// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:daily_you/database/image_storage.dart';
import 'package:daily_you/storage/file_store.dart';
import 'package:daily_you/storage/local_file_store.dart';
import 'package:daily_you/storage/storage_picker.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/models/image.dart';
import 'package:daily_you/providers/entries_provider.dart';
import 'package:daily_you/providers/entry_images_provider.dart';
import 'package:daily_you/providers/tags_provider.dart';
import 'package:daily_you/time_manager.dart';
import 'package:daily_you/utils/operation_outcome.dart';
import 'package:daily_you/utils/zip_utils.dart';
import 'package:daily_you/widgets/mood_icon.dart';
import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:daily_you/l10n/generated/app_localizations.dart';

enum ExportFormat {
  none,
  markdown,
  json,
}

/// Entries as the JSON array [decodeJsonEntries] reads back, plus place,
/// weather, activity and tags. Attachments are listed by name only; the
/// backup carries their files.
String encodeJsonEntries(List<Entry> entries,
    {required List<EntryImage> Function(Entry entry) imagesOf,
    required List<({String name, String? value})> Function(Entry entry)
        tagsOf}) {
  return const JsonEncoder.withIndent('  ').convert([
    for (final entry in entries)
      {
        'text': entry.text,
        'mood': entry.mood,
        'timeCreated': entry.timeCreate.toIso8601String(),
        'timeModified': entry.timeModified.toIso8601String(),
        if (entry.location case final place?)
          'location': {
            'name': place.name,
            'latitude': place.latitude,
            'longitude': place.longitude,
          },
        if (entry.weather case final weather?)
          'weather': {
            'code': weather.code,
            'temperature': weather.temperature,
          },
        if (entry.activity case final activity?) 'activity': activity.name,
        'tags': [
          for (final tag in tagsOf(entry))
            {'name': tag.name, if (tag.value != null) 'value': tag.value},
        ],
        'images': [
          for (final image in imagesOf(entry))
            {
              'imgPath': image.imgPath,
              'imgRank': image.imgRank,
              'timeCreated': image.timeCreate.toIso8601String(),
            },
        ],
      },
  ]);
}

class ExportUtils {
  /// Saves every entry as one JSON file in a folder the user picks.
  static Future<OperationOutcome> exportToJson(
      Function(String) updateStatus) async {
    updateStatus("0%");
    PickedDirectory? exportFolder;
    try {
      exportFolder = await StoragePicker.pickDirectory();
    } catch (error) {
      return OperationOutcome.failed(error);
    }
    if (exportFolder == null) return const OperationOutcome.cancelled();

    final tags = TagsProvider.instance;
    final tagById = {for (final tag in tags.tags) tag.id: tag};
    final json = encodeJsonEntries(
      EntriesProvider.instance.entries,
      imagesOf: EntryImagesProvider.instance.getForEntry,
      tagsOf: (entry) => [
        for (final entryTag in tags.getEntryTagsForEntry(entry.id!))
          if (tagById[entryTag.tagId] case final tag?)
            (name: tag.name, value: entryTag.value),
      ],
    );
    final name =
        "aid_diary_${DateTime.now().toIso8601String().replaceAll(':', '-')}.json";
    final file = File(join((await getTemporaryDirectory()).path, name));
    try {
      await file.writeAsString(json);
      await exportFolder.copyFileInto(file.path, name,
          mimeType: "application/json",
          onProgress: (percent) => updateStatus("${percent.round()}%"));
      return const OperationOutcome.succeeded();
    } catch (error) {
      return OperationOutcome.failed(error);
    } finally {
      if (await file.exists()) await file.delete();
    }
  }

  static Future<OperationOutcome> exportToMarkdown(
      BuildContext context, Function(String) updateStatus) async {
    final localizations = AppLocalizations.of(context)!;
    final locale = TimeManager.currentLocale(context);
    updateStatus("(1/2) 0%");

    PickedDirectory? exportFolder;
    try {
      exportFolder = await StoragePicker.pickDirectory();
    } catch (error) {
      return OperationOutcome.failed(error);
    }
    if (exportFolder == null) return const OperationOutcome.cancelled();

    var outcome = const OperationOutcome.succeeded();

    var tempDir = await getTemporaryDirectory();
    final tempExportFolder = Directory(join(tempDir.path, "logs"));
    await tempExportFolder.create(recursive: true);
    final tempExportImageFolder =
        Directory(join(tempExportFolder.path, "Images"));
    await tempExportImageFolder.create(recursive: true);
    final exportedZipName =
        "daily_you_markdown_export_${DateTime.now().toIso8601String().replaceAll(':', '-')}.zip";

    final exportStore = LocalFileStore(tempExportFolder.path);
    final exportImageStore = LocalFileStore(tempExportImageFolder.path);

    try {
      final entries = EntriesProvider.instance.entries;
      final totalLogs = entries.length;
      int processedLogs = 0;
      final writer = MarkdownExportWriter(
          noteStore: exportStore, imageStore: exportImageStore, locale: locale);

      for (Entry entry in entries) {
        final images = <(EntryImage, Uint8List)>[];
        for (EntryImage image
            in EntryImagesProvider.instance.getForEntry(entry)) {
          final bytes = await ImageStorage.instance.getBytes(image.imgPath);
          if (bytes != null) images.add((image, bytes));
        }

        await writer.write(entry, images);

        processedLogs++;
        updateStatus("(1/2) ${((processedLogs / totalLogs) * 100).round()}%");
      }

      // Zip export folder
      await ZipUtils.compress(
          join(tempDir.path, exportedZipName), [], [tempExportFolder.path],
          onProgress: (percent) {
        updateStatus("(2/2) ${percent.round()}%");
      });

      // Save archive
      updateStatus(localizations.tranferStatus("0"));
      await exportFolder.copyFileInto(
          join(tempDir.path, exportedZipName), exportedZipName,
          mimeType: "application/zip", onProgress: (percent) {
        updateStatus(localizations.tranferStatus("${percent.round()}"));
      });
    } catch (error) {
      outcome = OperationOutcome.failed(error);
    }

    // Delete temp files
    updateStatus(localizations.cleanUpStatus);
    await File(join(tempDir.path, exportedZipName)).delete();
    if (await tempExportFolder.exists()) {
      await tempExportFolder.delete(recursive: true);
    }

    return outcome;
  }
}

class MarkdownExportWriter {
  MarkdownExportWriter(
      {required this.noteStore,
      required this.imageStore,
      required this.locale});

  final FileStore noteStore;
  final FileStore imageStore;
  final String locale;

  final Map<String, int> _timestampCount = {};

  Future<void> write(Entry entry, List<(EntryImage, Uint8List)> images) async {
    final timestamp = DateFormat("yyyy-MM-dd", locale).format(entry.timeCreate);
    _timestampCount[timestamp] = (_timestampCount[timestamp] ?? 0) + 1;
    final index = _timestampCount[timestamp]!;
    final indexSuffix = index > 1 ? "_$index" : "";

    final noteBody = StringBuffer();
    for (final (image, bytes) in images) {
      final prettyName =
          "image_$timestamp${indexSuffix}_${image.imgRank}${extension(image.imgPath)}";
      noteBody.writeln('![](Images/$prettyName)');
      await imageStore.write(prettyName, bytes);
    }

    final moodText =
        entry.mood != null ? "${MoodIcon.getMoodIcon(entry.mood)} " : "";
    noteBody.writeln(
        "$moodText${DateFormat.yMMMEd(locale).format(entry.timeCreate)}\n${entry.text}");

    await noteStore.write(
        "log_$timestamp$indexSuffix.md", utf8.encode(noteBody.toString()));
  }
}
