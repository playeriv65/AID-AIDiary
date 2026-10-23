// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/layouts/mobile_scaffold.dart';
import 'package:aid_diary/pages/edit_entry_page.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test/support/diary_app_harness.dart';
import '../../test/support/screenshot_session.dart';

void main() {
  final session = screenshotSession();
  for (final (device, size) in [
    ('phone', const Size(390, 844)),
    ('tablet', const Size(1280, 800)),
  ]) {
    testWidgets('diary day editor and picker $device', (tester) async {
      await session.start(tester, size);
      final entry = await DiaryAppHarness.addEntry(
          tester, '把今天写下的回忆，放回它所属的那一天。', DateTime.now());
      final context = tester.element(find.byType(MobileScaffold));
      Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => AddEditEntryPage(entry: entry),
      ));
      await tester.pumpAndSettle();
      await session.capture(tester, '$device-diary-day-editor');
      await tester.tap(find.byKey(const ValueKey('editor-date')));
      await tester.pumpAndSettle();
      await session.capture(tester, '$device-diary-day-picker');
      await session.finish(tester);
    });
  }
}
