// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';
import 'dart:typed_data';

import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/storage/storage_picker.dart';
import 'package:aid_diary/utils/imports/import_helpers.dart';
import 'package:aid_diary/utils/operation_outcome.dart';
import 'package:aid_diary/utils/zip_utils.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// The files of an import: a zip's contents, or a single picked file.
abstract interface class ArchiveFiles {
  /// Paths relative to the archive root, separated by `/`.
  List<String> get paths;

  Future<Uint8List?> read(String path);
}

class _DirectoryFiles implements ArchiveFiles {
  _DirectoryFiles(this.root, this.paths);

  final String root;

  @override
  final List<String> paths;

  @override
  Future<Uint8List?> read(String path) async {
    final file = File(p.joinAll([root, ...path.split('/')]));
    return await file.exists() ? file.readAsBytes() : null;
  }
}

/// Lets the user pick a zip, or a single file named [singleFileName] in the
/// archive, decodes it with [decode] and adds the entries. Photos are read
/// while the extracted files still exist.
Future<OperationOutcome> importArchive(
    BuildContext context,
    Function(String) updateStatus,
    Future<List<ImportedEntry>> Function(ArchiveFiles files) decode,
    {required String singleFileName}) async {
  final localizations = AppLocalizations.of(context)!;
  updateStatus("0%");

  final selectedFile = await StoragePicker.pickFile();
  if (selectedFile == null) return const OperationOutcome.cancelled();

  var outcome = const OperationOutcome.succeeded();
  final work = await (await getTemporaryDirectory()).createTemp('import');
  final picked = p.join(work.path, 'picked');
  final extracted = Directory(p.join(work.path, 'files'));

  try {
    updateStatus(localizations.tranferStatus("0"));
    await selectedFile.copyInto(work.path, 'picked', onProgress: (percent) {
      updateStatus(localizations.tranferStatus("${percent.round()}"));
    });

    await extracted.create();
    if (await _isZip(picked)) {
      await ZipUtils.extract(picked, extracted.path);
    } else {
      await File(picked).rename(p.join(extracted.path, singleFileName));
    }
    final paths = [
      await for (final file in extracted.list(recursive: true))
        if (file is File)
          p.split(p.relative(file.path, from: extracted.path)).join('/'),
    ]..sort();

    final entries = await decode(_DirectoryFiles(extracted.path, paths));
    await addImportedEntries(entries, updateStatus);
  } catch (error) {
    outcome = OperationOutcome.failed(error);
  }

  updateStatus(localizations.cleanUpStatus);
  outcome = await finishImport(updateStatus, outcome);
  if (await work.exists()) await work.delete(recursive: true);
  return outcome;
}

Future<bool> _isZip(String path) async {
  final file = await File(path).open();
  try {
    final magic = await file.read(4);
    return magic.length == 4 &&
        magic[0] == 0x50 &&
        magic[1] == 0x4b &&
        magic[2] == 0x03 &&
        magic[3] == 0x04;
  } finally {
    await file.close();
  }
}
