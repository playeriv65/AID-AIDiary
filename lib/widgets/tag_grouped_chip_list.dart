// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/models/tag_category.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/utils/tag_category_visuals.dart';
import 'package:aid_diary/widgets/tag_icon_glyph.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

/// Renders a list of [TagSection]s as grouped chip rows.
class TagGroupedChipList extends StatelessWidget {
  final List<TagSection> sections;

  /// Builds the chip widget for each tag. The caller controls tap/remove behavior.
  final Widget Function(Tag) chipBuilder;

  /// When given, a long press lifts a chip, and dropping it on another tag
  /// puts it in that tag's place.
  final void Function(Tag moved, Tag target)? onMove;

  const TagGroupedChipList({
    super.key,
    required this.sections,
    required this.chipBuilder,
    this.onMove,
  });

  Widget _movable(BuildContext context, Tag tag) {
    final chip = chipBuilder(tag);
    final onMove = this.onMove;
    if (onMove == null) return chip;
    return DragTarget<Tag>(
      key: ValueKey('tag-move-${tag.id}'),
      onWillAcceptWithDetails: (details) {
        if (details.data.id == tag.id) return false;
        HapticFeedback.selectionClick();
        return true;
      },
      onAcceptWithDetails: (details) => onMove(details.data, tag),
      builder: (context, candidates, _) => LongPressDraggable<Tag>(
        data: tag,
        onDragStarted: HapticFeedback.mediumImpact,
        feedback: Material(
          type: MaterialType.transparency,
          child: Transform.scale(scale: 1.1, child: chip),
        ),
        childWhenDragging: Opacity(opacity: 0.3, child: chip),
        child: DecoratedBox(
          // Where the lifted tag will land.
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              if (candidates.isNotEmpty)
                BoxShadow(
                    color: Theme.of(context).colorScheme.primary,
                    spreadRadius: 2),
            ],
          ),
          child: chip,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (sections.isEmpty) return const SizedBox.shrink();

    final items = <Widget>[];
    for (final section in sections) {
      if (section.category != null) {
        items.add(_PickerSectionHeader(category: section.category!));
      }
      items.add(Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [for (final tag in section.tags) _movable(context, tag)],
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items,
    );
  }
}

class _PickerSectionHeader extends StatelessWidget {
  final TagCategory category;
  const _PickerSectionHeader({required this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Row(
        children: [
          TagIconGlyph(
            icon: category.icon,
            iconType: category.iconType,
            fallbackIcon: Icons.folder_rounded,
            color: category.resolvedColor(context),
            size: 16,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              category.name,
              overflow: TextOverflow.fade,
              softWrap: false,
              maxLines: 1,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
