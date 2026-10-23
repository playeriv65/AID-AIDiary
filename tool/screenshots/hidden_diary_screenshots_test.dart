// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/layouts/mobile_scaffold.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/pages/hidden_entries_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../test/support/diary_app_harness.dart';
import '../../test/support/screenshot_session.dart';

void main() {
  final session = screenshotSession();
  for (final (device, size) in [
    ('phone', const Size(390, 844)),
    ('tablet', const Size(1280, 800)),
  ]) {
    testWidgets('hidden section locked and authenticated $device',
        (tester) async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
              const MethodChannel('plugins.flutter.io/local_auth'),
              (call) async => call.method == 'authenticate' ? true : null);
      await session.start(tester, size);
      final time = DateTime(2026, 10, 20, 20);
      await tester.runAsync(() => EntryStore.instance.add(Entry(
          text: '# 留给自己的文字\n安静地记录今天。',
          timeCreate: time,
          timeModified: time,
          isHidden: true)));
      final context = tester.element(find.byType(MobileScaffold));
      Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => const HiddenEntriesPage(),
      ));
      await tester.pumpAndSettle();
      await session.capture(tester, '$device-hidden-locked');
      await tester.tap(find.byKey(const ValueKey('hidden-unlock')));
      await DiaryAppHarness.pumpUntil(
          tester, () => find.text('留给自己的文字').evaluate().isNotEmpty);
      await session.capture(tester, '$device-hidden-unlocked');
      await session.finish(tester);
    });
  }
}
