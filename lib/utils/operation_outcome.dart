// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

enum OperationStatus { succeeded, cancelled, failed }

class OperationOutcome {
  const OperationOutcome.succeeded({this.output})
      : status = OperationStatus.succeeded,
        error = null;

  const OperationOutcome.cancelled()
      : status = OperationStatus.cancelled,
        error = null,
        output = null;

  const OperationOutcome.failed([this.error])
      : status = OperationStatus.failed,
        output = null;

  final OperationStatus status;
  final Object? error;

  /// What the operation made, such as the name of a file it wrote.
  final String? output;

  bool get succeeded => status == OperationStatus.succeeded;
  bool get failed => status == OperationStatus.failed;
}
