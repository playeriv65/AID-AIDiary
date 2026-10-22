// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/routing/destinations.dart';
import 'package:aid_diary/widgets/haptics.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/sync/google_auth.dart';
import 'package:aid_diary/sync/device_auth.dart';
import 'package:aid_diary/sync/google_drive_backend.dart';
import 'package:aid_diary/sync/sync_backend.dart';
import 'package:aid_diary/sync/sync_crypto.dart';
import 'package:aid_diary/sync/sync_service.dart';
import 'package:aid_diary/sync/webdav_backend.dart';
import 'package:aid_diary/widgets/progress_dialog.dart';
import 'package:aid_diary/widgets/cloud_traffic_notice.dart';
import 'package:aid_diary/widgets/device_name_tile.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_ui/material_ui.dart';

class SyncSettings extends StatefulWidget {
  const SyncSettings({super.key});

  @override
  State<SyncSettings> createState() => _SyncSettingsState();
}

class _SyncSettingsState extends State<SyncSettings> {
  final _server = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _service = SyncService.instance;

  @override
  void dispose() {
    _server.dispose();
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  void _say(String message) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(message)));

  String _describe(Object error, AppLocalizations l10n) => switch (error) {
        WebDavException(unauthorized: true) => l10n.syncSignInFailed,
        GoogleSignInNeeded() ||
        GoogleDriveException(unauthorized: true) =>
          l10n.syncGoogleSignInAgain,
        GoogleDriveNotAllowed() => l10n.syncGoogleDriveNotAllowed,
        WrongKeyException() => l10n.syncWrongKey,
        DeviceAuthorizationNeeded() => l10n.syncDeviceUnavailable,
        ActionException(:final message) => message,
        _ => l10n.syncConnectionProblem,
      };

  /// Runs [task] behind a progress dialog and reports a failure; null then,
  /// and also when the user called a sign-in off.
  Future<T?> _attempt<T>(Future<T> Function() task) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      return await runWithProgress(context, (update) => task());
    } on DeviceAuthorizationNeeded {
      if (mounted) await openPlace(context, 'settings/sync/devices');
      return null;
    } on GoogleSignInException catch (error) {
      if (error.code != GoogleSignInExceptionCode.canceled && mounted) {
        _say(_describe(error, l10n));
      }
      return null;
    } catch (error) {
      if (mounted) _say(_describe(error, l10n));
      return null;
    }
  }

  Future<void> _connect() async {
    final server = Uri.tryParse(_server.text.trim());
    if (server == null || !server.hasScheme || server.host.isEmpty) return;
    await _open(WebDavLogin(
        server: server,
        username: _username.text.trim(),
        password: _password.text));
  }

  Future<void> _connectGoogleDrive() async {
    final doneMessage = AppLocalizations.of(context)!.syncGoogleSignedIn;
    final auth = GoogleAuth.forPlatform();
    final login = await _attempt(() async => GoogleDriveLogin(
        username: await auth.signIn(doneMessage: doneMessage), auth: auth));
    if (login != null && mounted) await _open(login);
  }

  /// Starts a space at [login], or joins the one already there.
  Future<void> _open(SyncLogin login) async {
    var probed = false;
    final space = await _attempt(() async {
      final space = await _service.probe(login);
      probed = true;
      return space;
    });
    if (!probed || !mounted) return;
    if (space == null) {
      await _startSpace(login);
      return;
    }
    try {
      await runWithProgress(context, (_) => _service.joinSpace(login, space));
    } on NeedsKeyException {
      if (mounted) await _askForKey(login, space);
    } catch (error) {
      if (mounted) _say(_describe(error, AppLocalizations.of(context)!));
    }
  }

  Future<void> _startSpace(SyncLogin login) async {
    final choice = await showDialog<({String? password})>(
        context: context, builder: (_) => const _NewSpaceDialog());
    if (choice == null || !mounted) return;
    final code = await _attempt(
        () => _service.createSpace(login, chosen: choice.password));
    if (code != null && choice.password == null && mounted) {
      await _showRecoveryCode(code);
    }
  }

  /// The space belongs to the user's other devices: pair with one, or
  /// open it with the recovery code.
  Future<void> _askForKey(SyncLogin login, SpaceInfo space) async {
    final l10n = AppLocalizations.of(context)!;
    final choice = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.syncJoinTitle),
        content: Text(l10n.syncJoinNeedsKey),
        actions: [
          TextButton(
              key: const ValueKey('sync-use-recovery'),
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.syncUseRecoveryCode)),
          FilledButton(
              key: const ValueKey('sync-pair'),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.syncPairDevice)),
        ],
      ),
    );
    if (choice == null || !mounted) return;
    if (choice) {
      await _pair();
    } else {
      await _recoverWith((code) => _service.recover(login, space, code));
    }
  }

  Future<void> _pair() => openPlace(context, 'sync/pairing');

  /// Asks for the recovery code until one opens the space.
  Future<void> _recoverWith(Future<void> Function(String code) open) async {
    while (true) {
      if (!mounted) return;
      final code = await showDialog<String>(
          context: context, builder: (_) => const _RecoveryCodeInputDialog());
      if (code == null || !mounted) return;
      final l10n = AppLocalizations.of(context)!;
      try {
        await runWithProgress(context, (update) => open(code));
        return;
      } on WrongKeyException {
        Haptics.error();
        if (mounted) _say(l10n.syncWrongKey);
      } on ActionException catch (error) {
        Haptics.error();
        if (mounted) _say(_describe(error, l10n));
        if (error.code != 'wrong_key') return;
      } catch (error) {
        if (mounted) _say(_describe(error, l10n));
        return;
      }
    }
  }

  Future<void> _showRecoveryCode(String code) => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _RecoveryCodeDialog(code));

  Future<bool> _confirm(String title, String description, String action,
      {bool destructive = false}) async {
    if (destructive) Haptics.warning();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel)),
          FilledButton(
              style: destructive
                  ? FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error)
                  : null,
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(action)),
        ],
      ),
    );
    return confirmed ?? false;
  }

  Future<void> _changeRecoveryCode() async {
    final l10n = AppLocalizations.of(context)!;
    final choice = await showDialog<({String? password})>(
        context: context, builder: (_) => const _ChangeRecoveryDialog());
    if (choice == null || !mounted) return;
    final result = await _attempt(() => AppActions.instance.run(
        'sync.recovery_code',
        {if (choice.password case final password?) 'password': password},
        confirmed: true));
    if (result is! Map || !mounted) return;
    if (choice.password == null) {
      await _showRecoveryCode(result['recoveryCode'] as String);
    } else {
      _say(l10n.syncRecoveryCodeChanged);
    }
  }

  Future<void> _resetSpace() async {
    final l10n = AppLocalizations.of(context)!;
    final reset = await _confirm(l10n.syncResetSpace,
        l10n.syncResetSpaceDescription, l10n.syncResetSpace,
        destructive: true);
    if (!reset || !mounted) return;
    final result = await _attempt(
        () => AppActions.instance.run('sync.reset_space', {}, confirmed: true));
    if (result is Map && mounted) {
      await _showRecoveryCode(result['recoveryCode'] as String);
    }
  }

  Future<void> _disconnect() async {
    final l10n = AppLocalizations.of(context)!;
    if (await _confirm(l10n.syncDisconnect, l10n.syncDisconnectDescription,
            l10n.syncDisconnect) &&
        mounted) {
      await _attempt(() =>
          AppActions.instance.run('sync.disconnect', {}, confirmed: true));
    }
  }

  String _status(AppLocalizations l10n) {
    final last = _service.lastSync;
    return switch (_service.state) {
      SyncState.syncing => switch (_service.progress) {
          (sending: false, :final done, :final total) =>
            l10n.syncReceiving(done, total),
          (sending: true, :final done, :final total) =>
            l10n.syncSending(done, total),
          null => l10n.syncSyncing,
        },
      SyncState.failed => l10n.syncConnectionProblem,
      SyncState.locked => l10n.syncLocked,
      SyncState.mediaPending => l10n.syncMediaPending,
      SyncState.waitingForDevices => l10n.syncWaitingForDevices,
      _ when last == null => l10n.syncNever,
      _ => l10n.syncAllSynced,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsSyncTitle), centerTitle: true),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 840),
          child: ListenableBuilder(
            listenable: _service,
            builder: (context, _) {
              final target = _service.target;
              if (target != null) return _connected(l10n, target);
              return Column(children: [
                const DeviceNameTile(),
                ListTile(
                    key: const ValueKey('nearby-migration-settings'),
                    leading: const Icon(Icons.phonelink),
                    title: Text(l10n.nearbyTitle),
                    onTap: () => openPlace(context, 'settings/sync/nearby')),
                if (DeviceAuthManager.instance.registrations.isNotEmpty)
                  ListTile(
                      key: const ValueKey('sync-device-settings'),
                      leading: const Icon(Icons.verified_user),
                      title: Text(l10n.syncDevicesTitle),
                      onTap: () => openPlace(context, 'settings/sync/devices')),
                Expanded(child: _signIn(l10n)),
              ]);
            },
          ),
        ),
      ),
    );
  }

  Widget _signIn(AppLocalizations l10n) {
    InputDecoration field(String label) =>
        InputDecoration(labelText: label, border: const OutlineInputBorder());
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const CloudTrafficNotice(key: ValueKey('sync-cloud-traffic-sign-in')),
        Text(l10n.syncOffDescription),
        if (GoogleAuth.available) ...[
          const SizedBox(height: 16),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: FilledButton.tonalIcon(
              key: const ValueKey('sync-google-drive'),
              icon: const Icon(Icons.add_to_drive_rounded),
              label: Text(l10n.syncUseGoogleDrive),
              onPressed: _connectGoogleDrive,
            ),
          ),
          const SizedBox(height: 24),
          Text(l10n.syncOrWebDav,
              style: Theme.of(context).textTheme.titleSmall),
        ],
        const SizedBox(height: 16),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: ActionChip(
            key: const ValueKey('sync-use-official'),
            avatar: const Icon(Icons.cloud_outlined, size: 18),
            label: Text(l10n.syncUseOfficial),
            onPressed: () =>
                _server.text = AppConfig.instance.syncOfficialServer,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          key: const ValueKey('sync-server'),
          controller: _server,
          keyboardType: TextInputType.url,
          autocorrect: false,
          decoration: field(l10n.syncServer)
              .copyWith(hintText: AppConfig.instance.syncExampleServer),
        ),
        const SizedBox(height: 12),
        TextField(
          key: const ValueKey('sync-username'),
          controller: _username,
          autocorrect: false,
          decoration: field(l10n.syncUsername),
        ),
        const SizedBox(height: 12),
        TextField(
          key: const ValueKey('sync-password'),
          controller: _password,
          obscureText: true,
          autocorrect: false,
          decoration: field(l10n.syncPassword),
        ),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton(
              key: const ValueKey('sync-connect'),
              onPressed: _connect,
              child: Text(l10n.syncConnect)),
        ),
      ],
    );
  }

  Widget _connected(AppLocalizations l10n, SyncTarget target) {
    final syncing = _service.state == SyncState.syncing;
    final locked = _service.state == SyncState.locked;
    return ListView(
      children: [
        const CloudTrafficNotice(key: ValueKey('sync-cloud-traffic-connected')),
        ListTile(
          leading: syncing
              ? const SizedBox.square(
                  dimension: 24,
                  child: CircularProgressIndicator(strokeWidth: 2.5))
              : Icon(locked
                  ? Icons.lock_rounded
                  : _service.state == SyncState.failed
                      ? Icons.sync_problem_rounded
                      : Icons.sync_rounded),
          title: Text(_status(l10n), key: const ValueKey('sync-status')),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => openPlace(context, 'settings/sync/copies'),
        ),
        const Divider(),
        if (DeviceAuthManager.instance.registrations.isNotEmpty)
          ListTile(
            key: const ValueKey('sync-device-settings'),
            leading: const Icon(Icons.verified_user),
            title: Text(l10n.syncDevicesTitle),
            onTap: () => openPlace(context, 'settings/sync/devices'),
          ),
        if (_service.error is GoogleSignInNeeded)
          ListTile(
            key: const ValueKey('sync-sign-in-again'),
            leading: const Icon(Icons.login_rounded),
            title: Text(l10n.syncSignInAgain),
            onTap: () => _attempt(() =>
                _service.signInAgain(doneMessage: l10n.syncGoogleSignedIn)),
          ),
        if (locked) ...[
          ListTile(
            key: const ValueKey('sync-pair'),
            leading: const Icon(Icons.devices_rounded),
            title: Text(l10n.syncPairDevice),
            onTap: _pair,
          ),
          ListTile(
            key: const ValueKey('sync-use-recovery'),
            leading: const Icon(Icons.key_rounded),
            title: Text(l10n.syncUseRecoveryCode),
            onTap: () => _recoverWith((code) =>
                AppActions.instance.run('sync.unlock', {'recoveryCode': code})),
          ),
        ] else ...[
          ListTile(
            key: const ValueKey('sync-now'),
            leading: const Icon(Icons.sync_rounded),
            title: Text(l10n.syncNow),
            enabled: !syncing,
            onTap: () async {
              await AppActions.instance.run('sync.now', {});
              _service.state == SyncState.failed
                  ? Haptics.error()
                  : Haptics.success();
            },
          ),
          ListTile(
            key: const ValueKey('sync-add-device'),
            leading: const Icon(Icons.devices_rounded),
            title: Text(l10n.syncAddDevice),
            onTap: _pair,
          ),
        ],
        ExpansionTile(
            key: const ValueKey('sync-more'),
            title: Text(l10n.syncMore),
            children: [
              const DeviceNameTile(),
              ListTile(
                  key: const ValueKey('nearby-migration-settings'),
                  leading: const Icon(Icons.phonelink),
                  title: Text(l10n.nearbyTitle),
                  onTap: () => openPlace(context, 'settings/sync/nearby')),
              ListTile(
                title: Text(target.server?.host ?? l10n.syncGoogleDrive),
                subtitle: Text('${target.username} · ${l10n.syncEncrypted}'),
              ),
              if (_service.temporaryMediaCache)
                ListTile(subtitle: Text(l10n.syncCacheNotice)),
              if (!locked) ...[
                ListTile(
                  key: const ValueKey('sync-change-recovery'),
                  leading: const Icon(Icons.key_rounded),
                  title: Text(l10n.syncChangeRecoveryCode),
                  onTap: _changeRecoveryCode,
                ),
                ListTile(
                  key: const ValueKey('sync-reset-space'),
                  leading: const Icon(Icons.restart_alt_rounded),
                  title: Text(l10n.syncResetSpace),
                  onTap: _resetSpace,
                ),
              ],
              ListTile(
                leading: const Icon(Icons.cloud_off_rounded),
                title: Text(l10n.syncDisconnect),
                onTap: _disconnect,
              ),
            ]),
      ],
    );
  }
}

