// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/sync/google_auth.dart';
import 'package:aid_diary/sync/pairing.dart';
import 'package:aid_diary/sync/sync_backend.dart';
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
    if (_sync.pendingConflicts > 0) 'conflicts': _sync.pendingConflicts,
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

/// The sign-in of the last connect that did not finish: there was no space
/// yet (`sync.create_space` goes on from it), or the space there belongs to
/// other devices (`sync.unlock` goes on from it).
({SyncLogin login, SpaceInfo? space})? _signedIn;

/// Signs in at [login] and joins the space there when this device holds
/// its key; the first sync then runs on without being waited for. `space`
/// in the result says how it went: `joined`; `none`, when there is no
/// space yet; or `needs_key`, when the space belongs to other devices.
/// Both of the latter keep the sign-in for the step that follows.
Future<Map<String, Object?>> openSyncSpace(SyncLogin login) async {
  _signedIn = null;
  final space = await _sync.probe(login);
  if (space == null) {
    _signedIn = (login: login, space: null);
    return {'space': 'none', ...syncStatus()};
  }
  try {
    await _sync.joinSpace(login, space);
  } on NeedsKeyException {
    _signedIn = (login: login, space: space);
    return {'space': 'needs_key', ...syncStatus()};
  }
  return {'space': 'joined', ...syncStatus()};
}

Future<PairingStatus> _acceptPairing(String code) async {
  try {
    return await _withKey(() => _sync.acceptPairing(code));
  } on FormatException {
    throw const ActionException('bad_args',
        'code is the digits the other device shows, such as 12-345678');
  }
}

/// What a connect action does after signing in, for its description.
const _connectSteps = 'joins the space there if this device holds its key. '
    'Returns space: joined; none (then sync.create_space); or needs_key '
    '(then pair, or sync.unlock with the recovery code).';

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
    describe: 'Signs in to a WebDAV server and $_connectSteps',
    risk: ActionRisk.write,
    params: const [
      ActionParam('server', ParamType.string,
          'The full WebDAV address, such as https://dav.example.com/'),
      ActionParam('username', ParamType.string, 'The account name'),
      ActionParam('password', ParamType.string, 'The account password'),
    ],
    run: (context, args) async {
      final server = Uri.tryParse((args['server'] as String).trim());
      if (server == null || !server.hasScheme || server.host.isEmpty) {
        throw const ActionException('bad_address',
            'server must be a full address, such as https://dav.example.com/');
      }
      return openSyncSpace(WebDavLogin(
          server: server,
          username: (args['username'] as String).trim(),
          password: args['password'] as String));
    },
  ),
  AppAction(
    id: 'sync.connect_google',
    describe: "Signs in to the user's Google Drive and $_connectSteps "
        "Google's account chooser appears on the device and needs a person "
        'to pick an account.',
    risk: ActionRisk.write,
    run: (context, args) async {
      if (!GoogleAuth.available) {
        throw const ActionException(
            'unavailable', 'This build is not registered with Google');
      }
      final auth = GoogleAuth.forPlatform();
      final account = await auth.signIn(
          doneMessage: shownLocalizations().syncGoogleSignedIn);
      return openSyncSpace(GoogleDriveLogin(username: account, auth: auth));
    },
  ),
  AppAction(
    id: 'sync.create_space',
    describe: 'Makes an encrypted space with this diary in it where the last '
        'sync.connect_webdav or sync.connect_google found none, and starts '
        'syncing it. Returns the recovery code to keep: a random one, or '
        'the password given.',
    risk: ActionRisk.write,
    params: const [
      ActionParam('password', ParamType.string,
          'A recovery password of your own instead of a random code',
          required: false),
    ],
    run: (context, args) async {
      final signedIn = _signedIn;
      if (signedIn == null || signedIn.space != null || _sync.target != null) {
        throw const ActionException(
            'not_signed_in',
            'Sign in first with sync.connect_webdav or sync.connect_google '
                'where there is no space yet');
      }
      final code = await _withKey(() => _sync.createSpace(signedIn.login,
          chosen: args['password'] as String?));
      _signedIn = null;
      return {'recoveryCode': code, ...syncStatus()};
    },
  ),
  AppAction(
    id: 'sync.sign_in_again',
    describe: 'Signs in to Google Drive again after Google asked for it '
        '(sync.status shows the error), keeping the space and its key, then '
        "syncs. Google's account chooser appears on the device.",
    risk: ActionRisk.write,
    run: (context, args) async {
      if (_sync.target?.provider != SyncProvider.googleDrive) {
        throw const ActionException(
            'not_connected', 'This device does not sync with Google Drive');
      }
      await _sync.signInAgain(
          doneMessage: shownLocalizations().syncGoogleSignedIn);
      return syncStatus();
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
    describe: 'Opens a space with its recovery code: the one this device '
        'syncs, after it was started over elsewhere, or else the one the '
        'last sync.connect_webdav or sync.connect_google found belonging to '
        'other devices. The sync that follows runs on (sync.status).',
    risk: ActionRisk.write,
    params: const [
      ActionParam(
          'recoveryCode', ParamType.string, "The space's recovery code"),
    ],
    run: (context, args) async {
      final code = args['recoveryCode'] as String;
      final signedIn = _signedIn;
      if (_sync.target != null) {
        await _withKey(() => _sync.unlock(code));
      } else if (signedIn != null && signedIn.space != null) {
        await _withKey(
            () => _sync.recover(signedIn.login, signedIn.space!, code));
        _signedIn = null;
      } else {
        throw const ActionException('not_connected', 'Sync is not set up');
      }
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
        "a separate space from this device's diary under this device's keys. "
        'Previous encrypted objects stay in their storage paths. Other '
        'devices pair again. Returns the new recovery code.',
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
