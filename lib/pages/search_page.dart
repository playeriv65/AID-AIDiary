// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/providers/entries_provider.dart';
import 'package:daily_you/providers/entry_images_provider.dart';
import 'package:daily_you/providers/tags_provider.dart';
import 'package:daily_you/utils/entry_navigation.dart';
import 'package:daily_you/widgets/journal_entry_row.dart';
import 'package:daily_you/widgets/list_detail_layout.dart';
import 'package:daily_you/widgets/mood_icon.dart';
import 'package:daily_you/widgets/tag_picker_dialog.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

/// Text search with tag, starred and mood filters.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  List<int> _tagIds = [];
  TagFilterMode _tagMode = TagFilterMode.any;
  bool _noTags = false;
  bool _starred = false;
  final Set<int> _moods = {};

  bool get _active =>
      _controller.text.trim().isNotEmpty ||
      _tagIds.isNotEmpty ||
      _noTags ||
      _starred ||
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
      if (query.isNotEmpty &&
          !entry.text.toLowerCase().contains(query) &&
          !(entry.location?.name?.toLowerCase().contains(query) ?? false)) {
        return false;
      }
      if (_starred && !tags.isFavorite(entry.id!)) return false;
      if (_moods.isNotEmpty && !_moods.contains(entry.mood)) return false;
      final entryTagIds =
          tags.getEntryTagsForEntry(entry.id!).map((t) => t.tagId).toSet();
      if (_noTags && entryTagIds.isNotEmpty) return false;
      if (_tagIds.isNotEmpty) {
        final matches = _tagMode == TagFilterMode.all
            ? _tagIds.every(entryTagIds.contains)
            : _tagIds.any(entryTagIds.contains);
        if (!matches) return false;
      }
      return true;
    }).toList();
  }

  void _pickTags() {
    showDialog(
      context: context,
      builder: (_) => TagPickerDialog(
        mode: TagPickerMode.filter,
        initialSelectedTagIds: List.of(_tagIds),
        initialFilterMode: _tagMode,
        initialNoTagsOnly: _noTags,
        onFilterChanged: (ids, mode, noTags) => setState(() {
          _tagIds = ids;
          _tagMode = mode;
          _noTags = noTags;
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    context.watch<EntriesProvider>();
    final tags = context.watch<TagsProvider>();
    final images = context.watch<EntryImagesProvider>();
    final results = _active ? _results() : const <Entry>[];
    final starredCount = EntriesProvider.instance.entries
        .where((e) => tags.isFavorite(e.id!))
        .length;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          key: const ValueKey('search-field'),
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
              hintText: l10n.searchLogsHint, border: InputBorder.none),
          onChanged: (_) => setState(() {}),
        ),
        actions: [
          if (_active)
            IconButton(
              tooltip: MaterialLocalizations.of(context).clearButtonTooltip,
              icon: const Icon(Icons.close_rounded),
              onPressed: () => setState(() {
                _controller.clear();
                _tagIds = [];
                _noTags = false;
                _starred = false;
                _moods.clear();
              }),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          SectionLabel(l10n.searchFilters),
          ListTile(
            key: const ValueKey('search-filter-tags'),
            leading: const Icon(Icons.local_offer_outlined),
            title: Text(l10n.searchFilterTags),
            trailing: Text(_noTags ? '0' : '${_tagIds.length}'),
            onTap: _pickTags,
          ),
          SwitchListTile(
            key: const ValueKey('search-filter-starred'),
            secondary: const Icon(Icons.star_outline_rounded),
            title: Text(l10n.searchFilterStarred),
            subtitle: Text('$starredCount'),
            value: _starred,
            onChanged: (value) => setState(() => _starred = value),
          ),
          ListTile(
            leading: const Icon(Icons.mood_rounded),
            title: Text(l10n.tagMoodTitle),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Wrap(spacing: 8, children: [
                for (final mood in const [2, 1, 0, -1, -2])
                  FilterChip(
                    key: ValueKey('search-mood-$mood'),
                    label: MoodIcon(moodValue: mood, size: 18),
                    selected: _moods.contains(mood),
                    onSelected: (on) => setState(
                        () => on ? _moods.add(mood) : _moods.remove(mood)),
                  ),
              ]),
            ),
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
                      onTap: () => EntryNavigation.view(context, entry,
                          entries: _results),
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
        ],
      ),
    );
  }
}