/// A recovery password of the user's own, typed twice.
class _RecoveryPasswordFields extends StatelessWidget {
  const _RecoveryPasswordFields(
      {required this.password, required this.repeat, this.showErrors = false});

  final TextEditingController password;
  final TextEditingController repeat;
  final bool showErrors;

  static String? problem(
      String password, String repeat, AppLocalizations l10n) {
    final min = AppConfig.instance.recoveryMinPasswordLength;
    return password.trim().length < min
        ? l10n.syncRecoveryPasswordTooShort(min)
        : password != repeat
            ? l10n.syncRecoveryPasswordMismatch
            : null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final error = showErrors ? problem(password.text, repeat.text, l10n) : null;
    return Column(mainAxisSize: MainAxisSize.min, children: [
      TextField(
        key: const ValueKey('sync-recovery-password'),
        controller: password,
        obscureText: true,
        autocorrect: false,
        decoration: InputDecoration(
            labelText: l10n.syncRecoveryPassword,
            border: const OutlineInputBorder()),
      ),
      const SizedBox(height: 12),
      TextField(
        key: const ValueKey('sync-recovery-password-repeat'),
        controller: repeat,
        obscureText: true,
        autocorrect: false,
        decoration: InputDecoration(
            labelText: l10n.syncRecoveryPasswordRepeat,
            errorText: error,
            border: const OutlineInputBorder()),
      ),
    ]);
  }
}

