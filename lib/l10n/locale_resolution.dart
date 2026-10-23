// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:flutter/widgets.dart';

import 'generated/app_localizations.dart';

final List<Locale> appSupportedLocales = List.unmodifiable([
  const Locale('en'),
  ...AppLocalizations.supportedLocales
      .where((locale) => locale.languageCode != 'en'),
]);

Locale resolveAppLocale(
  List<Locale>? preferredLocales,
  Iterable<Locale> supportedLocales,
) {
  return basicLocaleListResolution(
    preferredLocales?.map((locale) {
      // Some platforms report only a region, without a Chinese script.
      if (locale.languageCode == 'zh' &&
          locale.scriptCode == null &&
          const {'TW', 'HK', 'MO'}.contains(locale.countryCode)) {
        return Locale.fromSubtags(
          languageCode: locale.languageCode,
          scriptCode: 'Hant',
          countryCode: locale.countryCode,
        );
      }
      return locale;
    }).toList(),
    supportedLocales,
  );
}
