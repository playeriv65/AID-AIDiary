// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:material_ui/material_ui.dart';

/// The names of the routes open on one navigator, for `ui.screen`. Routes
/// opened through `lib/routing/` are named after their destination, such
/// as `entry/12` or `settings/data`.
class RouteNames extends NavigatorObserver {
  RouteNames({required this.base});

  /// How many routes are there before anything is opened: the home page
  /// of the navigator.
  final int base;

  final List<Route<dynamic>> _routes = [];

  int get depth => _routes.length;

  /// The top route's name, or null when only the home page is showing.
  String? get top =>
      _routes.length > base ? _routes.last.settings.name ?? 'page' : null;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // The first route of a navigator: whatever was kept belongs to one
    // that is gone, such as before a hot restart.
    if (previousRoute == null) _routes.clear();
    _routes.add(route);
  }

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

/// The app's root navigator, where the editor and other screens that cover
/// the tab bar open.
final rootRoutes = RouteNames(base: 1);
