// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/actions/sync_actions.dart';
import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/language_option.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/services/settings_service.dart';
import 'package:aid_diary/services/wallpaper_service.dart';
import 'package:aid_diary/theme_palette.dart';
import 'package:aid_diary/utils/password_store.dart';
import 'package:flutter/foundation.dart' show kProfileMode, kReleaseMode;
import 'package:flutter/widgets.dart' show StringCharacters;
import 'package:package_info_plus/package_info_plus.dart';

ConfigProvider get _config => ConfigProvider.instance;

/// Settings an action may show: none that hold passwords, keys or sync
/// secrets, and not the version of the config file.
Iterable<Setting<Object?>> get _open => Settings.all.where((setting) =>
    !setting.secure &&
    !setting.secretStore &&
    setting != Settings.configVersion);

/// Settings other actions change, because writing the value alone would
/// leave the diary half moved: what to use instead.
final Map<Setting<Object?>, String> _managed = {
  Settings.useExternalDb: 'storage.set or storage.reset',
  Settings.externalDbUri: 'storage.set or storage.reset',
  Settings.useExternalImg: 'storage.set or storage.reset',
  Settings.externalImgUri: 'storage.set or storage.reset',
  Settings.wallpaperImage: 'wallpaper.set_photo',
};

Setting<Object?> _setting(String key) {
  final setting = _open.where((setting) => setting.key == key).firstOrNull;
  if (setting == null) {
    throw ActionException('not_found', 'There is no open setting $key');
  }
  return setting;
}

ActionException _badValue(Setting<Object?> setting, String rule) =>
    ActionException('bad_args', '${setting.key} must be $rule');

/// [text] as the value of [setting], by the setting's type.
Object? _decode(Setting<Object?> setting, String text) {
  switch (setting) {
    case Setting<bool>():
      return switch (text) {
        'true' => true,
        'false' => false,
        _ => throw _badValue(setting, 'true or false'),
      };
    case Setting<int>():
      // A colour may be named, or written as 0xAARRGGBB.
      final number = (setting == Settings.accentColor ||
                  setting == Settings.darkAccentColor) &&
              accentPresets[text] != null
          ? accentPresets[text]
          : int.tryParse(text);
      return number ?? (throw _badValue(setting, 'a whole number'));
    case Setting<String>():
      return text;
    case Setting<String?>():
      // Text that may also be unset; no text unsets it.
      return text.isEmpty ? null : text;
    default:
      final Object? decoded;
      try {
        decoded = jsonDecode(text);
      } on FormatException {
        throw _badValue(setting, 'JSON');
      }
      return decoded;
  }
}

/// [value] as the text [_decode] reads back for [setting].
String _encode(Setting<Object?> setting, Object? value) {
  switch (setting) {
    case Setting<bool>() || Setting<int>():
      return '$value';
    case Setting<String>():
      return value as String;
    case Setting<String?>():
      return (value as String?) ?? '';
    default:
      return jsonEncode(value);
  }
}

