// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';
import 'dart:isolate';

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/utils/exif_orientation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;

/// A video above [AppConfig.maxVideoBytes]: attachments are held in memory
/// while stored and synced, so it is refused.
class MediaTooLargeException implements Exception {
  const MediaTooLargeException(this.name);

  final String name;

  @override
  String toString() => '$name is larger than the video size limit';
}

/// Turns files on this device into entry attachments, whoever picked them:
/// the GUI's pickers and recorder, or the `entry.attach` action.
class MediaImport {
  /// Whether [name] has an extension the app takes as a photo, video or
  /// voice recording.
  static bool supports(String name) {
    final extension = p.extension(name).toLowerCase();
    final config = AppConfig.instance;
    return [
      ...config.imageExtensions,
      ...config.videoExtensions,
      ...config.audioExtensions,
    ].contains(extension);
  }

  /// Stores the file at [path] as an attachment of the kind its extension
  /// names; null when it could not be written.
  static Future<String?> store(String path, {String? name}) =>
      switch (MediaKind.of(name ?? path)) {
        MediaKind.image => storeImage(path, name: name),
        MediaKind.video => storeVideo(path, name: name),
        MediaKind.audio => storeAudio(path, name: name),
      };

  /// Stores a photo compressed as the image quality setting asks.
  static Future<String?> storeImage(String path, {String? name}) async {
    final quality = ConfigProvider.instance.get(Settings.imageQualityLevel);
    return ImageStorage.instance
        .create(name ?? p.basename(path), await _compress(path, quality));
  }

  /// Stores a video as it is; throws [MediaTooLargeException] when it is
  /// over the size limit.
  static Future<String?> storeVideo(String path, {String? name}) async {
    final file = File(path);
    if (await file.length() > AppConfig.instance.maxVideoBytes) {
      throw MediaTooLargeException(name ?? p.basename(path));
    }
    return ImageStorage.instance
        .create(name ?? p.basename(path), await file.readAsBytes());
  }

  /// Stores a voice note or other audio as it is.
  static Future<String?> storeAudio(String path, {String? name}) async =>
      ImageStorage.instance
          .create(name ?? p.basename(path), await File(path).readAsBytes());

  static Future<Uint8List> _compress(String path, String imageQuality) async {
    final width =
        (ConfigProvider.imageQualityMaxSizeMapping[imageQuality] ?? 1600)
            .toInt();
    final quality =
        ConfigProvider.imageQualityCompressionMapping[imageQuality] ?? 100;

    if ((p.extension(path).toLowerCase() == ".gif") ||
        (imageQuality == ImageQuality.noCompression)) {
      return File(path).readAsBytes();
    }
    if (Platform.isAndroid) {
      final original = await File(path).readAsBytes();
      final orientation = ExifOrientation.read(original);
      final mirrored = ExifOrientation.isMirrored(orientation);
      final compressed = await FlutterImageCompress.compressWithFile(path,
          quality: quality,
          minWidth: width,
          minHeight: width,
          autoCorrectionAngle: !mirrored,
          keepExif: true);
      if (compressed == null) return original;
      return mirrored
          ? ExifOrientation.bake(compressed, orientation!, quality: quality)
          : compressed;
    }
    return Isolate.run(() async {
      final originalImage = await img.decodeImageFile(path);
      if (originalImage == null) return File(path).readAsBytesSync();

      // Compressing never enlarges a small picture.
      final resizedImage = originalImage.width > width
          ? img.copyResize(
              originalImage,
              width: width,
              interpolation: img.Interpolation.average,
            )
          : originalImage;
      resizedImage.exif = originalImage.exif;
      return img.encodeJpg(resizedImage, quality: quality);
    });
  }
}
