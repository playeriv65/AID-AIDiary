// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/models/photo_suggestion.dart';
import 'package:aid_diary/services/media_import.dart';
import 'package:aid_diary/utils/photo_metadata.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

abstract interface class LocalPhotoSource {
  Future<List<LocalPhoto>> recent(
      {required DateTime after, required bool locations});
  Future<String> copyForImport(String id);
  Future<void> releaseCopy(String path);
}

class DevicePhotoSource implements LocalPhotoSource {
  static const _channel = MethodChannel('aid.local_photos');
  static const maxPhotoBytes = 32 * 1024 * 1024;
  final _scannedFiles = <String>{};
  @override
  Future<List<LocalPhoto>> recent(
      {required DateTime after, required bool locations}) async {
    if (Platform.isAndroid) {
      final rows = await _channel.invokeListMethod<dynamic>('query', {
            'after': after.millisecondsSinceEpoch,
            'limit': 500,
            'locations': locations
          }) ??
          [];
      return [
        for (final row in rows.take(500))
          LocalPhoto(
              id: (row as Map)['id'] as String,
              taken: DateTime.fromMillisecondsSinceEpoch(
                  (row['taken'] as num).toInt()),
              latitude: (row['latitude'] as num?)?.toDouble(),
              longitude: (row['longitude'] as num?)?.toDouble())
      ];
    }
    final folder = ConfigProvider.instance.get(Settings.localPhotoFolder);
    if (folder.isEmpty) return [];
    final directory = Directory(folder);
    if (!await directory.exists()) {
      throw const FileSystemException(
          'The selected photo folder is unavailable');
    }
    _scannedFiles.clear();
    final candidates = <({String path, DateTime modified, int size})>[];
    var examined = 0;
    // Never recurse or follow symlinks into another user's files.
    await for (final entity in directory.list(followLinks: false)) {
      if (++examined > 5000) break;
      if (entity is! File ||
          !['.jpg', '.jpeg', '.png', '.webp']
              .contains(p.extension(entity.path).toLowerCase())) {
        continue;
      }
      final stat = await entity.stat();
      if (stat.size <= 0 ||
          stat.size > maxPhotoBytes ||
          stat.modified.isBefore(after)) {
        continue;
      }
      candidates
          .add((path: entity.path, modified: stat.modified, size: stat.size));
    }
    candidates.sort((a, b) => b.modified.compareTo(a.modified));
    final photos = <LocalPhoto>[];
    for (final item in candidates.take(500)) {
      // EXIF is parsed without decoding pixels. Only the selected directory is
      // read; original images are never imported by this metadata scan.
      final metadata =
          ['.jpg', '.jpeg'].contains(p.extension(item.path).toLowerCase())
              ? await _headerMetadata(item.path)
              : const PhotoMetadata();
      final taken = metadata.taken ?? item.modified;
      if (taken.isBefore(after)) continue;
      _scannedFiles.add(item.path);
      photos.add(LocalPhoto(
          id: item.path,
          taken: taken,
          latitude: locations ? metadata.latitude : null,
          longitude: locations ? metadata.longitude : null));
    }
    return photos;
  }

  Future<PhotoMetadata> _headerMetadata(String path) async {
    final file = await File(path).open();
    try {
      return PhotoMetadata.read(await file.read(512 * 1024));
    } finally {
      await file.close();
    }
  }

  @override
  Future<String> copyForImport(String id) async {
    if (Platform.isAndroid) {
      final path = await _channel.invokeMethod<String>('copy', {'id': id});
      if (path == null) {
        throw const FileSystemException('Photo copy is unavailable');
      }
      return path;
    }
    if (!_scannedFiles.contains(id) ||
        await FileSystemEntity.type(id, followLinks: false) !=
            FileSystemEntityType.file ||
        await File(id).length() > maxPhotoBytes) {
      throw const FileSystemException('Photo was not in the recent local scan');
    }
    return id;
  }

  @override
  Future<void> releaseCopy(String path) async {
    // Desktop files are originals; only our Android cache copies are removed.
    if (Platform.isAndroid) {
      final file = File(path);
      if (await file.exists()) await file.delete();
    }
  }
}

class LocalPhotoSuggestions {
  LocalPhotoSuggestions({LocalPhotoSource? source})
      : source = source ?? DevicePhotoSource();
  static final instance = LocalPhotoSuggestions();
  final LocalPhotoSource source;
  final _cards = <String, PhotoSuggestion>{};
  final _creating = <String>{};

