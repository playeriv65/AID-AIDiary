// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/routing/destination.dart';
import 'package:aid_diary/routing/destinations.dart';
import 'package:aid_diary/pages/settings/templates_page.dart';
import 'package:material_ui/material_ui.dart';

/// Opens the app's screens. Shared widgets go through here rather than
/// importing pages, so components never depend on the screens using them.
/// The places themselves are in `destinations.dart`.
abstract final class AppNavigation {
  static Future<void> search(NavigatorState navigator) =>
      openPlace(navigator.context, 'search');

  static Future<void> settings(NavigatorState navigator) =>
      openPlace(navigator.context, 'settings');

  static Future<void> statistics(NavigatorState navigator) =>
      openPlace(navigator.context, 'statistics');

  static Future<void> templates(NavigatorState navigator,
          {bool fullscreenDialog = false}) =>
      fullscreenDialog
          ? pushPlace(
              navigator.context, 'templates', (_) => const TemplateSettings(),
              fullscreenDialog: true)
          : openPlace(navigator.context, 'templates');

  static Future<void> tags(NavigatorState navigator) =>
      openPlace(navigator.context, 'tags');
}
