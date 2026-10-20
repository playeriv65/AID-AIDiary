// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/utils/operation_outcome.dart';
import 'package:aid_diary/widgets/failure_dialog.dart';
import 'package:material_ui/material_ui.dart';

typedef StatusCallback = void Function(String status);

/// Runs [task] behind a modal dialog that shows the status it reports.
///
/// The dialog goes on the root navigator and is removed by its own route,
/// so it closes correctly from pages inside the tablet layout's nested
/// navigator and when the task opens dialogs of its own.
Future<T> runWithProgress<T>(BuildContext context,
    Future<T> Function(StatusCallback update) task) async {
  final status = ValueNotifier<String>('');
  final navigator = Navigator.of(context, rootNavigator: true);
  final route = DialogRoute<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) => PopScope(
      canPop: false,
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              ValueListenableBuilder<String>(
                valueListenable: status,
                builder: (context, message, child) =>
                    Text(message, textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  navigator.push(route);
  try {
    return await task((message) => status.value = message);
  } finally {
    if (route.isActive) navigator.removeRoute(route);
  }
}

/// [runWithProgress] for an operation that reports its outcome; a failure
/// is shown with [failureDescription].
Future<OperationOutcome> runOperation(BuildContext context,
    Future<OperationOutcome> Function(StatusCallback update) task,
    {required String failureDescription}) async {
  final outcome = await runWithProgress(context, task);
  if (outcome.failed && context.mounted) {
    await showFailureDialog(context,
        description: failureDescription, error: outcome.error);
  }
  return outcome;
}
