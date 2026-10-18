// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/models/image.dart';
import 'package:daily_you/time_manager.dart';
import 'package:daily_you/utils/entry_preview.dart';
import 'package:daily_you/widgets/entry_tag_icon_preview.dart';
import 'package:daily_you/widgets/local_image_loader.dart';
import 'package:daily_you/widgets/mood_icon.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:word_count/word_count.dart';

/// A journal row: date column, title and preview, metadata, thumbnail.
///
/// Consecutive rows from one day pass [showDate] false so the day reads as a
/// single block on the timeline.
class EntryTimelineTile extends StatelessWidget {
  const EntryTimelineTile({
    super.key,
    required this.entry,
    required this.images,
    required this.onTap,
    this.showDate = true,
    this.hideImage = false,
    this.isFirst = false,
    this.isLast = false,
    this.background,
  });

  final Entry entry;
  final List<EntryImage> images;
  final VoidCallback onTap;
  final bool showDate;
  final bool hideImage;
  final bool isFirst;
  final bool isLast;

  /// Surface the tile sits on; it masks the axis behind the date.
  final Color? background;

  static const double dateColumnWidth = 56;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final locale = TimeManager.currentLocale(context);
    final isToday = TimeManager.isToday(entry.timeCreate);
    final preview = entryPreview(entry.text);
    final words = wordsCount(entry.text);
    final thumbnail = images.isNotEmpty && !hideImage ? images.first : null;
    final metaStyle =
        theme.textTheme.labelMedium?.copyWith(color: cs.onSurfaceVariant);

    final dateColumn = SizedBox(
      width: dateColumnWidth,
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: showDate
            // The opaque backing hides the axis behind the date.
            ? ColoredBox(
                color: background ?? cs.surface,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Column(children: [
                    Text(
                      TimeManager.isJalaliCalendar(context)
                          ? '${TimeManager.jalaliDayNumber(entry.timeCreate)}'
                          : '${entry.timeCreate.day}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.1,
                          color: isToday ? cs.primary : cs.onSurface),
                    ),
                    Text(DateFormat.E(locale).format(entry.timeCreate),
                        style: theme.textTheme.labelSmall?.copyWith(
                            color: isToday ? cs.primary : cs.onSurfaceVariant)),
                  ]),
                ),
              )
            : Center(
                heightFactor: 1,
                child: Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 6),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: cs.outlineVariant)),
              ),
      ),
    );

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (preview.title != null)
          Text(preview.title!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
        if (preview.snippet.isNotEmpty || preview.title == null)
          Padding(
            padding: EdgeInsets.only(top: preview.title != null ? 2 : 0),
            child: Text(
              preview.snippet.isEmpty
                  ? l10n.writeSomethingHint
                  : preview.snippet,
              maxLines: preview.title != null ? 2 : 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: preview.snippet.isEmpty
                      ? cs.outline
                      : cs.onSurfaceVariant,
                  height: 1.4),
            ),
          ),
        const SizedBox(height: 8),
        Row(children: [
          Text(
              TimeManager.localizedTimeFormat(context, locale)
                  .format(entry.timeCreate),
              style: metaStyle),
          if (MoodIcon.getMoodIcon(entry.mood).isNotEmpty) ...[
            const SizedBox(width: 8),
            MoodIcon(moodValue: entry.mood, size: 14),
          ],
          if (words > 0) ...[
            _dot(cs),
            Flexible(
                child: Text(l10n.wordCount(words),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: metaStyle)),
          ],
          if (images.length > 1) ...[
            _dot(cs),
            Icon(Icons.photo_library_outlined,
                size: 14, color: cs.onSurfaceVariant),
            const SizedBox(width: 2),
            Text('${images.length}', style: metaStyle),
          ],
          const SizedBox(width: 8),
          Expanded(
              child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: EntryTagIconPreview(
                      entryId: entry.id, iconSize: 14, spacing: 4))),
        ]),
      ],
    );

    return InkWell(
      key: ValueKey('journal-entry-${entry.id}'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Stack(children: [
        PositionedDirectional(
          start: dateColumnWidth / 2 - 1,
          top: isFirst ? 16 : 0,
          bottom: isLast ? null : 0,
          height: isLast ? (isFirst ? 0 : 24) : null,
          width: 2,
          child: ColoredBox(color: cs.outlineVariant),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            dateColumn,
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(4, 12, 12, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: body),
                    if (thumbnail != null) ...[
                      const SizedBox(width: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                            width: 72,
                            height: 72,
                            child: LocalImageLoader(
                                imagePath: thumbnail.imgPath, cacheSize: 200)),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }

  Widget _dot(ColorScheme cs) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Container(
          width: 3,
          height: 3,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: cs.outline)));
}
