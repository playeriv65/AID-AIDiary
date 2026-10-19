// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/models/template.dart';

/// A ready-made template shipped with the app, in the user's language.
/// It is never stored; picking it only inserts its text.
class BuiltinTemplate {
  const BuiltinTemplate(
      {required this.id,
      required this.name,
      required this.description,
      required this.text});

  final String id;
  final String name;
  final String description;
  final String text;

  /// An unsaved [Template] carrying this text, for code that takes templates.
  Template toTemplate() {
    final now = DateTime.now();
    return Template(name: name, text: text, timeCreate: now, timeModified: now);
  }

  static List<BuiltinTemplate> all(AppLocalizations l10n) => [
        BuiltinTemplate(
            id: 'daily',
            name: l10n.templateDailyName,
            description: l10n.templateDailyDescription,
            text: l10n.templateDailyText),
        BuiltinTemplate(
            id: 'travel',
            name: l10n.templateTravelName,
            description: l10n.templateTravelDescription,
            text: l10n.templateTravelText),
        BuiltinTemplate(
            id: 'reading',
            name: l10n.templateReadingName,
            description: l10n.templateReadingDescription,
            text: l10n.templateReadingText),
        BuiltinTemplate(
            id: 'weekly',
            name: l10n.templateWeeklyName,
            description: l10n.templateWeeklyDescription,
            text: l10n.templateWeeklyText),
      ];
}
