// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:material_ui/material_ui.dart';

/// Says [message] in a snack bar: a note, or a failure the user can simply
/// try again. A failure the user has to act on goes to `showFailureDialog`
/// (or `runOperation`) instead; see docs/ARCHITECTURE.md, "Reporting
/// failures". [action] offers one step that follows from it; [leading] (the
/// coach's avatar) says who is speaking.
///
/// Every message goes away on its own. Flutter keeps a snack bar with an
/// action until it is tapped; a message with an action instead stays a
/// little longer, to leave time to reach the action.
void showSnackMessage(BuildContext context, String message,
    {SnackBarAction? action, Widget? leading}) {
  if (!context.mounted) return;
  final text = Text(message);
  ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(
    content: leading == null
        ? text
        : Row(children: [
            leading,
            const SizedBox(width: 16),
            Expanded(child: text),
          ]),
    action: action,
    persist: false,
    duration: action == null ? snackMessageDuration : snackActionDuration,
  ));
}

/// How long a message stays on screen.
const snackMessageDuration = Duration(seconds: 4);

/// How long a message with an action stays on screen.
const snackActionDuration = Duration(seconds: 8);

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
