// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/time_manager.dart';
import 'package:flutter/widgets.dart';

/// The language the app shows: the one chosen in settings, else the
/// system's, else the closest the app is translated into. For code that has
/// no `BuildContext` to read it from (stored names, actions).
Locale shownLocale() {
  final wanted = ConfigProvider.instance.getOverrideLanguage() ??
      WidgetsBinding.instance.platformDispatcher.locale;
  if (AppLocalizations.delegate.isSupported(wanted)) return wanted;
  final languageOnly = Locale(wanted.languageCode);
  return AppLocalizations.delegate.isSupported(languageOnly)
      ? languageOnly
      : const Locale('en');
}

/// [shownLocale]'s texts.
AppLocalizations shownLocalizations() => lookupAppLocalizations(shownLocale());

/// [shownLocale]'s texts for code that awaits them. Loading gives a
/// `SynchronousFuture`, which an error thrown right after awaiting it
/// escapes as an unhandled one.
Future<AppLocalizations> loadShownLocalizations() async =>
    AppLocalizations.delegate.load(shownLocale());

/// The day weeks start on, as `DateTime.weekday` counts (Monday = 1): the
/// setting, or what the language shown uses.
int firstWeekdayShown() =>
    ConfigProvider.instance
        .firstDayOfWeekIndexFor(TimeManager.dateLocaleName(shownLocale())) +
    1;
