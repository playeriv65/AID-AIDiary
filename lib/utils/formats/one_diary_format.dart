// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:typed_data';

import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/utils/formats/time_zones.dart';
import 'package:aid_diary/utils/imports/import_archive.dart';
import 'package:aid_diary/utils/imports/import_helpers.dart';
import 'package:crypto/crypto.dart' as hash;
import 'package:html2md/html2md.dart' as html2md;
import 'package:lat_lng_to_timezone/lat_lng_to_timezone.dart' as geo;
import 'package:path/path.dart' as p;
import 'package:pointycastle/export.dart';

/// Reads the independently encrypted members of a One Diary v3 ZIP.
/// Decryption is local and never authenticates a backup: the source format
/// uses CBC with no MAC. Validate the complete structure before adding entries.
class OneDiaryCodec {
  OneDiaryCodec(this.protocol);

  final Map<String, dynamic> protocol;

  Object? decode(String name, Uint8List bytes) {
    try {
      final key = (protocol['payloadKeys'] as Map)[name] as String;
      final cipher =
          PaddedBlockCipherImpl(PKCS7Padding(), CBCBlockCipher(AESEngine()))
            ..init(
                false,
                PaddedBlockCipherParameters(
                    ParametersWithIV(
                        KeyParameter(Uint8List.fromList(
                            hash.sha256.convert(utf8.encode(key)).bytes)),
                        Uint8List(16)),
                    null));
      final encrypted = base64.decode(utf8.decode(bytes).trim());
      if (encrypted.isEmpty || encrypted.length % 16 != 0) {
        throw const FormatException();
      }
      return jsonDecode(utf8.decode(cipher.process(encrypted)));
    } catch (_) {
      // Never include ciphertext, decrypted text or a diary field in errors.
      throw FormatException('Invalid One Diary backup member: $name');
    }
  }
}

/// Decodes the original UTC moments and explicit diary dates, independently
/// of the importing device's date and its late-night diary-day preference.
Future<List<ImportedEntry>> decodeOneDiaryArchive(
    ArchiveFiles files, Map<String, dynamic> protocol) async {
  final codec = OneDiaryCodec(protocol);
  Future<Object?> member(String name, {bool required = true}) async {
    final bytes = await files.read(name);
    if (bytes == null) {
      if (!required) return null;
      throw FormatException('Missing One Diary backup member: $name');
    }
    return codec.decode(name, bytes);
  }

  if (await member('version') != protocol['version']) {
    throw const FormatException('Unsupported One Diary backup version');
  }
  final rows = _objects(await member('source.json'), 'source.json');
  final categories = <String, String>{};
  for (final item in _objects(await member('category.json'), 'category.json')) {
    categories[_string(item['uuid'])] = _string(item['name']);
  }
  final tagNames = <String, String>{};
  for (final item in _objects(
      await member('tag.json', required: false) ?? [], 'tag.json')) {
    tagNames[_string(item['uuid'])] = _string(item['name']);
  }
  // Templates are not diary entries. Validate this payload if present rather
  // than treating unreadable auxiliary metadata as a successful full import.
  final models =
      _objects(await member('model.json', required: false) ?? [], 'model.json');
  if (models.isNotEmpty) {
    throw const FormatException('One Diary templates are not supported');
  }

  final available = <String, String>{};
  for (final path in files.paths) {
    final name = p.posix.basename(path);
    if (available.containsKey(name)) {
      throw const FormatException('Ambiguous One Diary attachment name');
    }
    available[name] = path;
  }
  final entries = <ImportedEntry>[];
  for (final row in rows) {
    if (row['deleted'] == true) continue;
    final id = _string(row['uuid']);
    if (id.isEmpty) {
      throw const FormatException('Missing One Diary entry identifier');
    }
    final instant = _epoch(row['createTime']);
    final day = _diaryDay(row);
    final place =
        _location(row, (protocol['coordinateScale'] as num).toDouble());
    final zone = place?.hasCoordinates == true
        ? geo.latLngToTimezoneString(place!.latitude!, place.longitude!)
        : null;
    final created = wallClockInZone(instant, zone);
    // Unknown source zones retain the instant using the importing device's
    // offset. No home country, category or guessed residency is imposed.
    final offset =
        created.utcOffset ?? instant.toLocal().timeZoneOffset.inMinutes;
    final title = _string(row['title']);
    final weatherCode =
        (protocol['weatherCodes'] as Map?)?[_string(row['weather'])] as int?;
    final temperatureText = _string(row['temperature']);
    final temperatureMatch = RegExp(r'^\s*(-?\d+(?:\.\d+)?)\s*(?:℃|°C)\s*$')
        .firstMatch(temperatureText);
    final temperature =
        temperatureMatch == null ? null : double.parse(temperatureMatch[1]!);
    final body = _string(row['content']);
    final markdown = _html.hasMatch(body) ? html2md.convert(body) : body;
    final tags = <String>{};
    final category = categories[_string(row['category'])];
    if (category != null && category.isNotEmpty) tags.add(category);
    final type = _string(row['type']);
    if (type.isNotEmpty) tags.add(type);
    for (final token in _string(row['tag']).split('|')) {
      if (token.isEmpty) continue;
      final name = tagNames[token];
      if (name == null) {
        throw const FormatException('Unknown One Diary tag reference');
      }
      tags.add(name);
    }
    final photos = <ImportedPhoto>[];
    final photoHashes = <String>[];
    for (final field in [
      'images',
      'localImages',
      'audio',
      'localAudio',
      'draw',
      'localDraw'
    ]) {
      for (final reference in _string(row[field]).split('|')) {
        if (reference.isEmpty) continue;
        final uri = Uri.tryParse(reference);
        final name = uri != null && uri.pathSegments.isNotEmpty
            ? uri.pathSegments.last
            : p.posix.basename(reference.replaceAll('\\', '/'));
        final path = available[name];
        if (path == null) {
          throw const FormatException(
              'A One Diary attachment is missing from the backup');
        }
        if (photos.any((item) => item.name == name)) continue;
        final bytes = await files.read(path);
        if (bytes == null || bytes.isEmpty) {
          throw const FormatException('Empty One Diary attachment');
        }
        photos.add(ImportedPhoto(name, () => files.read(path)));
        photoHashes.add(hash.sha256.convert(bytes).toString());
      }
    }
    final sourceJson = jsonEncode(_canonical(row));
    entries.add(ImportedEntry(
      Entry(
        text: [
          if (title.isNotEmpty) '# $title',
          if (markdown.isNotEmpty) markdown
        ].join('\n\n'),
        timeCreate: created.wall,
        timeModified: _epoch(row['updateTime'] ?? row['createTime']).toLocal(),
        utcOffset: offset,
        day: day,
        location: place,
        weather: weatherCode == null || temperature == null
            ? null
            : EntryWeather(code: weatherCode, temperature: temperature),
        isHidden: row['isHidden'] == true,
      ),
      tags: [for (final name in tags) (name: name, value: null)],
      photos: photos,
      source: ImportedSource(
          format: 'one_diary',
          id: id,
          hash: hash.sha256
              .convert(utf8.encode(jsonEncode([sourceJson, photoHashes])))
              .toString(),
          json: sourceJson),
    ));
  }
  return entries;
}

