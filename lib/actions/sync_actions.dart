// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/sync/google_auth.dart';
import 'package:aid_diary/sync/pairing.dart';
import 'package:aid_diary/sync/sync_crypto.dart';
import 'package:aid_diary/sync/sync_service.dart';
import 'package:aid_diary/sync/connection_manager.dart';
import 'package:aid_diary/l10n/shown_language.dart';

SyncService get _sync => SyncService.instance;

Map<String, Object?> syncStatus() {
  final target = _sync.target;
  final report = _sync.lastReport;
  final progress = _sync.progress;
  return {
    'state': _sync.state.name,
    if (_sync.activeRoute case final route?) 'route': route,
    if (_sync.retryAt case final retry?) 'retryAt': retry.toIso8601String(),
    if (target != null) ...{
      'provider': target.provider.name,
      if (target.server case final server?) 'server': server.toString(),
      'account': target.username,
    },
    if (_sync.pendingSpace != null) 'waitingForKey': true,
    if (_sync.pairing case final pairing?) 'pairing': pairingStatus(pairing),
    if (_sync.lastSync case final last?) 'lastSync': last.toIso8601String(),
    if (report != null)
      'lastReport': {
        'received': report.received,
        'sent': report.sent,
        'keptConflicts': report.keptConflicts,
        'pendingMedia': report.pendingMedia,
        'mediaCompleted': report.mediaCompleted,
        'mediaFailures': report.mediaFailures,
        'waitingForPeer': report.waitingForPeer,
      },
    if (progress != null)
      'progress': {
        'sending': progress.sending,
        'done': progress.done,
        'total': progress.total,
      },
    if (_sync.error case final error?) 'error': '$error',
    'unsyncedEntries': _sync.unsyncedEntryIds.length,
    // The ids the journal marks as waiting to go up.
    'unsyncedIds': _sync.unsyncedEntryIds.toList()..sort(),
  };
}

Map<String, Object?> pairingStatus(PairingStatus pairing) => {
      'stage': pairing.stage.name,
      if (pairing.code case final code?) 'code': code.typed,
      if (pairing.otherDevice case final device?) 'otherDevice': device,
      if (pairing.joined) 'joined': true,
      if (pairing.failure case final failure?) 'failure': failure.name,
      if (pairing.error case final error?) 'error': '$error',
    };

/// Runs [open], which takes a key or code, and says what was wrong with it.
Future<T> _withKey<T>(Future<T> Function() open) async {
  try {
    return await open();
  } on WrongKeyException {
    throw const ActionException(
        'wrong_key', 'That recovery code does not open the space');
  } on WeakRecoveryCodeException catch (e) {
    throw ActionException('bad_args', '$e');
  } on NeedsKeyException catch (e) {
    throw ActionException('needs_key', '$e');
  } on StateError catch (e) {
    throw ActionException('not_connected', e.message);
  }
}

/// [status] as the action's result, or why the pairing failed.
Map<String, Object?> _paired(PairingStatus status) {
  if (status.stage == PairingStage.failed) {
    throw ActionException(
        'pairing_failed',
        status.failure != null
            ? '${PairingException(status.failure!)}'
            : '${status.error}');
  }
  return {'pairing': pairingStatus(status), ...syncStatus()};
}

/// Starts a space at [login], or joins the one there: directly when this
/// device holds its key, else with a recovery or pairing code. Without
/// either, the space waits for the key from `sync.pair_offer` or
/// `sync.pair_accept`. Then waits for the first sync.
Future<Map<String, Object?>> _open(SyncLogin login, ActionArgs args) async {
  final recoveryCode = args['recoveryCode'] as String?;
  final pairCode = args['pairCode'] as String?;
  final space = await _sync.probe(login);
  String? newRecoveryCode;
  if (space == null) {
    newRecoveryCode = await _withKey(() =>
        _sync.createSpace(login, chosen: args['recoveryPassword'] as String?));
  } else if (recoveryCode != null) {
    await _withKey(() => _sync.recover(login, space, recoveryCode));
  } else {
    try {
      await _sync.joinSpace(login, space);
    } on NeedsKeyException {
      if (pairCode == null) {
        throw const ActionException(
            'needs_key',
            'This space belongs to other devices. Pair with one: run '
                'sync.pair_offer here and type the code there, or give '
                'pairCode from sync.pair_offer there; or give recoveryCode.');
      }
      _paired(await _acceptPairing(pairCode));
    }
  }
  final stopwatch = Stopwatch()..start();
  await _sync.syncNow();
  return {
    'created': space == null,
    if (newRecoveryCode != null) 'recoveryCode': newRecoveryCode,
    'firstSyncMs': stopwatch.elapsedMilliseconds,
    ...syncStatus(),
  };
}

