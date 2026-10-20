// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

/// Font, size and line spacing chosen for entry text, shared by the editor
/// and the reader.
class EntryTypography {
  const EntryTypography({
    required this.fontSize,
    required this.lineSpacing,
    this.fontFamilies = const [],
  });

  /// The size the markdown styles are designed around.
  static const baseFontSize = 16.0;

  final double fontSize;
  final double lineSpacing;
  final List<String> fontFamilies;

  double get scale => fontSize / baseFontSize;

  /// The current choice; rebuilds [context] when settings change.
  static EntryTypography of(BuildContext context) {
    final settings = context.watch<ConfigProvider>();
    final config = AppConfig.instance;
    return EntryTypography(
      fontSize: config.fontSizes[settings.get(Settings.entryFontSize)] ??
          baseFontSize,
      lineSpacing:
          config.lineSpacings[settings.get(Settings.entryLineSpacing)] ??
              config.lineSpacings.values.first,
      fontFamilies:
          config.fontFamilies[settings.get(Settings.entryFontFamily)] ??
              const [],
    );
  }

  /// [style] with the chosen family and spacing; [sized] also sets the size.
  TextStyle apply(TextStyle style, {bool sized = true}) => style.copyWith(
        fontSize: sized ? fontSize : null,
        height: lineSpacing,
        fontFamily: fontFamilies.firstOrNull,
        fontFamilyFallback: fontFamilies.isEmpty ? null : fontFamilies,
      );

  /// Only the family, for spans whose size and spacing come from elsewhere.
  TextStyle get familyStyle => TextStyle(
        fontFamily: fontFamilies.firstOrNull,
        fontFamilyFallback: fontFamilies.isEmpty ? null : fontFamilies,
      );
}
