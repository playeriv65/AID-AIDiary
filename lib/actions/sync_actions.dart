// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/sync/google_auth.dart';
import 'package:aid_diary/sync/sync_crypto.dart';
import 'package:aid_diary/sync/sync_service.dart';
import 'package:aid_diary/l10n/shown_language.dart';

SyncService get _sync => SyncService.instance;

Map<String, Object?> syncStatus() {
  final target = _sync.target;
  final report = _sync.lastReport;
  final progress = _sync.progress;
  return {
    'state': _sync.state.name,
    if (target != null) ...{
      'provider': target.provider.name,
      if (target.server case final server?) 'server': server.toString(),
      'account': target.username,
      'encrypted': target.encrypted,
    },
    if (_sync.lastSync case final last?) 'lastSync': last.toIso8601String(),
    if (report != null)
      'lastReport': {
        'received': report.received,
        'sent': report.sent,
        'keptConflicts': report.keptConflicts,
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

/// Runs [open], a try at opening the space with a key, and says when the
/// key was wrong.
Future<void> _withKey(Future<void> Function() open) async {
  try {
    await open();
  } on WrongKeyException {
    throw const ActionException(
        'wrong_key', 'That passphrase or recovery key does not open the space');
  }
}

/// The connected, encrypted and unlocked space a change of key needs.
SyncTarget _keyedTarget() {
  final target = _sync.target;
  if (target == null) {
    throw const ActionException('not_connected', 'Sync is not set up');
  }
  if (!target.encrypted) {
    throw const ActionException('not_encrypted', 'The space is not encrypted');
  }
  if (_sync.state == SyncState.locked) {
    throw const ActionException(
        'locked', 'The space is locked: open it with sync.unlock first');
  }
  return target;
}

String _passphrase(ActionArgs args) {
  final passphrase = args['passphrase'] as String;
  if (passphrase.isEmpty) {
    throw const ActionException('bad_args', 'passphrase must not be empty');
  }
  return passphrase;
}

/// Starts a space at [login], or joins the one there with the passphrase
/// or recovery key, then waits for the first sync.
Future<Map<String, Object?>> _open(SyncLogin login, ActionArgs args) async {
  final passphrase = args['passphrase'] as String?;
  final recoveryKey = args['recoveryKey'] as String?;
  final space = await _sync.probe(login);
  String? newRecoveryKey;
  if (space == null) {
    newRecoveryKey = await _sync.createSpace(login, passphrase: passphrase);
  } else {
    if (space.encrypted && passphrase == null && recoveryKey == null) {
      throw const ActionException('needs_key',
          'The space here is encrypted: give passphrase or recoveryKey');
    }
    await _withKey(() => _sync.joinSpace(login, space,
        passphrase: passphrase, recoveryKey: recoveryKey));
  }
  final stopwatch = Stopwatch()..start();
  await _sync.syncNow();
  return {
    'created': space == null,
    if (newRecoveryKey != null) 'recoveryKey': newRecoveryKey,
    'firstSyncMs': stopwatch.elapsedMilliseconds,
    ...syncStatus(),
  };
}

const _keyParams = [
  ActionParam('passphrase', ParamType.string,
      'Encrypts a new space, or opens an existing one; none for no encryption',
      required: false),
  ActionParam('recoveryKey', ParamType.string,
      'Opens an existing encrypted space instead of the passphrase',
      required: false),
];

final List<AppAction> syncActions = [
  AppAction(
    id: 'sync.status',
    describe: 'Shows where this device syncs, how the last sync went and '
        'how far a running one is.',
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
    describe: 'Starts syncing with a WebDAV server: makes a space there or '
        'joins the one there, then syncs.',
    risk: ActionRisk.write,
    params: const [
      ActionParam('server', ParamType.string, 'The WebDAV address'),
      ActionParam('username', ParamType.string, 'The account name'),
      ActionParam('password', ParamType.string, 'The account password'),
      ..._keyParams,
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
    describe: "Starts syncing with the user's Google Drive. Google's account "
        'chooser appears on the device and needs a person to pick an account.',
    risk: ActionRisk.write,
    params: _keyParams,
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
    id: 'sync.unlock',
    describe: 'Opens an encrypted space this device lost the key of, after '
        'it was reset elsewhere, with the passphrase or the recovery key, '
        'then syncs.',
    risk: ActionRisk.write,
    params: const [
      ActionParam('passphrase', ParamType.string, 'The space passphrase',
          required: false),
      ActionParam('recoveryKey', ParamType.string,
          'The recovery key, instead of the passphrase',
          required: false),
    ],
    run: (context, args) async {
      if (_sync.target == null) {
        throw const ActionException('not_connected', 'Sync is not set up');
      }
      final passphrase = args['passphrase'] as String?;
      final recoveryKey = args['recoveryKey'] as String?;
      if (passphrase == null && recoveryKey == null) {
        throw const ActionException(
            'bad_args', 'Give passphrase or recoveryKey');
      }
      await _withKey(
          () => _sync.unlock(passphrase: passphrase, recoveryKey: recoveryKey));
      await _sync.syncNow();
      return syncStatus();
    },
  ),
  AppAction(
    id: 'sync.change_passphrase',
    describe: 'Locks the space key under a new passphrase; the synced data '
        'and the other devices stay as they are.',
    risk: ActionRisk.write,
    params: const [
      ActionParam('passphrase', ParamType.string, 'The new passphrase'),
    ],
    run: (context, args) async {
      _keyedTarget();
      await _sync.changePassphrase(_passphrase(args));
      return syncStatus();
    },
  ),
  AppAction(
    id: 'sync.reset_encryption',
    describe: 'For a forgotten passphrase: starts the space over from this '
        "device's diary under a new key. The old copy is removed and the "
        'other devices must join again. Returns the new recovery key.',
    risk: ActionRisk.destructive,
    params: const [
      ActionParam('passphrase', ParamType.string, 'The new passphrase'),
    ],
    run: (context, args) async {
      _keyedTarget();
      final recoveryKey = await _sync.resetEncryption(_passphrase(args));
      await _sync.syncNow();
      return {'recoveryKey': recoveryKey, ...syncStatus()};
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