Future<PairingStatus> _acceptPairing(String code) async {
  try {
    return await _withKey(() => _sync.acceptPairing(code));
  } on FormatException {
    throw const ActionException('bad_args',
        'code is the digits the other device shows, such as 12-345678');
  }
}

const _joinParams = [
  ActionParam(
      'recoveryCode',
      ParamType.string,
      "Joins a space this device has no key for with the space's recovery "
          'code',
      required: false),
  ActionParam(
      'pairCode',
      ParamType.string,
      'Joins a space this device has no key for with the code another '
          'device of the space shows (sync.pair_offer there)',
      required: false),
  ActionParam(
      'recoveryPassword',
      ParamType.string,
      'For a new space, a recovery password of your own instead of a '
          'random code',
      required: false),
];

final List<AppAction> syncActions = [
  AppAction(
    id: 'sync.cloud_usage',
    describe:
        'Cloud media monthly allowance, usage and reset time; null for personal storage without an operator policy.',
    risk: ActionRisk.read,
    run: (context, args) => _sync.cloudTraffic(),
  ),
  AppAction(
    id: 'sync.network_reconnect',
    describe:
        'Reconnects signaling while retaining established direct channels for a development network check.',
    devOnly: true,
    risk: ActionRisk.write,
    params: const [
      ActionParam(
          'delaySeconds', ParamType.integer, 'Reconnect delay, 1 to 60 seconds',
          required: false)
    ],
    run: (context, args) async {
      final seconds = args['delaySeconds'] as int? ?? 5;
      if (seconds < 1 || seconds > 60) {
        throw const ActionException(
            'bad_args', 'delaySeconds must be between 1 and 60');
      }
      await _sync.reconnectNetwork(delay: Duration(seconds: seconds));
      return _sync.networkStatus();
    },
  ),
  AppAction(
    id: 'sync.network_paths',
    describe:
        'Restricts paths for an isolated development network check; restart restores automatic selection.',
    devOnly: true,
    risk: ActionRisk.write,
    params: [
      const ActionParam('paths', ParamType.string,
          'Comma-separated lan,direct,ice,relay,cache'),
      const ActionParam('stunOnly', ParamType.boolean,
          'For ICE diagnostics, exchange only server-reflexive candidates',
          required: false)
    ],
    run: (context, args) async {
      final names =
          (args['paths'] as String).split(',').map((s) => s.trim()).toSet();
      if (names.isEmpty ||
          names.any(
              (s) => !SyncRouteType.values.any((type) => type.name == s))) {
        throw const ActionException(
            'invalid_paths', 'Choose one or more known network paths');
      }
      await _sync.setNetworkPaths(
          {for (final name in names) SyncRouteType.values.byName(name)},
          stunOnly: args['stunOnly'] as bool? ?? false);
      return _sync.networkStatus();
    },
  ),
  AppAction(
    id: 'sync.network',
    describe: 'Advanced network diagnostics: selected and available routes, '
        'pending media and durable versus temporary remote copies.',
    risk: ActionRisk.read,
    run: (context, args) => _sync.networkStatus(),
  ),
  AppAction(
    id: 'sync.status',
    describe: 'Shows where this device syncs, how the last sync went, how '
        'far a running one is, and the last pairing.',
    risk: ActionRisk.read,
    run: (context, args) async => syncStatus(),
  ),
  AppAction(
    id: 'sync.now',
    describe: 'Syncs now and waits for it to finish.',
    risk: ActionRisk.write,
    run: (context, args) async {
      if (_sync.target == null) {
        throw const ActionException('not_connected', 'Sync is not set up');
      }
      final stopwatch = Stopwatch()..start();
      await _sync.syncNow();
      return {'elapsedMs': stopwatch.elapsedMilliseconds, ...syncStatus()};
    },
  ),
  AppAction(
    id: 'sync.connect_webdav',
    describe: 'Starts syncing with a WebDAV server: makes an encrypted space '
        'there, returning its recovery code, or joins the one there, then '
        'syncs.',
    risk: ActionRisk.write,
    params: const [
      ActionParam('server', ParamType.string, 'The WebDAV address'),
      ActionParam('username', ParamType.string, 'The account name'),
      ActionParam('password', ParamType.string, 'The account password'),
      ..._joinParams,
    ],
    run: (context, args) async {
      final server = Uri.tryParse(args['server'] as String);
      if (server == null || !server.hasScheme || server.host.isEmpty) {
        throw const ActionException('bad_args', 'server must be a URL');
      }
      return _open(
          WebDavLogin(
              server: server,
              username: args['username'] as String,
              password: args['password'] as String),
          args);
    },
  ),
  AppAction(
    id: 'sync.connect_google',
    describe: "Starts syncing with the user's Google Drive, as "
        "sync.connect_webdav does. Google's account chooser appears on the "
        'device and needs a person to pick an account.',
    risk: ActionRisk.write,
    params: _joinParams,
    run: (context, args) async {
      if (!GoogleAuth.available) {
        throw const ActionException(
            'unavailable', 'This build is not registered with Google');
      }
      final auth = GoogleAuth.forPlatform();
      final account = await auth.signIn(
          doneMessage: shownLocalizations().syncGoogleSignedIn);
      return _open(GoogleDriveLogin(username: account, auth: auth), args);
    },
  ),
  AppAction(
    id: 'sync.pair_offer',
    describe: 'Shows a pairing code for another device of the user to type '
        '(sync.pair_accept) or scan. Works both ways: from a device that '
        'syncs the space, or from one signed in to it and waiting for its '
        'key. The pairing goes on in sync.status until the other device '
        'answers or it expires.',
    risk: ActionRisk.write,
    run: (context, args) async {
      final code = await _withKey(_sync.offerPairing);
      return {
        'code': code.typed,
        'qr': code.scannable,
        'expiresInSeconds': AppConfig.instance.pairingTimeout.inSeconds,
      };
    },
  ),
  AppAction(
    id: 'sync.pair_accept',
    describe: 'Pairs with the device that shows a pairing code '
        '(sync.pair_offer there), and waits until the key has gone from the '
        'device that holds it to the other.',
    risk: ActionRisk.write,
    params: const [
      ActionParam('code', ParamType.string,
          'The code the other device shows, typed or scanned'),
    ],
    run: (context, args) async =>
        _paired(await _acceptPairing(args['code'] as String)),
  ),
  AppAction(
    id: 'sync.pair_cancel',
    describe: 'Stops the pairing this device offered while it waits.',
    risk: ActionRisk.write,
    run: (context, args) async {
      _sync.cancelPairing();
      return syncStatus();
    },
  ),
  AppAction(
    id: 'sync.unlock',
    describe: 'Opens the space this device syncs again with its recovery '
        'code, after it was started over elsewhere, then syncs.',
    risk: ActionRisk.write,
    params: const [
      ActionParam(
          'recoveryCode', ParamType.string, "The space's recovery code"),
    ],
    run: (context, args) async {
      if (_sync.target == null) {
        throw const ActionException('not_connected', 'Sync is not set up');
      }
      await _withKey(() => _sync.unlock(args['recoveryCode'] as String));
      await _sync.syncNow();
      return syncStatus();
    },
  ),
  AppAction(
    id: 'sync.recovery_code',
    describe: 'Replaces the recovery code: a new random one, or a password '
        'of your own. The old one stops working; the data and the other '
        'devices stay as they are. Returns the new code to keep.',
    risk: ActionRisk.destructive,
    params: const [
      ActionParam('password', ParamType.string,
          'A recovery password of your own instead of a random code',
          required: false),
    ],
    run: (context, args) async => {
      'recoveryCode': await _withKey(
          () => _sync.changeRecoveryCode(chosen: args['password'] as String?)),
    },
  ),
  AppAction(
    id: 'sync.reset_space',
    describe: "When no device and no recovery code opens the space: starts "
        "it over from this device's diary under this device's keys. The old "
        'copy is removed and the other devices pair again. Returns the new '
        'recovery code.',
    risk: ActionRisk.destructive,
    params: const [
      ActionParam('password', ParamType.string,
          'A recovery password of your own instead of a random code',
          required: false),
    ],
    run: (context, args) async {
      if (_sync.target == null) {
        throw const ActionException('not_connected', 'Sync is not set up');
      }
      final code = await _withKey(
          () => _sync.resetSpace(chosen: args['password'] as String?));
      await _sync.syncNow();
      return {'recoveryCode': code, ...syncStatus()};
    },
  ),
  AppAction(
    id: 'sync.disconnect',
    describe: 'Stops syncing on this device; the diary and the synced copy '
        'stay as they are.',
    risk: ActionRisk.destructive,
    run: (context, args) async {
      await _sync.disconnect();
      return syncStatus();
    },
  ),
];
