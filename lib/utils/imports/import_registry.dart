// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/l10n/generated/app_localizations.dart';
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
import 'package:flutter/widgets.dart';

export 'package:aid_diary/utils/imports/import_format.dart';

typedef ImportRunner = Future<OperationOutcome> Function(
    BuildContext context, Function(String) updateStatus);

class ImportFormatOption {
  const ImportFormatOption(this.format, this.name, this.run);

  final ImportFormat format;
  final String Function(AppLocalizations localizations) name;
  final ImportRunner run;
}

class ImportRegistry {
  const ImportRegistry(this.options);

  static final ImportRegistry instance = ImportRegistry([
    ImportFormatOption(
      ImportFormat.json,
      (localizations) => localizations.formatJsonExport,
      (context, updateStatus) => json.importFromJson(updateStatus),
    ),
    ImportFormatOption(
      ImportFormat.dayOne,
      (localizations) => localizations.formatDayOne,
      (context, updateStatus) => importArchive(
          context, updateStatus, decodeDayOneArchive,
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
      (context, updateStatus) => importArchive(
          context, updateStatus, diaro.decodeDiaroArchive,
          singleFileName: 'DiaroBackup.xml'),
    ),
    ImportFormatOption(
      ImportFormat.journey,
      (localizations) => localizations.formatJourney,
      (context, updateStatus) => importArchive(
          context, updateStatus, decodeJourneyArchive,
          singleFileName: 'entry.json'),
    ),
    ImportFormatOption(
      ImportFormat.myBrain,
      (localizations) => localizations.formatMyBrain,
      (context, updateStatus) => mybrain.importFromMyBrain(updateStatus),
    ),
    ImportFormatOption(
      ImportFormat.oneShot,
      (localizations) => localizations.formatOneShot,
      (context, updateStatus) => oneshot.importFromOneShot(updateStatus),
    ),
    ImportFormatOption(
      ImportFormat.pixels,
      (localizations) => localizations.formatPixels,
      (context, updateStatus) => pixels.importFromPixels(updateStatus),
    ),
  ]);

  final List<ImportFormatOption> options;

  ImportFormatOption optionFor(ImportFormat format) =>
      options.firstWhere((option) => option.format == format);
}
