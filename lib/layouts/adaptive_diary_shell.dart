// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:material_ui/material_ui.dart';

enum DiaryLayout { compact, rail }

/// Phones get a bottom bar; anything wider gets a navigation rail.
DiaryLayout diaryLayoutFor(Size size) =>
    size.width < 600 ? DiaryLayout.compact : DiaryLayout.rail;

/// Whether a page has room for a list beside a detail pane.
bool diarySupportsSplit(Size contentSize) =>
    contentSize.width >= 700 && contentSize.height >= 280;

class DiaryDestination {
  const DiaryDestination(this.label, this.icon, this.selectedIcon);
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

/// All ordinary routes share one Navigator, stable through window resizing.
class AdaptiveDiaryShell extends StatefulWidget {
  const AdaptiveDiaryShell(
      {super.key,
      required this.navigatorKey,
      required this.home,
      required this.destinations,
      required this.selectedIndex,
      required this.onDestinationSelected,
      required this.newEntryLabel,
      required this.onNewEntry});
  final GlobalKey<NavigatorState> navigatorKey;
  final Widget home;
  final List<DiaryDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final String newEntryLabel;

  /// Opens the editor; the rail shows it as its leading button.
  final VoidCallback onNewEntry;

  @override
  State<AdaptiveDiaryShell> createState() => _AdaptiveDiaryShellState();
}

class _AdaptiveDiaryShellState extends State<AdaptiveDiaryShell> {
  late final _ContentRouteObserver _observer;
  bool _hasContentRoute = false;
  bool _navigating = false;

  Future<bool> _returnHome() async {
    final navigator = widget.navigatorKey.currentState;
    while (mounted && navigator != null && navigator.canPop()) {
      final before = _observer.currentRoute;
      if (!await navigator.maybePop()) return false;
      if (_observer.currentRoute == before) return false;
    }
    return mounted;
  }

  Future<void> _select(int index) async {
    if (_navigating) return;
    _navigating = true;
    try {
      if (await _returnHome()) widget.onDestinationSelected(index);
    } finally {
      _navigating = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _observer = _ContentRouteObserver((hasRoute) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _hasContentRoute != hasRoute) {
          setState(() => _hasContentRoute = hasRoute);
        }
      });
    });
  }

  Widget _railItem(int index) {
    final theme = Theme.of(context);
    final destination = widget.destinations[index];
    final selected = !_hasContentRoute && widget.selectedIndex == index;
    final foreground = selected
        ? theme.colorScheme.onSecondaryContainer
        : theme.colorScheme.onSurfaceVariant;
    return Semantics(
      selected: selected,
      button: true,
      label: destination.label,
      excludeSemantics: true,
      child: InkWell(
        key: ValueKey('diary-destination-$index'),
        borderRadius: BorderRadius.circular(16),
        onTap: () => _select(index),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 56,
              height: 32,
              decoration: BoxDecoration(
                  color: selected
                      ? theme.colorScheme.secondaryContainer
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16)),
              child: Icon(
                  selected ? destination.selectedIcon : destination.icon,
                  color: foreground),
            ),
            const SizedBox(height: 4),
            Text(destination.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    theme.textTheme.labelMedium?.copyWith(color: foreground)),
          ]),
        ),
      ),
    );
  }

  Widget _rail() {
    return SizedBox(
      key: const ValueKey('diary-rail'),
      width: 80,
      child: SafeArea(
        right: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
          child: Column(children: [
            FloatingActionButton(
              key: const ValueKey('diary-new-entry'),
              heroTag: 'diary-rail-new-entry',
              tooltip: widget.newEntryLabel,
              elevation: 0,
              onPressed: widget.onNewEntry,
              child: const Icon(Icons.add_rounded),
            ),
            const SizedBox(height: 40),
            for (var i = 0; i < widget.destinations.length; i++) _railItem(i),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final compact =
          diaryLayoutFor(constraints.biggest) == DiaryLayout.compact;
      return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(children: [
            Expanded(
                child: Row(children: [
              // Keep content in the same element slot to preserve drafts/routes.
              if (!compact) _rail() else const SizedBox.shrink(),
              Expanded(
                  child: NavigatorPopHandler<Object?>(
                      onPopWithResult: (result) =>
                          widget.navigatorKey.currentState!.pop(result),
                      child: Navigator(
                          key: widget.navigatorKey,
                          observers: [_observer],
                          pages: [
                            MaterialPage<void>(
                                key: const ValueKey('diary-home-route'),
                                child: widget.home)
                          ],
                          onDidRemovePage: (_) {}))),
            ])),
            if (compact && !_hasContentRoute)
              NavigationBar(
                  key: const ValueKey('diary-bottom-navigation'),
                  selectedIndex: widget.selectedIndex,
                  onDestinationSelected: _select,
                  destinations: [
                    for (final d in widget.destinations)
                      NavigationDestination(
                          icon: Icon(d.icon),
                          selectedIcon: Icon(d.selectedIcon),
                          label: d.label)
                  ]),
          ]));
    });
  }
}

class _ContentRouteObserver extends NavigatorObserver {
  _ContentRouteObserver(this.onChanged);
  final ValueChanged<bool> onChanged;
  final Set<Route<dynamic>> _routes = {};
  Route<dynamic>? get currentRoute => _routes.lastOrNull;
  void _changed() => onChanged(_routes.length > 1);
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routes.add(route);
    _changed();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routes.remove(route);
    _changed();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routes.remove(route);
    _changed();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _routes.remove(oldRoute);
    if (newRoute != null) _routes.add(newRoute);
    _changed();
  }
}
