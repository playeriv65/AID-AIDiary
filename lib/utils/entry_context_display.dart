// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:daily_you/config_provider.dart';
import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/models/entry.dart';
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
  clear,
  partlyCloudy,
  cloudy,
  fog,
  drizzle,
  rain,
  snow,
  storm
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

IconData weatherIcon(int code) => switch (weatherKind(code)) {
      WeatherKind.clear => Icons.wb_sunny_rounded,
      WeatherKind.partlyCloudy => Icons.wb_cloudy_outlined,
      WeatherKind.cloudy => Icons.cloud_rounded,
      WeatherKind.fog => Icons.foggy,
      WeatherKind.drizzle => Icons.grain_rounded,
      WeatherKind.rain => Icons.water_drop_rounded,
      WeatherKind.snow => Icons.ac_unit_rounded,
      WeatherKind.storm => Icons.thunderstorm_rounded,
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

/// Temperature in the unit chosen in settings, rounded to a whole degree.
String formatTemperature(double celsius) {
  final fahrenheit =
      ConfigProvider.instance.get(Settings.temperatureUnit) == 'fahrenheit';
  final value = fahrenheit ? celsius * 9 / 5 + 32 : celsius;
  return '${value.round()}°${fahrenheit ? 'F' : 'C'}';
}

/// "Rain, 14°C".
String weatherSummary(EntryWeather weather, AppLocalizations l10n) =>
    '${weatherLabel(weather.code, l10n)}, ${formatTemperature(weather.temperature)}';

IconData activityIcon(EntryActivity activity) => switch (activity) {
      EntryActivity.still => Icons.event_seat_rounded,
      EntryActivity.walking => Icons.directions_walk_rounded,
      EntryActivity.running => Icons.directions_run_rounded,
      EntryActivity.cycling => Icons.directions_bike_rounded,
      EntryActivity.vehicle => Icons.directions_car_rounded,
      EntryActivity.flying => Icons.flight_rounded,
      EntryActivity.exercise => Icons.fitness_center_rounded,
    };

String activityLabel(EntryActivity activity, AppLocalizations l10n) =>
    switch (activity) {
      EntryActivity.still => l10n.activityStill,
      EntryActivity.walking => l10n.activityWalking,
      EntryActivity.running => l10n.activityRunning,
      EntryActivity.cycling => l10n.activityCycling,
      EntryActivity.vehicle => l10n.activityVehicle,
      EntryActivity.flying => l10n.activityFlying,
      EntryActivity.exercise => l10n.activityExercise,
    };
