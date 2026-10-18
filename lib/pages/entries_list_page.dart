// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:daily_you/layouts/fast_page_view_scroll_physics.dart';
import 'package:daily_you/layouts/adaptive_diary_shell.dart';
import 'package:daily_you/time_manager.dart';
import 'package:daily_you/utils/entry_preview.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/pages/entry_view_page.dart';
import 'package:daily_you/providers/entries_provider.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

class EntriesListPage extends StatefulWidget {
  final int index;
  final List<Entry> Function() getEntries;

  const EntriesListPage({
    super.key,
    required this.index,
    required this.getEntries,
  });

  @override
  State<EntriesListPage> createState() => _EntriesListPageState();
}

class _EntriesListPageState extends State<EntriesListPage> {
  late PageController _pageController;
  int? _selectedId;
  bool _wasSplit = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index);
    final entries = widget.getEntries();
    if (entries.isNotEmpty) {
      _selectedId = entries[widget.index.clamp(0, entries.length - 1)].id;
    }
  }

  static String _previewLine(String text) {
    final preview = entryPreview(text);
    return [preview.title, preview.snippet]
        .whereType<String>()
        .where((s) => s.isNotEmpty)
        .join(' · ');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<EntriesProvider>(context);
    final entries = widget.getEntries();

    if (entries.isEmpty) return Scaffold(appBar: AppBar());
    var selectedIndex = entries.indexWhere((e) => e.id == _selectedId);
    if (selectedIndex < 0) selectedIndex = 0;
    final selected = entries[selectedIndex];
    return LayoutBuilder(builder: (context, constraints) {
      final split = diarySupportsSplit(constraints.biggest);
      if (!split && _wasSplit) {
        _pageController.dispose();
        _pageController = PageController(initialPage: selectedIndex);
      }
      _wasSplit = split;
      if (split) {
        return Row(key: const ValueKey('diary-entries-split'), children: [
          SizedBox(
              width: (constraints.maxWidth * .3).clamp(220.0, 300.0),
              child: Material(
                  child: ListView.builder(
                      key: const PageStorageKey('diary-entry-list'),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: entries.length,
                      itemBuilder: (context, index) {
                        final entry = entries[index];
                        return ListTile(
                          key: ValueKey('diary-entry-row-${entry.id}'),
                          selected: entry.id == selected.id,
                          selectedTileColor:
                              Theme.of(context).colorScheme.secondaryContainer,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          title: Text(TimeManager.formatDateWithWeekday(
                              entry.timeCreate, context)),
                          subtitle: entry.text.isEmpty
                              ? null
                              : Text(_previewLine(entry.text),
                                  maxLines: 2, overflow: TextOverflow.ellipsis),
                          onTap: () => setState(() => _selectedId = entry.id),
                        );
                      }))),
          const VerticalDivider(width: 1),
          Expanded(
              child: SelectionArea(
                  child: EntryViewPage(
                      key: ValueKey(selected.id),
                      entryId: selected.id!,
                      onEntryEdited: (id) {
                        if (mounted) setState(() => _selectedId = id);
                      }))),
        ]);
      }
      // SelectionArea above the pager lets swipe gestures keep working.
      return SelectionArea(
        child: PageView.builder(
            hitTestBehavior: HitTestBehavior.translucent,
            controller: _pageController,
            physics: FastPageViewScrollPhysics(),
            reverse: true,
            itemCount: entries.length,
            onPageChanged: (index) => _selectedId = entries[index].id,
            itemBuilder: (context, index) {
              return EntryViewPage(
                key: ValueKey(entries[index].id),
                entryId: entries[index].id!,
                onEntryEdited: (editedEntryId) {
                  final updatedEntries = widget.getEntries();
                  final newIndex =
                      updatedEntries.indexWhere((e) => e.id == editedEntryId);
                  if (newIndex != -1 && mounted) {
                    _selectedId = editedEntryId;
                    if (_pageController.hasClients) {
                      _pageController.jumpToPage(newIndex);
                    }
                  }
                },
              );
            }),
      );
    });
  }
}
