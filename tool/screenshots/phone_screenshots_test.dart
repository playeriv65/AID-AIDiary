// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

// Headless phone screenshots, no window:
//   flutter test tool/screenshots/
// Output: artifacts/ui-phone-*.png.

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../test/support/diary_app_harness.dart';
import '../../test/support/screenshot_session.dart';

void main() {
  final session = screenshotSession();

  Future<void> back(WidgetTester tester) async {
    await tester.tap(find.byType(BackButton).hitTestable().first);
    await tester.pumpAndSettle();
  }

  testWidgets('phone', (tester) async {
    // A gesture-navigation phone: status bar on top, gesture handle below.
    await session
        .start(tester, const Size(390, 844), systemBars: (top: 40, bottom: 20));
    await session.capture(tester, 'phone-journal');
    await session.tapKey(
        tester, 'journal-entry-${await session.starredEntryId(tester)}');
    await session.capture(tester, 'phone-entry');
    await session.tapKey(tester, 'entry-share');
    await session.capture(tester, 'phone-share-as');
    await session.tapKey(tester, 'share-as-image');
    await session.capture(tester, 'phone-share');
    await tester.tap(find.byType(CloseButton).hitTestable().first);
    await tester.pumpAndSettle();
    await back(tester);
    // The stories row builds lazily, so scroll it to the card first.
    Future<void> openStory(String key) async {
      await tester.scrollUntilVisible(find.byKey(ValueKey(key)), 120,
          scrollable: find
              .descendant(
                  of: find.byKey(const ValueKey('journal-stories')),
                  matching: find.byType(Scrollable))
              .first);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ValueKey(key)));
    }

    await openStory('story-random');
    await tester.pumpAndSettle();
    await session.capture(tester, 'phone-random');
    await back(tester);
    await openStory('story-week');
    await session.capture(tester, 'phone-week-review', settle: false);
    await tester.tap(find.byKey(const ValueKey('story-close')));
    await tester.pumpAndSettle();
    // Revealing the cards scrolled the journal; go back to its top.
    await tester.drag(
        find.byKey(const ValueKey('journal-stories')), const Offset(0, 800));
    await tester.pumpAndSettle();
    await session.tapKey(tester, 'journal-search');
    await session.capture(tester, 'phone-search');
    await back(tester);
    await session.tapKey(tester, 'journal-calendar');
    await session.capture(tester, 'phone-calendar');
    await session.tapKey(tester, 'journal-calendar');
    for (final (index, name) in [
      (1, 'media'),
      (3, 'coach'),
    ]) {
      await DiaryAppHarness.goTo(tester, index);
      await session.capture(tester, 'phone-$name');
    }
    await DiaryAppHarness.goTo(tester, 0);
    await session.tapKey(tester, 'diary-new-entry');
    await session.capture(tester, 'phone-editor');
    // With the real CJK font the caret must sit on the hint's line.
    final editable = tester.state<EditableTextState>(DiaryAppHarness.entryBody);
    final render = editable.renderEditable;
    final caret = MatrixUtils.transformRect(render.getTransformTo(null),
        render.getLocalRectForCaret(const TextPosition(offset: 0)));
    final hint = tester.getRect(find.text('开始写，或选择一个'));
    expect(caret.center.dy, closeTo(hint.center.dy, 1.5));
    await tester.tap(find.byIcon(Icons.place_outlined).hitTestable());
    await tester.pumpAndSettle();
    await session.capture(tester, 'phone-location');
    await session.tapKey(tester, 'location-pick');
    await session.capture(tester, 'phone-location-picker');
    await session.finish(tester);
  });
}
