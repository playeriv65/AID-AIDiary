// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:aid_diary/layouts/mobile_scaffold.dart';
import 'package:aid_diary/routing/destinations.dart';

import '../../test/support/screenshot_session.dart';
import '../../test/support/diary_app_harness.dart';

void main() {
  final session = screenshotSession();
  for (final (name, size) in [
    ('phone', const Size(390, 844)),
    ('tablet', const Size(1280, 800)),
  ]) {
    testWidgets('pinned search after scrolling on $name', (tester) async {
      await session.start(tester, size);
      for (var i = 0; i < 30; i++) {
        await DiaryAppHarness.addEntry(tester, 'A quiet afternoon $i',
            DateTime.now().subtract(Duration(days: i + 10)));
      }
      await tester.pumpWidget(session.app());
      await tester.pumpAndSettle();
      final scrollable = find
          .descendant(
              of: find.byKey(const PageStorageKey('journal-list')),
              matching: find.byType(Scrollable))
          .first;
      tester.state<ScrollableState>(scrollable).position.jumpTo(2000);
      await tester.pumpAndSettle();
      await session.capture(tester, '$name-pinned-search');
      openPlace(
          tester.element(find.byType(MobileScaffold)), 'settings/feedback');
      await tester.pumpAndSettle();
      await session.capture(tester, '$name-feedback');
      await session.finish(tester);
    });
  }
}
