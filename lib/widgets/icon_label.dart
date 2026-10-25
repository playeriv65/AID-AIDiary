// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:material_ui/material_ui.dart';

/// A fact about an entry as it is shown everywhere: a small icon, or a
/// [glyph] with colors of its own such as a weather icon, then a muted
/// label cut to one line.
class IconLabel extends StatelessWidget {
  const IconLabel({
    super.key,
    this.icon,
    this.glyph,
    required this.label,
    this.size = 16,
    this.color,
  }) : assert(icon != null || glyph != null);

  final IconData? icon;
  final Widget? glyph;
  final String label;
  final double size;

  /// The icon's and label's color; the muted surface text by default.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shade = color ?? theme.colorScheme.onSurfaceVariant;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      glyph ?? Icon(icon, size: size, color: shade),
      const SizedBox(width: 3),
      Flexible(
        child: Text(label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(color: shade)),
      ),
    ]);
  }
}
