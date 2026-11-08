// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:typed_data';

import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/widgets/snack_message.dart';
import 'package:file_picker/file_picker.dart';
import 'package:material_ui/material_ui.dart';

/// Saves [bytes] as a new file that the user names and places in the
/// system's save dialog, suggesting [fileName], and says in a snack bar
/// that it was saved or could not be. Returns whether it was saved; false
/// also when the user cancelled.
Future<bool> saveToFile(BuildContext context, Uint8List bytes,
    {required String fileName,
    String mimeType = 'application/octet-stream'}) async {
  final l10n = AppLocalizations.of(context)!;
  final saved = await runWithFailureSnack(
      context,
      () => FilePicker.saveFile(
          fileName: fileName, bytes: bytes, mimeType: mimeType),
      failure: l10n.exportErrorDescription);
  if (saved == null) return false;
  if (context.mounted) showSnackMessage(context, l10n.fileSaved);
  return true;
}
