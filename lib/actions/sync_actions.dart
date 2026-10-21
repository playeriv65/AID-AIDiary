// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:ui';

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/sync/google_auth.dart';
import 'package:aid_diary/sync/sync_service.dart';

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
  };
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
    await _sync.joinSpace(login, space,
        passphrase: passphrase, recoveryKey: recoveryKey);
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
      final l10n = lookupAppLocalizations(AppLocalizations.supportedLocales
          .firstWhere(
              (locale) =>
                  locale.languageCode ==
                  PlatformDispatcher.instance.locale.languageCode,
              orElse: () => const Locale('en')));
      final auth = GoogleAuth.forPlatform();
      final account = await auth.signIn(doneMessage: l10n.syncGoogleSignedIn);
      return _open(GoogleDriveLogin(username: account, auth: auth), args);
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