/// A random recovery code, or a password of the user's own: the choice a
/// new space and a changed code both make. Pops `(password: null)` for a
/// random code.
class _RecoveryChoice extends StatefulWidget {
  const _RecoveryChoice(
      {required this.title, required this.description, required this.action});

  final String title;
  final String description;
  final String action;

  @override
  State<_RecoveryChoice> createState() => _RecoveryChoiceState();
}

class _RecoveryChoiceState extends State<_RecoveryChoice> {
  final _password = TextEditingController();
  final _repeat = TextEditingController();
  var _own = false;
  var _showErrors = false;

  @override
  void dispose() {
    _password.dispose();
    _repeat.dispose();
    super.dispose();
  }

  void _done() {
    final l10n = AppLocalizations.of(context)!;
    if (_own &&
        _RecoveryPasswordFields.problem(_password.text, _repeat.text, l10n) !=
            null) {
      setState(() => _showErrors = true);
      return;
    }
    Navigator.of(context).pop((password: _own ? _password.text : null));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.description),
            SwitchListTile(
              key: const ValueKey('sync-own-recovery'),
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.syncOwnRecoveryPassword),
              value: _own,
              onChanged: (value) => setState(() => _own = value),
            ),
            if (_own) ...[
              const SizedBox(height: 8),
              _RecoveryPasswordFields(
                  password: _password,
                  repeat: _repeat,
                  showErrors: _showErrors),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel)),
        FilledButton(
            key: const ValueKey('sync-start'),
            onPressed: _done,
            child: Text(widget.action)),
      ],
    );
  }
}

