// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/utils/local_time.dart';
import 'package:path/path.dart' as p;

const String imagesTable = 'entry_images';

/// What an attachment holds. Attachments share one table and folder; the
/// file extension tells them apart, so backups and sync need no changes.
enum MediaKind {
  image,
  video,
  audio;

  static MediaKind of(String fileName) {
    final extension = p.extension(fileName).toLowerCase();
    final config = AppConfig.instance;
    if (config.videoExtensions.contains(extension)) return video;
    if (config.audioExtensions.contains(extension)) return audio;
    return image;
  }
}

class EntryImageFields {
  static const List<String> values = [
    id,
    entryId,
    imgPath,
    imgRank,
    timeCreate
  ];
  static const String id = 'id';
  static const String entryId = 'entry_id';
  static const String imgPath = 'img_path';
  static const String imgRank = 'img_rank';
  static const String timeCreate = 'time_create';
}

class EntryImage {
  final int? id;
  int? entryId;
  final String imgPath;
  int imgRank;
  final DateTime timeCreate;

  EntryImage({
    this.id,
    required this.entryId,
    required this.imgPath,
    required this.imgRank,
    required this.timeCreate,
  });

  MediaKind get kind => MediaKind.of(imgPath);
  bool get isImage => kind == MediaKind.image;

  EntryImage copy({
    int? id,
    int? entryId,
    String? imgPath,
    int? imgRank,
    DateTime? timeCreate,
  }) =>
      EntryImage(
        id: id ?? this.id,
        entryId: entryId ?? this.entryId,
        imgPath: imgPath ?? this.imgPath,
        imgRank: imgRank ?? this.imgRank,
        timeCreate: timeCreate ?? this.timeCreate,
      );

  static List<EntryImage> appendRanked(
    List<EntryImage> images,
    List<String> newImagePaths, {
    required int entryId,
  }) {
    final result = [for (final image in images) image.copy()];
    for (final path in newImagePaths) {
      for (final image in result) {
        image.imgRank += 1;
      }
      result.add(EntryImage(
        entryId: entryId,
        imgPath: path,
        imgRank: 0,
        timeCreate: DateTime.now(),
      ));
    }
    return result;
  }

  static EntryImage fromJson(Map<String, Object?> json) => EntryImage(
        id: json[EntryImageFields.id] as int?,
        entryId: json[EntryImageFields.entryId] as int?,
        imgPath: json[EntryImageFields.imgPath] as String,
        imgRank: json[EntryImageFields.imgRank] as int,
        timeCreate: parseLocalTime(json[EntryImageFields.timeCreate] as String),
      );

  Map<String, Object?> toJson() => {
        EntryImageFields.id: id,
        EntryImageFields.entryId: entryId,
        EntryImageFields.imgPath: imgPath,
        EntryImageFields.imgRank: imgRank,
        EntryImageFields.timeCreate: timeCreate.toIso8601String(),
      };
}
