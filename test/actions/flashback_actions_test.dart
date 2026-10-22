// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['integration'])
library;

import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/diary_app_harness.dart';

void main() {
  DiaryAppHarness().register();
  final actions = AppActions(devBuild: true);

  /// More than seven entries, so the journal picks a good day and a random
  /// day to bring back.
  Future<void> writeEntries() async {
    for (var day = 1; day <= 9; day++) {
      final time = DateTime(2026, 9, day, 9);
      await EntryStore.instance.add(Entry(
          text: 'Day $day', mood: 1, timeCreate: time, timeModified: time));
    }
  }

  Future<List<Map<String, Object?>>> listFlashbacks() async {
    final result =
        await actions.run('flashback.list', {}) as Map<String, Object?>;
    return [
      for (final flashback in result['flashbacks'] as List)
        flashback as Map<String, Object?>,
    ];
  }

  test("today's flashbacks are listed with the entries they bring back",
      () async {
    await writeEntries();
    final flashbacks = await listFlashbacks();

    expect(flashbacks, hasLength(2));
    final ids = {for (final entry in EntryStore.instance.entries) entry.id};
    for (final (index, flashback) in flashbacks.indexed) {
      expect(flashback['index'], index);
      expect(flashback['title'], isNotEmpty);
      final entries = flashback['entries'] as List;
      expect(entries, hasLength(1));
      final entry = entries.single as Map<String, Object?>;
      expect(ids, contains(entry['id']));
      expect(entry['day'], matches(RegExp(r'^2026-09-0\d$')));
    }
    // The same day twice would not be a second memory.
    expect({
      for (final flashback in flashbacks)
        ((flashback['entries'] as List).single as Map)['id']
    }, hasLength(2));
  });

  test('there are none with too few entries or with flashbacks off', () async {
    expect(await listFlashbacks(), isEmpty);
    await writeEntries();
    await DiaryAppHarness.setSetting(Settings.showFlashbacks, false);
    expect(await listFlashbacks(), isEmpty);
  });
}
