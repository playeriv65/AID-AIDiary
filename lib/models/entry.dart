// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/utils/diary_day.dart';
import 'package:aid_diary/utils/local_time.dart';

const String entriesTable = 'entries';

const String deprecatedImgPath = 'img_path';

class EntryFields {
  static const List<String> values = [
    id,
    title,
    text,
    mood,
    timeCreate,
    timeModified,
    latitude,
    longitude,
    locationName,
    locationSource,
    openAt,
    utcOffset,
    diaryDate,
    isHidden,
  ];
  static const String id = 'id';
  static const String title = 'title';
  static const String text = 'text';
  static const String mood = 'mood';
  static const String timeCreate = 'time_create';
  static const String timeModified = 'time_modified';
  static const String latitude = 'latitude';
  static const String longitude = 'longitude';
  static const String locationName = 'location_name';
  static const String locationSource = 'location_source';

  /// Dropped in database version 17; kept for the upgrades that add and
  /// move or remove them.
  static const String weatherCode = 'weather_code';
  static const String temperature = 'temperature';
  static const String activity = 'activity';

  static const String openAt = 'open_at';
  static const String utcOffset = 'utc_offset';
  static const String diaryDate = 'diary_date';
  static const String isHidden = 'is_hidden';

  /// Set while an entry sits in Recently deleted; not part of [Entry].
  static const String deletedAt = 'deleted_at';
}

/// How an entry's place was set: the device's position, a place picked from
/// a search or the places nearby, a name typed in, a photo's position, or
/// another journal's import.
enum LocationSource {
  gps,
  picked,
  typed,
  photo,
  imported;

  static LocationSource? byName(String? name) =>
      values.where((source) => source.name == name).firstOrNull;
}

/// Where an entry was written. Coordinates are optional so a place can be
/// named by hand without a location fix.
class EntryLocation {
  const EntryLocation({this.latitude, this.longitude, this.name, this.source});

  final double? latitude;
  final double? longitude;
  final String? name;

  /// Null for places set before database version 17.
  final LocationSource? source;

  EntryLocation withSource(LocationSource source) => EntryLocation(
      latitude: latitude, longitude: longitude, name: name, source: source);

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
      other.name == name &&
      other.source == source;

  @override
  int get hashCode => Object.hash(latitude, longitude, name, source);
}

class Entry {
  final int? id;

  /// What the writer named the entry; empty when they did not. Kept apart
  /// from [text] since database version 17.
  final String title;
  final String text;
  final int? mood;
  final DateTime timeCreate;
  final DateTime timeModified;
  final EntryLocation? location;

  /// A time capsule stays sealed until this moment.
  final DateTime? openAt;

  /// Hidden entries are only shown after opening the protected diary section.
  final bool isHidden;

  /// Minutes ahead of UTC where the entry was written. [timeCreate] is the
  /// wall-clock time there, so it reads the same after the device moves to
  /// another time zone; this pins down the moment for formats that need
  /// one. Null for entries from before it was recorded.
  final int? utcOffset;

  /// The diary day this entry belongs to, as a local midnight: what the
  /// writer meant, stored next to [timeCreate], the time it was actually
  /// written. Everything counted by day uses it, never [timeCreate]'s own
  /// date. Without one given it takes [DiaryDay.defaultFor] that time.
  final DateTime day;

  Entry({
    this.id,
    this.title = '',
    required this.text,
    this.mood,
    required this.timeCreate,
    required this.timeModified,
    this.location,
    this.openAt,
    this.isHidden = false,
    this.utcOffset,
    DateTime? day,
  }) : day = day == null
            ? DiaryDay.defaultFor(timeCreate)
            : DiaryDay.dateOf(day);

  /// The UTC offset where this was written, or the device's for that time
  /// when unknown.
  Duration get writtenOffset => utcOffset == null
      ? timeCreate.timeZoneOffset
      : Duration(minutes: utcOffset!);

  /// "UTC+8" when the entry was written in another time zone than the
  /// device's, so its time is not read as local; null otherwise.
  String? get otherZoneLabel {
    final offset = utcOffset;
    if (offset == null || offset == timeCreate.timeZoneOffset.inMinutes) {
      return null;
    }
    final sign = offset < 0 ? '−' : '+';
    final hours = offset.abs() ~/ 60;
    final minutes = offset.abs() % 60;
    return 'UTC$sign$hours${minutes == 0 ? '' : ':${'$minutes'.padLeft(2, '0')}'}';
  }

  /// The moment [timeCreate] stands for, in UTC.
  DateTime get createdInstant => _instantOf(timeCreate);

  /// The moment [journalTime] stands for, in UTC: what other journals get.
  DateTime get journalInstant => _instantOf(journalTime);

