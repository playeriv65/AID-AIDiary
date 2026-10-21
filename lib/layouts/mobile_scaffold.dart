// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/layouts/adaptive_diary_shell.dart';
import 'package:aid_diary/pages/atlas_page.dart';
import 'package:aid_diary/pages/calendar_page.dart';
import 'package:aid_diary/pages/coach_page.dart';
import 'package:aid_diary/pages/journal_page.dart';
import 'package:aid_diary/pages/media_page.dart';
import 'package:aid_diary/routing/entry_navigation.dart';
import 'package:material_ui/material_ui.dart';

class MobileScaffold extends StatefulWidget {
  const MobileScaffold({super.key});
  @override
  State<MobileScaffold> createState() => _MobileScaffoldState();
}

class _MobileScaffoldState extends State<MobileScaffold> {
  static const _coachIndex = 4;

  int currentIndex = 0;
  final _navigatorKey = GlobalKey<NavigatorState>();

  /// Pages are built on first visit, so the map loads no tiles until opened.
  final Set<int> _visited = {0};

  static const _pages = [
    JournalPage(),
    CalendarPage(),
    MediaPage(),
    AtlasPage(),
    CoachPage(),
  ];

  void _switchPage(int index) {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      currentIndex = index;
      _visited.add(index);
    });
  }

  void _newEntry() {
    final context = _navigatorKey.currentContext;
    if (context != null) EntryNavigation.edit(context, null);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AdaptiveDiaryShell(
      navigatorKey: _navigatorKey,
      selectedIndex: currentIndex,
      destinations: [
        DiaryDestination(l10n.pageJournalTitle, Icons.auto_stories_outlined,
            Icons.auto_stories_rounded),
        DiaryDestination(l10n.pageCalendarTitle, Icons.calendar_today_outlined,
            Icons.calendar_today_rounded),
        DiaryDestination(
            l10n.pageMediaTitle, Icons.photo_outlined, Icons.photo_rounded),
        DiaryDestination(
            l10n.pageAtlasTitle, Icons.map_outlined, Icons.map_rounded),
        DiaryDestination(l10n.pageCoachTitle, Icons.favorite_border_rounded,
            Icons.favorite_rounded),
      ],
      onDestinationSelected: _switchPage,
      newEntryLabel: l10n.adaptiveNewEntry,
      onNewEntry: _newEntry,
      home: Builder(builder: (context) {
        final compact =
            diaryLayoutFor(MediaQuery.sizeOf(context)) == DiaryLayout.compact;
        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: IndexedStack(
              index: currentIndex,
              children: [
                for (var i = 0; i < _pages.length; i++)
                  _visited.contains(i) ? _pages[i] : const SizedBox.shrink(),
              ],
            ),
          ),
          floatingActionButton: compact && currentIndex != _coachIndex
              ? FloatingActionButton.extended(
                  key: const ValueKey('diary-new-entry'),
                  heroTag: 'diary-new-entry',
                  onPressed: () => EntryNavigation.edit(context, null),
                  icon: const Icon(Icons.add_rounded),
                  label: Text(l10n.adaptiveNewEntry),
                )
              : null,
        );
      }),
    );
  }
}
