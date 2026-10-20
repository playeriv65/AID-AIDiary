// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/layouts/fast_page_view_scroll_physics.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/pages/entry_view_page.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

/// Swipes through [getEntries] starting at [index]; the arrows step too.
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
  late final PageController _pageController =
      PageController(initialPage: widget.index);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _go(int page) => _pageController.animateToPage(page,
      duration: const Duration(milliseconds: 250), curve: Curves.easeOut);

  @override
  Widget build(BuildContext context) {
    context.watch<EntriesProvider>();
    final entries = widget.getEntries();
    if (entries.isEmpty) return Scaffold(appBar: AppBar());
    return PageView.builder(
      controller: _pageController,
      physics: const FastPageViewScrollPhysics(),
      itemCount: entries.length,
      itemBuilder: (context, index) => EntryViewPage(
        key: ValueKey(entries[index].id),
        entryId: entries[index].id!,
        onPrevious: index > 0 ? () => _go(index - 1) : null,
        onNext: index < entries.length - 1 ? () => _go(index + 1) : null,
        onEntryEdited: (editedId) {
          final newIndex =
              widget.getEntries().indexWhere((e) => e.id == editedId);
          if (newIndex >= 0 && _pageController.hasClients) {
            _pageController.jumpToPage(newIndex);
          }
        },
      ),
    );
  }
}
