// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

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
  ];
  static const String id = 'id';
  static const String text = 'text';
  static const String mood = 'mood';
  static const String timeCreate = 'time_create';
  static const String timeModified = 'time_modified';
  static const String latitude = 'latitude';
  static const String longitude = 'longitude';
  static const String locationName = 'location_name';
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

  const Entry({
    this.id,
    required this.text,
    this.mood,
    required this.timeCreate,
    required this.timeModified,
    this.location,
  });

  static const _unset = Object();

  Entry copy({
    int? id,
    String? text,
    Object? mood = _unset,
    DateTime? timeCreate,
    DateTime? timeModified,
    Object? location = _unset,
  }) =>
      Entry(
        id: id ?? this.id,
        text: text ?? this.text,
        mood: mood == _unset ? this.mood : mood as int?,
        timeCreate: timeCreate ?? this.timeCreate,
        timeModified: timeModified ?? this.timeModified,
        location:
            location == _unset ? this.location : location as EntryLocation?,
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
      timeCreate: DateTime.parse(json[EntryFields.timeCreate] as String),
      timeModified: DateTime.parse(json[EntryFields.timeModified] as String),
      location: location.isEmpty ? null : location,
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
      };
}
