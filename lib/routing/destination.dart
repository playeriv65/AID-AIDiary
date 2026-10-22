// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/app_action.dart';
import 'package:material_ui/material_ui.dart';

/// A place the GUI can open, defined once: a tap and `ui.navigate` both
/// open it through [open], so the command line reaches every screen the
/// GUI does (docs/ARCHITECTURE.md, "Agent-native").
class Destination {
  const Destination(this.name, this.describe, this.open,
      {this.params = const []});

  /// `area` or `area/part`, e.g. `entry` or `settings/data`.
  final String name;
  final String describe;
  final List<ActionParam> params;

  /// Opens it from a context inside the tabs' navigator, with [ActionArgs]
  /// checked against [params].
  final Future<void> Function(BuildContext context, ActionArgs args) open;

  ScreenDestination get info =>
      ScreenDestination(name, describe, params: params);
}

/// [args]' integer [name], or null.
int? intArg(ActionArgs args, String name) => args[name] as int?;

/// [args]' date [name] (yyyy-MM-dd), or null when it is not given.
DateTime? dateArg(ActionArgs args, String name) {
  final text = args[name] as String?;
  if (text == null) return null;
  return DateTime.tryParse(text) ??
      (throw ActionException(
          'bad_args', '$name must be yyyy-MM-dd, not $text'));
}

/// [args]' [name] as the one of [values] with that name, or null when it is
/// not given.
T? enumArg<T extends Enum>(ActionArgs args, String name, List<T> values) {
  final text = args[name] as String?;
  if (text == null) return null;
  return values.where((value) => value.name == text).firstOrNull ??
      (throw ActionException('bad_args',
          '$name must be one of ${values.map((v) => v.name).join(', ')}'));
}

/// The route settings of a page opened for [name] with [args]: its name is
/// what `ui.screen` reports, e.g. `entry/12`.
RouteSettings routeFor(String name, [Object? id]) =>
    RouteSettings(name: id == null ? name : '$name/$id');

/// Pushes [page] as the place [name] from [context]; [root] covers the tab
/// bar as well.
Future<void> pushPlace(BuildContext context, String name, WidgetBuilder page,
        {Object? id, bool root = false, bool fullscreenDialog = false}) =>
    Navigator.of(context, rootNavigator: root).push(MaterialPageRoute<void>(
        settings: routeFor(name, id),
        allowSnapshotting: false,
        fullscreenDialog: fullscreenDialog,
        builder: page));

/// Shows [dialog] as the place [name], over the tab bar like any dialog.
Future<T?> showPlaceDialog<T>(
        BuildContext context, String name, WidgetBuilder dialog,
        {Object? id}) =>
    showDialog<T>(
        context: context, routeSettings: routeFor(name, id), builder: dialog);

/// Shows [sheet] as the place [name].
Future<T?> showPlaceSheet<T>(
        BuildContext context, String name, WidgetBuilder sheet, {Object? id}) =>
    showModalBottomSheet<T>(
        context: context,
        routeSettings: routeFor(name, id),
        isScrollControlled: true,
        showDragHandle: true,
        builder: sheet);

/// A place that is one page without arguments.
Destination pageDestination(String name, String describe, WidgetBuilder page,
        {bool fullscreenDialog = false}) =>
    Destination(
        name,
        describe,
        (context, args) =>
            pushPlace(context, name, page, fullscreenDialog: fullscreenDialog));
