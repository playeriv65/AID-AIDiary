// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/utils/tag_visuals.dart';
import 'package:aid_diary/widgets/tag_icon_glyph.dart';
import 'package:material_ui/material_ui.dart';

class TagChip extends StatelessWidget {
  final Tag tag;
  final String? value;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  /// Filled with the tag's colour, as a picked tag shows where it is.
  final bool selected;

  const TagChip(
      {super.key,
      required this.tag,
      this.value,
      this.onTap,
      this.onRemove,
      this.selected = false});

  Widget _buildTrackerValueBox(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: value != null
          ? Text(value!,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                  height: 1.0))
          : Icon(Icons.numbers_rounded,
              size: 12, color: colorScheme.onSurface.withValues(alpha: 0.6)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = tag.resolvedColor(context,
        fallback: Theme.of(context).colorScheme.secondary);
    final onColor =
        ThemeData.estimateBrightnessForColor(color) == Brightness.dark
            ? Colors.white
            : Colors.black;
    final screenWidth = MediaQuery.sizeOf(context).width;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : screenWidth - 32;
        final shape = BorderRadius.circular(16);
        // A tappable chip is a button, with a ripple, focus and its state
        // read out.
        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Semantics(
            button: onTap != null,
            selected: selected,
            child: Material(
              type: MaterialType.transparency,
              child: Ink(
                decoration: BoxDecoration(
                  border: Border.all(color: color, width: 1.5),
                  borderRadius: shape,
                  color: selected ? color : color.withValues(alpha: 0.12),
                ),
                child: InkWell(
                  onTap: onTap,
                  borderRadius: shape,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TagIconGlyph(
                          icon: tag.icon,
                          iconType: tag.iconType,
                          fallbackIcon: tag.typeIcon,
                          color: selected ? onColor : color,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            tag.name,
                            style: TextStyle(
                                fontSize: 13, color: selected ? onColor : null),
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                        if (tag.tagType == TagType.tracker) ...[
                          const SizedBox(width: 6),
                          _buildTrackerValueBox(context),
                        ] else if (value != null) ...[
                          const SizedBox(width: 4),
                          Text(value!,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: selected ? onColor : null)),
                        ],
                        if (onRemove != null) ...[
                          const SizedBox(width: 4),
                          Semantics(
                            button: true,
                            label: MaterialLocalizations.of(context)
                                .deleteButtonTooltip,
                            child: InkResponse(
                              onTap: onRemove,
                              radius: 14,
                              child: Icon(Icons.close,
                                  size: 14,
                                  color: selected
                                      ? onColor
                                      : Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
