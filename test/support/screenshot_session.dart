// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

// Shared setup for the headless UI screenshots in tool/screenshots/. Each
// device has its own test file, so each runs in its own isolate: the image
// cache is a process-wide singleton.

import 'dart:io';
import 'dart:ui' as ui;

import 'package:daily_you/database/image_storage.dart';
import 'package:daily_you/layouts/mobile_scaffold.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/models/image.dart';
import 'package:daily_you/providers/entry_images_provider.dart';
import 'package:daily_you/providers/tags_provider.dart';
import 'package:daily_you/storage/in_memory_file_store.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'diary_app_harness.dart';

const _fonts = {
  // Latin and CJK in one variable font, under the test default family.
  'Roboto': r'C:\Windows\Fonts\NotoSansSC-VF.ttf',
  'Emoji': r'C:\Windows\Fonts\seguiemj.ttf',
};

Future<void> _loadFonts() async {
  final flutterRoot = Platform.environment['FLUTTER_ROOT'] ??
      File(Platform.resolvedExecutable)
          .parent
          .parent
          .parent
          .parent
          .parent
          .parent
          .path;
  final icons = File(
      '$flutterRoot/bin/cache/artifacts/material_fonts/materialicons-regular.otf');
  final all = {..._fonts, 'MaterialIcons': icons.path};
  for (final MapEntry(key: family, value: path) in all.entries) {
    final bytes = File(path).readAsBytesSync();
    await (FontLoader(family)
          ..addFont(Future.value(ByteData.sublistView(bytes))))
        .load();
  }
}

/// Registers the harness and returns the screenshot helpers for one file.
ScreenshotSession screenshotSession() {
  final harness = DiaryAppHarness()..register();
  final boundary = GlobalKey();
  final out = Directory('artifacts')..createSync();

  // Image caches ask path_provider for folders; give them a scratch one.
  final scratch = Directory.systemTemp.createTempSync('aid-diary-shots');
  setUpAll(() async {
    WidgetsApp.debugAllowBannerOverride = false;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/path_provider'),
            (_) async => scratch.path);
    await TestWidgetsFlutterBinding.instance.runAsync(_loadFonts);
  });
  tearDownAll(() => scratch.deleteSync(recursive: true));

  Future<void> seed(WidgetTester tester) async {
    final photos = InMemoryFileStore();
    ImageStorage.instance.overrideStores(photos, InMemoryFileStore());
    final now = DateTime.now();
    DateTime at(int daysAgo, int hour, int minute) =>
        DateTime(now.year, now.month, now.day - daysAgo, hour, minute);
    final samples = [
      (
        '# 河边散步\n空气有点冷，叶子已经黄了。回来的路上买了杯咖啡。',
        at(0, 8, 40),
        2,
        const EntryLocation(latitude: 31.24, longitude: 121.49, name: '外滩'),
        'daily_03.jpg'
      ),
      (
        '# 和小美吃午饭\n去了新开的面馆，聊了她的旅行和冬天的计划。',
        at(0, 12, 30),
        1,
        null,
        'daily_07.jpg'
      ),
      ('# 夜读\n睡前读完两章，第九章的结尾很意外。', at(1, 22, 15), 0, null, null),
      (
        '# 周末爬山\n山顶风很大，云散开以后能看到整座城市。',
        at(3, 16, 5),
        2,
        const EntryLocation(latitude: 30.25, longitude: 120.13, name: '西湖'),
        'daily_11.jpg'
      ),
      ('# 有点累\n这周事情太多，早点睡。', at(5, 23, 0), -1, null, null),
    ];
    for (final (text, time, mood, location, photo) in samples) {
      final entry = await DiaryAppHarness.addEntry(tester, text, time,
          mood: mood, location: location);
      if (photo != null) {
        await tester.runAsync(() async {
          final bytes =
              File('tool/screenshots/assets/$photo').readAsBytesSync();
          await photos.write(photo, bytes);
          await EntryImagesProvider.instance.add(EntryImage(
              entryId: entry.id, imgPath: photo, imgRank: 0, timeCreate: time));
        });
      }
      if (mood == 2) {
        await tester
            .runAsync(() => TagsProvider.instance.setFavorite(entry.id!, true));
      }
    }
  }

  Widget app() => RepaintBoundary(
        key: boundary,
        child: harness.app(const MobileScaffold(),
            themeData: ThemeData(fontFamilyFallback: const ['Emoji'])),
      );

  /// Lets real image decoding finish, then writes the frame to [name].
  /// Screens that never settle, such as a running story, pass [settle].
  Future<void> capture(WidgetTester tester, String name,
      {bool settle = true}) async {
    for (var i = 0; i < 6; i++) {
      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 400)));
      settle
          ? await tester.pumpAndSettle()
          : await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.runAsync(() async {
      final render =
          boundary.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final image = await render.toImage(pixelRatio: 1);
      final png = await image.toByteData(format: ui.ImageByteFormat.png);
      File('${out.path}/ui-$name.png')
          .writeAsBytesSync(png!.buffer.asUint8List());
    });
  }

  Future<void> tapKey(WidgetTester tester, String key) async {
    await tester.tap(find.byKey(ValueKey(key)).hitTestable().first);
    await tester.pumpAndSettle();
  }

  return ScreenshotSession(
      seed: seed, app: app, capture: capture, tapKey: tapKey);
}

class ScreenshotSession {
  ScreenshotSession(
      {required this.seed,
      required this.app,
      required this.capture,
      required this.tapKey});
  final Future<void> Function(WidgetTester) seed;
  final Widget Function() app;
  final Future<void> Function(WidgetTester, String, {bool settle}) capture;
  final Future<void> Function(WidgetTester, String) tapKey;

  /// Seeds sample entries, sizes the view and shows the app.
  Future<void> start(WidgetTester tester, Size size) async {
    await seed(tester);
    // flutter_test draws shadows as solid outlines; render real ones.
    debugDisableShadows = false;
    DiaryAppHarness.size(tester, size);
    await tester.pumpWidget(app());
    // Touch-style focus, so no keyboard focus rings show up.
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTouch;
    await tester.pumpAndSettle();
  }

  Future<void> finish(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    // Let debounced saves and image work finish before the test ends.
    await tester.pump(const Duration(seconds: 10));
    debugDisableShadows = true;
  }

  /// The first entry carrying a tag, i.e. a starred sample.
  Future<int> starredEntryId(WidgetTester tester) async => (await tester
      .runAsync(() async => TagsProvider.instance.entryTags.first.entryId))!;
}
