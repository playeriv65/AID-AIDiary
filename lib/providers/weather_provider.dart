// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/models/day_weather.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/sync/sync_schema.dart';
import 'package:aid_diary/utils/diary_day.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sqflite/sqflite.dart';

/// The weather of each day at each place. An entry shows the weather of its
/// diary day at its place, from the source that counts most.
class WeatherProvider with ChangeNotifier {
  static final WeatherProvider instance = WeatherProvider._init();

  WeatherProvider._init();

  /// The weather that counts for each day and place.
  Map<String, DayWeather> _shown = const {};

  static String _key(DateTime day, String place) =>
      '${DiaryDay.format(day)}|$place';

  Future<void> load() async {
    final rows = await AppDatabase.instance.database!.query(dayWeatherTable);
    final shown = <String, DayWeather>{};
    for (final row in rows) {
      final weather = DayWeather.fromJson(row);
      final key = _key(weather.day, weather.place);
      if (shown[key] case final other?
          when other.source.index >= weather.source.index) {
        continue;
      }
      shown[key] = weather;
    }
    _shown = shown;
    notifyListeners();
  }

  /// The weather of [day] at [location], with where it came from.
  DayWeather? of(DateTime day, EntryLocation? location) =>
      _shown[_key(DiaryDay.dateOf(day), weatherPlaceOf(location))];

  /// The weather [entry] shows.
  EntryWeather? ofEntry(Entry entry) => of(entry.day, entry.location)?.weather;

  /// Keeps [weather] from [source] for [day] at [location]; null removes
  /// that day's weather there from every source.
  Future<void> set(DateTime day, EntryLocation? location, EntryWeather? weather,
      WeatherSource source,
      {DatabaseExecutor? executor}) async {
    await write(AppDatabase.executorOr(executor), DiaryDay.dateOf(day),
        weatherPlaceOf(location), weather, source);
    if (executor == null) await load();
  }

  /// Writes a day's weather without reloading, for upgrades and imports.
  static Future<void> write(DatabaseExecutor db, DateTime day, String place,
      EntryWeather? weather, WeatherSource source) async {
    if (weather == null) {
      await db.delete(dayWeatherTable,
          where:
              '${DayWeatherFields.day} = ? AND ${DayWeatherFields.place} = ?',
          whereArgs: [DiaryDay.format(day), place]);
      return;
    }
    final row = DayWeather(
        day: day,
        place: place,
        source: source,
        weather: weather,
        timeModified: DateTime.now());
    final updated = await db.update(dayWeatherTable, row.toJson(),
        where: '$syncIdColumn = ?', whereArgs: [row.syncId]);
    if (updated == 0) {
      await db
          .insert(dayWeatherTable, {...row.toJson(), syncIdColumn: row.syncId});
    }
  }
}
