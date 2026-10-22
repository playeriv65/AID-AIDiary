// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';

import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/services/media_import.dart';
import 'package:aid_diary/utils/photo_metadata.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class EntryImageActions {
  static Future<void> takePhoto(
      ValueChanged<List<String>> onChangedImage) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final imageName =
          await MediaImport.storeImage(pickedFile.path, name: pickedFile.name);
      if (imageName == null) return;
      onChangedImage([imageName]);
      if (Platform.isAndroid) {
        await File(pickedFile.path).delete();
      }
    }
  }

  /// Adds photos and videos from the gallery; videos go to [onVideo].
  /// [onMetadata] gets the first photo's date and place, read before
  /// compression can drop them.
  static Future<void> pickFromGallery(ValueChanged<List<String>> onChangedImage,
      {required Future<void> Function(XFile) onVideo,
      ValueChanged<PhotoMetadata>? onMetadata}) async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultipleMedia();

    final newImages = <String>[];
    PhotoMetadata? metadata;
    for (final file in pickedFiles) {
      if (MediaKind.of(file.name) == MediaKind.video) {
        await onVideo(file);
        continue;
      }
      if (onMetadata != null && metadata == null) {
        final read = PhotoMetadata.read(await file.readAsBytes());
        if (!read.isEmpty) metadata = read;
      }
      final imageName =
          await MediaImport.storeImage(file.path, name: file.name);
      if (imageName != null) {
        newImages.add(imageName);
      }
      if (Platform.isAndroid) {
        await File(file.path).delete();
      }
    }
    onChangedImage(newImages);
    if (metadata != null) onMetadata!(metadata);
  }

  static Future<List<String>> importSharedImages(List<String> paths) async {
    final newImages = <String>[];
    for (final path in paths) {
      final imageName = await MediaImport.storeImage(path);
      if (imageName != null) {
        newImages.add(imageName);
      }
    }
    return newImages;
  }
}
