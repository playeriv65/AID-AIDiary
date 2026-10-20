@Tags(['widget'])
library;

import 'package:daily_you/database/entry_store.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/pages/edit_entry_page.dart';
import 'package:daily_you/pages/settings_page.dart';
import 'package:daily_you/pages/today_story_page.dart';
import 'package:daily_you/providers/tags_provider.dart';
import 'package:daily_you/providers/templates_provider.dart';
import 'package:daily_you/utils/entry_actions.dart';
import 'package:daily_you/widgets/story_player.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();

  testWidgets('the empty editor offers templates and inserts a featured one',
      (tester) async {
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const AddEditEntryPage()));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('editor-template-link')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('template-featured-daily')));
    await tester.pumpAndSettle();
    final text = tester
        .widget<EditableText>(find.byType(EditableText).first)
        .controller
        .text;
    expect(text, contains('## 今天发生了什么'));
    expect(find.byKey(const ValueKey('editor-template-link')), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('duplicate copies text and tags; save as template names it',
      (tester) async {
    final entry = await DiaryAppHarness.addEntry(
        tester, '# 周末\n去了公园', DateTime(2026, 10, 18, 9),
        mood: 2, location: const EntryLocation(name: '公园'));
    await tester
        .runAsync(() => TagsProvider.instance.setFavorite(entry.id!, true));

    final copy = (await tester.runAsync(() => EntryActions.duplicate(entry)))!;
    expect(EntryStore.instance.entries, hasLength(2));
    final stored =
        EntryStore.instance.entries.firstWhere((e) => e.id == copy.id);
    expect(stored.text, entry.text);
    expect(stored.mood, 2);
    expect(stored.location?.name, '公园');
    expect(TagsProvider.instance.isFavorite(copy.id!), isTrue);

    final template = (await tester
        .runAsync(() => EntryActions.saveAsTemplate(entry, 'fallback')))!;
    expect(template.name, '周末');
    expect(TemplatesProvider.instance.templates.map((t) => t.id),
        contains(template.id));
    expect(
        TagsProvider.instance
            .getTemplateTagsForTemplate(template.id!)
            .map((t) => t.tagId),
        contains(TagsProvider.instance.favoriteTag!.id));
  });

  testWidgets('today story steps through its slides and closes',
      (tester) async {
    await DiaryAppHarness.addEntry(tester, '今天', DateTime.now(), mood: 1);
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const Scaffold(body: SizedBox())));
    final context = tester.element(find.byType(SizedBox).first);
    TodayStory.open(context);
    // The progress bar animates, so settle would play the whole story.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('统计'.toUpperCase()), findsOneWidget);
    // Tap the empty bottom edge: the chart and the mood grid take taps.
    const next = Offset(350, 820);
    await tester.tapAt(next);
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('心情图'.toUpperCase()), findsOneWidget);
    final now = DateTime.now();
    expect(find.byKey(ValueKey('story-mood-${now.month}-${now.day}')),
        findsOneWidget);
    // No program and no throwback: the closing card follows.
    await tester.tapAt(next);
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byKey(const ValueKey('story-wrap-up')), findsOneWidget);
    await tester.tapAt(next);
    await tester.pumpAndSettle();
    expect(find.byType(StoryPlayer), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('settings are grouped like Journey', (tester) async {
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const SettingsPage()));
    await tester.pumpAndSettle();
    for (final title in ['通用', '数据与存储', '故事', '安全', '帮助与关于']) {
      expect(find.text(title), findsOneWidget, reason: title);
    }
    await tester.tap(find.text('数据与存储'));
    await tester.pumpAndSettle();
    expect(find.text('存储'), findsWidgets);
  });
}
