// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Backgrounds for the list panes: a tinted pattern or the user's photo.
enum WallpaperKind {
  none,
  dots,
  grid,
  lines,
  photo;

  static WallpaperKind fromName(String name) =>
      values.where((kind) => kind.name == name).firstOrNull ?? none;
}

class WallpaperService {
  /// Keeps a copy of the photo at [path] as the wallpaper and drops the
  /// earlier copies. [deleteSource] removes the original too, for a cache
  /// copy a picker handed over.
  static Future<void> setPhoto(String path, {bool deleteSource = false}) async {
    final directory = Directory(p.join(
        (await getApplicationSupportDirectory()).path,
        AppConfig.instance.wallpaperDirectory));
    await directory.create(recursive: true);
    // A new name per pick, so the image cache never shows the old photo.
    final target = p.join(directory.path,
        'wallpaper-${DateTime.now().millisecondsSinceEpoch}${p.extension(path)}');
    await File(path).copy(target);
    if (deleteSource) await File(path).delete();
    await for (final old in directory.list()) {
      if (old.path != target) await old.delete();
    }
    final settings = ConfigProvider.instance;
    await settings.set(Settings.wallpaperImage, target);
    await settings.set(Settings.wallpaper, WallpaperKind.photo.name);
  }
}
