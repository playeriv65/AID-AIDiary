// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/pages/entry_view_page.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/utils/entry_context_display.dart';
import 'package:aid_diary/utils/entry_navigation.dart';
import 'package:aid_diary/widgets/journal_entry_row.dart';
import 'package:aid_diary/widgets/list_detail_layout.dart';
import 'package:aid_diary/widgets/mood_icon.dart';
import 'package:aid_diary/widgets/tag_icon_glyph.dart';
import 'package:aid_diary/utils/tag_visuals.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

/// Text search with inline tag, starred, activity and mood filters.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  final Set<int> _tagIds = {};
  bool _starred = false;
  final Set<EntryActivity> _activities = {};
  final Set<int> _moods = {};
  int? _selectedId;

  bool get _active =>
      _controller.text.trim().isNotEmpty ||
      _tagIds.isNotEmpty ||
      _starred ||
      _activities.isNotEmpty ||
      _moods.isNotEmpty;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Entry> _results() {
    final tags = TagsProvider.instance;
    final query = _controller.text.trim().toLowerCase();
    return EntriesProvider.instance.entries.where((entry) {
      if (entry.isSealed) return false;
      if (query.isNotEmpty &&
          !entry.text.toLowerCase().contains(query) &&
          !(entry.location?.name?.toLowerCase().contains(query) ?? false)) {
        return false;
      }
      if (_starred && !tags.isFavorite(entry.id!)) return false;
      if (_moods.isNotEmpty && !_moods.contains(entry.mood)) return false;
      if (_activities.isNotEmpty && !_activities.contains(entry.activity)) {
        return false;
      }
      if (_tagIds.isNotEmpty &&
          !tags
              .getEntryTagsForEntry(entry.id!)
              .any((t) => _tagIds.contains(t.tagId))) {
        return false;
      }
      return true;
    }).toList();
  }

  void _clear() => setState(() {
        _controller.clear();
        _tagIds.clear();
        _starred = false;
        _activities.clear();
        _moods.clear();
      });

  void _toggle<T>(Set<T> set, T value, bool? on) =>
      setState(() => on == true ? set.add(value) : set.remove(value));

  void _open(Entry entry, bool split) {
    if (split) {
      setState(() => _selectedId = entry.id);
    } else {
      EntryNavigation.view(context, entry, entries: _results);
    }
  }

  Widget? _detail(List<Entry> results) {
    final index = results.indexWhere((e) => e.id == _selectedId);
    if (index < 0) return null;
    return EntryViewPage(
      key: ValueKey('search-detail-$_selectedId'),
      entryId: _selectedId!,
      embedded: true,
      onPrevious: index > 0
          ? () => setState(() => _selectedId = results[index - 1].id)
          : null,
      onNext: index < results.length - 1
          ? () => setState(() => _selectedId = results[index + 1].id)
          : null,
      onEntryEdited: (id) => setState(() => _selectedId = id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    context.watch<EntriesProvider>();
    final tags = context.watch<TagsProvider>();
    final results = _active ? _results() : const <Entry>[];
    final favoriteId = tags.favoriteTag?.id;
    final tagOptions = tags.tags.where((t) => t.id != favoriteId).toList();

    // The search bar heads the list pane; on wide screens the detail pane
    // beside it shows the picked result, as on the journal.
    return Scaffold(
      body: SafeArea(
        child: ListDetailLayout(
          detail: _detail(results),
          listBuilder: (context, split) => Column(children: [
            SizedBox(
              height: kToolbarHeight,
              child: Row(children: [
                const SizedBox(width: 4),
                const BackButton(),
                Expanded(
                  child: TextField(
                    key: const ValueKey('search-field'),
                    controller: _controller,
                    autofocus: true,
                    style: theme.textTheme.titleMedium,
                    decoration: InputDecoration(
                        hintText: l10n.searchLogsHint,
                        border: InputBorder.none),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                if (_active)
                  IconButton(
                    key: const ValueKey('search-clear'),
                    tooltip:
                        MaterialLocalizations.of(context).clearButtonTooltip,
                    icon: const Icon(Icons.close_rounded),
                    onPressed: _clear,
                  ),
                const SizedBox(width: 4),
              ]),
            ),
            const Divider(height: 1),
            Expanded(child: _list(context, split, results, tagOptions)),
          ]),
        ),
      ),
    );
  }

  Widget _list(BuildContext context, bool split, List<Entry> results,
      List<Tag> tagOptions) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final images = context.watch<EntryImagesProvider>();
    return ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          SectionLabel(l10n.searchFilters),
          _FilterSection(
            key: const ValueKey('search-filter-tags'),
            icon: Icons.local_offer_outlined,
            title: l10n.searchFilterTags,
            options: tagOptions.length,
            selected: _tagIds.length,
            children: [
              for (final tag in tagOptions)
                CheckboxListTile(
                  key: ValueKey('search-tag-${tag.id}'),
                  secondary: TagIconGlyph(
                      icon: tag.icon,
                      iconType: tag.iconType,
                      fallbackIcon: tag.typeIcon,
                      color: tag.resolvedColor(context,
                          fallback: theme.colorScheme.secondary),
                      size: 20),
                  title: Text(tag.name),
                  value: _tagIds.contains(tag.id),
                  onChanged: (on) => _toggle(_tagIds, tag.id!, on),
                ),
            ],
          ),
          CheckboxListTile(
            key: const ValueKey('search-filter-starred'),
            secondary: const Icon(Icons.star_outline_rounded),
            title: Text(l10n.searchFilterStarred),
            value: _starred,
            onChanged: (value) => setState(() => _starred = value ?? false),
          ),
          // Activities are no longer recorded; imported entries may have one.
          if (EntriesProvider.instance.entries.any((e) => e.activity != null))
            _FilterSection(
              key: const ValueKey('search-filter-activity'),
              icon: Icons.directions_walk_rounded,
              title: l10n.activityTitle,
              options: EntryActivity.values.length,
              selected: _activities.length,
              children: [
                for (final activity in EntryActivity.values)
                  CheckboxListTile(
                    key: ValueKey('search-activity-${activity.name}'),
                    secondary: Icon(activityIcon(activity)),
                    title: Text(activityLabel(activity, l10n)),
                    value: _activities.contains(activity),
                    onChanged: (on) => _toggle(_activities, activity, on),
                  ),
              ],
            ),
          _FilterSection(
            key: const ValueKey('search-filter-mood'),
            icon: Icons.mood_rounded,
            title: l10n.tagMoodTitle,
            options: 5,
            selected: _moods.length,
            children: [
              for (final mood in const [2, 1, 0, -1, -2])
                CheckboxListTile(
                  key: ValueKey('search-mood-$mood'),
                  secondary: MoodIcon(moodValue: mood, size: 22),
                  title: Text(_moodName(mood, l10n)),
                  value: _moods.contains(mood),
                  onChanged: (on) => _toggle(_moods, mood, on),
                ),
            ],
          ),
          if (_active) ...[
            const SizedBox(height: 8),
            SectionLabel(l10n.logCount(results.length)),
            if (results.isEmpty)
              EmptyState(icon: Icons.search_off_rounded, title: l10n.noResults)
            else
              for (final (day, dayEntries) in groupEntriesByDay(results))
                EntryDayGroup(day: day, rows: [
                  for (final entry in dayEntries)
                    JournalEntryRow(
                      entry: entry,
                      images: images.getForEntry(entry),
                      selected: split && entry.id == _selectedId,
                      onTap: () => _open(entry, split),
                    ),
                ]),
          ] else
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text(l10n.searchHint,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.colorScheme.outline)),
            ),
        ]);
  }
}

String _moodName(int mood, AppLocalizations l10n) => switch (mood) {
      2 => l10n.moodGreat,
      1 => l10n.moodGood,
      0 => l10n.moodOkay,
      -1 => l10n.moodBad,
      _ => l10n.moodAwful,
    };

/// A filter that expands its options inline. The trailing number is how
/// many options it has, or how many are picked once some are.
class _FilterSection extends StatelessWidget {
  const _FilterSection({
    super.key,
    required this.icon,
    required this.title,
    required this.options,
    required this.selected,
    required this.children,
  });

  final IconData icon;
  final String title;
  final int options;
  final int selected;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ExpansionTile(
      leading: Icon(icon),
      title: Text(title),
      shape: const Border(),
      collapsedShape: const Border(),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        if (selected > 0)
          Badge(
              label: Text('$selected'),
              backgroundColor: cs.primary,
              textColor: cs.onPrimary)
        else
          Text('$options', style: TextStyle(color: cs.outline)),
        const SizedBox(width: 4),
        const Icon(Icons.expand_more_rounded),
      ]),
      children: children,
    );
  }
}
