// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:material_ui/material_ui.dart';
import 'package:aid_diary/actions/settings_actions.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:system_theme/system_theme.dart';

/// The theme as the settings choose it. It follows the settings whoever
/// changes them, the appearance page or an action, so nothing has to tell
/// it.
class ThemeModeProvider with ChangeNotifier {
  ThemeModeProvider() {
    ConfigProvider.instance.addListener(_configChanged);
  }

  ThemeMode get themeMode =>
      switch (ConfigProvider.instance.get(Settings.theme)) {
        'dark' || 'amoled' => ThemeMode.dark,
        'light' => ThemeMode.light,
        _ => ThemeMode.system,
      };

  Color _accentColor = const Color(0xff62A0EA);
  Color get accentColor => _accentColor;
  bool get usingSystemColor =>
      ConfigProvider.instance.get(Settings.followSystemColor);

  /// What [_accentColor] was made from, to tell when it needs making again.
  (bool, int)? _accentSource;

  (bool, int) get _currentAccentSource => (
        ConfigProvider.instance.get(Settings.followSystemColor),
        ConfigProvider.instance.get(Settings.accentColor),
      );

  void _configChanged() {
    if (_accentSource != _currentAccentSource) updateAccentColor();
  }

  /// Makes [color] the accent, by `settings.set` as the command line does.
  Future<void> selectAccentColor(Color color) =>
      changeSetting(Settings.accentColor, color.toARGB32());

  void updateAccentColor() {
    _accentSource = _currentAccentSource;
    if (ConfigProvider.instance.get(Settings.followSystemColor)) {
      _accentColor = SystemTheme.accentColor.accent;
    } else {
      _accentColor = Color(ConfigProvider.instance.get(Settings.accentColor));
    }
    notifyListeners();
  }

  Future<void> initializeThemeFromConfig() async {
    await SystemTheme.accentColor.load();
    SystemTheme.fallbackColor = _accentColor;
    updateAccentColor();
  }

  @override
  void dispose() {
    ConfigProvider.instance.removeListener(_configChanged);
    super.dispose();
  }
}
