// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/storage/storage_picker.dart';
import 'package:aid_diary/utils/formats/day_one_format.dart';
import 'package:aid_diary/utils/formats/journey_format.dart';
import 'package:aid_diary/utils/imports/import_archive.dart';
import 'package:aid_diary/utils/imports/import_daybook.dart' as daybook;
import 'package:aid_diary/utils/imports/import_daylio.dart' as daylio;
import 'package:aid_diary/utils/imports/import_diarium.dart' as diarium;
import 'package:aid_diary/utils/imports/import_diaro.dart' as diaro;
import 'package:aid_diary/utils/imports/import_format.dart';
import 'package:aid_diary/utils/imports/import_json.dart' as json;
import 'package:aid_diary/utils/imports/import_mybrain.dart' as mybrain;
import 'package:aid_diary/utils/imports/import_oneshot.dart' as oneshot;
import 'package:aid_diary/utils/imports/import_pixels.dart' as pixels;
import 'package:aid_diary/utils/operation_outcome.dart';

export 'package:aid_diary/utils/imports/import_format.dart';

/// Reads the picked [file], adds what is new in it to the diary and reports
/// its progress as [localizations] words it.
typedef ImportRunner = Future<OperationOutcome> Function(PickedFile file,
    AppLocalizations localizations, Function(String) updateStatus);

class ImportFormatOption {
  const ImportFormatOption(this.format, this.name, ImportRunner run,
      {this.extensions, this.mimeTypes})
      : _run = run;

  final ImportFormat format;
  final String Function(AppLocalizations localizations) name;
  final ImportRunner _run;

  /// Adds the entries of [file] that the diary does not have yet. Importers
  /// skip entries already there, so they wait for all of them to load.
  Future<OperationOutcome> run(PickedFile file, AppLocalizations localizations,
      Function(String) updateStatus) async {
    await EntriesProvider.instance.complete;
    return _run(file, localizations, updateStatus);
  }

  /// What the file picker offers; any file when null.
  final List<String>? extensions;
  final List<String>? mimeTypes;
}

const _jsonExtensions = ['json'];
const _jsonMimeTypes = ['application/json'];

class ImportRegistry {
  const ImportRegistry(this.options);

  static final ImportRegistry instance = ImportRegistry([
    ImportFormatOption(
      ImportFormat.json,
      (localizations) => localizations.formatJsonExport,
      (file, localizations, updateStatus) =>
          json.importFromJson(file, updateStatus),
      extensions: _jsonExtensions,
      mimeTypes: _jsonMimeTypes,
    ),
    ImportFormatOption(
      ImportFormat.dayOne,
      (localizations) => localizations.formatDayOne,
      (file, localizations, updateStatus) => importArchive(
          file, localizations, updateStatus, decodeDayOneArchive,
          singleFileName: 'Journal.json'),
    ),
    ImportFormatOption(
      ImportFormat.daybook,
      (localizations) => localizations.formatDaybook,
      daybook.importFromDaybook,
    ),
    ImportFormatOption(
      ImportFormat.daylio,
      (localizations) => localizations.formatDaylio,
      daylio.importFromDaylio,
    ),
    ImportFormatOption(
      ImportFormat.diarium,
      (localizations) => localizations.formatDiarium,
      diarium.importFromDiarium,
    ),
    ImportFormatOption(
      ImportFormat.diaro,
      (localizations) => localizations.formatDiaro,
      (file, localizations, updateStatus) => importArchive(
          file, localizations, updateStatus, diaro.decodeDiaroArchive,
          singleFileName: 'DiaroBackup.xml'),
    ),
    ImportFormatOption(
      ImportFormat.journey,
      (localizations) => localizations.formatJourney,
      (file, localizations, updateStatus) => importArchive(
          file, localizations, updateStatus, decodeJourneyArchive,
          singleFileName: 'entry.json'),
    ),
    ImportFormatOption(
      ImportFormat.myBrain,
      (localizations) => localizations.formatMyBrain,
      (file, localizations, updateStatus) =>
          mybrain.importFromMyBrain(file, updateStatus),
      extensions: _jsonExtensions,
      mimeTypes: _jsonMimeTypes,
    ),
    ImportFormatOption(
      ImportFormat.oneShot,
      (localizations) => localizations.formatOneShot,
      (file, localizations, updateStatus) =>
          oneshot.importFromOneShot(file, updateStatus),
      extensions: _jsonExtensions,
      mimeTypes: _jsonMimeTypes,
    ),
    ImportFormatOption(
      ImportFormat.pixels,
      (localizations) => localizations.formatPixels,
      (file, localizations, updateStatus) =>
          pixels.importFromPixels(file, updateStatus),
      extensions: _jsonExtensions,
      mimeTypes: _jsonMimeTypes,
    ),
  ]);

  final List<ImportFormatOption> options;

  ImportFormatOption optionFor(ImportFormat format) =>
      options.firstWhere((option) => option.format == format);
}
