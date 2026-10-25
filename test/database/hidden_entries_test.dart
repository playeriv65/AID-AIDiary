// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['integration'])
library;

import 'dart:convert';

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/database/entry_dao.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/l10n/generated/app_localizations_en.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/services/home_widget_service.dart';
import 'package:aid_diary/sync/sync_schema.dart';
import 'package:aid_diary/utils/diary_day.dart';
import 'package:aid_diary/utils/entry_filter.dart';
import 'package:aid_diary/utils/export_utils.dart';
import 'package:aid_diary/widgets/hidden_diary_scope.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();
  final store = EntryStore.instance;
  final actions = AppActions(devBuild: true);
  final time = DateTime(2026, 10, 20, 9);

  Entry entry(String text, {bool hidden = false}) =>
      Entry(text: text, timeCreate: time, timeModified: time, isHidden: hidden);

  test('hidden state survives SQL, reload, drafts and restoration', () async {
    final saved = await store.add(entry('Private text', hidden: true));
    await store.load();
    expect(store.entries, isEmpty);
    expect(EntriesProvider.instance.entries, isEmpty);
    expect(store.allEntries.single.isHidden, isTrue);
    expect((await EntryDao.get(saved.id!))!.isHidden, isTrue);
    final session = store.beginDraft(saved);
    final edited = await session
        .save((_) => EntryDraft(entry: saved.copy(text: 'Private revision')));
    await session.commit();
    expect(edited.isHidden, isTrue);
    expect(store.entries, isEmpty);
    await store.delete(edited);
    expect(await store.deleted(), isEmpty);
    expect((await store.deleted(includeHidden: true)).single.entry.isHidden,
        isTrue);
    await store.restore(edited);
    expect(store.entries, isEmpty);
    expect(store.hiddenEntries.single.text, 'Private revision');
  });

  test('hiding removes day indexes, search, widgets and CLI content', () async {
    final visible = await store.add(entry('Public text'));
    final secret = await store.add(entry('Private text'));
    await actions.run('entry.hide', {'id': secret.id});
    expect(store.entries.map((e) => e.id), [visible.id]);
    expect(store.getEntriesForDate(time).map((e) => e.id), [visible.id]);
    expect(store.getEntryDayCount(), 1);
    expect(store.hasEntryAtTimestamp(time), isTrue);
    expect(EntryFilter(query: 'Private').matches(store.hiddenEntries.single),
        isFalse);
    expect(
        HomeWidgetSnapshot.from(store.allEntries, AppLocalizationsEn()).snippet,
        'Public text');
    expect(photoCandidates(store.hiddenEntries, (_) => [], 10), isEmpty);
    final listed = jsonEncode(await actions.run('entry.list', {}));
    expect(listed, contains('Public text'));
    expect(listed, isNot(contains('Private text')));
    for (final id in ['entry.get', 'entry.update']) {
      await expectLater(
          actions.run(id, {'id': secret.id}),
          throwsA(isA<ActionException>()
              .having((e) => e.code, 'code', 'not_found')));
    }
  });

  test('a local session cannot reveal before unlocking or after locking',
      () async {
    final saved = await store.add(entry('Private text', hidden: true));
    final session = HiddenDiarySession();
    addTearDown(session.dispose);
    await expectLater(session.unhide(saved), throwsStateError);
    session.unlock();
    session.lock();
    await expectLater(session.unhide(saved), throwsStateError);
    session.unlock();
    await session.unhide(saved);
    expect(store.entries.single.text, 'Private text');
    expect(store.entries.single.isHidden, isFalse);
  });

  test('plain exports omit hidden rows even when passed raw storage contents',
      () async {
    final json = encodeJsonEntries(
        [entry('Public text'), entry('Private text', hidden: true)],
        imagesOf: (_) => [], tagsOf: (_) => [], weatherOf: (_) => null);
    expect(jsonDecode(json), hasLength(1));
    expect(json, isNot(contains('Private text')));
  });

  test('version 13 gains hidden defaults without rewriting diary content',
      () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath,
        options: OpenDatabaseOptions(singleInstance: false));
    addTearDown(db.close);
    await AppDatabase.instance.createVersion10Schema(db);
    await addSyncSchema(db);
    final id = await db.insert(entriesTable, {
      EntryFields.text: 'Existing diary',
      EntryFields.timeCreate: time.toIso8601String(),
      EntryFields.timeModified: time.toIso8601String(),
      EntryFields.diaryDate: DiaryDay.format(time),
      EntryFields.utcOffset: 480,
    });
    final before = (await db.query(entriesTable)).single;
    await AppDatabase.instance.upgradeSchema(db, 13, 14);
    final after = (await db.query(entriesTable)).single;
    expect(after, {...before, EntryFields.isHidden: 0});
    expect(Entry.fromJson(after).id, id);
    expect(await db.query('import_sources'), isEmpty);
    AppDatabase.instance.database = harness.database;
  });
}
