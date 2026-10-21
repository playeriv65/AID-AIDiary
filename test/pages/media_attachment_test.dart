@Tags(['widget'])
library;

import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/pages/edit_entry_page.dart';
import 'package:aid_diary/pages/entry_view_page.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/widgets/media_attachment.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();

  testWidgets('videos and voice notes show as tiles and open the player',
      (tester) async {
    final entry =
        await DiaryAppHarness.addEntry(tester, '有视频', DateTime(2026, 10, 18));
    await tester.runAsync(() async {
      for (final (rank, name) in [(1, 'clip.mp4'), (0, 'voice.m4a')]) {
        await EntryImagesProvider.instance.add(EntryImage(
            entryId: entry.id,
            imgPath: name,
            imgRank: rank,
            timeCreate: DateTime.now()));
      }
    });
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(EntryViewPage(entryId: entry.id!)));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('media-tile-video')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('entry-attachment-0')));
    // The player's spinner never settles and it reads real files, so let
    // real time pass between frames until it gives up.
    final unavailable = find.text('此附件在这台设备上不可用。');
    for (var i = 0; i < 50 && unavailable.evaluate().isEmpty; i++) {
      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 20)));
      await tester.pump(const Duration(milliseconds: 100));
    }
    // Tests have no file system plugin, so the player reports the file
    // as missing rather than crashing.
    expect(find.byType(MediaPlayerPage), findsOneWidget);
    expect(find.text('此附件在这台设备上不可用。'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('the editor offers voice note sources', (tester) async {
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const AddEditEntryPage()));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.mic_none_rounded));
    await tester.pumpAndSettle();
    expect(find.text('录制语音'), findsOneWidget);
    expect(find.text('选择音频文件'), findsOneWidget);
    await tester.tapAt(const Offset(195, 100));
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('the media tile offers gallery, voice note and files',
      (tester) async {
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const AddEditEntryPage()));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('editor-add-media')));
    await tester.pumpAndSettle();
    // The camera ones are added on Android; tests run on the desktop.
    for (final label in ['从图库选择', '录制语音', '从文件选择']) {
      expect(find.text(label), findsOneWidget, reason: label);
    }
    await tester.tapAt(const Offset(195, 100));
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('every editor button names what it does', (tester) async {
    DiaryAppHarness.size(tester, const Size(1280, 800));
    await tester.pumpWidget(harness.app(const AddEditEntryPage()));
    await tester.pumpAndSettle();
    for (final name in ['照片和视频', '心情', '标签', '粗体', '插入', '撤销']) {
      expect(find.byTooltip(name), findsOneWidget, reason: name);
    }
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
