// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

// Entries keep WMO weather codes. Other diaries use OpenWeather condition
// ids and icons (Journey) or named conditions (Day One); these map between
// them at the level of detail the WMO groups carry.

/// WMO code for an OpenWeather condition id, or null for an unknown id.
int? wmoFromOpenWeather(int id) => switch (id) {
      >= 200 && < 300 => 95,
      >= 300 && < 400 => 53,
      500 => 61,
      501 => 63,
      >= 502 && <= 504 => 65,
      511 => 66,
      520 => 80,
      521 => 81,
      522 || 531 => 82,
      600 => 71,
      601 => 73,
      602 => 75,
      >= 611 && <= 616 => 77,
      620 => 85,
      621 || 622 => 86,
      781 => 95,
      >= 700 && < 800 => 45,
      800 => 0,
      801 => 1,
      802 => 2,
      803 || 804 => 3,
      _ => null,
    };

/// OpenWeather condition id for a WMO code.
int openWeatherFromWmo(int code) => switch (code) {
      0 => 800,
      1 => 801,
      2 => 802,
      3 => 804,
      45 || 48 => 741,
      >= 51 && <= 57 => 301,
      61 => 500,
      63 => 501,
      65 => 502,
      66 || 67 => 511,
      71 => 600,
      73 => 601,
      75 => 602,
      77 => 611,
      80 => 520,
      81 => 521,
      82 => 522,
      85 => 620,
      86 => 621,
      >= 95 => 211,
      _ => 804,
    };

/// OpenWeather icon name for a WMO code, by day or by night.
String openWeatherIconFromWmo(int code, {required bool night}) {
  final icon = switch (code) {
    0 => '01',
    1 => '02',
    2 => '03',
    3 => '04',
    45 || 48 => '50',
    >= 51 && <= 57 || >= 80 && <= 82 => '09',
    >= 61 && <= 65 => '10',
    66 || 67 || >= 71 && <= 77 || 85 || 86 => '13',
    >= 95 => '11',
    _ => '04',
  };
  return '$icon${night ? 'n' : 'd'}';
}

/// WMO code for a Day One weather code, or null for an unknown one.
int? wmoFromDayOne(String code) =>
    switch (code.replaceFirst(RegExp(r'-night$'), '')) {
      'clear' || 'sunny' || 'fair' => 0,
      'partly-cloudy' || 'wind' => 2,
      'mostly-cloudy' || 'cloudy' => 3,
      'fog' || 'hazy' || 'smoke' || 'dust' => 45,
      'drizzle' => 53,
      'rain' || 'rain-wind' => 63,
      'showers' => 80,
      'freezing-rain' => 66,
      'sleet' || 'sleet-snow' || 'rain-snow' || 'hail' => 77,
      'snow' || 'snow-wind' || 'frigid' => 73,
      'flurries' || 'snow-showers' => 85,
      'thunderstorm' || 'lightning' || 'lighting' || 'tornado' => 95,
      _ => null,
    };

/// Day One weather code for a WMO code, by day or by night.
String dayOneFromWmo(int code, {required bool night}) {
  final (name, hasNight) = switch (code) {
    0 => ('clear', true),
    1 || 2 => ('partly-cloudy', false),
    3 => ('cloudy', true),
    45 || 48 => ('fog', true),
    >= 51 && <= 57 => ('drizzle', false),
    >= 61 && <= 65 => ('rain', true),
    66 || 67 => ('freezing-rain', false),
    >= 71 && <= 77 => ('snow', true),
    >= 80 && <= 82 => ('showers', false),
    85 || 86 => ('snow-showers', false),
    >= 95 => ('thunderstorm', true),
    _ => ('cloudy', true),
  };
  return night && hasNight ? '$name-night' : name;
}

/// Whether [time] is at night for the day/night variants above.
bool isNight(DateTime time) => time.hour < 6 || time.hour >= 18;
