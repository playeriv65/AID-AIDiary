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
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;

// Day One's JSON export is a zip with one `<Journal>.json` per journal, each
// {"metadata": ..., "entries": [...]}, and the photos in `photos/` named by
// their MD5 hash. Entry text is Markdown that places photos with
// `![](dayone-moment://<identifier>)` and escapes punctuation with
// backslashes. Journey, Diarium and others read this format too.

/// Folder of the photos inside the zip.
const String dayOnePhotoFolder = 'photos';

const Map<String, ActivityTag> _activities = {
  'stationary': ActivityTag.still,
  'walking': ActivityTag.walking,
  'running': ActivityTag.running,
  'biking': ActivityTag.cycling,
  'automotive': ActivityTag.vehicle,
  'train': ActivityTag.vehicle,
  'flying': ActivityTag.flying,
};

final RegExp _moment = RegExp(r'!\[[^\]]*\]\(dayone-moment:/[^)]*\)\n?');
final RegExp _escape = RegExp(r'\\([\\`*_{}\[\]()#+\-.!>|~])');

/// Decodes a Day One export: every JSON file outside [dayOnePhotoFolder] is
/// a journal.
Future<List<ImportedEntry>> decodeDayOneArchive(
    ArchiveFiles files, AppLocalizations l10n) async {
  final photoPaths = {
    for (final path in files.paths)
      if (p.url.basename(p.url.dirname(path)) == dayOnePhotoFolder)
        p.url.basename(path): path,
  };
  ImportedPhoto? photo(String name) => switch (photoPaths[name]) {
        final String path => ImportedPhoto(name, () => files.read(path)),
        null => null,
      };

  final entries = <ImportedEntry>[];
  for (final path in files.paths) {
    if (p.url.extension(path).toLowerCase() != '.json' ||
        photoPaths.containsValue(path)) {
      continue;
    }
    final bytes = await files.read(path);
    if (bytes == null) continue;
    if (jsonDecode(utf8.decode(bytes)) case final Map<String, dynamic> json) {
      entries.addAll(decodeDayOneJournal(json, photo, l10n));
    }
  }
  return entries;
}

/// Decodes the entries of one journal file. [photo] finds a photo by its
/// file name in [dayOnePhotoFolder].
List<ImportedEntry> decodeDayOneJournal(Map<String, dynamic> journal,
        ImportedPhoto? Function(String name) photo, AppLocalizations l10n) =>
    [
      for (final entry in journal['entries'] as List? ?? const [])
        if (decodeDayOneEntry(entry as Map<String, dynamic>, photo, l10n)
            case final decoded?)
          decoded,
    ];

/// Decodes one entry, or returns null when it has no creation date.
ImportedEntry? decodeDayOneEntry(Map<String, dynamic> json,
    ImportedPhoto? Function(String name) photo, AppLocalizations l10n) {
  final createdAt = _time(json['creationDate']);
  if (createdAt == null) return null;
  // The time as it read where the entry was written.
  final created =
      wallClockInZone(createdAt.toUtc(), json['timeZone'] as String?);

  final text = (json['text'] as String? ?? '')
      .replaceAll(_moment, '')
      .replaceAllMapped(_escape, (match) => match[1]!)
      .trim();

  final place = json['location'] as Map?;
  final latitude = (place?['latitude'] as num?)?.toDouble();
  final longitude = (place?['longitude'] as num?)?.toDouble();
  final placeName = (place?['placeName'] ?? place?['localityName']) as String?;
  final location = EntryLocation(
      latitude: longitude == null ? null : latitude,
      longitude: latitude == null ? null : longitude,
      name: placeName == null || placeName.isEmpty ? null : placeName);

  final weather = json['weather'] as Map?;
  final weatherCode = switch (weather?['weatherCode']) {
    final String code => wmoFromDayOne(code),
    _ => null,
  };
  final temperature = (weather?['temperatureCelsius'] as num?)?.toDouble();

  final photos = [
    for (final item in json['photos'] as List? ?? const [])
      if (item case {'md5': final String md5})
        (
          order: item['orderInEntry'] as int? ?? 0,
          name: '$md5.${item['type'] as String? ?? 'jpeg'}'
        ),
  ]..sort((a, b) => a.order.compareTo(b.order));

  return ImportedEntry(
    Entry(
      text: text,
      timeCreate: created.wall,
      utcOffset: created.utcOffset,
      timeModified: _time(json['modifiedDate']) ?? created.wall,
      location: location.isEmpty ? null : location,
    ),
    weather: weatherCode == null || temperature == null
        ? null
        : EntryWeather(code: weatherCode, temperature: temperature),
    tags: [
      for (final tag in json['tags'] as List? ?? const [])
        if (tag is String) (name: tag, value: null),
      if (_activities[(json['userActivity'] as Map?)?['activityName']]
          case final activity?)
        (name: activity.label(l10n), value: null),
    ],
    favorite: json['starred'] == true,
    photos: [
      for (final item in photos)
        if (photo(item.name) case final found?) found,
    ],
  );
}

