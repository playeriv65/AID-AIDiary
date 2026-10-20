// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';

import 'package:daily_you/config/app_config.dart';
import 'package:daily_you/config_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';
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

/// Paints the chosen wallpaper behind [child].
class DiaryWallpaper extends StatelessWidget {
  const DiaryWallpaper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final settings = ConfigProvider.instance;
    return ListenableBuilder(
      listenable: settings,
      builder: (context, _) {
        final kind = WallpaperKind.fromName(settings.get(Settings.wallpaper));
        final cs = Theme.of(context).colorScheme;
        final config = AppConfig.instance;
        final path = settings.get(Settings.wallpaperImage);
        final Widget background;
        switch (kind) {
          case WallpaperKind.none:
            return child;
          case WallpaperKind.photo:
            if (path.isEmpty) return child;
            background = Stack(fit: StackFit.expand, children: [
              Image.file(File(path),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink()),
              ColoredBox(
                  color: cs.surface
                      .withValues(alpha: config.wallpaperScrimOpacity)),
            ]);
          case WallpaperKind.dots:
          case WallpaperKind.grid:
          case WallpaperKind.lines:
            background = CustomPaint(
              painter: _PatternPainter(
                  kind: kind,
                  color: cs.outlineVariant.withValues(alpha: .6),
                  spacing: config.wallpaperPatternSpacing),
            );
        }
        return Stack(fit: StackFit.expand, children: [
          Positioned.fill(
              key: ValueKey('wallpaper-${kind.name}'), child: background),
          child,
        ]);
      },
    );
  }

  /// Lets the user pick a photo and keeps a copy as the wallpaper; returns
  /// whether one was set.
  static Future<bool> pickPhoto() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return false;
    final directory = Directory(p.join(
        (await getApplicationSupportDirectory()).path,
        AppConfig.instance.wallpaperDirectory));
    await directory.create(recursive: true);
    // A new name per pick, so the image cache never shows the old photo.
    final target = p.join(directory.path,
        'wallpaper-${DateTime.now().millisecondsSinceEpoch}${p.extension(picked.path)}');
    await File(picked.path).copy(target);
    // Android hands over a cache copy; desktop pickers return the original.
    if (Platform.isAndroid) await File(picked.path).delete();
    await for (final old in directory.list()) {
      if (old.path != target) await old.delete();
    }
    final settings = ConfigProvider.instance;
    await settings.set(Settings.wallpaperImage, target);
    await settings.set(Settings.wallpaper, WallpaperKind.photo.name);
    return true;
  }
}

class _PatternPainter extends CustomPainter {
  _PatternPainter(
      {required this.kind, required this.color, required this.spacing});

  final WallpaperKind kind;
  final Color color;
  final double spacing;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    switch (kind) {
      case WallpaperKind.dots:
        for (var y = spacing / 2; y < size.height; y += spacing) {
          for (var x = spacing / 2; x < size.width; x += spacing) {
            canvas.drawCircle(Offset(x, y), 1.4, paint);
          }
        }
      case WallpaperKind.grid:
        for (var x = spacing; x < size.width; x += spacing) {
          canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
        }
        for (var y = spacing; y < size.height; y += spacing) {
          canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
        }
      case WallpaperKind.lines:
        for (var y = spacing; y < size.height; y += spacing) {
          canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
        }
      case WallpaperKind.none:
      case WallpaperKind.photo:
        break;
    }
  }

  @override
  bool shouldRepaint(_PatternPainter old) =>
      old.kind != kind || old.color != color || old.spacing != spacing;
}
