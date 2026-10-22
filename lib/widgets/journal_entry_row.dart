// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/sync/sync_service.dart';
import 'package:aid_diary/time_manager.dart';
import 'package:aid_diary/utils/entry_context_display.dart';
import 'package:aid_diary/utils/entry_preview.dart';
import 'package:aid_diary/widgets/entry_tag_icon_preview.dart';
import 'package:aid_diary/widgets/local_image_loader.dart';
import 'package:aid_diary/widgets/mood_icon.dart';
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
    final sealed = entry.isSealed;
    final thumbnail =
        images.isNotEmpty && !hideImage && !sealed ? images.first : null;
    final muted =
        theme.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant);
    final preview = entryPreview(entry.text);
    final snippetLines = preview.title == null ? 2 : 1;
    final hasMood = MoodIcon.getMoodIcon(entry.mood).isNotEmpty;
    final location = entry.location;

    // One semantics node per row: a screen reader reads the entry as one
    // item, and the list has a node per row to move as it scrolls rather
    // than one per text and icon. Flutter keeps semantics up whenever any
    // accessibility service runs, such as an auto clicker.
    return MergeSemantics(
      child: ColoredBox(
        color: selected ? cs.secondaryContainer : Colors.transparent,
        // Ink paints on this transparent Material, above the selection.
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            key: ValueKey('journal-entry-${entry.id}'),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Text(
                              label ??
                                  TimeManager.localizedTimeFormat(context,
                                          TimeManager.currentLocale(context))
                                      .format(entry.timeCreate),
                              style: theme.textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w700)),
                          if (label == null && entry.isLateNight) ...[
                            const SizedBox(width: 4),
                            Tooltip(
                              message: l10n.lateNightBadge,
                              child: Icon(Icons.bedtime_outlined,
                                  key: const ValueKey('late-night'),
                                  size: 14,
                                  color: cs.onSurfaceVariant),
                            ),
                          ],
                          // Only entries that did not sync are marked.
                          if (entry.id case final id?)
                            ListenableBuilder(
                              listenable: SyncService.instance,
                              builder: (context, _) => SyncService
                                      .instance.unsyncedEntryIds
                                      .contains(id)
                                  ? Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          start: 4),
                                      child: Tooltip(
                                        message: l10n.syncEntryUnsynced,
                                        child: Icon(Icons.cloud_off_rounded,
                                            key: ValueKey('unsynced-$id'),
                                            size: 14,
                                            color: cs.error),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                        ]),
                        const SizedBox(height: 4),
                        // A sealed capsule shows nothing of what is inside.
                        if (sealed)
                          Row(children: [
                            Icon(Icons.lock_clock_rounded,
                                size: 16, color: cs.primary),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                  l10n.capsuleOpensOn(TimeManager.formatDate(
                                      entry.openAt!, context)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: muted),
                            ),
                          ])
                        else ...[
                          if (preview.title != null)
                            Text(preview.title!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600)),
                          // Text is shaped in full before it is cut to its
                          // lines, and that is most of what a row costs as
                          // it scrolls in: lay out only what its lines can
                          // hold of the narrowest letters (about half the
                          // font size wide each).
                          LayoutBuilder(builder: (context, constraints) {
                            final letter = MediaQuery.textScalerOf(context)
                                    .scale(muted?.fontSize ?? 14) /
                                2;
                            return Text(
                                preview.snippet.isEmpty && preview.title == null
                                    ? l10n.writeSomethingHint
                                    : cutSnippet(
                                        preview.snippet,
                                        (constraints.maxWidth /
                                                letter *
                                                snippetLines)
                                            .ceil()),
                                maxLines: snippetLines,
                                overflow: TextOverflow.ellipsis,
                                style: muted);
                          }),
                          if (hasMood ||
                              location != null ||
                              entry.id != null) ...[
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
                                            ?.copyWith(
                                                color: cs.onSurfaceVariant)),
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
                                        entryId: entry.id,
                                        iconSize: 14,
                                        spacing: 4),
                                  ),
                                ),
                              ]),
                            ),
                          ],
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
    final last = groups.lastOrNull?.$1;
    final time = timeOf?.call(entry);
    final sameDay = time == null
        ? last == entry.day
        : last != null &&
            last.year == time.year &&
            last.month == time.month &&
            last.day == time.day;
    if (sameDay) {
      groups.last.$2.add(entry);
    } else {
      groups.add((
        time == null ? entry.day : DateTime(time.year, time.month, time.day),
        [entry]
      ));
    }
  }
  return groups;
}
