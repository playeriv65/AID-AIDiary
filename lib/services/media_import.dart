// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/services/photo_compression.dart';
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

  /// Stores a photo as it is, or compressed when the setting asks for it.
  static Future<String?> storeImage(String path,
      {String? name, bool deduplicate = true}) async {
    final original = await File(path).readAsBytes();
    final compressed = ConfigProvider.instance.get(Settings.compressPhotos)
        ? await PhotoCompression.compress(original, name: name ?? path)
        : null;
    final fileName = name ?? p.basename(path);
    return ImageStorage.instance.create(
        deduplicate
            ? (compressed == null
                ? fileName
                : p.setExtension(fileName, PhotoCompression.extension))
            : null,
        compressed ?? original,
        fileExtension: compressed == null
            ? p.extension(fileName)
            : PhotoCompression.extension);
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
}
