// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/entry_access.dart';
import 'package:aid_diary/actions/place_actions.dart';
import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/models/builtin_templates.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/providers/templates_provider.dart';
import 'package:aid_diary/template_renderer.dart';
import 'package:aid_diary/utils/diary_day.dart';
import 'package:aid_diary/utils/entry_filter.dart';
import 'package:aid_diary/utils/entry_preview.dart';
import 'package:aid_diary/utils/time_capsule.dart';
import 'package:image/image.dart' as img;

final EntryStore _store = EntryStore.instance;

/// What `entry.erase_all` wants as `confirm`: the whole diary is not
/// something to erase by a slip of the hand.
const String eraseAllPhrase = 'delete-all';

ActionException _bad(String message) => ActionException('bad_args', message);

Map<String, Object?> _place(EntryLocation location) => {
      'place': location.label,
      if (location.hasCoordinates) ...{
        'latitude': location.latitude,
        'longitude': location.longitude,
      },
    };

/// What a list shows of [entry]. A time capsule that has not opened gives
/// away only that it is sealed and when it opens, as in the GUI.
Map<String, Object?> _summary(Entry entry) => {
      'id': entry.id,
      'day': DiaryDay.format(entry.day),
      'time': entry.timeCreate.toIso8601String(),
      if (entry.isSealed) ...{
        'sealed': true,
        'opensAt': entry.openAt!.toIso8601String(),
      } else ...{
        'preview': entry.text.length > 80
            ? '${entry.text.substring(0, 80)}…'
            : entry.text,
        if (entry.mood != null) 'mood': entry.mood,
        if (entry.location case final location?) ..._place(location),
      },
    };

Map<String, Object?> _details(Entry entry) {
  if (entry.isSealed) return _summary(entry);
  final tags = TagsProvider.instance;
  return {
    ..._summary(entry),
    'text': entry.text,
    'modified': entry.timeModified.toIso8601String(),
    if (entry.utcOffset != null) 'utcOffsetMinutes': entry.utcOffset,
    if (entry.weather case final weather?)
      'weather': {'code': weather.code, 'temperature': weather.temperature},
    if (entry.activity case final activity?) 'activity': activity.name,
    if (entry.openAt case final openAt?) 'opensAt': openAt.toIso8601String(),
    'favorite': tags.isFavorite(entry.id!),
    'tags': [
      for (final link in tags.getEntryTagsForEntry(entry.id!))
        {
          'tag':
              tags.tags.where((tag) => tag.id == link.tagId).firstOrNull?.name,
          if (link.value != null) 'value': link.value,
        },
    ],
    'attachments': EntryImagesProvider.instance.getForEntry(entry).length,
  };
}

/// The `limit` and `offset` page of [items] with how many there are in all.
/// [kinds] different made-up photos as JPEG, the size the app keeps a
/// phone photo at: a colour wash with a few round shapes, so each decodes
/// as a real one does.
List<Uint8List> _seedPhotos(int kinds) => [
      for (var kind = 0; kind < kinds; kind++)
        () {
          final random = Random(kind);
          final picture = img.Image(width: 1600, height: 1200);
          final from = [for (var c = 0; c < 3; c++) random.nextInt(256)];
          final to = [for (var c = 0; c < 3; c++) random.nextInt(256)];
          for (final pixel in picture) {
            final t = (pixel.x + pixel.y) / (1600 + 1200);
            pixel
              ..r = from[0] + (to[0] - from[0]) * t
              ..g = from[1] + (to[1] - from[1]) * t
              ..b = from[2] + (to[2] - from[2]) * t;
          }
          for (var shape = 0; shape < 6; shape++) {
            img.fillCircle(picture,
                x: random.nextInt(1600),
                y: random.nextInt(1200),
                radius: 80 + random.nextInt(240),
                color: img.ColorRgb8(random.nextInt(256), random.nextInt(256),
                    random.nextInt(256)));
          }
          return img.encodeJpg(picture, quality: 85);
        }(),
    ];

Map<String, Object?> _page<T>(
        List<T> items, ActionArgs args, Map<String, Object?> Function(T) of) =>
    {
      'total': items.length,
      'entries': [
        for (final item in items
            .skip(args['offset'] as int? ?? 0)
            .take(args['limit'] as int? ?? 20))
          of(item),
      ],
    };

const List<ActionParam> _pageParams = [
  ActionParam('limit', ParamType.integer, 'How many, 20 by default',
      required: false),
  ActionParam('offset', ParamType.integer, 'How many to skip', required: false),
];

