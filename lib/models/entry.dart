// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/utils/local_time.dart';

const String entriesTable = 'entries';

const String deprecatedImgPath = 'img_path';

class EntryFields {
  static const List<String> values = [
    id,
    text,
    mood,
    timeCreate,
    timeModified,
    latitude,
    longitude,
    locationName,
    weatherCode,
    temperature,
    activity,
    openAt,
  ];
  static const String id = 'id';
  static const String text = 'text';
  static const String mood = 'mood';
  static const String timeCreate = 'time_create';
  static const String timeModified = 'time_modified';
  static const String latitude = 'latitude';
  static const String longitude = 'longitude';
  static const String locationName = 'location_name';
  static const String weatherCode = 'weather_code';
  static const String temperature = 'temperature';
  static const String activity = 'activity';
  static const String openAt = 'open_at';

  /// Set while an entry sits in Recently deleted; not part of [Entry].
  static const String deletedAt = 'deleted_at';
}

/// Weather when the entry was written: a WMO weather code and the air
/// temperature in degrees Celsius.
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

/// What the writer was doing. The first five match motion detection.
enum EntryActivity {
  still,
  walking,
  running,
  cycling,
  vehicle,
  flying,
  exercise;

  static EntryActivity? fromName(String? name) =>
      values.where((a) => a.name == name).firstOrNull;
}

/// Where an entry was written. Coordinates are optional so a place can be
/// named by hand without a location fix.
class EntryLocation {
  const EntryLocation({this.latitude, this.longitude, this.name});

  final double? latitude;
  final double? longitude;
  final String? name;

  bool get hasCoordinates => latitude != null && longitude != null;
  bool get isEmpty => !hasCoordinates && (name == null || name!.isEmpty);

  /// The place name, or the coordinates when no name is known.
  String get label => name != null && name!.isNotEmpty
      ? name!
      : '${latitude!.toStringAsFixed(4)}, ${longitude!.toStringAsFixed(4)}';

  @override
  bool operator ==(Object other) =>
      other is EntryLocation &&
      other.latitude == latitude &&
      other.longitude == longitude &&
      other.name == name;

  @override
  int get hashCode => Object.hash(latitude, longitude, name);
}

class Entry {
  final int? id;
  final String text;
  final int? mood;
  final DateTime timeCreate;
  final DateTime timeModified;
  final EntryLocation? location;
  final EntryWeather? weather;
  final EntryActivity? activity;

  /// A time capsule stays sealed until this moment.
  final DateTime? openAt;

  Entry({
    this.id,
    required this.text,
    this.mood,
    required this.timeCreate,
    required this.timeModified,
    this.location,
    this.weather,
    this.activity,
    this.openAt,
  });

  /// Local midnight of [timeCreate], the key entries are grouped by. Kept
  /// once made: a local DateTime asks the OS for the time zone, which adds
  /// up over thousands of entries on every change.
  late final DateTime day =
      DateTime(timeCreate.year, timeCreate.month, timeCreate.day);

  /// Whether this is a time capsule that has not opened yet.
  bool get isSealed => openAt?.isAfter(DateTime.now()) ?? false;

  static const _unset = Object();

  Entry copy({
    int? id,
    String? text,
    Object? mood = _unset,
    DateTime? timeCreate,
    DateTime? timeModified,
    Object? location = _unset,
    Object? weather = _unset,
    Object? activity = _unset,
    Object? openAt = _unset,
  }) =>
      Entry(
        id: id ?? this.id,
        text: text ?? this.text,
        mood: mood == _unset ? this.mood : mood as int?,
        timeCreate: timeCreate ?? this.timeCreate,
        timeModified: timeModified ?? this.timeModified,
        location:
            location == _unset ? this.location : location as EntryLocation?,
        weather: weather == _unset ? this.weather : weather as EntryWeather?,
        activity:
            activity == _unset ? this.activity : activity as EntryActivity?,
        openAt: openAt == _unset ? this.openAt : openAt as DateTime?,
      );

  static Entry fromJson(Map<String, Object?> json) {
    final location = EntryLocation(
      latitude: (json[EntryFields.latitude] as num?)?.toDouble(),
      longitude: (json[EntryFields.longitude] as num?)?.toDouble(),
      name: json[EntryFields.locationName] as String?,
    );
    return Entry(
      id: json[EntryFields.id] as int?,
      text: json[EntryFields.text] as String,
      mood: json[EntryFields.mood] as int?,
      timeCreate: parseLocalTime(json[EntryFields.timeCreate] as String),
      timeModified: parseLocalTime(json[EntryFields.timeModified] as String),
      location: location.isEmpty ? null : location,
      weather: json[EntryFields.weatherCode] == null ||
              json[EntryFields.temperature] == null
          ? null
          : EntryWeather(
              code: json[EntryFields.weatherCode] as int,
              temperature: (json[EntryFields.temperature] as num).toDouble()),
      activity: EntryActivity.fromName(json[EntryFields.activity] as String?),
      openAt: switch (json[EntryFields.openAt]) {
        final String at => parseLocalTime(at),
        _ => null,
      },
    );
  }

  Map<String, Object?> toJson() => {
        EntryFields.id: id,
        EntryFields.text: text,
        EntryFields.mood: mood,
        EntryFields.timeCreate: timeCreate.toIso8601String(),
        EntryFields.timeModified: timeModified.toIso8601String(),
        EntryFields.latitude: location?.latitude,
        EntryFields.longitude: location?.longitude,
        EntryFields.locationName: location?.name,
        EntryFields.weatherCode: weather?.code,
        EntryFields.temperature: weather?.temperature,
        EntryFields.activity: activity?.name,
        EntryFields.openAt: openAt?.toIso8601String(),
      };
}
