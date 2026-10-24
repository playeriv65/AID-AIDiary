// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/entry_access.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/models/entry_link.dart';
import 'package:aid_diary/providers/links_provider.dart';

/// Entries that may show: not hidden, not a sealed capsule, not deleted.
Set<int> openEntryIds() => {
      for (final entry in EntryStore.instance.entries)
        if (!entry.isSealed) entry.id!,
    };

/// A citation of the open entry [id], of [quote] when given: what a
/// comment on it carries.
Future<EntryRef> citationOf(int id, String? quote) async {
  final cited = await openEntryOf({'id': id});
  final words = quote?.trim();
  final start = words == null || words.isEmpty ? -1 : cited.text.indexOf(words);
  return EntryRef(
    target: await LinksProvider.syncIdOf(id),
    targetId: id,
    quote: words == null || words.isEmpty ? null : words,
    quoteStart: start < 0 ? null : start,
    timeCreate: DateTime.now(),
  );
}

/// What [entryId] cites and which entries answer it, for `entry.get`.
Map<String, Object?> citationsJson(int entryId) {
  final links = LinksProvider.instance;
  final open = openEntryIds();
  final refs = links.refsOf(entryId);
  final replies = [
    for (final id in links.repliesTo(entryId))
      if (open.contains(id)) id
  ];
  return {
    if (refs.isNotEmpty)
      'cites': [
        for (final ref in refs)
          {
            // Gone for good, or out of sight: the quote alone remains.
            'entry': open.contains(ref.targetId) ? ref.targetId : null,
            if (ref.quote != null) 'quote': ref.quote,
          },
      ],
    if (replies.isNotEmpty) 'answeredBy': replies,
  };
}

Map<String, Object?> _passageJson(KeptPassage passage) => {
      'id': passage.id,
      'entry': passage.entryId,
      'quote': passage.quote,
      'time': passage.timeCreate.toIso8601String(),
    };

KeptPassage _passage(ActionArgs args) {
  final id = args['passage'] as int;
  final open = openEntryIds();
  final passage = LinksProvider.instance.passages
      .where((passage) => passage.id == id && open.contains(passage.entryId))
      .firstOrNull;
  if (passage == null) {
    throw ActionException('not_found', 'There is no kept passage $id');
  }
  return passage;
}

final List<AppAction> linkActions = [
  AppAction(
    id: 'passage.keep',
    describe: 'Keeps a passage of an entry, as selecting it and choosing '
        'Keep does.',
    risk: ActionRisk.write,
    params: const [
      entryIdParam,
      ActionParam('quote', ParamType.string, 'The words to keep'),
    ],
    run: (context, args) async {
      final entry = await openEntryOf(args);
      final quote = (args['quote'] as String).trim();
      if (quote.isEmpty) {
        throw const ActionException('bad_args', 'The passage is empty');
      }
      final start = entry.text.indexOf(quote);
      final kept = await LinksProvider.instance.keep(KeptPassage(
          entryId: entry.id!,
          quote: quote,
          quoteStart: start < 0 ? null : start,
          timeCreate: DateTime.now()));
      return _passageJson(kept);
    },
  ),
  AppAction(
    id: 'passage.list',
    describe: 'Lists kept passages, newest first: all, or those of one '
        'entry.',
    risk: ActionRisk.read,
    params: const [
      ActionParam('id', ParamType.integer, 'Only those of this entry',
          required: false),
    ],
    run: (context, args) async {
      final open = openEntryIds();
      final id = args['id'] as int?;
      return {
        'passages': [
          for (final passage in LinksProvider.instance.passages.reversed)
            if (open.contains(passage.entryId) &&
                (id == null || passage.entryId == id))
              _passageJson(passage),
        ],
      };
    },
  ),
  AppAction(
    id: 'passage.delete',
    describe: 'Lets a kept passage go.',
    risk: ActionRisk.destructive,
    params: const [
      ActionParam('passage', ParamType.integer, 'The passage id'),
    ],
    run: (context, args) async {
      final passage = _passage(args);
      await LinksProvider.instance.forget(passage);
      return {'id': passage.id, 'deleted': true};
    },
  ),
  AppAction(
    id: 'entry.cite',
    describe: 'Makes an entry cite another (or words of it), as the '
        "editor's Cite does. A comment is an entry citing what it answers.",
    risk: ActionRisk.write,
    params: const [
      entryIdParam,
      ActionParam('target', ParamType.integer, 'The entry to cite'),
      ActionParam('quote', ParamType.string, 'Words of it to cite',
          required: false),
    ],
    run: (context, args) async {
      final entry = await openEntryOf(args);
      final target = args['target'] as int;
      if (target == entry.id) {
        throw const ActionException('bad_args', 'An entry cannot cite itself');
      }
      final ref = await citationOf(target, args['quote'] as String?);
      await saveEntry(entry,
          refs: [...LinksProvider.instance.refsOf(entry.id!), ref]);
      return citationsJson(entry.id!);
    },
  ),
  AppAction(
    id: 'entry.uncite',
    describe: 'Takes the citations of one entry out of another.',
    risk: ActionRisk.write,
    params: const [
      entryIdParam,
      ActionParam('target', ParamType.integer, 'The cited entry'),
    ],
    run: (context, args) async {
      final entry = await openEntryOf(args);
      final target = args['target'] as int;
      await saveEntry(entry, refs: [
        for (final ref in LinksProvider.instance.refsOf(entry.id!))
          if (ref.targetId != target) ref
      ]);
      return citationsJson(entry.id!);
    },
  ),
];
