// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/widgets/haptics.dart';
import 'package:material_ui/material_ui.dart';

/// Asks before doing something, the same way everywhere: [title], then
/// [message] or a [content] widget, Cancel on the left and [confirm] on the
/// right, red when it cannot be undone. True only when confirmed.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  String? message,
  Widget? content,
  required String confirm,
  bool destructive = false,
  Key? confirmKey,
}) async {
  if (destructive) Haptics.warning();
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      final colors = Theme.of(dialogContext).colorScheme;
      return AlertDialog(
        title: Text(title),
        content: content ?? (message == null ? null : Text(message)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child:
                Text(MaterialLocalizations.of(dialogContext).cancelButtonLabel),
          ),
          FilledButton(
            key: confirmKey,
            style: destructive
                ? FilledButton.styleFrom(
                    backgroundColor: colors.error,
                    foregroundColor: colors.onError)
                : null,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(confirm),
          ),
        ],
      );
    },
  );
  return confirmed ?? false;
}

/// [showConfirmDialog] for deleting what [message] names.
Future<bool> showDeleteConfirmDialog(BuildContext context,
        {required String message, Key? confirmKey}) =>
    showConfirmDialog(context,
        title: AppLocalizations.of(context)!.deleteTitle,
        message: message,
        confirm: MaterialLocalizations.of(context).deleteButtonTooltip,
        destructive: true,
        confirmKey: confirmKey);
