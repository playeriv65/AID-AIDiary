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
class TagGroupedChipList extends StatefulWidget {
  final List<TagSection> sections;

  /// Builds the chip widget for each tag. The caller controls tap/remove behavior.
  final Widget Function(Tag) chipBuilder;

  /// When given, a long press lifts a chip. Held over another tag it takes
  /// that tag's place and the tags after it move along, as it will be once
  /// dropped; dropping it there calls this with the tag whose place it took.
  final void Function(Tag moved, Tag target)? onMove;

  const TagGroupedChipList({
    super.key,
    required this.sections,
    required this.chipBuilder,
    this.onMove,
  });

  @override
  State<TagGroupedChipList> createState() => _TagGroupedChipListState();
}

class _TagGroupedChipListState extends State<TagGroupedChipList> {
  /// The lifted tag, and the tag whose place it is shown in.
  Tag? _lifted;
  Tag? _over;

  /// The sections as they will be once [_lifted] is dropped on [_over].
  List<TagSection> get _shown {
    final lifted = _lifted;
    final over = _over;
    if (lifted == null || over == null) return widget.sections;
    final original = [for (final section in widget.sections) ...section.tags];
    // Moving forward it goes after the tag, so that tag takes its place.
    final forward = lifted.categoryId == over.categoryId &&
        original.indexWhere((tag) => tag.id == lifted.id) <
            original.indexWhere((tag) => tag.id == over.id);
    return [
      for (final section in widget.sections)
        TagSection(category: section.category, tags: [
          for (final tag in section.tags)
            if (tag.id == over.id) ...[
              if (forward) tag,
              lifted,
              if (!forward) tag,
            ] else if (tag.id != lifted.id)
              tag,
        ]),
    ];
  }

  void _drop() {
    final lifted = _lifted;
    final over = _over;
    setState(() => _lifted = _over = null);
    if (lifted != null && over != null) widget.onMove!(lifted, over);
  }

  Widget _movable(Tag tag) {
    final chip = widget.chipBuilder(tag);
    if (widget.onMove == null) return chip;
    final isLifted = tag.id == _lifted?.id;
    return DragTarget<Tag>(
      key: ValueKey('tag-move-${tag.id}'),
      onWillAcceptWithDetails: (details) {
        if (details.data.id != tag.id && _over?.id != tag.id) {
          HapticFeedback.selectionClick();
          setState(() => _over = tag);
        }
        return true;
      },
      onAcceptWithDetails: (_) => _drop(),
      builder: (context, candidates, _) => LongPressDraggable<Tag>(
        data: tag,
        onDragStarted: () {
          HapticFeedback.mediumImpact();
          setState(() => _lifted = tag);
        },
        // Let go anywhere else: everything goes back.
        onDraggableCanceled: (_, __) => setState(() => _lifted = _over = null),
        feedback: Material(
          type: MaterialType.transparency,
          child: Transform.scale(scale: 1.1, child: chip),
        ),
        childWhenDragging: Opacity(opacity: 0.3, child: chip),
        // Where it will land shows as the faded chip.
        child: isLifted ? Opacity(opacity: 0.3, child: chip) : chip,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sections = _shown;
    if (sections.isEmpty) return const SizedBox.shrink();

    final items = <Widget>[];
    for (final section in sections) {
      if (section.category != null) {
        items.add(_PickerSectionHeader(category: section.category!));
      }
      items.add(Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [for (final tag in section.tags) _movable(tag)],
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
