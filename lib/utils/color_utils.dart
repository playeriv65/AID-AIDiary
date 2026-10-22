// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:material_ui/material_ui.dart';

Color contrastingTextColor(Color background) =>
    background.computeLuminance() > 0.5 ? Colors.black : Colors.white;

/// A color as `#RRGGBB`, the form actions and scripts use; opacity is dropped.
String colorToHex(int argb) =>
    '#${(argb & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';

/// The opaque color for `#RRGGBB`, or null when [text] is not that.
int? colorFromHex(String text) {
  if (!RegExp(r'^#[0-9a-fA-F]{6}$').hasMatch(text)) return null;
  return 0xFF000000 | int.parse(text.substring(1), radix: 16);
}