/// Refuses a [value] the settings page could never produce.
void _check(Setting<Object?> setting, Object? value) {
  if (setting.choices case final choices? when value is String) {
    if (!choices.contains(value)) {
      throw _badValue(setting, 'one of ${choices.join(', ')}');
    }
  }
  if (setting.range case (final low, final high) when value is int) {
    if (value < low || value > high) {
      throw _badValue(setting, 'from $low to $high');
    }
  }
  // Only the day settings have their choices there.
  late final config = AppConfig.instance;
  switch (setting) {
    case Settings.dayStartHour when !config.dayStartHourChoices.contains(value):
      throw _badValue(
          setting, 'one of ${config.dayStartHourChoices.join(', ')}');
    case Settings.dayAskUntilHour
        when !config.dayAskUntilHourChoices.contains(value) ||
            (value as int) < _config.get(Settings.dayStartHour):
      throw _badValue(
          setting,
          'one of ${config.dayAskUntilHourChoices.join(', ')}, '
          'not before dayStartHour');
    case Settings.reminderWeekdays
        when value is! List ||
            value.isEmpty ||
            value.any((day) => day is! int || day < 1 || day > 7):
      throw _badValue(setting, 'a JSON list of weekdays 1 (Monday) to 7');
    case Settings.overrideLanguage when value != null:
      if (value is! Map || !_isLanguage(value)) {
        throw _badValue(
            setting, 'null or a language like {"languageCode":"zh"}');
      }
    case Settings.savedPlaces
        when value is! List || value.any((p) => p is! Map):
      throw _badValue(setting, 'a JSON list of {name, latitude, longitude}');
    case Settings.dismissedPhotoSuggestions || Settings.importedPhotoSuggestions
        when value is! List ||
            value.length >
                (setting == Settings.importedPhotoSuggestions ? 2000 : 500) ||
            value.any((id) =>
                id is! String || !RegExp(r'^[a-f0-9]{64}$').hasMatch(id)):
      throw _badValue(setting, 'a bounded JSON list of SHA-256 photo ids');
    case Settings.veryHappyIcon ||
            Settings.happyIcon ||
            Settings.neutralIcon ||
            Settings.sadIcon ||
            Settings.verySadIcon
        when (value as String).characters.length != 1:
      throw _badValue(setting, 'one character');
    case Settings.wallpaper when value == WallpaperKind.photo.name:
      if (_config.get(Settings.wallpaperImage).isEmpty) {
        throw const ActionException(
            'needs_photo', 'Set the photo first with wallpaper.set_photo');
      }
    case Settings.autoBackupEnabled when value == true:
      if (_config.get(Settings.autoBackupLocationUri).isEmpty) {
        throw const ActionException('needs_location',
            'Set autoBackupLocationUri, the folder the backups go to, first');
      }
    case Settings.autoBackupMaxCount when (value as int) < 0:
      throw _badValue(setting, '0 (keep all) or more');
    default:
      break;
  }
}

bool _isLanguage(Map value) {
  try {
    return LanguageOption.displayNameMapping
        .containsKey(LanguageOption.fromJson(value.cast<String, dynamic>()));
  } catch (_) {
    return false;
  }
}

/// Changes settings, given as key and text of the value as `settings.set`
/// reads it; all or none. Checks every value before storing any.
Future<Object?> _change(Map<String, String> texts) async {
  final changes = <Setting<Object?>, Object?>{};
  for (final MapEntry(:key, :value) in texts.entries) {
    final setting = _setting(key);
    if (_managed[setting] case final instead?) {
      throw ActionException('bad_args', '${setting.key} changes with $instead');
    }
    final decoded = _decode(setting, value);
    _check(setting, decoded);
    changes[setting] = decoded;
  }
  if (!await SettingsService.instance.setMany(changes)) {
    throw const ActionException('needs_permission',
        'The notification permission was not given on the device');
  }
  return {
    for (final setting in changes.keys) setting.key: _config.get(setting)
  };
}

/// Changes [setting] to [value] by running `settings.set`, so the settings
/// pages and the command line change a setting the same way. False, with
/// nothing changed, when it needs the notification permission and that was
/// not given.
Future<bool> changeSetting<T>(Setting<T> setting, T value) =>
    changeSettings({setting: value});

/// [changeSetting] for several at once, which a new time (hour and minute)
/// needs to rearm its alarm once.
Future<bool> changeSettings(Map<Setting<Object?>, Object?> changes) async {
  try {
    await AppActions.instance.run('settings.set_many', {
      'values': jsonEncode({
        for (final MapEntry(:key, :value) in changes.entries)
          key.key: _encode(key, value),
      }),
    });
    return true;
  } on ActionException catch (error) {
    if (error.code == 'needs_permission') return false;
    rethrow;
  }
}

/// `settings.set_many`'s [values] as key and text, each text as
/// `settings.set` reads a value.
Map<String, String> _texts(String values) {
  final Object? decoded;
  try {
    decoded = jsonDecode(values);
  } on FormatException {
    throw const ActionException('bad_args', 'values must be a JSON object');
  }
  if (decoded is! Map) {
    throw const ActionException('bad_args', 'values must be a JSON object');
  }
  return {
    for (final MapEntry(:key, :value) in decoded.entries)
      '$key': switch (value) {
        String() || bool() || int() => '$value',
        _ => throw ActionException(
            'bad_args', '$key must be text, a whole number or true or false'),
      },
  };
}

