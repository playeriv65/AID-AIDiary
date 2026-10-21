// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aid_diary/utils/diary_day.dart';
import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/storage/file_store.dart';
import 'package:aid_diary/storage/local_file_store.dart';
import 'package:aid_diary/storage/storage_picker.dart';
import 'package:aid_diary/time_manager.dart';
import 'package:aid_diary/utils/formats/archive_export.dart';
import 'package:aid_diary/utils/formats/day_one_format.dart';
import 'package:aid_diary/utils/formats/journey_format.dart';
import 'package:aid_diary/utils/operation_outcome.dart';
import 'package:aid_diary/utils/zip_utils.dart';
import 'package:aid_diary/utils/mood_emoji.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

typedef ExportRunner = Future<OperationOutcome> Function(
    BuildContext context, Function(String) updateStatus);

enum ExportFormat { markdown, json, journey, dayOne }

class ExportFormatOption {
  const ExportFormatOption(this.format, this.name, this.run);

  final ExportFormat format;
  final String Function(AppLocalizations localizations) name;
  final ExportRunner run;
}

/// The formats entries can be exported to, in the order they are offered.
class ExportRegistry {
  const ExportRegistry(this.options);

  static final ExportRegistry instance = ExportRegistry([
    ExportFormatOption(
      ExportFormat.markdown,
      (localizations) => localizations.formatMarkdown,
      (context, updateStatus) {
        final locale = TimeManager.currentLocale(context);
        return ExportUtils.exportArchive(context, updateStatus,
            name: 'markdown',
            writer: (folder) => MarkdownExportWriter(
                noteStore: LocalFileStore(folder),
                imageStore: LocalFileStore(join(folder, 'Images')),
                locale: locale));
      },
    ),
    ExportFormatOption(
      ExportFormat.json,
      (localizations) => localizations.formatJson,
      (context, updateStatus) => ExportUtils.exportToJson(updateStatus),
    ),
    ExportFormatOption(
      ExportFormat.journey,
      (localizations) => localizations.formatJourney,
      (context, updateStatus) => ExportUtils.exportArchive(
          context, updateStatus,
          name: 'journey',
          writer: (folder) => JourneyExportWriter(LocalFileStore(folder))),
    ),
    ExportFormatOption(
      ExportFormat.dayOne,
      (localizations) => localizations.formatDayOne,
      (context, updateStatus) => ExportUtils.exportArchive(
          context, updateStatus,
          name: 'day_one',
          writer: (folder) => DayOneExportWriter(
              journalStore: LocalFileStore(folder),
              photoStore: LocalFileStore(join(folder, dayOnePhotoFolder)))),
    ),
  ]);

  final List<ExportFormatOption> options;

  ExportFormatOption optionFor(ExportFormat format) =>
      options.firstWhere((option) => option.format == format);
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
        // Wall-clock time where it was written, and that place's offset.
        'timeCreated': entry.timeCreate.toIso8601String(),
        if (entry.utcOffset case final offset?) 'utcOffsetMinutes': offset,
        // The day the entry belongs to, chosen apart from when it was written.
        'diaryDate': DiaryDay.format(entry.day),
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
        if (entry.openAt case final openAt?) 'openAt': openAt.toIso8601String(),
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
  static String _stamp() =>
      DateTime.now().toIso8601String().replaceAll(':', '-');

  /// An entry's tags by name, the favorite star included.
  static List<({String name, String? value})> _tagsOf(Entry entry) {
    final tags = TagsProvider.instance;
    return [
      for (final entryTag in tags.getEntryTagsForEntry(entry.id!))
        if (tags.tags.where((tag) => tag.id == entryTag.tagId).firstOrNull
            case final tag?)
          (name: tag.name, value: entryTag.value),
    ];
  }

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

    final json = encodeJsonEntries(
      EntriesProvider.instance.entries,
      imagesOf: EntryImagesProvider.instance.getForEntry,
      tagsOf: _tagsOf,
    );
    final name = "aid_diary_${_stamp()}.json";
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

