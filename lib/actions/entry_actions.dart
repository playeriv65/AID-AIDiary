// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:math';

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/utils/diary_day.dart';

final EntryStore _store = EntryStore.instance;

Map<String, Object?> _summary(Entry entry) => {
      'id': entry.id,
      'day': DiaryDay.format(entry.day),
      'time': entry.timeCreate.toIso8601String(),
      'preview': entry.text.length > 80
          ? '${entry.text.substring(0, 80)}…'
          : entry.text,
      if (entry.mood != null) 'mood': entry.mood,
    };

Map<String, Object?> _details(Entry entry) => {
      ..._summary(entry),
      'text': entry.text,
      'modified': entry.timeModified.toIso8601String(),
      if (entry.utcOffset != null) 'utcOffsetMinutes': entry.utcOffset,
      if (entry.location case final location?) 'place': location.label,
      if (entry.openAt case final openAt?) 'opensAt': openAt.toIso8601String(),
      'tags': [
        for (final link
            in TagsProvider.instance.getEntryTagsForEntry(entry.id!))
          {
            'tag': TagsProvider.instance.tags
                .where((tag) => tag.id == link.tagId)
                .firstOrNull
                ?.name,
            if (link.value != null) 'value': link.value,
          },
      ],
      'attachments': EntryImagesProvider.instance.getForEntry(entry).length,
    };

Future<Entry> _entry(ActionArgs args) async {
  await _store.complete;
  final id = args['id'] as int;
  for (final entry in _store.entries) {
    if (entry.id == id) return entry;
  }
  throw ActionException('not_found', 'There is no entry $id');
}

DateTime? _day(ActionArgs args) => switch (args['day']) {
      final String text => DiaryDay.parse(text) ??
          (throw ActionException('bad_args', 'day must be yyyy-MM-dd')),
      _ => null,
    };

