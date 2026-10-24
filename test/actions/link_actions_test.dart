// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['integration'])
library;

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/entry_link.dart';
import 'package:aid_diary/providers/links_provider.dart';
import 'package:aid_diary/utils/diary_day.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/diary_app_harness.dart';

void main() {
  DiaryAppHarness().register();
  final actions = AppActions(devBuild: true);
  final store = EntryStore.instance;
  final lastYear = DateTime(2025, 3, 1, 21);

  Future<Entry> past(String text, {bool hidden = false}) => store.add(Entry(
      text: text,
      timeCreate: lastYear,
      timeModified: lastYear,
      isHidden: hidden));

  Future<Map<String, Object?>> run(String id, Map<String, Object?> args,
          {bool confirmed = false}) async =>
      (await actions.run(id, args, confirmed: confirmed))!
          as Map<String, Object?>;

  test('a comment is an entry of today citing the words it answers', () async {
    final lake = await past('Snow fell on the lake. We skated until dark.');
    final comment = await run('entry.create', {
      'text': 'I still remember the cold.',
      'cite': lake.id,
      'quote': 'We skated until dark.',
      'place': 'Minneapolis',
    });
    expect(comment['day'], DiaryDay.format(DiaryDay.today()));
    final ref = LinksProvider.instance.refsOf(comment['id'] as int).single;
    expect(ref.targetId, lake.id);
    expect(ref.quoteStart, 23);

    expect((await run('entry.get', {'id': comment['id']}))['cites'], [
      {'entry': lake.id, 'quote': 'We skated until dark.'}
    ]);
    expect((await run('entry.get', {'id': lake.id}))['answeredBy'],
        [comment['id']]);
  });

  test('an entry cites another, and lets it go', () async {
    final first = await past('First');
    final second = await past('Second');
    await run('entry.cite', {'id': second.id, 'target': first.id});
    expect(LinksProvider.instance.repliesTo(first.id!), [second.id]);
    await run('entry.uncite', {'id': second.id, 'target': first.id});
    expect(LinksProvider.instance.refsOf(second.id!), isEmpty);
    await expectLater(
        actions.run('entry.cite', {'id': second.id, 'target': second.id}),
        throwsA(
            isA<ActionException>().having((e) => e.code, 'code', 'bad_args')));
  });

  test('passages are kept, listed and let go', () async {
    final entry = await past('Snow fell on the lake.');
    final kept =
        await run('passage.keep', {'id': entry.id, 'quote': 'the lake'});
    expect((await run('passage.list', {}))['passages'], [
      containsPair('quote', 'the lake'),
    ]);
    await run('passage.delete', {'passage': kept['id']}, confirmed: true);
    expect(LinksProvider.instance.passages, isEmpty);
  });

  test('hidden entries cannot be cited or kept from', () async {
    final secret = await past('Private', hidden: true);
    for (final (id, args) in [
      ('entry.create', {'text': 'x', 'cite': secret.id}),
      ('passage.keep', {'id': secret.id, 'quote': 'Private'}),
    ]) {
      await expectLater(
          actions.run(id, args),
          throwsA(isA<ActionException>()
              .having((e) => e.code, 'code', 'not_found')));
    }
  });

  test('erasing a cited entry keeps the quote; erasing the citer, its links',
      () async {
    final lake = await past('Snow fell on the lake.');
    final comment = await run('entry.create',
        {'text': 'Cold.', 'cite': lake.id, 'quote': 'the lake'});
    await run('passage.keep', {'id': lake.id, 'quote': 'Snow'});

    await store.erase(lake);
    expect((await run('entry.get', {'id': comment['id']}))['cites'], [
      {'entry': null, 'quote': 'the lake'}
    ]);
    final db = AppDatabase.instance.database!;
    expect(await db.query(passagesTable), isEmpty);

    await store.erase(store.entries.single);
    expect(await db.query(entryRefsTable), isEmpty);
  });
}