DateTime? _time(Object? text) => switch (text) {
      final String iso => DateTime.tryParse(iso)?.toLocal(),
      _ => null,
    };

String _utc(DateTime time) =>
    '${time.toUtc().toIso8601String().split('.').first}Z';

/// Writes entries as a Day One JSON export: photos into [photoStore] as they
/// come, then `Journal.json` into [journalStore] on [close].
class DayOneExportWriter implements ArchiveExportWriter {
  DayOneExportWriter({required this.journalStore, required this.photoStore});

  final FileStore journalStore;
  final FileStore photoStore;
  final List<Map<String, Object?>> _entries = [];

  @override
  Future<void> write(ExportedEntry exported) async {
    final entry = exported.entry;
    if (entry.isSealed || entry.isHidden) return;
    final photos = <Map<String, Object?>>[];
    for (final (index, (image, bytes)) in exported.images.indexed) {
      final md5Hash = md5.convert(bytes).toString();
      final type = _photoType(image.imgPath);
      await photoStore.write('$md5Hash.$type', bytes);
      photos.add({
        'identifier': _identifier('${entry.id}-$index-$md5Hash'),
        'md5': md5Hash,
        'type': type,
        'orderInEntry': index,
      });
    }

    final location = entry.location;
    final weather = exported.weather;
    _entries.add({
      'uuid': _identifier('${entry.id}-${entry.timeCreate.toIso8601String()}'),
      'creationDate': _utc(entry.journalInstant),
      if (zoneForOffset(entry.writtenOffset) case final zone?) 'timeZone': zone,
      'modifiedDate': _utc(entry.timeModified),
      'starred': exported.favorite,
      'text': [
        for (final photo in photos)
          '![](dayone-moment://${photo['identifier']})',
        entry.markdown,
      ].join('\n'),
      'tags': [for (final tag in exported.tags) tag.name],
      if (location != null && !location.isEmpty)
        'location': {
          if (location.hasCoordinates) ...{
            'latitude': location.latitude,
            'longitude': location.longitude,
          },
          if (location.name case final name?) 'placeName': name,
        },
      if (weather != null)
        'weather': {
          'weatherCode':
              dayOneFromWmo(weather.code, night: isNight(entry.timeCreate)),
          'temperatureCelsius': weather.temperature,
        },
      if (photos.isNotEmpty) 'photos': photos,
    });
  }

  @override
  Future<void> close() async {
    final journal = {
      'metadata': {'version': '1.0'},
      'entries': _entries,
    };
    await journalStore.write(
        'Journal.json', Uint8List.fromList(utf8.encode(jsonEncode(journal))));
  }

  /// Day One ids are 32 uppercase hex digits; these are derived from the
  /// entry so a re-export keeps them.
  static String _identifier(String seed) =>
      md5.convert(utf8.encode(seed)).toString().toUpperCase();

  static String _photoType(String path) {
    final type = p.extension(path).replaceFirst('.', '').toLowerCase();
    return type == 'jpg' || type.isEmpty ? 'jpeg' : type;
  }
}