/// Starts a space: always end-to-end encrypted, with a random recovery code
/// unless the user picks a password.
class _NewSpaceDialog extends StatelessWidget {
  const _NewSpaceDialog();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _RecoveryChoice(
        title: l10n.syncNewSpaceTitle,
        description: l10n.syncNewSpaceDescription,
        action: l10n.syncConnect);
  }
}

/// A new recovery code in place of the current one.
class _ChangeRecoveryDialog extends StatelessWidget {
  const _ChangeRecoveryDialog();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _RecoveryChoice(
        title: l10n.syncChangeRecoveryCode,
        description: l10n.syncChangeRecoveryDescription,
        action: l10n.syncChangeRecoveryCode);
  }
}

/// The recovery code, or the recovery password, of a space.
class _RecoveryCodeInputDialog extends StatefulWidget {
  const _RecoveryCodeInputDialog();

  @override
  State<_RecoveryCodeInputDialog> createState() =>
      _RecoveryCodeInputDialogState();
}

class _RecoveryCodeInputDialogState extends State<_RecoveryCodeInputDialog> {
  final _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.syncUseRecoveryCode),
      content: TextField(
        key: const ValueKey('sync-recovery-input'),
        controller: _code,
        autocorrect: false,
        decoration: InputDecoration(
            labelText: l10n.syncRecoveryCode,
            border: const OutlineInputBorder()),
        onSubmitted: (code) => Navigator.of(context).pop(code),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel)),
        FilledButton(
            key: const ValueKey('sync-unlock-confirm'),
            onPressed: () => Navigator.of(context).pop(_code.text),
            child: Text(l10n.syncUnlock)),
      ],
    );
  }
}