  /// Writes every entry with its tags and images through the writer made
  /// for a temporary folder, zips the folder and saves the zip as
  /// `aid_diary_<name>_export_<time>.zip` in a folder the user picks.
  static Future<OperationOutcome> exportArchive(
      BuildContext context, Function(String) updateStatus,
      {required String name,
      required ArchiveExportWriter Function(String folder) writer}) async {
    final localizations = AppLocalizations.of(context)!;
    updateStatus("(1/2) 0%");

    PickedDirectory? exportFolder;
    try {
      exportFolder = await StoragePicker.pickDirectory();
    } catch (error) {
      return OperationOutcome.failed(error);
    }
    if (exportFolder == null) return const OperationOutcome.cancelled();

    var outcome = const OperationOutcome.succeeded();
    final work = await (await getTemporaryDirectory()).createTemp('export');
    final folder = Directory(join(work.path, name));
    final zipName = "aid_diary_${name}_export_${_stamp()}.zip";
    final zipPath = join(work.path, zipName);

    try {
      await folder.create();
      final output = writer(folder.path);
      final favoriteId = TagsProvider.instance.favoriteTag?.id;
      final favoriteName = TagsProvider.instance.favoriteTag?.name;
      final entries = EntriesProvider.instance.entries;
      for (final (index, entry) in entries.indexed) {
        final images = <(EntryImage, Uint8List)>[];
        for (final image in EntryImagesProvider.instance.getForEntry(entry)) {
          final bytes = await ImageStorage.instance.getBytes(image.imgPath);
          if (bytes != null) images.add((image, bytes));
        }
        final tags = _tagsOf(entry);
        await output.write(ExportedEntry(entry,
            tags: [
              for (final tag in tags)
                if (tag.name != favoriteName) tag
            ],
            favorite: favoriteId != null &&
                TagsProvider.instance
                    .getEntryTagsForEntry(entry.id!)
                    .any((tag) => tag.tagId == favoriteId),
            images: images));
        updateStatus("(1/2) ${((index + 1) / entries.length * 100).round()}%");
      }
      await output.close();

      await ZipUtils.compress(zipPath, [], [folder.path],
          foldersAtRoot: true,
          onProgress: (percent) => updateStatus("(2/2) ${percent.round()}%"));

      updateStatus(localizations.tranferStatus("0"));
      await exportFolder.copyFileInto(zipPath, zipName,
          mimeType: "application/zip", onProgress: (percent) {
        updateStatus(localizations.tranferStatus("${percent.round()}"));
      });
    } catch (error) {
      outcome = OperationOutcome.failed(error);
    }

    updateStatus(localizations.cleanUpStatus);
    if (await work.exists()) await work.delete(recursive: true);
    return outcome;
  }
}

/// Writes each entry as a Markdown note named after its day, with its images
/// in a folder beside the notes.
class MarkdownExportWriter implements ArchiveExportWriter {
  MarkdownExportWriter(
      {required this.noteStore,
      required this.imageStore,
      required this.locale});

  final FileStore noteStore;
  final FileStore imageStore;
  final String locale;

  final Map<String, int> _timestampCount = {};

  @override
  Future<void> write(ExportedEntry exported) async {
    final entry = exported.entry;
    final timestamp = DateFormat("yyyy-MM-dd", locale).format(entry.day);
    _timestampCount[timestamp] = (_timestampCount[timestamp] ?? 0) + 1;
    final index = _timestampCount[timestamp]!;
    final indexSuffix = index > 1 ? "_$index" : "";

    final noteBody = StringBuffer();
    for (final (image, bytes) in exported.images) {
      final prettyName =
          "image_$timestamp${indexSuffix}_${image.imgRank}${extension(image.imgPath)}";
      noteBody.writeln('![](Images/$prettyName)');
      await imageStore.write(prettyName, bytes);
    }

    final moodText = entry.mood != null ? "${moodEmoji(entry.mood)} " : "";
    noteBody.writeln(
        "$moodText${DateFormat.yMMMEd(locale).format(entry.day)}\n${entry.text}");

    await noteStore.write(
        "log_$timestamp$indexSuffix.md", utf8.encode(noteBody.toString()));
  }

  @override
  Future<void> close() async {}
}