final List<AppAction> settingsActions = [
  AppAction(
    id: 'app.finish_onboarding',
    describe: 'Completes first-run setup.',
    risk: ActionRisk.write,
    run: (context, args) async {
      final saved =
          await SettingsService.instance.set(Settings.onboardingDone, true);
      if (!saved) {
        throw const ActionException('failed', 'Could not finish setup.');
      }
      return {'completed': true};
    },
  ),
  AppAction(
    id: 'app.status',
    describe: 'Shows the build, the platform, the size of the diary, the '
        'sync state and the screen in view.',
    risk: ActionRisk.read,
    run: (context, args) async {
      final info = await PackageInfo.fromPlatform();
      final store = EntryStore.instance;
      await store.complete;
      // Debug and profile builds serve it; `aid trace` records from it.
      final vmService = (await developer.Service.getInfo()).serverUri;
      return {
        'version': '${info.version}+${info.buildNumber}',
        'package': info.packageName,
        'devBuild': context.devBuild,
        // Frame rates mean something only in profile and release.
        'mode': kReleaseMode
            ? 'release'
            : kProfileMode
                ? 'profile'
                : 'debug',
        'platform': Platform.operatingSystem,
        'entries': store.entries.length,
        'media': EntryImagesProvider.instance.images
            .where((image) => store.visibleEntryIds.contains(image.entryId))
            .length,
        'days': store.getEntryDayCount(),
        'sync': syncStatus()['state'],
        if (context.screen case final screen?) 'screen': screen.current,
        if (vmService != null) 'vmService': '$vmService',
      };
    },
  ),
  AppAction(
    id: 'settings.list',
    describe: 'Lists the settings and their values, without secrets.',
    risk: ActionRisk.read,
    run: (context, args) async => {
      for (final setting in _open) setting.key: _config.get(setting),
    },
  ),
  AppAction(
    id: 'settings.set',
    describe: 'Changes one setting as the settings pages do, including what '
        'follows: reminders are rearmed, the theme changes, the command line '
        'server starts or stops. Notifications need their permission given '
        'on the device, and automatic backups a folder.',
    risk: ActionRisk.write,
    params: const [
      ActionParam(
          'key', ParamType.string, 'The setting, as settings.list names it'),
      ActionParam(
          'value',
          ParamType.string,
          'The new value, read as the setting\'s type: true or false, a '
              'whole number, text (none unsets a setting that may be unset), '
              'or JSON for lists and objects: reminderWeekdays [1,2,3,4,5] '
              '(1 is Monday), overrideLanguage {"languageCode":"zh",'
              '"scriptCode":"Hant"} or null, savedPlaces '
              '[{"name":"Home","latitude":1.5,"longitude":2.5}]. '
              'accentColor is a number such as 0xff62A0EA or a name '
              '(blue, green, brown, purple, rose, amber).'),
    ],
    run: (context, args) =>
        _change({args['key'] as String: args['value'] as String}),
  ),
  AppAction(
    id: 'settings.set_many',
    describe: 'Changes several settings at once, all or none, as '
        'settings.set does one: a pair of hour and minute is changed with '
        'one alarm rearmed.',
    risk: ActionRisk.write,
    params: const [
      ActionParam(
          'values',
          ParamType.string,
          'A JSON object of setting to new value, each value as settings.set '
              'reads it: {"scheduledReminderHour":8,'
              '"scheduledReminderMinute":30}. A list or an object goes in '
              'as a string of its JSON.'),
    ],
    run: (context, args) => _change(_texts(args['values'] as String)),
  ),
  AppAction(
    id: 'wallpaper.set_photo',
    describe: 'Uses a photo from a file as the wallpaper behind the lists: '
        'keeps a copy and drops the earlier one.',
    risk: ActionRisk.write,
    params: const [
      ActionParam('path', ParamType.string, 'The image file on this device'),
    ],
    run: (context, args) async {
      final path = args['path'] as String;
      if (!await File(path).exists()) {
        throw ActionException('not_found', 'There is no file $path');
      }
      await WallpaperService.setPhoto(path);
      return {
        Settings.wallpaper.key: _config.get(Settings.wallpaper),
        Settings.wallpaperImage.key: _config.get(Settings.wallpaperImage),
      };
    },
  ),
  AppAction(
    id: 'security.status',
    describe: 'Shows whether the app lock and the backup password are on, '
        'never the passwords. They are set in the app only, so that nobody '
        'but the person at the device can lock them out.',
    risk: ActionRisk.read,
    run: (context, args) async => {
      'appLock': _config.get(Settings.requirePassword),
      if (_config.get(Settings.requirePassword)) ...{
        'appLockType': _config.get(Settings.passwordIsPin) ? 'pin' : 'password',
        'biometricUnlock': _config.get(Settings.biometricUnlock),
      },
      'backupPassword': BackupPasswordStore.isEnabled,
    },
  ),
];
