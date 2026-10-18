// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:material_ui/material_ui.dart';

enum DiaryLayout { compact, rail, expanded }

/// Use available logical pixels, including height, not the device name.
DiaryLayout diaryLayoutFor(Size size) {
  if (size.width < 600) return DiaryLayout.compact;
  if (size.width >= 1200 && size.height >= 600) return DiaryLayout.expanded;
  return DiaryLayout.rail;
}

bool diarySupportsSplit(Size contentSize) =>
    contentSize.width >= 700 && contentSize.height >= 280;

class DiaryDestination {
  const DiaryDestination(this.label, this.icon);
  final String label;
  final IconData icon;
}

/// All ordinary routes share one Navigator, stable through window resizing.
class AdaptiveDiaryShell extends StatefulWidget {
  const AdaptiveDiaryShell(
      {super.key,
      required this.navigatorKey,
      required this.home,
      required this.title,
      required this.destinations,
      required this.selectedIndex,
      required this.onDestinationSelected,
      required this.settingsLabel,
      required this.onSettings});
  final GlobalKey<NavigatorState> navigatorKey;
  final Widget home;
  final String title;
  final List<DiaryDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final String settingsLabel;
  final VoidCallback onSettings;

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

  Future<void> _settings() async {
    if (_navigating || _observer.currentRoute?.settings.name == 'settings') {
      return;
    }
    _navigating = true;
    try {
      if (await _returnHome()) widget.onSettings();
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

  Widget _item(DiaryDestination destination,
      {required bool expanded,
      required bool selected,
      required Key key,
      required VoidCallback onTap}) {
    final theme = Theme.of(context);
    final foreground = selected
        ? theme.colorScheme.onSecondaryContainer
        : theme.colorScheme.onSurfaceVariant;
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Tooltip(
            message: destination.label,
            child: Semantics(
                selected: selected,
                button: true,
                label: destination.label,
                excludeSemantics: true,
                child: Material(
                    borderRadius: BorderRadius.circular(24),
                    color: selected
                        ? theme.colorScheme.secondaryContainer
                        : Colors.transparent,
                    child: InkWell(
                        key: key,
                        borderRadius: BorderRadius.circular(24),
                        onTap: onTap,
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: expanded ? 16 : 12, vertical: 12),
                            child: Row(
                                mainAxisAlignment: expanded
                                    ? MainAxisAlignment.start
                                    : MainAxisAlignment.center,
                                children: [
                                  Icon(destination.icon, color: foreground),
                                  if (expanded) ...[
                                    const SizedBox(width: 12),
                                    Expanded(
                                        child: Text(destination.label,
                                            style: theme.textTheme.labelLarge
                                                ?.copyWith(color: foreground)))
                                  ],
                                ])))))));
  }

  Widget _navigation(DiaryLayout layout) {
    final expanded = layout == DiaryLayout.expanded;
    return SizedBox(
        key: ValueKey(expanded ? 'diary-sidebar' : 'diary-rail'),
        width: expanded ? 240 : 80,
        child: Material(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            child: SafeArea(
                child: Column(children: [
              if (expanded)
                Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                    child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(widget.title,
                            style: Theme.of(context).textTheme.titleLarge))),
              Expanded(
                  child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                          horizontal: expanded ? 12 : 8, vertical: 8),
                      child: Column(children: [
                        for (var i = 0; i < widget.destinations.length; i++)
                          _item(widget.destinations[i],
                              expanded: expanded,
                              selected: !_hasContentRoute &&
                                  widget.selectedIndex == i,
                              key: ValueKey('diary-destination-$i'),
                              onTap: () => _select(i))
                      ]))),
              const Divider(indent: 12, endIndent: 12),
              Padding(
                  padding: EdgeInsets.fromLTRB(
                      expanded ? 12 : 8, 0, expanded ? 12 : 8, 8),
                  child: _item(
                      DiaryDestination(
                          widget.settingsLabel, Icons.settings_rounded),
                      expanded: expanded,
                      selected: false,
                      key: const ValueKey('diary-settings'),
                      onTap: _settings)),
            ]))));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final layout = diaryLayoutFor(constraints.biggest);
      final compact = layout == DiaryLayout.compact;
      return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(children: [
            Expanded(
                child: Row(children: [
              // Keep content in the same element slot to preserve drafts/routes.
              if (!compact) _navigation(layout) else const SizedBox.shrink(),
              if (!compact)
                const VerticalDivider(width: 1)
              else
                const SizedBox.shrink(),
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
                  height: 64,
                  selectedIndex: widget.selectedIndex,
                  labelBehavior:
                      NavigationDestinationLabelBehavior.onlyShowSelected,
                  onDestinationSelected: _select,
                  destinations: [
                    for (final d in widget.destinations)
                      NavigationDestination(icon: Icon(d.icon), label: d.label)
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
