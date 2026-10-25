// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:typed_data';

import 'package:aid_diary/models/day_weather.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/storage/file_store.dart';
import 'package:aid_diary/utils/activity_tags.dart';
import 'package:aid_diary/utils/formats/archive_export.dart';
import 'package:aid_diary/utils/formats/time_zones.dart';
import 'package:aid_diary/utils/formats/weather_codes.dart';
import 'package:aid_diary/utils/imports/import_archive.dart';
import 'package:aid_diary/utils/imports/import_helpers.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:path/path.dart' as p;

// Journey (journey.cloud) backs up a diary as a zip with one JSON file per
// entry beside its photos. Older backups use schema 1, with epoch
// milliseconds and flat fields; newer ones say "schemaVersion": 2 and use
// ISO dates and nested location. Its importer reads schema 1, so that is
// what the export writes.

/// Journey's marker for an unset coordinate or temperature.
const double _unset = 1.7976931348623157e308;

/// Journey's activity numbers, shared with its Day One importer.
const Map<int, ActivityTag> _activities = {
  1: ActivityTag.still,
  3: ActivityTag.walking,
  4: ActivityTag.running,
  5: ActivityTag.cycling,
  6: ActivityTag.vehicle,
  7: ActivityTag.flying,
};

/// Decodes a Journey backup: every JSON file is an entry, with the photos it
/// names in the same folder.
Future<List<ImportedEntry>> decodeJourneyArchive(
    ArchiveFiles files, AppLocalizations l10n) async {
  final available = files.paths.toSet();
  final entries = <ImportedEntry>[];
  for (final path in files.paths) {
    if (p.url.extension(path).toLowerCase() != '.json') continue;
    final bytes = await files.read(path);
    if (bytes == null) continue;
    if (jsonDecode(utf8.decode(bytes)) case final Map<String, dynamic> json) {
      final folder = p.url.dirname(path);
      final entry = decodeJourneyEntry(json, (name) {
        final photoPath = p.url.normalize(p.url.join(folder, name));
        return available.contains(photoPath)
            ? ImportedPhoto(name, () => files.read(photoPath))
            : null;
      }, l10n);
      if (entry != null) entries.add(entry);
    }
  }
  return entries;
}

/// Decodes one entry file, or returns null when it has no date. [photo]
/// finds a photo named in the entry inside the backup.
ImportedEntry? decodeJourneyEntry(Map<String, dynamic> json,
    ImportedPhoto? Function(String name) photo, AppLocalizations l10n) {
  final v2 = json['schemaVersion'] == 2;
  final createdAt =
      v2 ? _isoTime(json['dateOfJournal']) : _epochTime(json['date_journal']);
  if (createdAt == null) return null;
  // The time as it read where the entry was written, not where it is
  // imported.
  final created = wallClockInZone(createdAt, json['timezone'] as String?);
  final modified =
      (v2 ? _isoTime(json['updatedAt']) : _epochTime(json['date_modified']))
              ?.toLocal() ??
          created.wall;

  final text = json['text'] as String? ?? '';
  final markdown = switch (json['type']) {
    'html' => html2md.convert(text).trim(),
    _ => text,
  };

  final place = v2 ? json['location'] as Map? : json;
  final address = json['address'] as String? ?? '';
  final location = switch ((
    _coordinate(place?['lat'], 90),
    _coordinate(place?[v2 ? 'lng' : 'lon'], 180)
  )) {
    (final double lat, final double lon) => EntryLocation(
        latitude: lat, longitude: lon, name: address.isEmpty ? null : address),
    _ => EntryLocation(name: address.isEmpty ? null : address),
  };

  final weather = json['weather'] as Map?;
  final weatherCode = switch (weather?['id']) {
    final int id => wmoFromOpenWeather(id),
    _ => null,
  };
  final temperature =
      (weather?[v2 ? 'degreeC' : 'degree_c'] as num?)?.toDouble();

  return ImportedEntry(
    Entry(
      text: markdown,
      timeCreate: created.wall,
      utcOffset: created.utcOffset,
      timeModified: modified,
      location: location.isEmpty ? null : location,
    ),
    weather:
        weatherCode == null || temperature == null || temperature.abs() > 100
            ? null
            : EntryWeather(code: weatherCode, temperature: temperature),
    tags: [
      for (final tag in json['tags'] as List? ?? const [])
        if (tag is String) (name: tag, value: null),
      if (_activities[json['activity']] case final activity?)
        (name: activity.label(l10n), value: null),
    ],
    favorite: json['favourite'] == true,
    photos: [
      for (final name in json['photos'] as List? ?? const [])
        if (name is String)
          if (photo(name) case final found?) found,
    ],
  );
}

DateTime? _epochTime(Object? millis) => switch (millis) {
      final int ms when ms > 0 =>
        DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true),
      _ => null,
    };

DateTime? _isoTime(Object? text) => switch (text) {
      final String iso => DateTime.tryParse(iso)?.toUtc(),
      _ => null,
    };

double? _coordinate(Object? value, double limit) => switch (value) {
      final num n when n.abs() <= limit && n != _unset => n.toDouble(),
      _ => null,
    };

/// Writes entries as a Journey backup: `<id>.json` per entry, photos beside.
class JourneyExportWriter implements ArchiveExportWriter {
  JourneyExportWriter(this.store);

  final FileStore store;

  @override
  Future<void> write(ExportedEntry exported) async {
    final entry = exported.entry;
    if (entry.isSealed || entry.isHidden) return;
    final created = entry.journalInstant.millisecondsSinceEpoch;
    // Journey ids are the creation time and a hex suffix.
    final id =
        '$created-${(entry.id ?? created).toRadixString(16).padLeft(16, '0')}';

    final photos = <String>[];
    for (final (index, (image, bytes)) in exported.images.indexed) {
      final name = '$id-$index${p.extension(image.imgPath)}';
      await store.write(name, bytes);
      photos.add(name);
    }

    final location = entry.location;
    final weather = exported.weather;
    final json = {
      'id': id,
      'text': entry.markdown,
      'preview_text': entry.markdown.length > 512
          ? entry.markdown.substring(0, 512)
          : entry.markdown,
      'type': 'markdown',
      'date_journal': created,
      'date_modified': entry.timeModified.millisecondsSinceEpoch,
      'timezone': zoneForOffset(entry.writtenOffset) ?? '',
      'address': location?.name ?? '',
      'lat': location?.latitude ?? _unset,
      'lon': location?.longitude ?? _unset,
      'weather': {
        'id': weather == null ? -1 : openWeatherFromWmo(weather.code),
        'degree_c': weather?.temperature ?? _unset,
        'description': '',
        'icon': weather == null
            ? ''
            : openWeatherIconFromWmo(weather.code,
                night: isNight(entry.timeCreate)),
        'place': '',
      },
      'favourite': exported.favorite,
      'tags': [for (final tag in exported.tags) tag.name],
      'photos': photos,
      'mood': 0,
      'sentiment': 0.0,
      'label': '',
      'folder': '',
      'music_artist': '',
      'music_title': '',
      'linked_account_id': '',
    };
    await store.write(
        '$id.json', Uint8List.fromList(utf8.encode(jsonEncode(json))));
  }

  @override
  Future<void> close() async {}
}
