// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/utils/exif_orientation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;

/// Photos made small for keeping in a diary: lossy WebP, which every
/// platform the app runs on can show, at most about
/// [AppConfig.compressedPhotoBytes]. The photo itself is usually kept
/// elsewhere (the camera roll); this copy only has to look right here.
class PhotoCompression {
  PhotoCompression._();

  static const String extension = '.webp';

  /// [bytes] as a compressed photo, or null when there is nothing to gain:
  /// already small enough, an animation, or not a picture this can read.
  /// Its orientation is applied to the pixels; other metadata is not kept.
  static Future<Uint8List?> compress(Uint8List bytes, {String? name}) async {
    final config = AppConfig.instance;
    final target = config.compressedPhotoBytes;
    if (bytes.length <= target) return null;
    if (name != null && name.toLowerCase().endsWith('.gif')) return null;
    final shortSide = config.compressedPhotoShortSide;
    final qualities = config.compressedPhotoQualities;
    final orientation = ExifOrientation.read(bytes);
    Uint8List? best;
    // Android's own encoder is quicker; it cannot mirror, so a mirrored
    // photo goes the portable way.
    if (Platform.isAndroid && !ExifOrientation.isMirrored(orientation)) {
      for (final quality in qualities) {
        final out = await FlutterImageCompress.compressWithList(bytes,
            minWidth: shortSide,
            minHeight: shortSide,
            quality: quality,
            format: CompressFormat.webp);
        if (out.isEmpty) break;
        best = out;
        if (out.length <= target) break;
      }
    }
    best ??=
        await Isolate.run(() => _portable(bytes, shortSide, qualities, target));
    return best == null || best.length >= bytes.length ? null : best;
  }

  static Uint8List? _portable(
      Uint8List bytes, int shortSide, List<int> qualities, int target) {
    final decoded = img.decodeImage(bytes);
    if (decoded == null || decoded.numFrames > 1) return null;
    final upright = img.bakeOrientation(decoded);
    final scale = shortSide / min(upright.width, upright.height);
    final sized = scale >= 1
        ? upright
        : img.copyResize(upright,
            width: (upright.width * scale).round(),
            height: (upright.height * scale).round(),
            interpolation: img.Interpolation.average);
    Uint8List? best;
    for (final quality in qualities) {
      best = img.encodeWebP(sized, lossless: false, quality: quality);
      if (best.length <= target) break;
    }
    return best;
  }
}
