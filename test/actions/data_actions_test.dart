// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['integration'])
library;

import 'dart:convert';
import 'dart:io';

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/utils/zip_utils.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import '../support/app_folders_harness.dart';
import '../support/diary_app_harness.dart';

void main() {
  DiaryAppHarness().register();
  final folders = useTemporaryAppFolders();
  final actions = AppActions(devBuild: true);
  final config = ConfigProvider.instance;

  Future<Map<String, Object?>> run(String id, Map<String, Object?> args,
          {bool confirmed = false}) async =>
      (await actions.run(id, args, confirmed: confirmed))
          as Map<String, Object?>;

  Matcher refused(String code) =>
      throwsA(isA<ActionException>().having((e) => e.code, 'code', code));

  String write(String name, String content) {
    final file = File(p.join(folders().folder('files').path, name))
      ..writeAsStringSync(content);
    return file.path;
  }

  List<String> texts() => [
        for (final entry in EntryStore.instance.entries) entry.text,
      ]..sort();

  Future<void> add(String text, DateTime time) => EntryStore.instance.add(Entry(
      text: text,
      mood: 1,
      timeCreate: time,
      timeModified: time,
      location: const EntryLocation(
          latitude: 48.1, longitude: 11.6, name: 'Munich')));

  group('import and export', () {
    test('a file of this app is imported once, whatever is in the diary',
        () async {
      final path = write(
          'diary.json',
          jsonEncode([
            {
              'text': 'From another device',
              'mood': 2,
              'timeCreated': '2026-10-01T09:00:00.000',
              'timeModified': '2026-10-01T09:00:00.000',
              'diaryDate': '2026-10-01',
              'tags': [
                {'name': 'travel'}
              ],
              'images': [],
            }
          ]));
      final first = await run('data.import', {'format': 'json', 'path': path});
      expect(first, {'format': 'json', 'added': 1, 'entries': 1});
      expect(texts(), ['From another device']);
      expect(EntryStore.instance.entries.single.mood, 2);
      // The same file again adds nothing.
      expect(
          (await run('data.import', {'format': 'json', 'path': path}))['added'],
          0);
      expect(texts(), hasLength(1));
    });

    test('other apps\' files are read by their own format', () async {
      await run('data.import', {
        'format': 'my_brain',
        'path': write(
            'brain.json',
            jsonEncode({
              'diary': [
                {
                  'title': 'Hello',
                  'content': 'World',
                  'mood': 'GOOD',
                  'createdDate': 1760000000000,
                  'updatedDate': 1760000000000,
                }
              ]
            })),
      });
      await run('data.import', {
        'format': 'pixels',
        'path': write(
            'pixels.json',
            jsonEncode([
              {
                'type': 'Mood',
                'date': '2026-09-01',
                'scores': [5],
                'notes': 'A good day',
              }
            ])),
      });
      expect(texts(), ['# Hello\n\nWorld', 'A good day']);
      expect(
          [for (final entry in EntryStore.instance.entries) entry.mood]..sort(),
          [1, 2]);
    });

    test('a bad format, file or content is refused with a reason', () async {
      final path = write('empty.json', '[]');
      expect(() => run('data.import', {'format': 'excel', 'path': path}),
          refused('bad_args'));
      expect(
          () => run('data.import',
              {'format': 'json', 'path': p.join(p.dirname(path), 'gone.json')}),
          refused('not_found'));
      expect(
          () => run('data.import',
              {'format': 'json', 'path': write('bad.json', 'not json')}),
          refused('failed'));
      expect(texts(), isEmpty);
      // Every format the app reads is offered, under the name scripts use.
      final offered = actions.find('data.import').params.first.describe;
      for (final format in [
        'json',
        'day_one',
        'daybook',
        'daylio',
        'diarium',
        'diaro',
        'journey',
        'my_brain',
        'one_shot',
        'pixels',
      ]) {
        expect(offered, contains(format));
      }
    });

    test('the diary goes out as JSON and comes back whole', () async {
      await add('Walk by the river', DateTime(2026, 10, 20, 8));
      final folder = p.join(folders().folder('out').path, 'new', 'deeper');
      final exported =
          await run('data.export', {'format': 'json', 'path': folder});
      expect(exported['entries'], 1);
      final file = File(p.join(folder, exported['file'] as String));
      expect(p.basename(file.path), matches(RegExp(r'^aid_diary_.*\.json$')));

      final entry = EntryStore.instance.entries.single;
      await EntryStore.instance.erase(entry);
      expect(texts(), isEmpty);
      await run('data.import', {'format': 'json', 'path': file.path});
      final back = EntryStore.instance.entries.single;
      expect(back.text, 'Walk by the river');
      expect(back.mood, 1);
      expect(back.location!.name, 'Munich');
      expect(back.timeCreate, DateTime(2026, 10, 20, 8));
    });

    test('entry export excludes sealed writing and reports the exported count',
        () async {
      await add('Open writing', DateTime(2026, 10, 20));
      await EntryStore.instance.add(Entry(
          text: 'Private capsule',
          timeCreate: DateTime(2026, 10, 21),
          timeModified: DateTime(2026, 10, 21),
          openAt: DateTime(2099)));
      final folder = folders().folder('out').path;
      final exported =
          await run('data.export', {'format': 'json', 'path': folder});
      expect(exported['entries'], 1);
      final data = jsonDecode(
          await File(p.join(folder, exported['file'] as String))
              .readAsString()) as List;
      expect(data.single['text'], 'Open writing');
      expect(EntryStore.instance.entries, hasLength(2));
    });

    test('the other formats are zips with the notes in them', () async {
      await add('Walk by the river', DateTime(2026, 10, 20, 8));
      final folder = folders().folder('out').path;
      for (final (format, name) in [
        ('markdown', 'markdown'),
        ('journey', 'journey'),
        ('day_one', 'day_one'),
      ]) {
        final exported =
            await run('data.export', {'format': format, 'path': folder});
        expect(exported['file'],
            matches(RegExp('^aid_diary_${name}_export_.*\\.zip\$')));
        expect(File(p.join(folder, exported['file'] as String)).lengthSync(),
            greaterThan(0));
      }
      final markdown = Directory(folder)
          .listSync()
          .map((file) => file.path)
          .firstWhere((path) => path.contains('markdown'));
      final unpacked = folders().folder('unpacked');
      await ZipUtils.extract(markdown, unpacked.path);
      final notes = unpacked
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.md'))
          .single;
      expect(p.basename(notes.path), 'log_2026-10-20.md');
      expect(notes.readAsStringSync(), contains('Walk by the river'));
      expect(() => run('data.export', {'format': 'pdf', 'path': folder}),
          refused('bad_args'));
    });
  });

  group('backup', () {
    test('a backup is a zip in the folder, noted as the last one', () async {
      expect((await run('backup.status', {}))['encrypted'], isFalse);
      expect(await run('backup.status', {}), isNot(contains('lastBackup')));
      final folder = folders().folder('backups').path;
      final created = await run('backup.create', {'path': folder});
      expect(created['encrypted'], isFalse);
      expect(created['file'], matches(RegExp(r'^aid_diary_backup_.*\.zip$')));
      expect(File(p.join(folder, created['file'] as String)).lengthSync(),
          greaterThan(0));
      final status = await run('backup.status', {});
      expect(status['lastBackup'], created['lastBackup']);
      expect((status['autoBackup'] as Map)['supported'], Platform.isAndroid);
      expect((status['autoBackup'] as Map)['enabled'], isFalse);
      expect(status['autoBackup'], isNot(contains('next')));
    });

    test('the backup password encrypts, and next backup is shown when due',
        () async {
      await DiaryAppHarness.setSetting(Settings.backupPasswordEnabled, true);
      await DiaryAppHarness.setSetting(Settings.backupPassword, 'secret');
      final created =
          await run('backup.create', {'path': folders().folder('b').path});
      expect(created['encrypted'], isTrue);
      expect(created['file'], endsWith('.zip.enc'));
      expect((await run('backup.status', {}))['encrypted'], isTrue);

      await DiaryAppHarness.setSetting(Settings.autoBackupEnabled, true);
      await DiaryAppHarness.setSetting(Settings.autoBackupLocationUri, '/b');
      final auto = (await run('backup.status', {}))['autoBackup'] as Map;
      expect(auto['enabled'], isTrue);
      expect(auto['folder'], 'b');
      expect(DateTime.parse(auto['next'] as String), isA<DateTime>());
    });

    test('restoring asks for confirmation first, and for a real file',
        () async {
      expect(() => run('backup.restore', {'path': '/none.zip'}),
          refused('needs_confirmation'));
      expect(
          () => run('backup.restore', {'path': '/none.zip'}, confirmed: true),
          refused('not_found'));
    });
  });

  // These move the real database file, so they use one in a temporary folder.
  group('on a database file', () {
    setUp(() async {
      await AppDatabase.instance.init(forceWithoutSync: true);
      await EntryStore.instance.complete;
    });

    tearDown(() async {
      EasyDebounce.cancelAll();
      await AppDatabase.instance.close();
    });

    test('a backup brings back the diary as it was, encrypted or not',
        () async {
      await add('Kept', DateTime(2026, 10, 20, 8));
      final keptTexts = texts();
      final folder = folders().folder('backups').path;
      final plain = await run('backup.create', {'path': folder});
      await DiaryAppHarness.setSetting(Settings.backupPasswordEnabled, true);
      await DiaryAppHarness.setSetting(Settings.backupPassword, 'secret');
      final locked = await run('backup.create', {'path': folder});
      await DiaryAppHarness.setSetting(Settings.backupPassword, 'other');

      await add('Written after the backup', DateTime(2026, 10, 21, 8));
      await EntryStore.instance.erase(
          EntryStore.instance.entries.firstWhere((e) => e.text == 'Kept'));
      expect(texts(), isNot(keptTexts));

      final restored = await run(
          'backup.restore', {'path': p.join(folder, plain['file'] as String)},
          confirmed: true);
      expect(restored['entries'], keptTexts.length);
      expect(texts(), keptTexts);

      // The saved password does not open the locked one: it is asked for.
      final lockedPath = p.join(folder, locked['file'] as String);
      await add('Again after', DateTime(2026, 10, 22, 8));
      expect(() => run('backup.restore', {'path': lockedPath}, confirmed: true),
          refused('needs_password'));
      expect(
          () => run('backup.restore', {'path': lockedPath, 'password': 'no'},
              confirmed: true),
          refused('failed'));
      expect(texts(), contains('Again after'));
      await run('backup.restore', {'path': lockedPath, 'password': 'secret'},
          confirmed: true);
      expect(texts(), keptTexts);
    });

    test('storage is shown, moved to a folder of your own and reset', () async {
      final status = await run('storage.status', {});
      expect((status['database'] as Map)['folder'],
          p.join(folders().support.path, AppDatabase.databaseFileName));
      expect((status['database'] as Map)['external'], isFalse);
      expect((status['images'] as Map)['external'], isFalse);
      expect(status['imageQuality'], 'medium');

      final target = folders().folder('mine').path;
      expect(() => run('storage.set', {'target': 'images', 'path': target}),
          refused('needs_confirmation'));
      expect(
          () => run('storage.set', {'target': 'photos', 'path': target},
              confirmed: true),
          refused('bad_args'));
      expect(
          () => run('storage.set',
              {'target': 'images', 'path': p.join(target, 'gone')},
              confirmed: true),
          refused('not_found'));

      final moved = await run(
          'storage.set', {'target': 'database', 'path': target},
          confirmed: true);
      expect(moved['database'], containsPair('externalFolder', target));
      expect(moved['database'], containsPair('external', true));
      expect(File(p.join(target, AppDatabase.databaseFileName)).existsSync(),
          isTrue);
      expect(config.get(Settings.useExternalDb), isTrue);
      // The diary still opens and takes new entries there.
      await add('In my folder', DateTime(2026, 10, 20, 8));
      expect(texts(), contains('In my folder'));

      final photos = await run(
          'storage.set', {'target': 'images', 'path': target},
          confirmed: true);
      expect(photos['images'], containsPair('external', true));
      expect(config.get(Settings.externalImgUri), target);

      final reset = await run('storage.reset', {'target': 'database'});
      expect(reset['database'], containsPair('external', false));
      expect(reset['images'], containsPair('external', true));
      expect((await run('storage.reset', {'target': 'images'}))['images'],
          containsPair('external', false));
      // What was in the folder stays there.
      expect(File(p.join(target, AppDatabase.databaseFileName)).existsSync(),
          isTrue);
    });
  });
}
