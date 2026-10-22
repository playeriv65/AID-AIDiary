// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['integration'])
library;

import 'dart:io';

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/actions/settings_actions.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/language_option.dart';
import 'package:aid_diary/utils/diary_day.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show Color, ThemeMode;
import 'package:path/path.dart' as p;

import '../support/app_folders_harness.dart';
import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();
  final folders = useTemporaryAppFolders();
  final actions = AppActions(devBuild: true);
  final config = ConfigProvider.instance;

  Future<Map<String, Object?>> run(String id,
          [Map<String, Object?> args = const {}]) async =>
      (await actions.run(id, args)) as Map<String, Object?>;

  Future<Map<String, Object?>> set(String key, String value) =>
      run('settings.set', {'key': key, 'value': value});

  // The diary day hours are global: put them back after each test.
  late (int, int) hours;
  setUp(() => hours = (DiaryDay.startHour, DiaryDay.askUntilHour));
  tearDown(() {
    DiaryDay.startHour = hours.$1;
    DiaryDay.askUntilHour = hours.$2;
  });

  Matcher refused(String code) =>
      throwsA(isA<ActionException>().having((e) => e.code, 'code', code));

  test('settings are listed with their values, defaults included', () async {
    final listed = await run('settings.list');
    expect(listed['theme'], 'system');
    expect(listed['showFlashbacks'], isTrue);
    expect(listed['dayStartHour'], 4);
    expect(listed['reminderWeekdays'], [1, 2, 3, 4, 5, 6, 7]);
    expect(listed['moodOverTimeGrouping'], isNull);
  });

  test('text settings take the text as written, optional ones may be unset',
      () async {
    expect(await set('moodOverTimeGrouping', 'week'),
        {'moodOverTimeGrouping': 'week'});
    expect(config.get(Settings.moodOverTimeGrouping), 'week');
    expect(
        await set('moodOverTimeGrouping', ''), {'moodOverTimeGrouping': null});
    expect(config.get(Settings.moodOverTimeGrouping), isNull);
    expect(await set('entryFontFamily', 'serif'), {'entryFontFamily': 'serif'});
  });

  test('lists and objects are JSON, and wrong JSON is a bad argument',
      () async {
    expect(await set('reminderWeekdays', '[1,3,5]'), {
      'reminderWeekdays': [1, 3, 5]
    });
    await set('overrideLanguage', '{"languageCode":"zh","scriptCode":"Hant"}');
    expect(config.getOverrideLanguage()!.toLanguageTag(), 'zh-Hant');
    expect(await set('overrideLanguage', 'null'), {'overrideLanguage': null});
    expect(config.getOverrideLanguage(), isNull);

    expect(() => set('reminderWeekdays', 'nope'), refused('bad_args'));
    expect(() => set('reminderWeekdays', '[]'), refused('bad_args'));
    expect(() => set('reminderWeekdays', '[8]'), refused('bad_args'));
    expect(() => set('overrideLanguage', '{"languageCode":"xx"}'),
        refused('bad_args'));
    expect(() => set('savedPlaces', '{}'), refused('bad_args'));
    expect(config.get(Settings.reminderWeekdays), [1, 3, 5]);
  });

  test('several settings change together, or none does', () async {
    expect(
        await run('settings.set_many', {
          'values': '{"scheduledReminderHour":8,"scheduledReminderMinute":"30",'
              '"alwaysRemind":true}'
        }),
        {
          'scheduledReminderHour': 8,
          'scheduledReminderMinute': 30,
          'alwaysRemind': true,
        });
    expect(config.get(Settings.scheduledReminderHour), 8);
    expect(config.get(Settings.scheduledReminderMinute), 30);

    // One refused value keeps the others from being written.
    expect(
        () => run('settings.set_many',
            {'values': '{"scheduledReminderHour":9,"theme":"neon"}'}),
        refused('bad_args'));
    expect(config.get(Settings.scheduledReminderHour), 8);
    expect(() => run('settings.set_many', {'values': '{"savedPlaces":[]}'}),
        refused('bad_args'));
    expect(
        () => run('settings.set_many', {'values': '[1]'}), refused('bad_args'));
    expect(() => run('settings.set_many', {'values': '{"passwordHash":"x"}'}),
        refused('not_found'));
  });

  test('the pages change a setting by value and the action reads it back',
      () async {
    // What the settings pages pass: typed values, of every kind of setting.
    await changeSetting(Settings.accentColor, 0xff112233);
    expect(config.get(Settings.accentColor), 0xff112233);
    await changeSetting(Settings.moodOverTimeGrouping, 'week');
    expect(config.get(Settings.moodOverTimeGrouping), 'week');
    await changeSetting(Settings.moodOverTimeGrouping, null);
    expect(config.get(Settings.moodOverTimeGrouping), isNull);
    await changeSetting(Settings.reminderWeekdays, [1, 3]);
    expect(config.get(Settings.reminderWeekdays), [1, 3]);
    await changeSetting(Settings.overrideLanguage,
        {'languageCode': 'zh', 'scriptCode': 'Hant'});
    expect(config.getOverrideLanguage()!.toLanguageTag(), 'zh-Hant');
    await changeSetting(Settings.overrideLanguage, null);
    expect(config.getOverrideLanguage(), isNull);
    await changeSettings({
      for (final setting in Settings.moodIcons.values) setting: '👍',
    });
    expect(
        Settings.moodIcons.values.map(config.get), everyElement(equals('👍')));

    // Every language the language page offers is one the action takes.
    for (final locale in AppLocalizations.supportedLocales) {
      final option = LanguageOption.fromLocale(locale);
      await changeSetting(Settings.overrideLanguage, option.toJson());
      expect(config.getOverrideLanguage(), locale, reason: '$locale');
    }

    // A value the action refuses is not swallowed.
    expect(() => changeSetting(Settings.theme, 'neon'), refused('bad_args'));
  });

  test('a value the settings page could never give is refused', () async {
    expect(() => set('theme', 'neon'), refused('bad_args'));
    expect(() => set('scheduledReminderHour', '25'), refused('bad_args'));
    expect(() => set('scheduledReminderHour', 'noon'), refused('bad_args'));
    expect(() => set('showFlashbacks', 'maybe'), refused('bad_args'));
    expect(() => set('happyIcon', 'ab'), refused('bad_args'));
    expect(await set('happyIcon', '👍'), {'happyIcon': '👍'});
    // Asking ends no earlier than the day starts.
    await set('dayStartHour', '3');
    expect(() => set('dayAskUntilHour', '2'), refused('bad_args'));
    expect(() => set('configVersion', '3'), refused('not_found'));
    expect(() => set('passwordHash', 'x'), refused('not_found'));
    expect((await run('settings.list')).keys, isNot(contains('configVersion')));
  });

  test('what only another action can do is not written bare', () async {
    for (final key in [
      'useExternalDb',
      'externalDbUri',
      'useExternalImg',
      'externalImgUri',
      'wallpaperImage',
    ]) {
      expect(() => set(key, 'true'), refused('bad_args'), reason: key);
    }
    expect(() => set('wallpaper', 'photo'), refused('needs_photo'));
    expect(() => set('autoBackupEnabled', 'true'), refused('needs_location'));
    expect(config.get(Settings.autoBackupEnabled), isFalse);
  });

  test('the diary day hours apply as soon as they are set', () async {
    await set('dayStartHour', '2');
    await set('dayAskUntilHour', '5');
    expect((DiaryDay.startHour, DiaryDay.askUntilHour), (2, 5));
  });

  test('the theme follows the settings without being told', () async {
    final theme = harness.theme;
    expect(theme.themeMode, ThemeMode.system);
    await set('theme', 'dark');
    expect(theme.themeMode, ThemeMode.dark);
    await set('theme', 'light');
    expect(theme.themeMode, ThemeMode.light);

    // A colour, by name or number, replaces following the system's.
    expect(theme.usingSystemColor, isTrue);
    await set('accentColor', 'green');
    expect(theme.usingSystemColor, isFalse);
    expect(theme.accentColor, const Color(0xff587E64));
    await set('accentColor', '0xff112233');
    expect(theme.accentColor, const Color(0xff112233));
    expect(() => set('accentColor', 'plaid'), refused('bad_args'));
    await set('followSystemColor', 'true');
    expect(theme.usingSystemColor, isTrue);
  });

  test('a photo wallpaper is copied in and replaces the last one', () async {
    final photo = File(p.join(folders().folder('pictures').path, 'sea.jpg'))
      ..writeAsBytesSync([1, 2, 3]);
    final first = await run('wallpaper.set_photo', {'path': photo.path});
    final kept = File(first['wallpaperImage'] as String);
    expect(first['wallpaper'], 'photo');
    expect(kept.readAsBytesSync(), [1, 2, 3]);
    expect(kept.path, startsWith(folders().support.path));
    expect(photo.existsSync(), isTrue);

    // A second pick, in another millisecond, leaves one copy behind.
    await Future<void>.delayed(const Duration(milliseconds: 5));
    photo.writeAsBytesSync([4]);
    final second = await run('wallpaper.set_photo', {'path': photo.path});
    expect(kept.existsSync(), isFalse);
    expect(File(second['wallpaperImage'] as String).readAsBytesSync(), [4]);
    expect(Directory(p.dirname(kept.path)).listSync(), hasLength(1));

    // With a photo set, the kind may be chosen as any other.
    await set('wallpaper', 'dots');
    await set('wallpaper', 'photo');
    expect(config.get(Settings.wallpaper), 'photo');

    expect(() => run('wallpaper.set_photo', {'path': '${photo.path}.gone'}),
        refused('not_found'));
  });

  test('security is shown and never set', () async {
    expect(await run('security.status'),
        {'appLock': false, 'backupPassword': false});
    await DiaryAppHarness.setSetting(Settings.requirePassword, true);
    await DiaryAppHarness.setSetting(Settings.passwordIsPin, true);
    await DiaryAppHarness.setSetting(Settings.backupPasswordEnabled, true);
    await DiaryAppHarness.setSetting(Settings.backupPassword, 'secret');
    final status = await run('security.status');
    expect(status, {
      'appLock': true,
      'appLockType': 'pin',
      'biometricUnlock': false,
      'backupPassword': true,
    });
    expect(status.values.join(), isNot(contains('secret')));
    for (final key in [
      'requirePassword',
      'biometricUnlock',
      'passwordIsPin',
      'backupPasswordEnabled',
      'backupPassword',
    ]) {
      expect(() => set(key, 'false'), refused('not_found'), reason: key);
    }
    expect(actions.available.map((action) => action.id),
        isNot(anyOf(contains('security.set'), contains('security.unlock'))));
  });
}