/// A diary day written yyyy-MM-dd, as stored.
DateTime? _dayOf(Object? text) {
  if (text == null) return null;
  final day = DiaryDay.parse('$text');
  if (day == null || DiaryDay.format(day) != text) {
    throw _bad('A day is written yyyy-MM-dd');
  }
  return day;
}

/// The words of a comma-separated argument.
List<String> _words(Object? text) => [
      for (final word in (text as String? ?? '').split(','))
        if (word.trim().isNotEmpty) word.trim(),
    ];

Set<int> _tagIds(Object? text) {
  final tags = TagsProvider.instance.tags;
  return {
    for (final word in _words(text))
      (tags
                  .where((tag) => tag.name.toLowerCase() == word.toLowerCase())
                  .firstOrNull ??
              tags.where((tag) => '${tag.id}' == word).firstOrNull ??
              (throw ActionException('not_found', 'There is no tag $word')))
          .id!,
  };
}

int _moodOf(String text) => switch (int.tryParse(text)) {
      final mood? when mood >= -2 && mood <= 2 => mood,
      _ => throw _bad('A mood is a number from -2 to 2, not $text'),
    };

EntryActivity _activityOf(String name) =>
    EntryActivity.fromName(name) ??
    (throw _bad('An activity is one of $_activityNames, not $name'));

final String _activityNames =
    EntryActivity.values.map((activity) => activity.name).join(', ');

EntryWeather _weatherOf(String text) {
  final parts = text.split(',');
  final code = parts.length == 2 ? int.tryParse(parts[0].trim()) : null;
  final temperature =
      parts.length == 2 ? double.tryParse(parts[1].trim()) : null;
  if (code == null || temperature == null) {
    throw _bad('weather is a WMO weather code and a temperature in °C, '
        'such as 61,12.5, or $noValue');
  }
  return EntryWeather(code: code, temperature: temperature);
}

bool _clears(String text) => text.isEmpty || text == noValue;

/// A change to an optional field: null leaves it, a value (which may be
/// null) sets or clears it.
typedef _Change<T> = ({T? value})?;

T? _pick<T>(_Change<T> change, T? current) =>
    change == null ? current : change.value;

/// The optional fields of an entry that `entry.create` and `entry.update`
/// share, read from their arguments.
class _Fields {
  _Fields(ActionArgs args)
      : text = args['text'] as String?,
        day = _dayOf(args['day']),
        time = switch (args['time']) {
          final String text =>
            (DateTime.tryParse(text) ?? (throw _bad('time must be ISO 8601')))
                .toLocal(),
          _ => null,
        },
        mood = switch (args['mood']) {
          final String text => (value: _clears(text) ? null : _moodOf(text)),
          _ => null,
        },
        activity = switch (args['activity']) {
          final String text => (
              value: _clears(text) ? null : _activityOf(text)
            ),
          _ => null,
        },
        weather = switch (args['weather']) {
          final String text => (value: _clears(text) ? null : _weatherOf(text)),
          _ => null,
        },
        clearPlace = switch (args['place']) {
          final String name => _clears(name),
          _ => false,
        },
        placeName = switch (args['place']) {
          final String name when !_clears(name) => name,
          _ => null,
        },
        latitude =
            args['latitude'] == null ? null : degreesArg(args, 'latitude', 90),
        longitude = args['longitude'] == null
            ? null
            : degreesArg(args, 'longitude', 180) {
    if ((latitude == null) != (longitude == null)) {
      throw _bad('latitude and longitude go together');
    }
    if (clearPlace && latitude != null) {
      throw _bad('A place cannot be removed and set at once');
    }
  }

  final String? text;
  final DateTime? day;
  final DateTime? time;
  final _Change<int> mood;
  final _Change<EntryActivity> activity;
  final _Change<EntryWeather> weather;
  final bool clearPlace;
  final String? placeName;
  final double? latitude;
  final double? longitude;

  /// Whether mood, place, weather or activity is set or cleared.
  bool get changesContext =>
      mood != null ||
      activity != null ||
      weather != null ||
      clearPlace ||
      placeName != null ||
      latitude != null;

  bool get isEmpty =>
      text == null && day == null && time == null && !changesContext;

  /// [entry] with mood, place, weather and activity as these fields say.
  Entry withContext(Entry entry) => entry.copy(
      mood: _pick(mood, entry.mood),
      activity: _pick(activity, entry.activity),
      weather: _pick(weather, entry.weather),
      location: _locationFor(entry.location));

