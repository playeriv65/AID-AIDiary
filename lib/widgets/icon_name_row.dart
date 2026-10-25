// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/models/tag_icon_type.dart';
import 'package:aid_diary/widgets/tag_icon_glyph.dart';
import 'package:material_ui/material_ui.dart';

/// The top of the tag and category editors: the icon, which opens the icon
/// picker and has a cross to take it off, beside the name.
class IconNameRow extends StatelessWidget {
  const IconNameRow({
    super.key,
    required this.icon,
    required this.iconType,
    required this.fallbackIcon,
    required this.color,
    required this.onPickIcon,
    required this.onClearIcon,
    required this.nameController,
    required this.nameHint,
    this.nameError,
    this.autofocus = false,
    this.onSubmitted,
  });

  final String? icon;
  final TagIconType iconType;
  final IconData fallbackIcon;
  final Color color;
  final VoidCallback onPickIcon;
  final VoidCallback onClearIcon;
  final TextEditingController nameController;
  final String nameHint;
  final String? nameError;
  final bool autofocus;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final fill = Theme.of(context).colorScheme.surfaceContainerHighest;
    final hasIcon = icon != null && icon!.isNotEmpty;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Card.filled(
                  margin: EdgeInsets.zero,
                  color: fill,
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    key: const ValueKey('icon-pick'),
                    onTap: onPickIcon,
                    child: Center(
                      child: TagIconGlyph(
                        icon: icon,
                        iconType: iconType,
                        fallbackIcon: fallbackIcon,
                        color: color,
                        size: 28,
                      ),
                    ),
                  ),
                ),
                if (hasIcon)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      key: const ValueKey('icon-clear'),
                      visualDensity: VisualDensity.compact,
                      iconSize: 14,
                      tooltip:
                          MaterialLocalizations.of(context).deleteButtonTooltip,
                      onPressed: onClearIcon,
                      icon: const Icon(Icons.close),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Card.filled(
              margin: EdgeInsets.zero,
              color: fill,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: nameController,
                  autofocus: autofocus,
                  maxLines: 1,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    hintText: nameHint,
                    errorText: nameError,
                    border: InputBorder.none,
                  ),
                  onSubmitted: onSubmitted,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
