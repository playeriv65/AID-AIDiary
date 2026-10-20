// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/stats/entry_stats.dart';
import 'package:aid_diary/utils/entry_context_display.dart';
import 'package:aid_diary/utils/tag_visuals.dart';
import 'package:aid_diary/widgets/mood_icon.dart';
import 'package:aid_diary/widgets/tag_icon_glyph.dart';
import 'package:material_ui/material_ui.dart';

/// "What makes me feel…": the activities and tags most often seen with the
/// chosen mood.
class MoodAssociationsCard extends StatefulWidget {
  const MoodAssociationsCard({super.key, required this.entries});

  final List<Entry> entries;

  static const _shown = 5;

  @override
  State<MoodAssociationsCard> createState() => _MoodAssociationsCardState();
}

class _MoodAssociationsCardState extends State<MoodAssociationsCard> {
  int _mood = 2;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final tags = TagsProvider.instance;
    final tagById = {for (final tag in tags.tags) tag.id!: tag};
    final factors = moodAssociations<Object>(
      widget.entries,
      _mood,
      (entry) => [
        if (entry.activity case final activity?) activity,
        for (final entryTag in tags.getEntryTagsForEntry(entry.id!))
          if (tagById[entryTag.tagId] case final tag?) tag,
      ],
    ).take(MoodAssociationsCard._shown).toList();

    return Card.filled(
      key: const ValueKey('mood-associations'),
      color: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(l10n.moodAssociationsTitle,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children: [
                for (final mood in const [2, 1, 0, -1, -2])
                  ChoiceChip(
                    key: ValueKey('mood-associations-$mood'),
                    label: MoodIcon(moodValue: mood, size: 20),
                    showCheckmark: false,
                    selected: _mood == mood,
                    onSelected: (_) => setState(() => _mood = mood),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (factors.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(l10n.statisticsNotEnoughData,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.disabledColor)),
              )
            else
              for (final association in factors)
                _FactorRow(association: association),
          ],
        ),
      ),
    );
  }
}

class _FactorRow extends StatelessWidget {
  const _FactorRow({required this.association});

  final MoodAssociation<Object> association;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final (icon, name, color) = switch (association.factor) {
      final EntryActivity activity => (
          Icon(activityIcon(activity),
              size: 22, color: theme.colorScheme.primary),
          activityLabel(activity, l10n),
          theme.colorScheme.primary,
        ),
      final Tag tag => (
          TagIconGlyph(
              icon: tag.icon,
              iconType: tag.iconType,
              fallbackIcon: tag.typeIcon,
              color: tag.resolvedColor(context),
              size: 22),
          tag.name,
          tag.resolvedColor(context),
        ),
      _ => throw ArgumentError(association.factor),
    };
    final share = association.matching / association.total;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        SizedBox(width: 28, child: Center(child: icon)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                    child: Text(name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium)),
                Text('${(share * 100).round()}%',
                    style: theme.textTheme.labelLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ]),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: share,
                color: color,
                backgroundColor: color.withValues(alpha: .15),
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 2),
              Text(
                  l10n.moodAssociationsCount(
                      association.matching, association.total),
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: theme.colorScheme.outline)),
            ],
          ),
        ),
      ]),
    );
  }
}
