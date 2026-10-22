// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:math' as math;
import 'package:crypto/crypto.dart';

class LocalPhoto {
  const LocalPhoto(
      {required this.id, required this.taken, this.latitude, this.longitude});
  final String id;
  final DateTime taken;
  final double? latitude;
  final double? longitude;
  String get fingerprint => sha256
      .convert(utf8.encode(jsonEncode([id, taken.toIso8601String()])))
      .toString();
  bool get hasLocation =>
      latitude != null &&
      longitude != null &&
      latitude!.isFinite &&
      longitude!.isFinite &&
      latitude!.abs() <= 90 &&
      longitude!.abs() <= 180 &&
      !(latitude == 0 && longitude == 0);
}

class PhotoSuggestion {
  PhotoSuggestion(List<LocalPhoto> photos)
      : photos = List.unmodifiable(photos),
        id = sha256
            .convert(utf8
                .encode((photos.map((p) => p.id).toList()..sort()).join('\n')))
            .toString();
  final String id;
  final List<LocalPhoto> photos;
  DateTime get day => DateTime(photos.first.taken.year,
      photos.first.taken.month, photos.first.taken.day);
  LocalPhoto? get placed => photos.where((p) => p.hasLocation).firstOrNull;
  Map<String, Object?> toJson() => {
        'id': id,
        'day': day.toIso8601String(),
        'count': photos.length,
        'latitude': placed?.latitude,
        'longitude': placed?.longitude
      };
}

double photoDistance(double aLat, double aLon, double bLat, double bLon) {
  const radians = math.pi / 180;
  final dLat = (bLat - aLat) * radians;
  final dLon = (bLon - aLon) * radians;
  final h = math.pow(math.sin(dLat / 2), 2) +
      math.cos(aLat * radians) *
          math.cos(bLat * radians) *
          math.pow(math.sin(dLon / 2), 2);
  return 6371000 * 2 * math.asin(math.sqrt(h.clamp(0, 1)));
}

/// Deterministic sessions, never inferred image subjects or activities. Missing
/// coordinates stay missing; an album name is never presented as a place.
List<PhotoSuggestion> groupPhotoSuggestions(List<LocalPhoto> photos) {
  final ordered = List<LocalPhoto>.of(photos)
    ..sort((a, b) {
      final time = a.taken.compareTo(b.taken);
      return time == 0 ? a.id.compareTo(b.id) : time;
    });
  final groups = <PhotoSuggestion>[];
  var current = <LocalPhoto>[];
  for (final photo in ordered) {
    final previous = current.lastOrNull;
    final anchor = current.where((p) => p.hasLocation).firstOrNull;
    final distant = photo.hasLocation &&
        anchor != null &&
        photoDistance(photo.latitude!, photo.longitude!, anchor.latitude!,
                anchor.longitude!) >
            1000;
    if (previous != null &&
        (current.length >= 20 ||
            distant ||
            photo.taken.difference(previous.taken) > const Duration(hours: 3) ||
            photo.taken.year != previous.taken.year ||
            photo.taken.month != previous.taken.month ||
            photo.taken.day != previous.taken.day)) {
      if (current.length >= 2) groups.add(PhotoSuggestion(current));
      current = [];
    }
    current.add(photo);
  }
  if (current.length >= 2) groups.add(PhotoSuggestion(current));
  return groups.reversed.toList();
}
