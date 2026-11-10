// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/device_info_service.dart';
import 'package:aid_diary/services/app_updates.dart';

/// What the About page's update rows do (docs/UPDATES.md).
final updateActions = [
  AppAction(
      id: 'update.check',
      describe: 'Asks the release manifest for a build newer than this app; '
          'shows nothing to the user. A build the user chose to skip is '
          'still reported, marked skipped. Android builds outside F-Droid '
          'and the installed Windows app only.',
      risk: ActionRisk.read,
      run: (_, __) async {
        final updates = AppUpdates.instance;
        if (!await updates.enabled()) {
          throw const ActionException(
              'unavailable', 'This build cannot install updates');
        }
        final update = await _check(updates);
        return {
          'installed': {
            'version': DeviceInfoService().appInfo?.version,
            'build':
                int.tryParse(DeviceInfoService().appInfo?.buildNumber ?? ''),
          },
          'update': update == null
              ? null
              : {...update.toJson(), 'skipped': update.skipped},
        };
      }),
  AppAction(
      id: 'update.install',
      describe: 'Downloads the newer build and checks its size and hash. '
          'Android checks its name, signing key and version and installs '
          'it, and may ask on the device first; an app granted root '
          'installs as root without asking, and closes before it answers. '
          'Windows runs the installer silently and opens the app again. '
          'The app closes while it installs.',
      risk: ActionRisk.write,
      run: (context, __) async {
        final updates = AppUpdates.instance;
        if (!await updates.enabled()) {
          throw const ActionException(
              'unavailable', 'This build cannot install updates');
        }
        final update = await _check(updates);
        if (update == null) {
          throw const ActionException('newest', 'This is the newest build');
        }
        try {
          final file = await updates.download(update,
              progress: (done) => context.progress('${(done * 100).round()}%'));
          final outcome = await updates.install(update, file);
          return {'build': update.build, 'outcome': outcome.name};
        } on UpdateException catch (error) {
          throw ActionException(error.code, error.message);
        }
      }),
];

Future<AppUpdate?> _check(AppUpdates updates) async {
  try {
    return await updates.check();
  } on UpdateException catch (error) {
    throw ActionException(error.code, error.message);
  }
}
