// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:io';

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/sync_actions.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:package_info_plus/package_info_plus.dart';

ConfigProvider get _config => ConfigProvider.instance;

/// Settings an action may show or change: none that hold passwords, keys
/// or sync secrets.
Iterable<Setting<Object?>> get _open =>
    Settings.all.where((setting) => !setting.secure && !setting.secretStore);

Setting<Object?> _setting(String key) => _open.firstWhere(
    (setting) => setting.key == key,
    orElse: () =>
        throw ActionException('not_found', 'There is no open setting $key'));

final List<AppAction> settingsActions = [
  AppAction(
    id: 'app.status',
    describe: 'Shows the build, the platform, the size of the diary, the '
        'sync state and the screen in view.',
    risk: ActionRisk.read,
    run: (context, args) async {
      final info = await PackageInfo.fromPlatform();
      final store = EntryStore.instance;
      await store.complete;
      return {
        'version': '${info.version}+${info.buildNumber}',
        'package': info.packageName,
        'devBuild': context.devBuild,
        'platform': Platform.operatingSystem,
        'entries': store.entries.length,
        'days': store.getEntryDayCount(),
        'sync': syncStatus()['state'],
        if (context.screen case final screen?) 'screen': screen.current,
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
    describe: 'Changes one setting. The value is read as the setting\'s '
        'type: true or false, a number, text, or JSON.',
    risk: ActionRisk.write,
    params: const [
      ActionParam(
          'key', ParamType.string, 'The setting, as settings.list names it'),
      ActionParam('value', ParamType.string, 'The new value'),
    ],
    run: (context, args) async {
      final setting = _setting(args['key'] as String);
      final text = args['value'] as String;
      final Object? value = switch (setting.defaultValue) {
        bool() => switch (text) {
            'true' => true,
            'false' => false,
            _ => throw const ActionException('bad_args', 'Use true or false'),
          },
        int() => int.tryParse(text) ??
            (throw const ActionException('bad_args', 'Use a whole number')),
        String() => text,
        _ => jsonDecode(text),
      };
      await _config.set(setting, value);
      return {setting.key: _config.get(setting)};
    },
  ),
];
