// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:math' as math;

import 'package:aid_diary/widgets/icon_label.dart';
import 'package:aid_diary/providers/weather_provider.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/providers/links_provider.dart';
import 'package:aid_diary/sync/sync_service.dart';
import 'package:aid_diary/time_manager.dart';
import 'package:aid_diary/utils/entry_preview.dart';
import 'package:aid_diary/widgets/entry_tag_names.dart';
import 'package:aid_diary/widgets/local_image_loader.dart';
import 'package:aid_diary/widgets/mood_icon.dart';
import 'package:intl/intl.dart';
import 'package:aid_diary/widgets/weather_icon.dart';
import 'package:material_ui/material_ui.dart';

/// Predictable desktop preview slots let scrollbar jumps skip unseen days
/// without shaping and laying out thousands of intervening entry widgets.
class JournalListMetrics {
  const JournalListMetrics({
    required this.rowExtent,
    required this.headingExtent,
  });
  final double rowExtent;
  final double headingExtent;

  factory JournalListMetrics.of(BuildContext context) {
    final text = Theme.of(context).textTheme;
    double line(TextStyle? style) {
      final painter = TextPainter(
        text: TextSpan(text: 'Ag国', style: style),
        textDirection: Directionality.of(context),
        textScaler: MediaQuery.textScalerOf(context),
      )..layout();
      final height = painter.height;
      painter.dispose();
      return height;
    }

    // A card's top line holds its title or only its time; the day heading
    // is a small title.
    final top = math.max(line(text.titleMedium), line(text.labelMedium));
    final snippet = line(text.bodyMedium);
    final content = top + 4 + snippet * entryCardLines + 6 + 18;
    return JournalListMetrics(
      rowExtent: 28 + math.max(content, 84),
      headingExtent: line(text.titleSmall) + 24,
    );
  }

  double groupExtent(int rows) => headingExtent + rows * rowExtent + rows - 1;
}

/// How many lines of its text an entry card shows.
const entryCardLines = 3;

/// An entry as every list shows it: its title and when it was written on
/// top, three lines of its text, then mood, place, weather, whether it
/// answers another entry and its tags, with a thumbnail beside. A list
/// switches parts off rather than drawing an entry its own way.
class EntryCard extends StatelessWidget {
  const EntryCard({
    super.key,
    required this.entry,
    required this.onTap,
    this.images = const [],
    this.selected = false,
    this.hideImage = false,
    this.label,
    this.showDate = false,
    this.showDetails = true,
    this.highlight = '',
    this.trailing,
  });

  final Entry entry;
  final List<EntryImage> images;
  final VoidCallback onTap;
  final bool selected;
  final bool hideImage;

  /// Replaces the time, e.g. "1 year ago" in a throwback list.
  final String? label;

  /// The diary day goes before the time, for lists not grouped by day.
  final bool showDate;

  /// Mood, place, weather, citations and tags.
  final bool showDetails;

  /// Search words: the text shows from just before they appear, and they
  /// are marked wherever they do.
  final String highlight;

  /// An action at the end, such as restoring.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final sealed = entry.isSealed;
    final thumbnail =
        images.isNotEmpty && !hideImage && !sealed ? images.first : null;
    final muted = theme.textTheme.bodyMedium?.copyWith(
      color: cs.onSurfaceVariant,
    );
    final marked = TextStyle(
      backgroundColor: cs.tertiaryContainer,
      color: cs.onTertiaryContainer,
      fontWeight: FontWeight.w700,
    );
    final preview = entryPreview(entry, around: highlight);
    final time = TimeManager.localizedTimeFormat(
      context,
      TimeManager.currentLocale(context),
    ).format(entry.timeCreate);
    final timeText = label ??
        (showDate
            ? '${TimeManager.formatDate(entry.day, context)} $time'
            : time);
    final hasMood = MoodIcon.getMoodIcon(entry.mood).isNotEmpty;
    final location = entry.location;
    final lateNight = label == null && entry.isLateNight;
    final timeStyle = theme.textTheme.labelMedium?.copyWith(
      color: cs.onSurfaceVariant,
    );

