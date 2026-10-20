// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/models/image.dart';
import 'package:daily_you/time_manager.dart';
import 'package:daily_you/utils/entry_context_display.dart';
import 'package:daily_you/utils/entry_preview.dart';
import 'package:daily_you/widgets/entry_tag_icon_preview.dart';
import 'package:daily_you/widgets/local_image_loader.dart';
import 'package:daily_you/widgets/mood_icon.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

/// One entry in a day group: time, title, one-line preview, metadata icons
/// and a thumbnail.
class JournalEntryRow extends StatelessWidget {
  const JournalEntryRow({
    super.key,
    required this.entry,
    required this.images,
    required this.onTap,
    this.selected = false,
    this.hideImage = false,
    this.label,
  });

  final Entry entry;
  final List<EntryImage> images;
  final VoidCallback onTap;
  final bool selected;
  final bool hideImage;

  /// Replaces the time, e.g. "1 year ago" in a throwback list.
  final String? label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final preview = entryPreview(entry.text);
    final thumbnail = images.isNotEmpty && !hideImage ? images.first : null;
    final muted =
        theme.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant);
    final hasMood = MoodIcon.getMoodIcon(entry.mood).isNotEmpty;
    final location = entry.location;

    return Material(
      color: selected ? cs.secondaryContainer : Colors.transparent,
      child: InkWell(
        key: ValueKey('journal-entry-${entry.id}'),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        label ??
                            TimeManager.localizedTimeFormat(
                                    context, TimeManager.currentLocale(context))
                                .format(entry.timeCreate),
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    if (preview.title != null)
                      Text(preview.title!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium),
                    Text(
                        preview.snippet.isEmpty && preview.title == null
                            ? l10n.writeSomethingHint
                            : preview.snippet,
                        maxLines: preview.title == null ? 2 : 1,
                        overflow: TextOverflow.ellipsis,
                        style: muted),
                    if (hasMood || location != null || entry.id != null) ...[
                      const SizedBox(height: 6),
                      SizedBox(
                        height: 18,
                        child: Row(children: [
                          if (hasMood) ...[
                            MoodIcon(moodValue: entry.mood, size: 14),
                            const SizedBox(width: 6),
                          ],
                          if (location != null) ...[
                            Icon(Icons.place_rounded,
                                size: 14, color: cs.onSurfaceVariant),
                            const SizedBox(width: 2),
                            Flexible(
                              child: Text(location.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.labelSmall
                                      ?.copyWith(color: cs.onSurfaceVariant)),
                            ),
                            const SizedBox(width: 6),
                          ],
                          if (entry.weather != null) ...[
                            Icon(weatherIcon(entry.weather!.code),
                                size: 14, color: cs.onSurfaceVariant),
                            const SizedBox(width: 6),
                          ],
                          if (entry.activity != null) ...[
                            Icon(activityIcon(entry.activity!),
                                size: 14, color: cs.onSurfaceVariant),
                            const SizedBox(width: 6),
                          ],
                          Expanded(
                            child: Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: EntryTagIconPreview(
                                  entryId: entry.id, iconSize: 14, spacing: 4),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ]),
            ),
            if (thumbnail != null) ...[
              const SizedBox(width: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                    width: 84,
                    height: 84,
                    child: LocalImageLoader(
                        imagePath: thumbnail.imgPath, cacheSize: 250)),
              ),
            ],
          ]),
        ),
      ),
    );
  }
}

/// Entries of one day under a centred date line, in one rounded card.
class EntryDayGroup extends StatelessWidget {
  const EntryDayGroup({super.key, required this.day, required this.rows});

  final DateTime day;
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final weekday =
        DateFormat.E(TimeManager.currentLocale(context)).format(day);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text('${TimeManager.formatDate(day, context)} · $weekday',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall
                ?.copyWith(color: cs.onSurfaceVariant)),
      ),
      Card.filled(
        margin: EdgeInsets.zero,
        color: cs.surfaceContainer,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0)
              Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: cs.outlineVariant),
            rows[i],
          ],
        ]),
      ),
    ]);
  }
}

/// Consecutive entries grouped by calendar day, keeping their order.
/// Runs of entries on the same day, by [timeOf] (the entry date by default).
List<(DateTime, List<Entry>)> groupEntriesByDay(List<Entry> entries,
    {DateTime Function(Entry entry)? timeOf}) {
  final groups = <(DateTime, List<Entry>)>[];
  for (final entry in entries) {
    final time = timeOf?.call(entry) ?? entry.timeCreate;
    final day = DateTime(time.year, time.month, time.day);
    if (groups.isNotEmpty && groups.last.$1 == day) {
      groups.last.$2.add(entry);
    } else {
      groups.add((day, [entry]));
    }
  }
  return groups;
}
