// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/widgets/haptics.dart';
import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/layouts/adaptive_diary_shell.dart';
import 'package:aid_diary/pages/atlas_page.dart';
import 'package:aid_diary/pages/calendar_page.dart';
import 'package:aid_diary/pages/coach_page.dart';
import 'package:aid_diary/pages/journal_page.dart';
import 'package:aid_diary/pages/media_page.dart';
import 'package:aid_diary/routing/app_navigation.dart';
import 'package:aid_diary/widgets/command_palette.dart';
import 'package:flutter/services.dart';
import 'package:aid_diary/routing/entry_navigation.dart';
import 'package:material_ui/material_ui.dart';

class MobileScaffold extends StatefulWidget {
  const MobileScaffold({super.key});
  @override
  State<MobileScaffold> createState() => _MobileScaffoldState();
}

class _MobileScaffoldState extends State<MobileScaffold>
    implements ActionScreen {
  static const _coachIndex = 4;
  static const _tabs = ['journal', 'calendar', 'media', 'atlas', 'coach'];

  int currentIndex = 0;
  final _navigatorKey = GlobalKey<NavigatorState>();
  final _routes = _RouteNames();

  @override
  void initState() {
    super.initState();
    AppActions.instance.screen = this;
  }

  @override
  void dispose() {
    if (AppActions.instance.screen == this) AppActions.instance.screen = null;
    super.dispose();
  }

  @override
  String get current => _routes.top ?? _tabs[currentIndex];

  @override
  List<String> get destinations => [..._tabs, ...AppNavigation.byName.keys];

  @override
  Future<void> navigate(String destination) async {
    final navigator = _navigatorKey.currentState;
    if (navigator == null) return;
    // Back to the tabs the way a person would, so an editor still asks
    // about unsaved changes.
    while (navigator.canPop()) {
      final before = _routes.depth;
      if (!await navigator.maybePop() || _routes.depth == before) break;
    }
    if (!mounted || navigator.canPop()) return;
    final tab = _tabs.indexOf(destination);
    if (tab >= 0) return _switchPage(tab);
    await AppNavigation.byName[destination]!(navigator);
  }

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
    if (index != currentIndex) Haptics.selection();
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

  void _openCommands() {
    final context = _navigatorKey.currentContext;
    if (context != null) showCommandPalette(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyK, control: true):
            _openCommands,
      },
      child: _shell(context, l10n),
    );
  }

  Widget _shell(BuildContext context, AppLocalizations l10n) {
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
      observers: [_routes],
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

/// The names of the routes open above the tabs, for `ui.screen`.
class _RouteNames extends NavigatorObserver {
  final List<Route<dynamic>> _routes = [];

  int get depth => _routes.length;

  /// The top route's name, or null when only the tabs are showing.
  String? get top =>
      _routes.length > 1 ? _routes.last.settings.name ?? 'page' : null;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _routes.add(route);

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _routes.remove(route);

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _routes.remove(route);

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    final index = oldRoute == null ? -1 : _routes.indexOf(oldRoute);
    if (index >= 0 && newRoute != null) _routes[index] = newRoute;
  }
}
