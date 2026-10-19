// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:flutter/widgets.dart';

/// Sizes of the editor action bar, docked full width along the bottom edge.
@immutable
class DockMetrics {
  const DockMetrics._();

  static const instance = DockMetrics._();

  static const double screenMargin = 16.0;
  static const double toggleGap = 8.0;
  static const double itemSpacing = 4.0;

  double get buttonSize => 40.0;
  double get pillPadding => 4.0;
  double get toggleSize => 40.0;
  double get sideMargin => 0.0;
  double get topMargin => 8.0;
  double get contentInset => 4.0;
  double get barHeight => buttonSize + pillPadding * 2;

  static DockMetrics of(BuildContext context) => instance;

  static double reservedHeight(BuildContext context) =>
      instance.barHeight +
      instance.topMargin +
      MediaQuery.paddingOf(context).bottom;
}
