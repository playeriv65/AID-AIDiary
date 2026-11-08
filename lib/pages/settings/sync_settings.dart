// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/widgets/confirm_dialog.dart';
import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/routing/destinations.dart';
import 'package:aid_diary/widgets/haptics.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/sync/google_auth.dart';
import 'package:aid_diary/sync/device_auth.dart';
import 'package:aid_diary/sync/google_drive_backend.dart';
import 'package:aid_diary/sync/sync_service.dart';
import 'package:aid_diary/sync/webdav_backend.dart';
import 'package:aid_diary/widgets/failure_dialog.dart';
import 'package:aid_diary/widgets/new_password_fields.dart';
import 'package:aid_diary/widgets/progress_dialog.dart';
import 'package:aid_diary/widgets/cloud_traffic_notice.dart';
import 'package:aid_diary/widgets/device_name_tile.dart';
import 'package:aid_diary/widgets/settings_row.dart';
import 'package:aid_diary/widgets/snack_message.dart';
import 'package:aid_diary/widgets/sync_conflict_dialog.dart';
import 'package:aid_diary/widgets/text_input_dialog.dart';
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

  /// What went wrong, and whether the user has to change something before
  /// trying again (docs/ARCHITECTURE.md, "Reporting failures").
  ({String message, bool needsAction}) _describe(
          Object error, AppLocalizations l10n) =>
      switch (error) {
        WebDavException(unauthorized: true) => (
            message: l10n.syncSignInFailed,
            needsAction: true
          ),
        GoogleSignInNeeded() || GoogleDriveException(unauthorized: true) => (
            message: l10n.syncGoogleSignInAgain,
            needsAction: true
          ),
        GoogleDriveNotAllowed() => (
            message: l10n.syncGoogleDriveNotAllowed,
            needsAction: true
          ),
        ActionException(code: 'bad_address') => (
            message: l10n.syncServerInvalid,
            needsAction: true
          ),
        ActionException(code: 'wrong_key') => (
            message: l10n.syncWrongKey,
            needsAction: false
          ),
        DeviceAuthorizationNeeded() => (
            message: l10n.syncDeviceUnavailable,
            needsAction: false
          ),
        ActionException(:final message) => (
            message: message,
            needsAction: false
          ),
        _ => (message: l10n.syncConnectionProblem, needsAction: false),
      };

  /// Shows [error]: the failure dialog when the user has to change
  /// something, else a snack bar.
  Future<void> _report(Object error) async {
    if (!mounted) return;
    final (:message, :needsAction) =
        _describe(error, AppLocalizations.of(context)!);
    if (needsAction) {
      await showFailureDialog(context, description: message);
    } else {
      showSnackMessage(context, message);
    }
  }

  /// Runs [task] behind a progress dialog and reports a failure; null then,
  /// and also when the user called a sign-in off.
  Future<T?> _attempt<T>(Future<T> Function() task) async {
    try {
      return await runWithProgress(context, (update) => task());
    } on DeviceAuthorizationNeeded {
      if (mounted) await openPlace(context, 'settings/sync/devices');
    } on GoogleSignInException catch (error) {
      if (error.code != GoogleSignInExceptionCode.canceled) {
        await _report(error);
      }
    } catch (error) {
      await _report(error);
    }
    return null;
  }

  Future<void> _connect() => _open('sync.connect_webdav', {
        'server': _server.text,
        'username': _username.text,
        'password': _password.text,
      });

  Future<void> _connectGoogleDrive() => _open('sync.connect_google');

  /// Signs in with the connect [action], then starts a space or asks how
  /// to join the one there, as its result says.
  Future<void> _open(String action,
      [Map<String, Object?> args = const {}]) async {
    final result = await _attempt(() => AppActions.instance.run(action, args));
    if (result is! Map || !mounted) return;
    switch (result['space']) {
      case 'none':
        await _startSpace();
      case 'needs_key':
        await _askForKey();
    }
  }

  Future<void> _startSpace() async {
    final choice = await showDialog<({String? password})>(
        context: context, builder: (_) => const _NewSpaceDialog());
    if (choice == null || !mounted) return;
    final result = await _attempt(() => AppActions.instance.run(
        'sync.create_space',
        {if (choice.password case final password?) 'password': password}));
    if (result is Map && choice.password == null && mounted) {
      await _showRecoveryCode(result['recoveryCode'] as String);
    }
  }

  /// The space belongs to the user's other devices: pair with one, or
  /// open it with the recovery code.
  Future<void> _askForKey() async {
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
    choice ? await _pair() : await _useRecoveryCode();
  }

  Future<void> _pair() => openPlace(context, 'sync/pairing');

  /// Asks for the recovery code until one opens the space: the one this
  /// device syncs, or the one it signed in to (sync.unlock).
  Future<void> _useRecoveryCode() async {
    while (true) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      final code = await showTextInputDialog(context,
          title: l10n.syncUseRecoveryCode,
          confirm: l10n.syncUnlock,
          label: l10n.syncRecoveryCode,
          trim: false,
          plain: true,
          fieldKey: const ValueKey('sync-recovery-input'),
          confirmKey: const ValueKey('sync-unlock-confirm'));
      if (code == null || !mounted) return;
      try {
        await runWithProgress(
            context,
            (update) =>
                AppActions.instance.run('sync.unlock', {'recoveryCode': code}));
        return;
      } catch (error) {
        Haptics.error();
        await _report(error);
        // A wrong code is asked for again.
        if (error is! ActionException || error.code != 'wrong_key') return;
      }
    }
  }

  Future<void> _showRecoveryCode(String code) => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _RecoveryCodeDialog(code));

  Future<bool> _confirm(String title, String description, String action,
      {bool destructive = false}) {
    return showConfirmDialog(context,
        title: title,
        message: description,
        confirm: action,
        destructive: destructive);
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
      showSnackMessage(context, l10n.syncRecoveryCodeChanged);
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
                const _NearbyTile(),
                const _DevicesTile(),
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
        if (_service.pendingConflicts > 0)
          SettingsRow(
            key: const ValueKey('sync-conflicts'),
            icon: Icons.call_split_rounded,
            title: l10n.syncConflicts(_service.pendingConflicts),
            onTap: () => resolveSyncConflicts(context),
          ),
        const Divider(),
        const _DevicesTile(),
        if (_service.error is GoogleSignInNeeded)
          ListTile(
            key: const ValueKey('sync-sign-in-again'),
            leading: const Icon(Icons.login_rounded),
            title: Text(l10n.syncSignInAgain),
            onTap: () => _attempt(
                () => AppActions.instance.run('sync.sign_in_again', {})),
          ),
        if (!locked)
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
          key: const ValueKey('sync-pair'),
          leading: const Icon(Icons.devices_rounded),
          title: Text(l10n.syncPairDevice),
          onTap: _pair,
        ),
        if (locked)
          ListTile(
            key: const ValueKey('sync-use-recovery'),
            leading: const Icon(Icons.key_rounded),
            title: Text(l10n.syncUseRecoveryCode),
            onTap: _useRecoveryCode,
          ),
        ExpansionTile(
            key: const ValueKey('sync-more'),
            title: Text(l10n.syncMore),
            children: [
              const DeviceNameTile(),
              const _NearbyTile(),
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
  final _form = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _repeat = TextEditingController();
  var _own = false;

  @override
  void dispose() {
    _password.dispose();
    _repeat.dispose();
    super.dispose();
  }

  void _done() {
    if (_own && !_form.currentState!.validate()) return;
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
              Form(
                key: _form,
                child: NewPasswordFields(
                    password: _password,
                    repeat: _repeat,
                    minLength: AppConfig.instance.recoveryMinPasswordLength,
                    label: l10n.syncRecoveryPassword,
                    repeatLabel: l10n.syncRecoveryPasswordRepeat,
                    fieldKey: const ValueKey('sync-recovery-password'),
                    repeatKey: const ValueKey('sync-recovery-password-repeat')),
              ),
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
        action: l10n.syncNewSpaceTitle);
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
                    showSnackMessage(context, l10n.syncRecoveryCodeCopied);
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

/// Opens nearby pairing and transfer; the same tile signed in or out.
class _NearbyTile extends StatelessWidget {
  const _NearbyTile();

  @override
  Widget build(BuildContext context) => ListTile(
      key: const ValueKey('nearby-migration-settings'),
      leading: const Icon(Icons.phonelink),
      title: Text(AppLocalizations.of(context)!.nearbyTitle),
      onTap: () => openPlace(context, 'settings/sync/nearby'));
}

/// Opens the authorized devices, once this device has a registration.
class _DevicesTile extends StatelessWidget {
  const _DevicesTile();

  @override
  Widget build(BuildContext context) =>
      DeviceAuthManager.instance.registrations.isEmpty
          ? const SizedBox.shrink()
          : ListTile(
              key: const ValueKey('sync-device-settings'),
              leading: const Icon(Icons.verified_user),
              title: Text(AppLocalizations.of(context)!.syncDevicesTitle),
              onTap: () => openPlace(context, 'settings/sync/devices'));
}
