// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';

import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/utils/diary_day.dart';
import 'package:aid_diary/utils/local_time.dart';
import 'package:crypto/crypto.dart';

/// The weather of a day at a place, since database version 17: entries of
/// that day and place share it rather than each keeping a copy.
const String dayWeatherTable = 'day_weather';

class DayWeatherFields {
  static const String id = 'id';
  static const String day = 'day';
  static const String place = 'place';
  static const String source = 'source';
  static const String code = 'code';
  static const String temperature = 'temperature';
  static const String timeModified = 'time_modified';
}

/// A WMO weather code and the air temperature in degrees Celsius.
class EntryWeather {
  const EntryWeather({required this.code, required this.temperature});

  final int code;
  final double temperature;

  @override
  bool operator ==(Object other) =>
      other is EntryWeather &&
      other.code == code &&
      other.temperature == temperature;

  @override
  int get hashCode => Object.hash(code, temperature);
}

/// Where a day's weather came from, the one that counts most last: what the
/// writer set by hand stands over an import, which stands over a lookup.
enum WeatherSource {
  queried,
  imported,
  manual;

  static WeatherSource byName(String name) =>
      values.firstWhere((source) => source.name == name);
}

/// What a day's weather is kept under for [location]: its coordinates to a
/// tenth of a degree, about 11 km; its name when it has none; empty for no
/// place.
String weatherPlaceOf(EntryLocation? location) {
  if (location == null) return '';
  if (location.hasCoordinates) {
    String tenth(double degrees) =>
        ((degrees * 10).round() / 10).toStringAsFixed(1);
    return '${tenth(location.latitude!)},${tenth(location.longitude!)}';
  }
  return 'name:${location.name!.trim().toLowerCase()}';
}

class DayWeather {
  const DayWeather({
    this.id,
    required this.day,
    required this.place,
    required this.source,
    required this.weather,
    required this.timeModified,
  });

  final int? id;

  /// The diary day, as a local midnight.
  final DateTime day;

  /// See [weatherPlaceOf].
  final String place;
  final WeatherSource source;
  final EntryWeather weather;
  final DateTime timeModified;

  /// The same on every device, so two devices that look up or set the same
  /// day, place and source share one item rather than racing two.
  String get syncId => md5
      .convert(
          utf8.encode('weather|${DiaryDay.format(day)}|$place|${source.name}'))
      .toString();

  static DayWeather fromJson(Map<String, Object?> json) => DayWeather(
        id: json[DayWeatherFields.id] as int?,
        day: DiaryDay.parse(json[DayWeatherFields.day] as String)!,
        place: json[DayWeatherFields.place] as String,
        source: WeatherSource.byName(json[DayWeatherFields.source] as String),
        weather: EntryWeather(
            code: json[DayWeatherFields.code] as int,
            temperature:
                (json[DayWeatherFields.temperature] as num).toDouble()),
        timeModified:
            parseLocalTime(json[DayWeatherFields.timeModified] as String),
      );

  Map<String, Object?> toJson() => {
        DayWeatherFields.day: DiaryDay.format(day),
        DayWeatherFields.place: place,
        DayWeatherFields.source: source.name,
        DayWeatherFields.code: weather.code,
        DayWeatherFields.temperature: weather.temperature,
        DayWeatherFields.timeModified: timeModified.toIso8601String(),
      };
}