  /// A new name or coordinates change the place they name; coordinates
  /// without a name drop the old name, which belonged to the old spot.
  EntryLocation? _locationFor(EntryLocation? current) {
    if (clearPlace) return null;
    if (placeName == null && latitude == null) return current;
    final place = EntryLocation(
        name: placeName ?? (latitude == null ? current?.name : null),
        latitude: latitude ?? current?.latitude,
        longitude: longitude ?? current?.longitude);
    return place.isEmpty ? null : place;
  }
}

final List<ActionParam> _fieldParams = [
  ActionParam('mood', ParamType.string,
      'Mood from -2 (worst) to 2 (best); $noValue removes it',
      required: false),
  ActionParam('place', ParamType.string,
      'Name of the place; $noValue removes the place',
      required: false),
  const ActionParam('latitude', ParamType.number,
      'Latitude of the place in decimal degrees, given with longitude',
      required: false),
  const ActionParam('longitude', ParamType.number,
      'Longitude of the place in decimal degrees, given with latitude',
      required: false),
  ActionParam('weather', ParamType.string,
      'WMO weather code and temperature in °C, such as 61,12.5; $noValue removes it',
      required: false),
  ActionParam('activity', ParamType.string,
      'One of $_activityNames; $noValue removes it',
      required: false),
];

const List<ActionParam> _whenParams = [
  ActionParam('day', ParamType.string,
      'The diary day, yyyy-MM-dd; from the time by default',
      required: false),
  ActionParam(
      'time', ParamType.string, 'When it was written, ISO 8601; now by default',
      required: false),
];

/// The text and tags a template gives a new entry. A template is a stored
/// one by its number, or a ready-made one by its name such as `morning`.
Future<({String text, List<int> tagIds})> _templateOf(String id) async {
  final number = int.tryParse(id);
  final stored = TemplatesProvider.instance.templates
      .where((template) => template.id == number)
      .firstOrNull;
  if (stored != null) {
    return (
      text: TemplateRenderer.populateForDevice(stored.text ?? ''),
      tagIds: [
        for (final link
            in TagsProvider.instance.getTemplateTagsForTemplate(stored.id!))
          link.tagId,
      ],
    );
  }
  // Not awaited as it comes: a synchronous future reports an error thrown
  // below as uncaught as well as returning it.
  final l10n = await Future.value(TemplatesProvider.defaultsLocalizations());
  final builtin = BuiltinTemplate.all(l10n)
      .where((template) => template.id == id)
      .firstOrNull;
  if (builtin == null) {
    throw ActionException('not_found', 'There is no template $id');
  }
  return (
    text: TemplateRenderer.populateForDevice(builtin.text),
    tagIds: const <int>[],
  );
}

/// The entries `entry.list` shows: of one [day] when given, and, when any
/// filter is set, those that match it.
List<Entry> _matching(ActionArgs args) {
  final day = _dayOf(args['day']);
  final filter = EntryFilter(
    query: args['search'] as String? ?? '',
    tagIds: _tagIds(args['tags']),
    starred: args['starred'] == true,
    moods: {for (final word in _words(args['moods'])) _moodOf(word)},
    activities: {
      for (final word in _words(args['activity'])) _activityOf(word)
    },
    hasLocation: args['has_location'] as bool?,
  );
  return [
    for (final entry in _store.entries)
      if ((day == null || entry.day == day) &&
          (!filter.isActive || filter.matches(entry)))
        entry,
  ];
}