    final when = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(timeText, style: timeStyle),
        if (lateNight) ...[
          const SizedBox(width: 4),
          Tooltip(
            message: l10n.lateNightBadge,
            child: Icon(
              Icons.bedtime_outlined,
              key: const ValueKey('late-night'),
              size: 14,
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
        // Only entries that did not sync are marked.
        if (entry.id case final id?)
          ListenableBuilder(
            listenable: SyncService.instance,
            builder: (context, _) =>
                SyncService.instance.unsyncedEntryIds.contains(id)
                    ? Padding(
                        padding: const EdgeInsetsDirectional.only(start: 4),
                        child: Tooltip(
                          message: l10n.syncEntryUnsynced,
                          child: Icon(
                            Icons.cloud_off_rounded,
                            key: ValueKey('unsynced-$id'),
                            size: 14,
                            color: cs.error,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
          ),
      ],
    );

    // Keep one readable semantics node per card, including its details.
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (!sealed && preview.title != null) ...[
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    children: highlightSpans(
                                      preview.title!,
                                      highlight,
                                      marked,
                                    ),
                                  ),
                                  key: const ValueKey('entry-card-title'),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              when,
                            ] else
                              Expanded(
                                child: Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: when,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // A sealed capsule shows nothing of what is inside.
                        if (sealed)
                          Row(
                            children: [
                              Icon(
                                Icons.lock_clock_rounded,
                                size: 16,
                                color: cs.primary,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  l10n.capsuleOpensOn(
                                    TimeManager.formatDate(
                                      entry.openAt!,
                                      context,
                                    ),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: muted,
                                ),
                              ),
                            ],
                          )
                        else ...[
                          // Text is shaped in full before it is cut to its
                          // lines, and that is most of what a card costs as
                          // it scrolls in: lay out only what its lines can
                          // hold of the narrowest letters (about half the
                          // font size wide each).
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final letter = MediaQuery.textScalerOf(context)
                                      .scale(muted?.fontSize ?? 14) /
                                  2;
                              final text = preview.snippet.isEmpty &&
                                      preview.title == null
                                  ? l10n.writeSomethingHint
                                  : cutSnippet(
                                      preview.snippet,
                                      (constraints.maxWidth /
                                              letter *
                                              entryCardLines)
                                          .ceil(),
                                    );
                              return Text.rich(
                                TextSpan(
                                  children: highlightSpans(
                                    text,
                                    highlight,
                                    marked,
                                  ),
                                ),
                                key: const ValueKey('entry-card-snippet'),
                                maxLines: entryCardLines,
                                overflow: TextOverflow.ellipsis,
                                style: muted,
                              );
                            },
                          ),
                          if (showDetails &&
                              (hasMood ||
                                  location != null ||
                                  entry.id != null)) ...[
                            const SizedBox(height: 6),
                            SizedBox(
                              height: 18,
                              child: Row(
                                children: [
                                  if (hasMood) ...[
                                    MoodIcon(moodValue: entry.mood, size: 14),
                                    const SizedBox(width: 6),
                                  ],
                                  if (location != null) ...[
                                    Flexible(
                                      child: IconLabel(
                                          icon: Icons.place_rounded,
                                          label: location.label,
                                          size: 14),
                                    ),
                                    const SizedBox(width: 6),
                                  ],
                                  ListenableBuilder(
                                    listenable: WeatherProvider.instance,
                                    builder: (context, _) => switch (
                                        WeatherProvider.instance
                                            .ofEntry(entry)) {
                                      final weather? => Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                            end: 6,
                                          ),
                                          child: WeatherIcon(
                                            weather.code,
                                            size: 14,
                                          ),
                                        ),
                                      null => const SizedBox.shrink(),
                                    },
                                  ),
                                  // It answers another entry: a comment.
                                  if (entry.id case final id?
                                      when LinksProvider.instance
                                          .refsOf(id)
                                          .isNotEmpty) ...[
                                    Icon(
                                      Icons.format_quote_rounded,
                                      key: ValueKey('journal-cites-$id'),
                                      size: 14,
                                      color: cs.primary,
                                    ),
                                    const SizedBox(width: 6),
                                  ],
                                  Expanded(
                                    child: Align(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: EntryTagNames(entryId: entry.id),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                  if (thumbnail != null) ...[
                    const SizedBox(width: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 84,
                        height: 84,
                        child: LocalImageLoader(
                          imagePath: thumbnail.imgPath,
                          cacheSize: 250,
                        ),
                      ),
                    ),
                  ],
                  if (trailing != null) ...[
                    const SizedBox(width: 8),
                    trailing!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// [text] as spans with each place [words] appear (ignoring case) in
/// [marked].
List<TextSpan> highlightSpans(String text, String words, TextStyle marked) {
  final needle = words.trim().toLowerCase();
  if (needle.isEmpty) return [TextSpan(text: text)];
  final haystack = text.toLowerCase();
  final spans = <TextSpan>[];
  var start = 0;
  for (var at = haystack.indexOf(needle);
      at != -1;
      at = haystack.indexOf(needle, start)) {
    if (at > start) spans.add(TextSpan(text: text.substring(start, at)));
    start = at + needle.length;
    spans.add(TextSpan(text: text.substring(at, start), style: marked));
  }
  if (start < text.length) spans.add(TextSpan(text: text.substring(start)));
  return spans;
}

/// Entries of one day under a centred date line, in one rounded card.
class EntryDayGroup extends StatelessWidget {
  const EntryDayGroup({
    super.key,
    required this.day,
    required this.rows,
    this.metrics,
  });

  final DateTime day;
  final List<Widget> rows;
  final JournalListMetrics? metrics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final weekday =
        DateFormat.E(TimeManager.currentLocale(context)).format(day);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: metrics?.headingExtent,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              '${TimeManager.formatDate(day, context)} · $weekday',
              maxLines: metrics == null ? null : 1,
              overflow: metrics == null ? null : TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
        ),
        Card.filled(
          margin: EdgeInsets.zero,
          color: cs.surfaceContainer,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              for (var i = 0; i < rows.length; i++) ...[
                if (i > 0)
                  Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: cs.outlineVariant,
                  ),
                SizedBox(height: metrics?.rowExtent, child: rows[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Consecutive entries grouped by calendar day, keeping their order.
/// Runs of entries on the same day, by [timeOf] (the entry date by default).
List<(DateTime, List<Entry>)> groupEntriesByDay(
  List<Entry> entries, {
  DateTime Function(Entry entry)? timeOf,
}) {
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
        [entry],
      ));
    }
  }
  return groups;
}
