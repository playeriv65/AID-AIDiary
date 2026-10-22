// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/services/wallpaper_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';

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
    // Android hands over a cache copy; desktop pickers return the original.
    await WallpaperService.setPhoto(picked.path,
        deleteSource: Platform.isAndroid);
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
