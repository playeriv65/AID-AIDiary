// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['widget'])
library;

import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/providers/templates_provider.dart';
import 'package:aid_diary/widgets/edit_category.dart';
import 'package:aid_diary/widgets/edit_tag.dart';
import 'package:aid_diary/widgets/edit_template.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();
  final actions = AppActions(devBuild: true);

  /// Shows [editor] over a page, as the app opens it.
  Future<void> open(WidgetTester tester, Widget editor,
      {bool page = false}) async {
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(Builder(
        builder: (context) => Scaffold(
            body: Center(
                child: FilledButton(
                    onPressed: () => page
                        ? Navigator.of(context).push(
                            MaterialPageRoute<void>(builder: (_) => editor))
                        : showDialog<void>(
                            context: context, builder: (_) => editor),
                    child: const Text('open')))))));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  Future<void> tapOk(WidgetTester tester) async {
    await tester.tap(find.widgetWithText(TextButton, '确定'));
    await tester.pump();
  }

  Future<void> run(WidgetTester tester, String id, Map<String, Object?> args) =>
      tester.runAsync(() => actions.run(id, args)).then((_) {});

  const taken = '已有同名的标签';
  const takenCategory = '已有同名的分类';

  testWidgets('a new tag is made by tag.create, with the type chosen',
      (tester) async {
    await open(tester, const EditTag());
    await tester.tap(find.text('追踪器'));
    await tester.enterText(find.byType(TextField), 'Run,ning');
    await tester.pump();
    await tapOk(tester);
    await DiaryAppHarness.pumpUntil(
        tester, () => find.byType(EditTag).evaluate().isEmpty);

    final tag = TagsProvider.instance.tags.last;
    // The sanitizing is the action's, as it is for the command line.
    expect(tag.name, 'Running');
    expect(tag.tagType, TagType.tracker);
    expect(tag.color, isNull);
  });

  testWidgets('a tag name that is taken is refused at the field',
      (tester) async {
    await run(tester, 'tag.create', {'name': 'Reading'});
    final before = TagsProvider.instance.tags.length;

    await open(tester, const EditTag());
    await tester.enterText(find.byType(TextField), 'reading');
    await tester.pump();
    expect(find.text(taken), findsNothing);
    await tapOk(tester);
    await DiaryAppHarness.pumpUntil(
        tester, () => find.text(taken).evaluate().isNotEmpty);

    expect(find.byType(EditTag), findsOneWidget);
    expect(TagsProvider.instance.tags.length, before);

    // Another name is free, and the message goes away as it is typed.
    await tester.enterText(find.byType(TextField), 'Reading list');
    await tester.pump();
    expect(find.text(taken), findsNothing);
    await tapOk(tester);
    await DiaryAppHarness.pumpUntil(
        tester, () => find.byType(EditTag).evaluate().isEmpty);
    expect(TagsProvider.instance.tags.length, before + 1);
  });

  testWidgets('a tag may be saved under its own name in another case',
      (tester) async {
    await run(tester, 'tag.create', {'name': 'Reading', 'color': '#336699'});
    final tag = TagsProvider.instance.tags.last;

    await open(tester, EditTag(tag: tag));
    await tester.enterText(find.byType(TextField), 'READING');
    await tester.pump();
    await tapOk(tester);
    await DiaryAppHarness.pumpUntil(
        tester, () => find.byType(EditTag).evaluate().isEmpty);

    final saved = TagsProvider.instance.tags.last;
    expect(saved.id, tag.id);
    expect(saved.name, 'READING');
    // What the person did not touch stays as it was.
    expect(saved.color, tag.color);
  });

  testWidgets('a category name that is taken is refused at the field',
      (tester) async {
    await run(tester, 'category.create', {'name': 'Work'});
    final before = TagsProvider.instance.categories.length;

    await open(tester, const EditCategory());
    await tester.enterText(find.byType(TextField), 'WORK');
    await tester.pump();
    await tapOk(tester);
    await DiaryAppHarness.pumpUntil(
        tester, () => find.text(takenCategory).evaluate().isNotEmpty);
    expect(find.byType(EditCategory), findsOneWidget);
    expect(TagsProvider.instance.categories.length, before);

    await tester.enterText(find.byType(TextField), 'Home');
    await tester.pump();
    expect(find.text(takenCategory), findsNothing);
    await tapOk(tester);
    await DiaryAppHarness.pumpUntil(
        tester, () => find.byType(EditCategory).evaluate().isEmpty);
    expect(TagsProvider.instance.categories.last.name, 'Home');
  });

  testWidgets('deleting a category in its editor deletes its tags too',
      (tester) async {
    await run(tester, 'category.create', {'name': 'Work'});
    await run(tester, 'tag.create', {'name': 'Meetings', 'category': 'Work'});
    final category = TagsProvider.instance.categories.last;

    await open(tester, EditCategory(category: category));
    await tester.tap(find.byIcon(Icons.delete_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, '删除'));
    await DiaryAppHarness.pumpUntil(
        tester, () => TagsProvider.instance.categories.isEmpty);

    expect(
        TagsProvider.instance.tags.where((t) => t.name == 'Meetings'), isEmpty);
  });

  testWidgets('the template editor saves through the template actions',
      (tester) async {
    await open(tester, const EditTemplate(), page: true);
    final save = find.widgetWithIcon(IconButton, Icons.check);
    // A template needs a name, as template.create wants.
    expect(tester.widget<IconButton>(save).onPressed, isNull);

    await tester.enterText(find.byType(TextField).first, '  周报 ');
    await tester.pump();
    await tester.tap(save);
    await DiaryAppHarness.pumpUntil(
        tester, () => find.byType(EditTemplate).evaluate().isEmpty);

    final template = TemplatesProvider.instance.templates.last;
    expect(template.name, '周报');

    await open(tester, EditTemplate(template: template), page: true);
    await tester.enterText(find.byType(TextField).first, '月报');
    await tester.pump();
    await tester.tap(find.widgetWithIcon(IconButton, Icons.check));
    await DiaryAppHarness.pumpUntil(
        tester, () => find.byType(EditTemplate).evaluate().isEmpty);
    expect(TemplatesProvider.instance.templates.last.id, template.id);
    expect(TemplatesProvider.instance.templates.last.name, '月报');
  });
}
