// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/layouts/mobile_scaffold.dart';
import 'package:aid_diary/pages/drawing_page.dart';
import 'package:aid_diary/pages/edit_entry_page.dart';
import 'package:aid_diary/pages/entry_view_page.dart';
import 'package:aid_diary/pages/local_moments_page.dart';
import 'package:aid_diary/pages/settings/appearance_settings.dart';
import 'package:aid_diary/pages/settings/sync_settings.dart';
import 'package:aid_diary/pages/settings/sync_copy_settings.dart';
import 'package:aid_diary/theme_mode_provider.dart';
import 'package:aid_diary/widgets/drawing_canvas.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../test/support/diary_app_harness.dart';
import '../../test/support/screenshot_session.dart';

void main() {
  final session = screenshotSession();

  // The screenshot harness deliberately fixes its app theme. Preview routes
  // use the same configured seed selection as MainApp for light/dark coverage.
  Future<void> open(WidgetTester tester, Widget page,
      {bool dark = false}) async {
    final context = tester.element(find.byType(MobileScaffold));
    final theme = context.read<ThemeModeProvider>();
    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute<void>(
        builder: (_) => Theme(
            data: ThemeData(
                useMaterial3: true,
                fontFamilyFallback: const ['Emoji'],
                colorScheme: ColorScheme.fromSeed(
                    seedColor: dark ? theme.darkAccentColor : theme.accentColor,
                    brightness: dark ? Brightness.dark : Brightness.light)),
            child: page)));
    await tester.pumpAndSettle();
  }

  Future<void> close(WidgetTester tester, Type type) async {
    Navigator.of(tester.element(find.byType(type))).pop();
    await tester.pumpAndSettle();
  }

  for (final (device, size) in [
    ('phone', const Size(390, 844)),
    ('tablet', const Size(1280, 800)),
  ]) {
    testWidgets('backlog $device', (tester) async {
      await session.start(tester, size);
      await DiaryAppHarness.setSetting(Settings.deviceName, '我的平板');
      await DiaryAppHarness.setSetting(
          Settings.syncTarget,
          jsonEncode({
            'type': 'webdav',
            'server': 'https://example.org/dav/',
            'username': 'storage-account',
            'spaceId': 'screenshots'
          }));
      await DiaryAppHarness.setSetting(
          Settings.lastSync, '2026-10-22T12:00:00Z');
      await open(tester, const SyncSettings());
      await session.capture(tester, '$device-sync-simple');
      await close(tester, SyncSettings);
      await open(
          tester,
          SyncCopySettings(
              load: () async => {
                    'local': {'name': '我的平板', 'present': 3, 'total': 3},
                    'devices': [
                      {
                        'name': '我的电脑',
                        'present': 3,
                        'total': 3,
                        'current': true,
                        'checkedAt': '2026-10-22T12:00:00Z'
                      },
                      {
                        'name': '我的手机',
                        'present': 1,
                        'total': 3,
                        'current': true,
                        'checkedAt': '2026-10-22T11:00:00Z'
                      },
                    ],
                    'storage': 'webdav',
                    'storageHost': 'example.org',
                    'temporaryStorage': true,
                  }));
      await session.capture(tester, '$device-sync-copies');
      await close(tester, SyncCopySettings);
      await DiaryAppHarness.setSetting(Settings.syncTarget, '');
      await DiaryAppHarness.setSetting(Settings.lastSync, '');
      await DiaryAppHarness.setSetting(Settings.followSystemColor, false);
      await DiaryAppHarness.setSetting(Settings.accentColor, 0xff587e64);
      await DiaryAppHarness.setSetting(Settings.darkTheme, 'dark');
      await DiaryAppHarness.setSetting(Settings.darkFollowSystemColor, false);
      await DiaryAppHarness.setSetting(Settings.darkAccentColor, 0xff8f6caf);
      final entry = await DiaryAppHarness.addEntry(
          tester,
          '# 留给自己的空白\n\n午后的阳光落在桌边。\n慢一点，把今天的小事记下来。\n\n下次带上画本，去河边坐一会儿。',
          DateTime.now());

      for (final (paper, decoration) in [
        ('lined', 'botanical'),
        ('grid', 'stars'),
      ]) {
        await DiaryAppHarness.setSetting(Settings.paperStyle, paper);
        await DiaryAppHarness.setSetting(Settings.paperDecoration, decoration);
        await open(tester, AddEditEntryPage(entry: entry));
        await session.capture(tester, '$device-backlog-$paper');
        await close(tester, AddEditEntryPage);
      }
      await DiaryAppHarness.setSetting(Settings.paperStyle, 'tinted');
      await DiaryAppHarness.setSetting(Settings.paperDecoration, 'washi');
      await open(tester, EntryViewPage(entryId: entry.id!));
      await session.capture(tester, '$device-backlog-tinted-reader');
      await close(tester, EntryViewPage);
      await open(tester, EntryViewPage(entryId: entry.id!), dark: true);
      await session.capture(tester, '$device-backlog-dark-reader');
      await close(tester, EntryViewPage);
      await open(tester, const AppearanceSettings());
      final darkChoice = find.byKey(const ValueKey('appearance-dark-style'));
      await tester.scrollUntilVisible(darkChoice, 300,
          scrollable: find.byType(Scrollable).first);
      await tester.pumpAndSettle();
      await session.capture(tester, '$device-backlog-appearance');
      await close(tester, AppearanceSettings);

      await open(tester, const DrawingPage());
      final canvas = find.byKey(const ValueKey('drawing-canvas'));
      final rect = tester.getRect(canvas);
      // A small landscape made through real pen events, not injected pixels.
      for (final points in [
        [
          const Offset(.12, .68),
          const Offset(.34, .28),
          const Offset(.56, .68)
        ],
        [const Offset(.43, .68), const Offset(.63, .4), const Offset(.84, .68)],
        [const Offset(.1, .72), const Offset(.88, .72)],
      ]) {
        final pen =
            await tester.createGesture(kind: ui.PointerDeviceKind.stylus);
        Offset at(Offset point) => Offset(rect.left + rect.width * point.dx,
            rect.top + rect.height * point.dy);
        await pen.down(at(points.first));
        for (final point in points.skip(1)) {
          await pen.moveTo(at(point));
        }
        await pen.up();
        await tester.pump();
      }
      await tester.pumpAndSettle();
      expect(
          tester
              .widget<DrawingCanvas>(find.byType(DrawingCanvas))
              .controller
              .document
              .strokes,
          hasLength(3));
      await session.capture(tester, '$device-backlog-drawing');
      // Clear through the same controller to leave without a discard modal.
      tester
          .widget<DrawingCanvas>(find.byType(DrawingCanvas))
          .controller
          .clear();
      await tester.pump();
      await close(tester, DrawingPage);

      // Synthetic file metadata only. This path is explicitly selected for the
      // test; no source photo library, image decoder or import is touched.
      final folder = Directory.systemTemp.createTempSync('aid-moment-shots');
      addTearDown(() => folder.deleteSync(recursive: true));
      await tester.runAsync(() async {
        final now = DateTime.now();
        for (var i = 0; i < 10; i++) {
          final file = await File('${folder.path}/sample-$i.png')
              .writeAsBytes(const [0]);
          await file.setLastModified(DateTime(
              now.year, now.month, now.day - 1, i < 6 ? 9 : 15, i * 3));
        }
        await DiaryAppHarness.setSetting(
            Settings.localPhotoFolder, folder.path);
      });
      await open(tester, const LocalMomentsPage());
      await tester.tap(find.byKey(const ValueKey('moments-scan')));
      await DiaryAppHarness.pumpUntil(
          tester, () => find.byType(Card).evaluate().length == 2);
      expect(find.byKey(const ValueKey('moments-scan')), findsOneWidget);
      expect(find.byType(Card), findsNWidgets(2));
      await session.capture(tester, '$device-backlog-moments');
      expect(tester.takeException(), isNull);
      await session.finish(tester);
    });
  }
}