  Future<List<PhotoSuggestion>> scan({int days = 7, DateTime? now}) async {
    if (days < 1 || days > 30) throw ArgumentError('Days must be from 1 to 30');
    final current = now ?? DateTime.now();
    final after = current.subtract(Duration(days: days));
    final locations =
        ConfigProvider.instance.get(Settings.photoSuggestionsLocation);
    final raw = await source.recent(after: after, locations: locations);
    final photos = locations
        ? raw
        : [
            for (final photo in raw)
              LocalPhoto(id: photo.id, taken: photo.taken)
          ];
    final imported =
        ConfigProvider.instance.get(Settings.importedPhotoSuggestions).toSet();
    final dismissed =
        ConfigProvider.instance.get(Settings.dismissedPhotoSuggestions).toSet();
    final cards = groupPhotoSuggestions(photos
            .where((p) =>
                !p.taken.isAfter(current) &&
                !p.taken.isBefore(after) &&
                !imported.contains(p.fingerprint))
            .take(500)
            .toList())
        .where((card) => !dismissed.contains(card.id))
        .toList();
    _cards
      ..clear()
      ..addEntries(cards.map((card) => MapEntry(card.id, card)));
    return cards;
  }

  String? placeName(PhotoSuggestion card) {
    if (!ConfigProvider.instance.get(Settings.photoSuggestionsLocation)) {
      return null;
    }
    final photo = card.placed;
    if (photo == null) return null;
    for (final item
        in ConfigProvider.instance.get(Settings.savedPlaces).take(500)) {
      if (item is Map &&
          item['name'] is String &&
          item['latitude'] is num &&
          item['longitude'] is num &&
          photoDistance(
                  photo.latitude!,
                  photo.longitude!,
                  (item['latitude'] as num).toDouble(),
                  (item['longitude'] as num).toDouble()) <
              500) {
        return item['name'] as String;
      }
    }
    return null;
  }

  Future<void> dismiss(String id) async {
    final ids = ConfigProvider.instance
        .get(Settings.dismissedPhotoSuggestions)
        .whereType<String>()
        .where((old) => old != id)
        .toList()
      ..add(id);
    await ConfigProvider.instance.set(Settings.dismissedPhotoSuggestions,
        ids.length > 500 ? ids.sublist(ids.length - 500) : ids);
    _cards.remove(id);
  }

  Future<Entry> create(String id,
      {String text = '', void Function(String)? progress}) async {
    final card = _cards[id];
    if (card == null) {
      throw StateError('Run a local photo scan before choosing this card');
    }
    if (!_creating.add(id)) {
      throw StateError('This photo card is already being imported');
    }
    final names = <String>[];
    var committed = false;
    try {
      for (final photo in card.photos) {
        progress?.call('${names.length + 1}/${card.photos.length}');
        final path = await source.copyForImport(photo.id);
        try {
          final name = await MediaImport.storeImage(path, deduplicate: false);
          if (name == null) {
            throw const FileSystemException(
                'Could not store the selected photo');
          }
          names.add(name);
        } finally {
          await source.releaseCopy(path);
        }
      }
      final now = DateTime.now();
      final placed =
          ConfigProvider.instance.get(Settings.photoSuggestionsLocation)
              ? card.placed
              : null;
      final entry = Entry(
          text: text,
          timeCreate: now,
          timeModified: now,
          day: card.day,
          utcOffset: now.timeZoneOffset.inMinutes,
          location: placed == null
              ? null
              : EntryLocation(
                  latitude: placed.latitude,
                  longitude: placed.longitude,
                  name: placeName(card)));
      final session = EntryStore.instance.beginDraft();
      final saved = await session.save((_) => EntryDraft(
          entry: entry,
          images: EntryImage.appendRanked([], names, entryId: -1)));
      await session.commit();
      committed = true;
      final imported = ConfigProvider.instance
          .get(Settings.importedPhotoSuggestions)
          .whereType<String>()
          .toSet()
        ..addAll(card.photos.map((photo) => photo.fingerprint));
      final history = imported.toList();
      await ConfigProvider.instance.set(
          Settings.importedPhotoSuggestions,
          history.length > 2000
              ? history.sublist(history.length - 2000)
              : history);
      await dismiss(id);
      return saved;
    } catch (_) {
      if (!committed) {
        for (final name in names) {
          await ImageStorage.instance.delete(name);
        }
      }
      rethrow;
    } finally {
      _creating.remove(id);
    }
  }
}
