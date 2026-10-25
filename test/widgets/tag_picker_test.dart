// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['widget'])
library;

import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/widgets/tag_attachment_source.dart';
import 'package:aid_diary/widgets/tag_chip.dart';
import 'package:aid_diary/widgets/tag_picker_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();
  final actions = AppActions(devBuild: true);

  Future<TagAttachmentSource> open(WidgetTester tester) async {
    await tester.runAsync(() async {
      for (final name in ['Walk', 'Read', 'Cook']) {
        await actions.run('tag.create', {'name': name});
      }
    });
    final source = TagAttachmentSource();
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness
        .app(TagPickerDialog(mode: TagPickerMode.attach, source: source)));
    await tester.pumpAndSettle();
    return source;
  }

  List<String> shown(WidgetTester tester) => [
        for (final chip in tester.widgetList<TagChip>(find.byType(TagChip)))
          chip.tag.name,
      ];

  TagChip chip(WidgetTester tester, String name) => tester.widget<TagChip>(
      find.byWidgetPredicate((w) => w is TagChip && w.tag.name == name));

  testWidgets('a picked tag stays in its place, highlighted', (tester) async {
    final source = await open(tester);

    await tester.tap(find.text('Read'));
    await tester.pumpAndSettle();
    expect(shown(tester), ['Walk', 'Read', 'Cook']);
    expect(chip(tester, 'Read').selected, isTrue);
    expect(source.attachedTagIds, [chip(tester, 'Read').tag.id]);

    await tester.tap(find.text('Read'));
    await tester.pumpAndSettle();
    expect(chip(tester, 'Read').selected, isFalse);
    expect(source.attachedTagIds, isEmpty);
  });

  testWidgets('a long-pressed tag is dragged into another tag\'s place',
      (tester) async {
    await open(tester);

    final gesture =
        await tester.startGesture(tester.getCenter(find.text('Cook')));
    await tester.pump(kLongPressTimeout + const Duration(milliseconds: 50));
    await gesture.moveTo(tester.getCenter(find.text('Walk')));
    await tester.pump();
    await gesture.up();
    await DiaryAppHarness.pumpUntil(
        tester, () => TagsProvider.instance.tags.first.name == 'Cook');
    await tester.pumpAndSettle();

    expect(shown(tester), ['Cook', 'Walk', 'Read']);
  });

  testWidgets('while held over a tag, the lifted one already sits there',
      (tester) async {
    await open(tester);
    int idOf(String name) =>
        TagsProvider.instance.tags.firstWhere((tag) => tag.name == name).id!;
    Offset at(String name) =>
        tester.getTopLeft(find.byKey(ValueKey('tag-move-${idOf(name)}')));
    final walk = at('Walk');

    final gesture =
        await tester.startGesture(tester.getCenter(find.text('Cook')));
    await tester.pump(kLongPressTimeout + const Duration(milliseconds: 50));
    await gesture.moveTo(tester.getCenter(find.text('Walk').first));
    await tester.pump();
    // Cook takes Walk's place and Walk moves along; nothing is saved yet.
    expect(at('Cook'), walk);
    expect(at('Walk').dx, greaterThan(walk.dx));
    expect(TagsProvider.instance.tags.first.name, 'Walk');

    // Let go away from every tag: all goes back.
    await gesture.moveTo(const Offset(5, 5));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(at('Walk'), walk);
    expect(TagsProvider.instance.tags.first.name, 'Walk');
  });

  testWidgets('search and a new tag share a row, above tags used lately',
      (tester) async {
    await tester.runAsync(() async {
      for (final name in ['Walk', 'Read', 'Cook']) {
        await actions.run('tag.create', {'name': name});
      }
      // Cook twice, Read once, Walk never.
      for (final names in [
        ['Read', 'Cook'],
        ['Cook'],
      ]) {
        final entry = await actions.run('entry.create', {'text': 'x'}) as Map;
        for (final name in names) {
          await actions.run('entry.tag', {'id': entry['id'], 'tag': name});
        }
      }
    });
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(TagPickerDialog(
        mode: TagPickerMode.attach, source: TagAttachmentSource())));
    await tester.pumpAndSettle();

    final search = tester.getRect(find.byKey(const ValueKey('tag-search')));
    final add = tester.getRect(find.byKey(const ValueKey('tag-new')));
    expect(add.center.dy, moreOrLessEquals(search.center.dy, epsilon: 1));
    expect(add.left, greaterThan(search.right));

    final recent = find.byKey(const ValueKey('tags-recent'));
    expect([
      for (final chip in tester.widgetList<TagChip>(
          find.descendant(of: recent, matching: find.byType(TagChip))))
        chip.tag.name
    ], [
      'Cook',
      'Read'
    ]);
    expect(tester.getRect(recent).top, greaterThan(search.bottom));
  });
}
