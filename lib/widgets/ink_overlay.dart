// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:material_ui/material_ui.dart';

/// Makes [child], which paints its own surface (a photo, a card, a map
/// marker), a button: the ripple shows on top of it, within [shape], and
/// it gets focus and a button's semantics.
class InkOverlay extends StatelessWidget {
  const InkOverlay({
    super.key,
    required this.child,
    required this.onTap,
    this.shape,
    this.label,
  });

  final Widget child;
  final VoidCallback? onTap;
  final ShapeBorder? shape;

  /// What the button does, when [child] says nothing readable itself.
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Stack(children: [
        child,
        Positioned.fill(
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(customBorder: shape, onTap: onTap),
          ),
        ),
      ]),
    );
  }
}
