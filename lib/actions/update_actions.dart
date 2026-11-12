// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/device_info_service.dart';
import 'package:aid_diary/services/app_updates.dart';

/// What the About page's update rows and the update dialog do
/// (docs/UPDATES.md).
final updateActions = [
  AppAction(
      id: 'update.check',
      describe: 'Asks the release manifest for a build newer than this app; '
          'shows nothing to the user. A build the user chose to skip is '
          'still reported, marked skipped. Also reports the package being '
          'downloaded or ready to install. Android builds outside F-Droid '
          'and the installed Windows app only.',
      risk: ActionRisk.read,
      run: (_, __) async {
        final updates = await _enabled();
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
          'download': updates.downloadState.value?.toJson(),
        };
      }),
  AppAction(
      id: 'update.download',
      describe: 'Downloads the newer build in the background, as the app '
          'does when it finds one, on any network, and returns at once '
          'with the download\'s state; with wait, returns once the '
          'package\'s size and hash are checked. A download already under '
          'way or left by an earlier run continues.',
      risk: ActionRisk.write,
      params: const [
        ActionParam('wait', ParamType.boolean,
            'Return once the package is downloaded and checked',
            required: false),
      ],
      run: (context, args) async {
        final updates = await _enabled();
        final update = await _check(updates);
        if (update == null) {
          throw const ActionException('newest', 'This is the newest build');
        }
        if (args['wait'] == true) {
          await _run(() => updates.download(update,
              progress: (done) =>
                  context.progress('${(done * 100).round()}%')));
        } else {
          // Its failure shows as no download in update.check; the next
          // check tries again.
          updates.download(update).ignore();
        }
        return {
          'build': update.build,
          'download': updates.downloadState.value?.toJson(),
        };
      }),
  AppAction(
      id: 'update.install',
      describe: 'Installs the newer build: the downloaded package when it '
          'is the newest, else downloads it first, checking its size and '
          'hash. Without a network the downloaded package is installed. '
          'Android checks its name, signing key and version and installs '
          'it, and may ask on the device first. Windows runs the installer '
          'silently and opens the app again. The app closes while it '
          'installs.',
      risk: ActionRisk.write,
      run: (context, __) async {
        final updates = await _enabled();
        AppUpdate? update;
        try {
          update = await updates.check();
        } on UpdateException catch (error) {
          update = await updates.pending();
          if (update == null) throw ActionException(error.code, error.message);
        }
        if (update == null) {
          throw const ActionException('newest', 'This is the newest build');
        }
        final found = update;
        final file = await _run(() => updates.download(found,
            progress: (done) => context.progress('${(done * 100).round()}%')));
        final outcome = await _run(() => updates.install(found, file));
        return {'build': found.build, 'outcome': outcome.name};
      }),
];

Future<AppUpdates> _enabled() async {
  final updates = AppUpdates.instance;
  if (!await updates.enabled()) {
    throw const ActionException(
        'unavailable', 'This build cannot install updates');
  }
  return updates;
}

Future<AppUpdate?> _check(AppUpdates updates) => _run(() => updates.check());

/// [step]'s result, with its update error as the action's.
Future<T> _run<T>(Future<T> Function() step) async {
  try {
    return await step();
  } on UpdateException catch (error) {
    throw ActionException(error.code, error.message);
  }
}
