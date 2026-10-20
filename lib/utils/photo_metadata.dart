// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// When and where a photo was taken, from its EXIF data.
class PhotoMetadata {
  const PhotoMetadata({this.taken, this.latitude, this.longitude});

  final DateTime? taken;
  final double? latitude;
  final double? longitude;

  bool get hasPlace => latitude != null && longitude != null;
  bool get isEmpty => taken == null && !hasPlace;

  /// Reads a JPEG's EXIF; empty for other formats or unreadable data.
  static PhotoMetadata read(Uint8List bytes) {
    try {
      final exif = img.decodeJpgExif(bytes);
      if (exif == null) return const PhotoMetadata();
      final gps = exif.gpsIfd;
      final latitude = _coordinate(gps[0x0002], gps.gpsLatitudeRef, 'S');
      final longitude = _coordinate(gps[0x0004], gps.gpsLongitudeRef, 'W');
      // 0,0 is what some cameras write when they have no fix.
      final placed = latitude != null &&
          longitude != null &&
          !(latitude == 0 && longitude == 0);
      return PhotoMetadata(
        // DateTimeOriginal, else the file's DateTime.
        taken: parseDate(exif.exifIfd[0x9003]?.toString()) ??
            parseDate(exif.imageIfd[0x0132]?.toString()),
        latitude: placed ? latitude : null,
        longitude: placed ? longitude : null,
      );
    } catch (_) {
      return const PhotoMetadata();
    }
  }

  /// EXIF's "2026:10:19 15:53:00", a local time.
  static DateTime? parseDate(String? text) {
    final match = RegExp(r'^(\d{4}):(\d{2}):(\d{2}) (\d{2}):(\d{2}):(\d{2})')
        .firstMatch(text?.trim() ?? '');
    if (match == null) return null;
    final parts = [for (var i = 1; i <= 6; i++) int.parse(match.group(i)!)];
    if (parts[0] == 0) return null;
    return DateTime(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5]);
  }

  /// Degrees, minutes and seconds to signed decimal degrees.
  static double? _coordinate(
      img.IfdValue? value, String? reference, String negative) {
    if (value == null || value.length == 0) return null;
    var degrees = 0.0;
    for (var i = 0; i < value.length && i < 3; i++) {
      degrees += value.toDouble(i) / [1, 60, 3600][i];
    }
    return reference?.trim().toUpperCase() == negative ? -degrees : degrees;
  }
}
