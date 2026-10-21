// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/pages/search_page.dart';
import 'package:aid_diary/pages/settings/sync_settings.dart';
import 'package:aid_diary/pages/settings/tags_settings.dart';
import 'package:aid_diary/pages/settings/templates_page.dart';
import 'package:aid_diary/pages/settings_page.dart';
import 'package:aid_diary/pages/statistics_page.dart';
import 'package:material_ui/material_ui.dart';

/// Opens the app's screens. Shared widgets go through here rather than
/// importing pages, so components never depend on the screens using them.
/// Entry screens have their own routes in `EntryNavigation`.
abstract final class AppNavigation {
  static Future<void> _push(
          NavigatorState navigator, String name, WidgetBuilder page,
          {bool fullscreenDialog = false}) =>
      navigator.push(MaterialPageRoute<void>(
          settings: RouteSettings(name: name),
          allowSnapshotting: false,
          fullscreenDialog: fullscreenDialog,
          builder: page));

  static Future<void> search(NavigatorState navigator) =>
      _push(navigator, 'search', (_) => const SearchPage());

  static Future<void> settings(NavigatorState navigator) =>
      _push(navigator, 'settings', (_) => const SettingsPage());

  static Future<void> statistics(NavigatorState navigator) => _push(
      navigator,
      'statistics',
      (context) => Scaffold(
          appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.pageStatisticsTitle)),
          body: const StatsPage()));

  static Future<void> templates(NavigatorState navigator,
          {bool fullscreenDialog = false}) =>
      _push(navigator, 'templates', (_) => const TemplateSettings(),
          fullscreenDialog: fullscreenDialog);

  static Future<void> tags(NavigatorState navigator) =>
      _push(navigator, 'tags', (_) => const TagsSettings());

  static Future<void> sync(NavigatorState navigator) =>
      _push(navigator, 'sync', (_) => const SyncSettings());

  /// The screens above, by route name, for `ui.navigate`.
  static final Map<String, Future<void> Function(NavigatorState navigator)>
      byName = {
    'search': search,
    'settings': settings,
    'statistics': statistics,
    'templates': templates,
    'tags': tags,
    'sync': sync,
  };
}