final List<AppAction> entryActions = [
  AppAction(
    id: 'entry.list',
    describe: 'Lists entries, newest first, optionally of one day or with '
        'some text.',
    risk: ActionRisk.read,
    params: const [
      ActionParam('limit', ParamType.integer, 'How many, 20 by default',
          required: false),
      ActionParam('offset', ParamType.integer, 'How many to skip',
          required: false),
      ActionParam('day', ParamType.string, 'Only this diary day, yyyy-MM-dd',
          required: false),
      ActionParam('search', ParamType.string, 'Only entries with this text',
          required: false),
    ],
    run: (context, args) async {
      await _store.complete;
      final day = _day(args);
      final search = (args['search'] as String?)?.toLowerCase();
      final matching = [
        for (final entry in _store.entries)
          if ((day == null || entry.day == day) &&
              (search == null || entry.text.toLowerCase().contains(search)))
            entry,
      ];
      final offset = args['offset'] as int? ?? 0;
      final limit = args['limit'] as int? ?? 20;
      return {
        'total': matching.length,
        'entries': [
          for (final entry in matching.skip(offset).take(limit))
            _summary(entry),
        ],
      };
    },
  ),
  AppAction(
    id: 'entry.get',
    describe: 'Shows one entry in full.',
    risk: ActionRisk.read,
    params: const [ActionParam('id', ParamType.integer, 'The entry id')],
    run: (context, args) async => _details(await _entry(args)),
  ),
  AppAction(
    id: 'entry.create',
    describe: 'Writes a new entry, for now or for a given day and time.',
    risk: ActionRisk.write,
    params: const [
      ActionParam('text', ParamType.string, 'What the entry says'),
      ActionParam('day', ParamType.string,
          'The diary day, yyyy-MM-dd; from the time by default',
          required: false),
      ActionParam('time', ParamType.string,
          'When it was written, ISO 8601; now by default',
          required: false),
    ],
    run: (context, args) async {
      final now = DateTime.now();
      final written = switch (args['time']) {
        final String text => DateTime.tryParse(text) ??
            (throw const ActionException('bad_args', 'time must be ISO 8601')),
        _ => now,
      };
      final session = _store.beginDraft();
      final saved = await session.save((saved) => EntryDraft(
          entry: Entry(
              id: saved?.id,
              text: args['text'] as String,
              timeCreate: written,
              timeModified: now,
              utcOffset: written.timeZoneOffset.inMinutes,
              day: _day(args))));
      await session.commit();
      return _summary(saved);
    },
  ),
  AppAction(
    id: 'entry.update',
    describe: "Replaces an entry's text; its tags and attachments stay.",
    risk: ActionRisk.write,
    params: const [
      ActionParam('id', ParamType.integer, 'The entry id'),
      ActionParam('text', ParamType.string, 'The new text'),
    ],
    run: (context, args) async {
      final entry = await _entry(args);
      final session = _store.beginDraft(entry);
      final saved = await session.save((_) => EntryDraft(
              entry: entry.copy(
                  text: args['text'] as String, timeModified: DateTime.now()),
              tags: TagsProvider.instance.getEntryTagsForEntry(entry.id!),
              images: [
                for (final image
                    in EntryImagesProvider.instance.getForEntry(entry))
                  image.copy(),
              ]));
      await session.commit();
      return _summary(saved);
    },
  ),
  AppAction(
    id: 'entry.delete',
    describe: 'Moves an entry to Recently deleted.',
    risk: ActionRisk.destructive,
    params: const [ActionParam('id', ParamType.integer, 'The entry id')],
    run: (context, args) async {
      final entry = await _entry(args);
      await _store.delete(entry);
      return {'id': entry.id, 'deleted': true};
    },
  ),
  AppAction(
    id: 'entry.restore',
    describe: 'Brings an entry back from Recently deleted.',
    risk: ActionRisk.write,
    params: const [ActionParam('id', ParamType.integer, 'The entry id')],
    run: (context, args) async {
      final id = args['id'] as int;
      for (final item in await _store.deleted()) {
        if (item.entry.id == id) {
          await _store.restore(item.entry);
          return _summary(item.entry);
        }
      }
      throw ActionException(
          'not_found', 'Entry $id is not in Recently deleted');
    },
  ),
  AppAction(
    id: 'entry.erase',
    describe: 'Erases an entry in Recently deleted for good, with its '
        'attachments.',
    risk: ActionRisk.destructive,
    params: const [ActionParam('id', ParamType.integer, 'The entry id')],
    run: (context, args) async {
      final id = args['id'] as int;
      for (final item in await _store.deleted()) {
        if (item.entry.id == id) {
          await _store.erase(item.entry);
          return {'id': id, 'erased': true};
        }
      }
      throw ActionException(
          'not_found', 'Entry $id is not in Recently deleted');
    },
  ),
  AppAction(
    id: 'entry.seed',
    describe: 'Adds made-up entries, one a day going back from yesterday, '
        'for trying the app with a large diary.',
    risk: ActionRisk.write,
    devOnly: true,
    params: const [
      ActionParam('count', ParamType.integer, 'How many entries'),
      ActionParam('words', ParamType.integer,
          'About how many words each, 80 by default',
          required: false),
    ],
    run: (context, args) async {
      final count = args['count'] as int;
      final words = args['words'] as int? ?? 80;
      final random = Random(count);
      const vocabulary = [
        'rain', 'river', 'coffee', 'walk', 'quiet', 'family', 'train', //
        'letter', 'garden', 'sunset', '下雨', '散步', '河边', '咖啡', '读书', '朋友',
      ];
      final start = DateTime.now().subtract(const Duration(days: 1));
      final stopwatch = Stopwatch()..start();
      // One transaction and one reload: the GUI redraws once, not per entry.
      await AppDatabase.instance.database!.transaction((txn) async {
        final batch = txn.batch();
        for (var i = 0; i < count; i++) {
          final written = DateTime(start.year, start.month, start.day - i, 21);
          batch.insert(entriesTable, {
            EntryFields.text: 'Seed ${i + 1} ${[
              for (var w = 0; w < words; w++)
                vocabulary[random.nextInt(vocabulary.length)],
            ].join(' ')}',
            EntryFields.timeCreate: written.toIso8601String(),
            EntryFields.timeModified: written.toIso8601String(),
            EntryFields.utcOffset: written.timeZoneOffset.inMinutes,
            EntryFields.diaryDate: DiaryDay.format(written),
          });
        }
        await batch.commit(noResult: true);
      });
      await _store.load();
      return {'added': count, 'elapsedMs': stopwatch.elapsedMilliseconds};
    },
  ),
];
