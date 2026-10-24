// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

// The places the command line opens with `ui.navigate` show what a tap on
// the same thing shows, and the screen reports them under their name.

@Tags(['widget'])
library;

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/layouts/mobile_scaffold.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/models/tag_category.dart';
import 'package:aid_diary/models/template.dart';
import 'package:aid_diary/pages/edit_entry_page.dart';
import 'package:aid_diary/pages/entries_list_page.dart';
import 'package:aid_diary/pages/entry_share_page.dart';
import 'package:aid_diary/pages/entry_timeline_page.dart';
import 'package:aid_diary/pages/random_review_page.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/providers/templates_provider.dart';
import 'package:aid_diary/pages/coach_page.dart';
import 'package:aid_diary/widgets/auto_backup_settings_dialog.dart';
import 'package:aid_diary/widgets/command_palette.dart';
import 'package:aid_diary/widgets/edit_category.dart';
import 'package:aid_diary/widgets/edit_tag.dart';
import 'package:aid_diary/widgets/edit_template.dart';
import 'package:aid_diary/widgets/media_attachment.dart';
import 'package:aid_diary/widgets/quick_check_in.dart';
import 'package:aid_diary/widgets/share_tags_dialog.dart';
import 'package:aid_diary/widgets/share_templates_dialog.dart';
import 'package:aid_diary/widgets/story_player.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();
  final actions = AppActions.instance;

  /// Opens [to] as `ui.navigate` does and returns what `ui.screen` reports
  /// afterwards. Stories keep animating, so frames are pumped for a fixed
  /// time rather than until nothing moves.
  Future<String> navigate(WidgetTester tester, String to,
      [Map<String, Object?> args = const {}]) async {
    final done = actions.run('ui.navigate', {'to': to, ...args});
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await done;
    final screen = await actions.run('ui.screen', {}) as Map<String, Object?>;
    return screen['current'] as String;
  }

  Future<void> pumpApp(WidgetTester tester) async {
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const MobileScaffold()));
    await tester.pumpAndSettle();
  }

  Future<Entry> addEntry(WidgetTester tester, String text,
      {DateTime? openAt}) async {
    final time = DateTime(2026, 10, 18, 9);
    return (await tester.runAsync(() => EntryStore.instance.add(Entry(
        text: text,
        mood: 1,
        timeCreate: time,
        timeModified: time,
        openAt: openAt))))!;
  }

  Future<Template> addTemplate(WidgetTester tester) async {
    final now = DateTime(2026, 10, 18);
    return (await tester.runAsync(() => TemplatesProvider.instance.add(Template(
        name: '周报', text: '## 本周', timeCreate: now, timeModified: now))))!;
  }

  testWidgets('entries open as pages named after them', (tester) async {
    final entry = await addEntry(tester, '今天去了公园');
    await pumpApp(tester);

    expect(
        await navigate(tester, 'entry', {'id': entry.id}), 'entry/${entry.id}');
    expect(find.byType(EntriesListPage), findsOneWidget);
    expect(find.text('今天去了公园'), findsWidgets);

    expect(
        await navigate(tester, 'day', {'day': '2026-10-18'}), 'day/2026-10-18');
    expect(find.byType(EntryTimelinePage), findsOneWidget);

    expect(await navigate(tester, 'entry_share', {'id': entry.id}),
        'entry_share/${entry.id}');
    expect(find.byType(EntrySharePage), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  // Leaving the editor saves a draft on real IO, so these end on the editor.
  testWidgets('the editor opens an entry', (tester) async {
    final entry = await addEntry(tester, '今天去了公园');
    await pumpApp(tester);

    expect(await navigate(tester, 'editor', {'id': entry.id}),
        'editor/${entry.id}');
    expect(find.byType(AddEditEntryPage), findsOneWidget);
    expect(find.text('今天去了公园'), findsWidgets);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('the editor starts from a template', (tester) async {
    final template = await addTemplate(tester);
    await pumpApp(tester);

    expect(
        await navigate(tester, 'editor', {'template': template.id}), 'editor');
    expect(find.byType(AddEditEntryPage), findsOneWidget);
    expect(find.text('## 本周'), findsWidgets);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('an attachment opens full screen by its place in the entry',
      (tester) async {
    final entry = await addEntry(tester, '有视频');
    await tester.runAsync(() => EntryImagesProvider.instance.add(EntryImage(
        entryId: entry.id,
        imgPath: 'clip.mp4',
        imgRank: 0,
        timeCreate: DateTime.now())));
    await pumpApp(tester);

    expect(await navigate(tester, 'attachment', {'id': entry.id, 'index': 0}),
        'attachment/${entry.id}/0');
    expect(find.byType(MediaPlayerPage), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('stories and reviews play over the journal', (tester) async {
    await addEntry(tester, '今天');
    await pumpApp(tester);

    expect(await navigate(tester, 'story'), 'story/today');
    expect(find.byType(StoryPlayer), findsOneWidget);
    expect(find.text('统计'.toUpperCase()), findsOneWidget);

    expect(await navigate(tester, 'review', {'span': 'week'}), 'review/week');
    expect(find.byType(StoryPlayer), findsOneWidget);

    expect(await navigate(tester, 'review', {'span': 'year'}), 'review/year');
    expect(find.byType(StoryPlayer), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('stories are cards over the app in a wide window',
      (tester) async {
    await addEntry(tester, '今天');
    DiaryAppHarness.size(tester, const Size(1440, 900));
    await tester.pumpWidget(harness.app(const MobileScaffold()));
    await tester.pumpAndSettle();

    expect(await navigate(tester, 'story'), 'story/today');
    expect(find.byType(StoryPlayer), findsOneWidget);
    expect(await actions.run('ui.back', {}),
        {'closed': true, 'current': 'journal'});
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(StoryPlayer), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('a flashback opens as its card does, numbered as flashback.list',
      (tester) async {
    for (var day = 1; day <= 9; day++) {
      final time = DateTime(2026, 9, day, 9);
      await tester.runAsync(() => EntryStore.instance.add(Entry(
          text: '第$day天', mood: 1, timeCreate: time, timeModified: time)));
    }
    await pumpApp(tester);
    // The action waits on the store, which is real IO.
    final listed =
        await tester.runAsync(() => actions.run('flashback.list', {})) as Map;
    final first = (listed['flashbacks'] as List).first as Map;
    final entryId = ((first['entries'] as List).single as Map)['id'];

    expect(await navigate(tester, 'flashback', {'index': first['index']}),
        'entry/$entryId');
    expect(find.byType(EntriesListPage), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('random review starts with the filter it is given',
      (tester) async {
    await addEntry(tester, '今天');
    await pumpApp(tester);

    expect(await navigate(tester, 'random', {'filter': 'goodDays'}), 'random');
    expect(
        tester.widget<RandomReviewPage>(find.byType(RandomReviewPage)).filter,
        RandomFilter.goodDays);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('templates, tags and categories open their editors',
      (tester) async {
    final template = await addTemplate(tester);
    final now = DateTime(2026, 10, 18);
    final tag = (await tester.runAsync(() => TagsProvider.instance.add(Tag(
        name: '散步',
        tagType: TagType.label,
        timeCreate: now,
        timeModified: now))))!;
    final category = (await tester.runAsync(() => TagsProvider.instance
        .addCategory(
            TagCategory(name: '心情', timeCreate: now, timeModified: now))))!;
    await pumpApp(tester);

    expect(await navigate(tester, 'template'), 'template');
    expect(find.byType(EditTemplate), findsOneWidget);
    expect(await navigate(tester, 'template', {'id': template.id}),
        'template/${template.id}');
    expect(find.text('周报'), findsOneWidget);

    expect(await navigate(tester, 'tag'), 'tag');
    expect(find.byType(EditTag), findsOneWidget);
    expect(await navigate(tester, 'tag', {'id': tag.id, 'name': 'unused'}),
        'tag/${tag.id}');
    expect(find.text(tag.name), findsOneWidget);
    expect(await navigate(tester, 'tag', {'name': '新标签'}), 'tag');
    expect(find.text('新标签'), findsOneWidget);

    expect(await navigate(tester, 'category'), 'category');
    expect(find.byType(EditCategory), findsOneWidget);
    expect(await navigate(tester, 'category', {'id': category.id}),
        'category/${category.id}');
    expect(find.text('心情'), findsOneWidget);

    expect(await navigate(tester, 'tags/share'), 'tags/share');
    expect(find.byType(ShareTagsDialog), findsOneWidget);
    expect(await navigate(tester, 'templates/share'), 'templates/share');
    expect(find.byType(ShareTemplatesDialog), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('dialogs and sheets are places too', (tester) async {
    await pumpApp(tester);

    expect(await navigate(tester, 'check_in'), 'check_in');
    expect(find.byType(QuickCheckIn), findsOneWidget);
    expect(await navigate(tester, 'commands'), 'commands');
    expect(find.byType(CommandPalette), findsOneWidget);
    expect(
        await navigate(tester, 'settings/auto_backup'), 'settings/auto_backup');
    expect(find.byType(AutoBackupSettingsDialog), findsOneWidget);

    // Back closes the dialog, as a tap outside it does.
    expect(await actions.run('ui.back', {}),
        {'closed': true, 'current': 'journal'});
    await tester.pumpAndSettle();
    expect(find.byType(AutoBackupSettingsDialog), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('the coach catalog opens a program or a template',
      (tester) async {
    final template = await addTemplate(tester);
    await pumpApp(tester);

    expect(await navigate(tester, 'coach/program', {'id': 'everyday'}),
        'coach/program/everyday');
    expect(find.byType(CoachProgramDetail), findsOneWidget);
    expect(await navigate(tester, 'coach/template', {'builtin': 'daily'}),
        'coach/template/builtin-daily');
    expect(find.byType(CoachTemplateDetail), findsOneWidget);
    expect(await navigate(tester, 'coach/template', {'id': template.id}),
        'coach/template/${template.id}');
    expect(find.text('周报'), findsWidgets);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  group('what cannot be opened is refused', () {
    Future<void> expectRefused(WidgetTester tester, String to,
        Map<String, Object?> args, String code) async {
      await expectLater(
          actions.run('ui.navigate', {'to': to, ...args}),
          throwsA(isA<ActionException>()
              .having((error) => error.code, 'code', code)),
          reason: '$to $args');
    }

    testWidgets('missing things, and what a time capsule keeps back',
        (tester) async {
      final sealed = await addEntry(tester, '秘密',
          openAt: DateTime.now().add(const Duration(days: 30)));
      await pumpApp(tester);

      await expectRefused(tester, 'entry', {'id': 999}, 'not_found');
      await expectRefused(tester, 'tag', {'id': 999}, 'not_found');
      await expectRefused(tester, 'category', {'id': 999}, 'not_found');
      await expectRefused(tester, 'template', {'id': 999}, 'not_found');
      await expectRefused(tester, 'story', {'from': 'coach'}, 'not_found');
      await expectRefused(tester, 'flashback', {'index': 0}, 'not_found');
      await expectRefused(tester, 'coach/program', {'id': 'x'}, 'not_found');
      await expectRefused(tester, 'review', {'span': 'month'}, 'bad_args');
      await expectRefused(tester, 'coach/template', {}, 'bad_args');
      await expectRefused(tester, 'entry_share', {'id': sealed.id}, 'sealed');
      await expectRefused(
          tester, 'attachment', {'id': sealed.id, 'index': 0}, 'sealed');
      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('an attachment the entry does not have', (tester) async {
      final entry = await addEntry(tester, '没有附件');
      await pumpApp(tester);
      await expectRefused(
          tester, 'attachment', {'id': entry.id, 'index': 0}, 'not_found');
      await tester.pumpWidget(const SizedBox.shrink());
    });
  });
}
