// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:material_ui/material_ui.dart';

/// Says [message] in a snack bar: a note, or a failure the user can simply
/// try again. A failure the user has to act on goes to `showFailureDialog`
/// (or `runOperation`) instead; see docs/ARCHITECTURE.md, "Reporting
/// failures". [action] offers one step that follows from it.
void showSnackMessage(BuildContext context, String message,
    {SnackBarAction? action}) {
  if (!context.mounted) return;
  ScaffoldMessenger.maybeOf(context)
      ?.showSnackBar(SnackBar(content: Text(message), action: action));
}

/// Runs [task]; when it throws, says [failure] with [showSnackMessage] and
/// returns null.
Future<T?> runWithFailureSnack<T>(
    BuildContext context, Future<T> Function() task,
    {required String failure}) async {
  try {
    return await task();
  } catch (_) {
    if (context.mounted) showSnackMessage(context, failure);
    return null;
  }
}