/// Shows the recovery code once; it closes only after the user says it is
/// kept.
class _RecoveryCodeDialog extends StatefulWidget {
  const _RecoveryCodeDialog(this.code);

  final String code;

  @override
  State<_RecoveryCodeDialog> createState() => _RecoveryCodeDialogState();
}

class _RecoveryCodeDialogState extends State<_RecoveryCodeDialog> {
  var _saved = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: Text(l10n.syncRecoveryCodeTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.syncRecoveryCodeDescription),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SelectableText(widget.code,
                  key: const ValueKey('sync-recovery-code'),
                  style: const TextStyle(
                      fontFamily: 'monospace', fontSize: 16, height: 1.5)),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: const Icon(Icons.copy_rounded),
                label: Text(MaterialLocalizations.of(context).copyButtonLabel),
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: widget.code));
                  Haptics.success();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.syncRecoveryCodeCopied)));
                  }
                },
              ),
            ),
            CheckboxListTile(
              key: const ValueKey('sync-recovery-saved'),
              contentPadding: EdgeInsets.zero,
              value: _saved,
              title: Text(l10n.syncRecoveryCodeSaved),
              onChanged: (value) => setState(() => _saved = value ?? false),
            ),
          ],
        ),
        actions: [
          FilledButton(
              onPressed: _saved ? () => Navigator.of(context).pop() : null,
              child: Text(MaterialLocalizations.of(context).okButtonLabel)),
        ],
      ),
    );
  }
}