  DateTime _instantOf(DateTime wall) => DateTime.utc(wall.year, wall.month,
          wall.day, wall.hour, wall.minute, wall.second, wall.millisecond)
      .subtract(writtenOffset);

  /// The local wall-clock time at [offset] for a UTC moment.
  static DateTime wallClockAt(DateTime instant, Duration offset) {
    final wall = instant.toUtc().add(offset);
    return DateTime(wall.year, wall.month, wall.day, wall.hour, wall.minute,
        wall.second, wall.millisecond);
  }

  /// The calendar date it was actually written on. Kept once made: a local
  /// DateTime asks the OS for the time zone.
  late final DateTime writtenDate = DiaryDay.dateOf(timeCreate);

  /// Written in the night after its diary day, such as at 1:30 for the
  /// evening before.
  bool get isLateNight =>
      day == DateTime(writtenDate.year, writtenDate.month, writtenDate.day - 1);

  /// Belongs to another day than the one it was written on, other than a
  /// late night, such as an entry written later about a past day.
  bool get isForAnotherDay => day != writtenDate && !isLateNight;

  /// The diary day at the time of day it was written: the date other
  /// journals get, as they have no separate diary day. The written time
  /// itself where the two days agree or for a late night.
  DateTime get journalTime => isForAnotherDay
      ? DateTime(day.year, day.month, day.day, timeCreate.hour,
          timeCreate.minute, timeCreate.second)
      : timeCreate;

  /// The text with the title as a heading above it, for formats and readers
  /// without a title of their own.
  String get markdown => title.isEmpty ? text : '# $title\n$text';

  /// Whether this is a time capsule that has not opened yet.
  bool get isSealed => openAt?.isAfter(DateTime.now()) ?? false;

  static const _unset = Object();

  Entry copy({
    int? id,
    String? title,
    String? text,
    Object? mood = _unset,
    DateTime? timeCreate,
    DateTime? timeModified,
    Object? location = _unset,
    Object? openAt = _unset,
    bool? isHidden,
    Object? utcOffset = _unset,
    DateTime? day,
  }) =>
      Entry(
        id: id ?? this.id,
        title: title ?? this.title,
        text: text ?? this.text,
        mood: mood == _unset ? this.mood : mood as int?,
        timeCreate: timeCreate ?? this.timeCreate,
        timeModified: timeModified ?? this.timeModified,
        location:
            location == _unset ? this.location : location as EntryLocation?,
        openAt: openAt == _unset ? this.openAt : openAt as DateTime?,
        isHidden: isHidden ?? this.isHidden,
        utcOffset: utcOffset == _unset ? this.utcOffset : utcOffset as int?,
        // A new written time leaves the diary day as it was.
        day: day ?? this.day,
      );

  static Entry fromJson(Map<String, Object?> json) {
    final location = EntryLocation(
      latitude: (json[EntryFields.latitude] as num?)?.toDouble(),
      longitude: (json[EntryFields.longitude] as num?)?.toDouble(),
      name: json[EntryFields.locationName] as String?,
      source:
          LocationSource.byName(json[EntryFields.locationSource] as String?),
    );
    return Entry(
      id: json[EntryFields.id] as int?,
      title: json[EntryFields.title] as String? ?? '',
      text: json[EntryFields.text] as String,
      mood: json[EntryFields.mood] as int?,
      timeCreate: parseLocalTime(json[EntryFields.timeCreate] as String),
      timeModified: parseLocalTime(json[EntryFields.timeModified] as String),
      location: location.isEmpty ? null : location,
      openAt: switch (json[EntryFields.openAt]) {
        final String at => parseLocalTime(at),
        _ => null,
      },
      utcOffset: json[EntryFields.utcOffset] as int?,
      isHidden:
          json[EntryFields.isHidden] == 1 || json[EntryFields.isHidden] == true,
      day: DiaryDay.parse(json[EntryFields.diaryDate] as String?),
    );
  }

  Map<String, Object?> toJson() => {
        EntryFields.id: id,
        EntryFields.title: title,
        EntryFields.text: text,
        EntryFields.mood: mood,
        EntryFields.timeCreate: timeCreate.toIso8601String(),
        EntryFields.timeModified: timeModified.toIso8601String(),
        EntryFields.latitude: location?.latitude,
        EntryFields.longitude: location?.longitude,
        EntryFields.locationName: location?.name,
        EntryFields.locationSource: location?.source?.name,
        EntryFields.openAt: openAt?.toIso8601String(),
        EntryFields.utcOffset: utcOffset,
        EntryFields.diaryDate: DiaryDay.format(day),
        EntryFields.isHidden: isHidden ? 1 : 0,
      };
}

/// An entry in Recently deleted and when it went there.
typedef DeletedEntry = ({Entry entry, DateTime deletedAt});
