// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/widgets/tag_grouped_chip_list.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

class EntryTagChips extends StatelessWidget {
  final int entryId;
  final EdgeInsetsGeometry? padding;

  /// Builds the chip widget for each tag attached to the entry.
  final Widget Function(Tag tag, EntryTag entryTag) chipBuilder;

  const EntryTagChips({
    super.key,
    required this.entryId,
    required this.chipBuilder,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TagsProvider>(
      builder: (context, tagsProvider, _) {
        // The star in the app bar already shows the favourite tag.
        final favoriteId = tagsProvider.favoriteTag?.id;
        final entryTags = tagsProvider
            .getEntryTagsForEntry(entryId)
            .where((t) => t.tagId != favoriteId)
            .toList();
        if (entryTags.isEmpty) return const SizedBox.shrink();

        final entryTagByTagId = {
          for (final entryTag in entryTags) entryTag.tagId: entryTag
        };
        final tagPool = tagsProvider.tags
            .where((tag) => entryTagByTagId.containsKey(tag.id))
            .toList();
        final sections = tagsProvider.buildSections('', tagPool: tagPool);

        final chipList = TagGroupedChipList(
          sections: sections,
          chipBuilder: (tag) => chipBuilder(tag, entryTagByTagId[tag.id]!),
        );

        return padding == null
            ? chipList
            : Padding(padding: padding!, child: chipList);
      },
    );
  }
}
