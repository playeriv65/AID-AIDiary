// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/utils/tag_visuals.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

/// An entry's tags by name in one line, as many as fit and "+N" for the
/// rest, so a list shows them without opening the entry. The favorite tag
/// is a heart, as the star elsewhere stands for it.
class EntryTagNames extends StatelessWidget {
  const EntryTagNames({super.key, required this.entryId});

  final int? entryId;

  static const double _gap = 4;
  static const EdgeInsets _padding = EdgeInsets.symmetric(horizontal: 6);

  @override
  Widget build(BuildContext context) {
    final id = entryId;
    if (id == null) return const SizedBox.shrink();
    return Consumer<TagsProvider>(builder: (context, tags, _) {
      final attached = {
        for (final entryTag in tags.getEntryTagsForEntry(id)) entryTag.tagId
      };
      if (attached.isEmpty) return const SizedBox.shrink();
      final favoriteId = tags.favoriteTag?.id;
      final named = [
        for (final section in tags.buildSections('', tagPool: [
          for (final tag in tags.tags)
            if (attached.contains(tag.id) && tag.id != favoriteId) tag
        ]))
          ...section.tags,
      ];
      final theme = Theme.of(context);
      final style = theme.textTheme.labelSmall;
      final heart = attached.contains(favoriteId)
          ? Icon(Icons.favorite_rounded,
              size: 14,
              color: tags.favoriteTag!
                  .resolvedColor(context, fallback: theme.colorScheme.primary))
          : null;
      return LayoutBuilder(builder: (context, constraints) {
        final scaler = MediaQuery.textScalerOf(context);
        double widthOf(String text) =>
            (TextPainter(
                    text: TextSpan(text: text, style: style),
                    textScaler: scaler,
                    maxLines: 1,
                    textDirection: Directionality.of(context))
                  ..layout())
                .width +
            _padding.horizontal +
            _gap;
        var room = constraints.maxWidth - (heart == null ? 0 : 14 + _gap);
        final shown = <Tag>[];
        for (final (index, tag) in named.indexed) {
          final left = named.length - index - 1;
          final need = widthOf(tag.name) + (left == 0 ? 0 : widthOf('+$left'));
          if (need > room) break;
          shown.add(tag);
          room -= widthOf(tag.name);
        }
        final rest = named.length - shown.length;
        Widget pill(String text, Color color) => Container(
              padding: _padding,
              decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(8)),
              child:
                  Text(text, maxLines: 1, style: style?.copyWith(color: color)),
            );
        return Row(mainAxisSize: MainAxisSize.min, children: [
          if (heart != null) ...[heart, const SizedBox(width: _gap)],
          for (final tag in shown) ...[
            pill(
                tag.name,
                tag.resolvedColor(context,
                    fallback: theme.colorScheme.secondary)),
            const SizedBox(width: _gap),
          ],
          if (rest > 0) pill('+$rest', theme.colorScheme.onSurfaceVariant),
        ]);
      });
    });
  }
}
