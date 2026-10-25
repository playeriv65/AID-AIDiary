// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/day_weather.dart';
import 'package:material_ui/material_ui.dart';

/// Colour for a day's mood, from very bad (-2) to very good (2).
Color moodColor(int? mood, ColorScheme cs) => switch (mood) {
      -2 => Colors.red.shade300,
      -1 => Colors.orange.shade300,
      0 => Colors.amber.shade300,
      1 => Colors.lightGreen.shade400,
      2 => Colors.green.shade500,
      _ => cs.secondaryContainer,
    };

/// Coarse weather groups for WMO weather codes.
enum WeatherKind {
  clear(0),
  partlyCloudy(2),
  cloudy(3),
  fog(45),
  drizzle(53),
  rain(63),
  snow(73),
  storm(95);

  const WeatherKind(this.code);

  /// The WMO code weather of this kind is kept as when set by hand.
  final int code;
}

WeatherKind weatherKind(int code) => switch (code) {
      0 => WeatherKind.clear,
      1 || 2 => WeatherKind.partlyCloudy,
      3 => WeatherKind.cloudy,
      45 || 48 => WeatherKind.fog,
      >= 51 && <= 57 => WeatherKind.drizzle,
      >= 61 && <= 67 || >= 80 && <= 82 => WeatherKind.rain,
      >= 71 && <= 77 || 85 || 86 => WeatherKind.snow,
      >= 95 => WeatherKind.storm,
      _ => WeatherKind.cloudy,
    };

String weatherLabel(int code, AppLocalizations l10n) =>
    switch (weatherKind(code)) {
      WeatherKind.clear => l10n.weatherClear,
      WeatherKind.partlyCloudy => l10n.weatherPartlyCloudy,
      WeatherKind.cloudy => l10n.weatherCloudy,
      WeatherKind.fog => l10n.weatherFog,
      WeatherKind.drizzle => l10n.weatherDrizzle,
      WeatherKind.rain => l10n.weatherRain,
      WeatherKind.snow => l10n.weatherSnow,
      WeatherKind.storm => l10n.weatherStorm,
    };

bool get _fahrenheit =>
    ConfigProvider.instance.get(Settings.temperatureUnit) == 'fahrenheit';

/// "°C" or "°F", as chosen in settings.
String get temperatureUnit => _fahrenheit ? '°F' : '°C';

/// [celsius] in the unit chosen in settings.
double inChosenUnit(double celsius) =>
    _fahrenheit ? celsius * 9 / 5 + 32 : celsius;

/// A temperature in the unit chosen in settings, in degrees Celsius.
double celsiusFromChosenUnit(double value) =>
    _fahrenheit ? (value - 32) * 5 / 9 : value;

/// Temperature in the unit chosen in settings, rounded to a whole degree.
String formatTemperature(double celsius) =>
    '${inChosenUnit(celsius).round()}$temperatureUnit';

/// "Rain, 14°C".
String weatherSummary(EntryWeather weather, AppLocalizations l10n) =>
    '${weatherLabel(weather.code, l10n)}, ${formatTemperature(weather.temperature)}';