final List<AppAction> entryActions = [
  AppAction(
    id: 'entry.list',
    describe: 'Lists entries, newest first, optionally of one day or '
        'narrowed down like the search screen does. Time capsules that have '
        'not opened show only that they are sealed, and never match a filter.',
    risk: ActionRisk.read,
    params: [
      ..._pageParams,
      const ActionParam(
          'day', ParamType.string, 'Only this diary day, yyyy-MM-dd',
          required: false),
      const ActionParam('search', ParamType.string,
          'Only entries with this text or in a place of this name',
          required: false),
      const ActionParam('tags', ParamType.string,
          'Only entries with one of these tags: names or ids, comma-separated',
          required: false),
      const ActionParam(
          'starred', ParamType.boolean, 'true: only starred (favorite) entries',
          required: false),
      const ActionParam('moods', ParamType.string,
          'Only entries with one of these moods, such as 2,1',
          required: false),
      ActionParam('activity', ParamType.string,
          'Only entries with one of these activities, comma-separated: $_activityNames',
          required: false),
      const ActionParam('has_location', ParamType.boolean,
          'true: only entries with coordinates, false: only those without',
          required: false),
    ],
    run: (context, args) async {
      await _store.complete;
      return _page(_matching(args), args, _summary);
    },
  ),
  AppAction(
    id: 'entry.get',
    describe: 'Shows one entry in full.',
    risk: ActionRisk.read,
    params: const [entryIdParam],
    run: (context, args) async => _details(await entryOf(args)),
  ),
  AppAction(
    id: 'entry.create',
    describe: 'Writes a new entry, for now or for a given day and time. '
        'Without text, a mood, place, weather, activity or template must '
        'say what it is: a quick check-in is a mood alone.',
    risk: ActionRisk.write,
    params: [
      const ActionParam('text', ParamType.string, 'What the entry says',
          required: false),
      ..._whenParams,
      ..._fieldParams,
      const ActionParam('template', ParamType.string,
          'A template to start from: its id, or a ready-made one such as morning; the text goes below it',
          required: false),
    ],
    run: (context, args) async {
      final fields = _Fields(args);
      final template = switch (args['template']) {
        final String id => await _templateOf(id),
        _ => null,
      };
      final text = mergeSharedText(template?.text ?? '', fields.text);
      final now = DateTime.now();
      final written = fields.time ?? now;
      final entry = fields.withContext(Entry(
          text: text,
          timeCreate: written,
          timeModified: now,
          utcOffset: written.timeZoneOffset.inMinutes,
          day: fields.day));
      final session = _store.beginDraft();
      final saved = await session.save((saved) =>
          EntryDraft(entry: entry.copy(id: saved?.id), tags: [
            for (final tagId in template?.tagIds ?? const <int>[])
              EntryTag(entryId: saved?.id ?? -1, tagId: tagId, timeCreate: now),
          ]));
      await session.commit();
      return _summary(saved);
    },
  ),
  AppAction(
    id: 'entry.update',
    describe: 'Changes an entry: its text, mood, place, weather, activity, '
        'diary day or written time. What is not given stays, and so do its '
        'tags and attachments.',
    risk: ActionRisk.write,
    params: [
      entryIdParam,
      const ActionParam('text', ParamType.string, 'The new text',
          required: false),
      ..._whenParams,
      ..._fieldParams,
    ],
    run: (context, args) async {
      final entry = await openEntryOf(args);
      final fields = _Fields(args);
      if (fields.isEmpty) {
        throw _bad('Nothing to change: give a text, mood, place, weather, '
            'activity, day or time');
      }
      final time = fields.time;
      final saved = await saveEntry(fields.withContext(entry.copy(
          text: fields.text,
          timeCreate: time,
          utcOffset:
              time == null ? entry.utcOffset : time.timeZoneOffset.inMinutes,
          day: fields.day,
          timeModified: DateTime.now())));
      return _summary(saved);
    },
  ),
  AppAction(
    id: 'entry.append',
    describe: 'Adds text to the end of an entry, below a blank line.',
    risk: ActionRisk.write,
    params: const [
      entryIdParam,
      ActionParam('text', ParamType.string, 'The text to add'),
    ],
    run: (context, args) async {
      final entry = await openEntryOf(args);
      final saved = await saveEntry(entry.copy(
          text: mergeSharedText(entry.text, args['text'] as String),
          timeModified: DateTime.now()));
      return _summary(saved);
    },
  ),
  AppAction(
    id: 'entry.hide',
    describe: 'Hides an entry from ordinary views. Revealing or reading it '
        'requires local authentication in Settings > Security > Hidden entries.',
    risk: ActionRisk.write,
    params: const [entryIdParam],
    run: (context, args) async {
      final entry = await entryOf(args);
      await _store.setHidden(entry, true);
      return {'id': entry.id, 'hidden': true};
    },
  ),
  AppAction(
    id: 'entry.favorite',
    describe: 'Stars an entry, or takes the star off.',
    risk: ActionRisk.write,
    params: const [
      entryIdParam,
      ActionParam('value', ParamType.boolean, 'true to star, false to unstar'),
    ],
    run: (context, args) async {
      final entry = await openEntryOf(args);
      final tags = TagsProvider.instance;
      await tags.setFavorite(entry.id!, args['value'] as bool);
      return {'id': entry.id, 'favorite': tags.isFavorite(entry.id!)};
    },
  ),
  AppAction(
    id: 'entry.seal',
    describe: 'Seals an entry as a time capsule that opens on a later day, '
        'from tomorrow up to 50 years ahead. Until then it shows neither '
        'text nor details.',
    risk: ActionRisk.write,
    params: const [
      entryIdParam,
      ActionParam('opens', ParamType.string, 'The day it opens, yyyy-MM-dd'),
    ],
    run: (context, args) async {
      final entry = await openEntryOf(args);
      final opens = _dayOf(args['opens'])!;
      if (!CapsuleWindow.allows(opens, DateTime.now())) {
        throw _bad('A capsule opens from tomorrow, up to 50 years ahead');
      }
      return _summary(await _store.setOpenAt(entry, opens));
    },
  ),
  AppAction(
    id: 'entry.unseal',
    describe: 'Opens a time capsule before its day.',
    risk: ActionRisk.destructive,
    params: const [entryIdParam],
    run: (context, args) async {
      final entry = await entryOf(args);
      if (!entry.isSealed) {
        throw ActionException(
            'not_sealed', 'Entry ${entry.id} is not a sealed time capsule');
      }
      return _summary(await _store.setOpenAt(entry, null));
    },
  ),
  AppAction(
    id: 'entry.delete',
    describe: 'Moves an entry to Recently deleted.',
    risk: ActionRisk.destructive,
    params: const [entryIdParam],
    run: (context, args) async {
      final entry = await entryOf(args);
      await _store.delete(entry);
      return {'id': entry.id, 'deleted': true};
    },
  ),
  AppAction(
    id: 'entry.deleted',
    describe: 'Lists the entries in Recently deleted, most recently deleted '
        'first, with when each is erased for good.',
    risk: ActionRisk.read,
    params: _pageParams,
    run: (context, args) async => _page(
        await _store.deleted(),
        args,
        (item) => {
              ..._summary(item.entry),
              'deletedAt': item.deletedAt.toIso8601String(),
              'daysLeft': item.daysLeft,
            }),
  ),
  AppAction(
    id: 'entry.restore',
    describe: 'Brings an entry back from Recently deleted.',
    risk: ActionRisk.write,
    params: const [entryIdParam],
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
    params: const [entryIdParam],
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
    id: 'entry.empty_deleted',
    describe: 'Erases everything in Recently deleted for good, with the '
        'attachments.',
    risk: ActionRisk.destructive,
    run: (context, args) async => {'erased': await _store.emptyDeleted()},
  ),
  AppAction(
    id: 'entry.erase_all',
    describe: 'Erases every entry for good, including Recently deleted, '
        'with all attachments. Needs confirm=$eraseAllPhrase besides the '
        'usual confirmation.',
    risk: ActionRisk.destructive,
    params: const [
      ActionParam('confirm', ParamType.string,
          'Must be $eraseAllPhrase, to show that this is meant'),
    ],
    run: (context, args) async {
      if (args['confirm'] != eraseAllPhrase) {
        throw _bad('confirm must be $eraseAllPhrase');
      }
      await _store.complete;
      final count = _store.entries.length + (await _store.deleted()).length;
      await _store.deleteAll(context.progress);
      return {'erased': count};
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
      ActionParam(
          'photos',
          ParamType.integer,
          'How many of them get a made-up photo, spread evenly; none by '
              'default',
          required: false),
    ],
    run: (context, args) async {
      final count = args['count'] as int;
      final words = args['words'] as int? ?? 80;
      final photos = min(args['photos'] as int? ?? 0, count);
      // A dozen different pictures, each entry's in a file of its own as
      // a photo of its own would be.
      final pictures = photos == 0
          ? <Uint8List>[]
          : await Isolate.run(() => _seedPhotos(12));
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
        final ids = await batch.commit();
        if (photos == 0) return;
        final images = await ImageStorage.instance.internalStore();
        final photoRows = txn.batch();
        for (var i = 0; i < photos; i++) {
          final index = i * count ~/ photos;
          final id = ids[index] as int;
          final name = 'seed_$id.jpg';
          if (!await images.write(name, pictures[i % pictures.length])) {
            throw ActionException('write_failed', 'Could not store $name');
          }
          photoRows.insert(imagesTable, {
            EntryImageFields.entryId: id,
            EntryImageFields.imgPath: name,
            EntryImageFields.imgRank: 0,
            EntryImageFields.timeCreate:
                DateTime(start.year, start.month, start.day - index, 21)
                    .toIso8601String(),
          });
        }
        await photoRows.commit(noResult: true);
      });
      await EntryImagesProvider.instance.load();
      await _store.load();
      return {
        'added': count,
        'photos': photos,
        'elapsedMs': stopwatch.elapsedMilliseconds,
      };
    },
  ),
];
