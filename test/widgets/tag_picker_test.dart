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
}