final _html = RegExp(
    r'<(?:p|div|br|span|b|i|strong|em|ul|ol|li|h[1-6])(?:\s|/?>)',
    caseSensitive: false);

List<Map<String, dynamic>> _objects(Object? value, String member) {
  if (value is! List || value.any((row) => row is! Map<String, dynamic>)) {
    throw FormatException('Invalid One Diary list: $member');
  }
  return value.cast<Map<String, dynamic>>();
}

String _string(Object? value) {
  if (value == null) return '';
  if (value is! String) {
    throw const FormatException('Invalid One Diary text field');
  }
  return value;
}

DateTime _epoch(Object? value) {
  if (value is! int || value <= 0) {
    throw const FormatException('Invalid One Diary timestamp');
  }
  return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
}

DateTime _diaryDay(Map<String, dynamic> row) {
  final year = row['year'], month = row['monthOfYear'], day = row['dayOfMonth'];
  if (year is! int || month is! int || day is! int || year < 1 || year > 9999) {
    throw const FormatException('Invalid One Diary diary date');
  }
  final result = DateTime(year, month, day);
  if (result.year != year || result.month != month || result.day != day) {
    throw const FormatException('Invalid One Diary diary date');
  }
  return result;
}

EntryLocation? _location(Map<String, dynamic> row, double scale) {
  final address = _string(row['address']);
  var lat = (row['latitude'] as num?)?.toDouble();
  var lon = (row['longitude'] as num?)?.toDouble();
  if (lat != null && lon != null && (lat.abs() > 90 || lon.abs() > 180)) {
    lat /= scale;
    lon /= scale;
  }
  if (lat == null ||
      lon == null ||
      !lat.isFinite ||
      !lon.isFinite ||
      lat.abs() > 90 ||
      lon.abs() > 180 ||
      (lat == 0 && lon == 0)) {
    lat = null;
    lon = null;
  }
  if (lat == null && address.isEmpty) return null;
  return EntryLocation(
      latitude: lat, longitude: lon, name: address.isEmpty ? null : address);
}

Object? _canonical(Object? value) => switch (value) {
      final Map map => {
          for (final key in map.keys.cast<String>().toList()..sort())
            key: _canonical(map[key])
        },
      final List list => [for (final item in list) _canonical(item)],
      _ => value,
    };
