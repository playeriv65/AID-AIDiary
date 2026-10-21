// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/sync/sync_backend.dart';
import 'package:aid_diary/sync/sync_crypto.dart';
import 'package:aid_diary/sync/sync_service.dart';
import 'package:aid_diary/sync/webdav_backend.dart';
import 'package:aid_diary/time_manager.dart';
import 'package:aid_diary/widgets/progress_dialog.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

/// Shortest passphrase accepted for a new or changed space key.
const int _minPassphraseLength = 8;

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
        WrongKeyException() => l10n.syncWrongKey,
        _ => l10n.syncConnectFailed('$error'),
      };

  /// Runs [task] behind a progress dialog and reports a failure; null then.
  Future<T?> _attempt<T>(Future<T> Function() task) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      return await runWithProgress(context, (update) => task());
    } catch (error) {
      if (mounted) _say(_describe(error, l10n));
      return null;
    }
  }

  Future<void> _connect() async {
    final server = Uri.tryParse(_server.text.trim());
    if (server == null || !server.hasScheme || server.host.isEmpty) return;
    final login = WebDavLogin(
        server: server,
        username: _username.text.trim(),
        password: _password.text);
    var probed = false;
    final space = await _attempt(() async {
      final space = await _service.probe(login);
      probed = true;
      return space;
    });
    if (!probed || !mounted) return;
    if (space == null) {
      await _startSpace(login);
    } else {
      await _joinSpace(login, space);
    }
  }

  Future<void> _startSpace(WebDavLogin login) async {
    final choice = await showDialog<({String? passphrase})>(
        context: context, builder: (_) => const _NewSpaceDialog());
    if (choice == null || !mounted) return;
    final recoveryKey = await _attempt(
        () => _service.createSpace(login, passphrase: choice.passphrase));
    if (recoveryKey != null && mounted) await _showRecoveryKey(recoveryKey);
  }

  Future<void> _joinSpace(WebDavLogin login, SpaceInfo space) async {
    final l10n = AppLocalizations.of(context)!;
    if (!space.encrypted) {
      final join = await _confirm(
          l10n.syncJoinTitle, l10n.syncJoinDescription, l10n.syncConnect);
      if (join && mounted) {
        await _attempt(() => _service.joinSpace(login, space));
      }
      return;
    }
    await _unlockWith((key) => _service.joinSpace(login, space,
        passphrase: key.passphrase, recoveryKey: key.recoveryKey));
  }

  /// Asks for the passphrase or recovery key until one opens the space.
  Future<void> _unlockWith(
      Future<void> Function(({String? passphrase, String? recoveryKey}) key)
          open) async {
    while (true) {
      if (!mounted) return;
      final key = await showDialog<({String? passphrase, String? recoveryKey})>(
          context: context, builder: (_) => const _UnlockDialog());
      if (key == null || !mounted) return;
      final l10n = AppLocalizations.of(context)!;
      try {
        await runWithProgress(context, (update) => open(key));
        return;
      } on WrongKeyException {
        if (mounted) _say(l10n.syncWrongKey);
      } catch (error) {
        if (mounted) _say(_describe(error, l10n));
        return;
      }
    }
  }

  Future<void> _showRecoveryKey(String recoveryKey) => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _RecoveryKeyDialog(recoveryKey));

  Future<bool> _confirm(String title, String description, String action,
      {bool destructive = false}) async {
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

  Future<void> _changePassphrase() async {
    final l10n = AppLocalizations.of(context)!;
    final passphrase = await showDialog<String>(
        context: context,
        builder: (_) => _PassphraseDialog(title: l10n.syncChangePassphrase));
    if (passphrase == null || !mounted) return;
    final done = await _attempt(
        () => _service.changePassphrase(passphrase).then((_) => true));
    if (done == true && mounted) _say(l10n.syncPassphraseChanged);
  }

  Future<void> _resetEncryption() async {
    final l10n = AppLocalizations.of(context)!;
    final reset = await _confirm(l10n.syncResetEncryption,
        l10n.syncResetEncryptionDescription, l10n.syncResetEncryption,
        destructive: true);
    if (!reset || !mounted) return;
    final passphrase = await showDialog<String>(
        context: context,
        builder: (_) => _PassphraseDialog(title: l10n.syncResetEncryption));
    if (passphrase == null || !mounted) return;
    final recoveryKey =
        await _attempt(() => _service.resetEncryption(passphrase));
    if (recoveryKey != null && mounted) await _showRecoveryKey(recoveryKey);
  }

  Future<void> _disconnect() async {
    final l10n = AppLocalizations.of(context)!;
    if (await _confirm(l10n.syncDisconnect, l10n.syncDisconnectDescription,
            l10n.syncDisconnect) &&
        mounted) {
      await _attempt(_service.disconnect);
    }
  }

  String _status(AppLocalizations l10n) {
    final last = _service.lastSync;
    return switch (_service.state) {
      SyncState.syncing => l10n.syncSyncing,
      SyncState.failed =>
        l10n.syncFailed(_describe(_service.error ?? '', l10n)),
      SyncState.locked => l10n.syncLocked,
      _ when last == null => l10n.syncNever,
      _ => l10n.syncLastSynced('${TimeManager.formatDate(last, context)} '
          '${TimeManager.timeOfDayString(context, TimeOfDay.fromDateTime(last))}'),
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
              return target == null ? _signIn(l10n) : _connected(l10n, target);
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
        Text(l10n.syncOffDescription),
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
        ListTile(
          leading: const Icon(Icons.cloud_done_rounded),
          title: Text(target.server.host),
          subtitle: Text('${target.username} · '
              '${target.encrypted ? l10n.syncEncrypted : l10n.syncNotEncrypted}'),
        ),
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
        ),
        const Divider(),
        if (locked)
          ListTile(
            leading: const Icon(Icons.lock_open_rounded),
            title: Text(l10n.syncUnlock),
            onTap: () => _unlockWith((key) => _service.unlock(
                passphrase: key.passphrase, recoveryKey: key.recoveryKey)),
          )
        else
          ListTile(
            key: const ValueKey('sync-now'),
            leading: const Icon(Icons.sync_rounded),
            title: Text(l10n.syncNow),
            enabled: !syncing,
            onTap: _service.syncNow,
          ),
        if (target.encrypted && !locked) ...[
          ListTile(
            leading: const Icon(Icons.password_rounded),
            title: Text(l10n.syncChangePassphrase),
            onTap: _changePassphrase,
          ),
          ListTile(
            leading: const Icon(Icons.restart_alt_rounded),
            title: Text(l10n.syncResetEncryption),
            onTap: _resetEncryption,
          ),
        ],
        ListTile(
          leading: const Icon(Icons.cloud_off_rounded),
          title: Text(l10n.syncDisconnect),
          onTap: _disconnect,
        ),
      ],
    );
  }
}

/// A new passphrase, typed twice.
class _PassphraseFields extends StatelessWidget {
  const _PassphraseFields(
      {required this.passphrase,
      required this.repeat,
      this.showErrors = false});

  final TextEditingController passphrase;
  final TextEditingController repeat;
  final bool showErrors;

  static String? problem(
          String passphrase, String repeat, AppLocalizations l10n) =>
      passphrase.length < _minPassphraseLength
          ? l10n.syncPassphraseTooShort
          : passphrase != repeat
              ? l10n.syncPassphraseMismatch
              : null;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final error =
        showErrors ? problem(passphrase.text, repeat.text, l10n) : null;
    return Column(mainAxisSize: MainAxisSize.min, children: [
      TextField(
        key: const ValueKey('sync-passphrase'),
        controller: passphrase,
        obscureText: true,
        autocorrect: false,
        decoration: InputDecoration(
            labelText: l10n.syncPassphrase, border: const OutlineInputBorder()),
      ),
      const SizedBox(height: 12),
      TextField(
        key: const ValueKey('sync-passphrase-repeat'),
        controller: repeat,
        obscureText: true,
        autocorrect: false,
        decoration: InputDecoration(
            labelText: l10n.syncPassphraseRepeat,
            errorText: error,
            border: const OutlineInputBorder()),
      ),
    ]);
  }
}

/// Starts a space, end-to-end encrypted unless turned off.
class _NewSpaceDialog extends StatefulWidget {
  const _NewSpaceDialog();

  @override
  State<_NewSpaceDialog> createState() => _NewSpaceDialogState();
}

class _NewSpaceDialogState extends State<_NewSpaceDialog> {
  final _passphrase = TextEditingController();
  final _repeat = TextEditingController();
  var _encrypt = true;
  var _showErrors = false;

  @override
  void dispose() {
    _passphrase.dispose();
    _repeat.dispose();
    super.dispose();
  }

  void _done() {
    final l10n = AppLocalizations.of(context)!;
    if (_encrypt &&
        _PassphraseFields.problem(_passphrase.text, _repeat.text, l10n) !=
            null) {
      setState(() => _showErrors = true);
      return;
    }
    Navigator.of(context).pop((passphrase: _encrypt ? _passphrase.text : null));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.syncNewSpaceTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.syncNewSpaceDescription),
            SwitchListTile(
              key: const ValueKey('sync-encrypt'),
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.syncEncrypt),
              subtitle: Text(l10n.syncEncryptDescription),
              value: _encrypt,
              onChanged: (value) => setState(() => _encrypt = value),
            ),
            if (_encrypt) ...[
              const SizedBox(height: 8),
              _PassphraseFields(
                  passphrase: _passphrase,
                  repeat: _repeat,
                  showErrors: _showErrors),
              const SizedBox(height: 12),
              Text(l10n.syncPassphraseNote,
                  style: Theme.of(context).textTheme.bodySmall),
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
            child: Text(l10n.syncConnect)),
      ],
    );
  }
}

/// A new passphrase for an existing space key.
class _PassphraseDialog extends StatefulWidget {
  const _PassphraseDialog({required this.title});

  final String title;

  @override
  State<_PassphraseDialog> createState() => _PassphraseDialogState();
}

class _PassphraseDialogState extends State<_PassphraseDialog> {
  final _passphrase = TextEditingController();
  final _repeat = TextEditingController();
  var _showErrors = false;

  @override
  void dispose() {
    _passphrase.dispose();
    _repeat.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(widget.title),
      content: _PassphraseFields(
          passphrase: _passphrase, repeat: _repeat, showErrors: _showErrors),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel)),
        FilledButton(
            onPressed: () {
              if (_PassphraseFields.problem(
                      _passphrase.text, _repeat.text, l10n) !=
                  null) {
                setState(() => _showErrors = true);
                return;
              }
              Navigator.of(context).pop(_passphrase.text);
            },
            child: Text(MaterialLocalizations.of(context).okButtonLabel)),
      ],
    );
  }
}

/// The passphrase, or the recovery key, of an encrypted space.
class _UnlockDialog extends StatefulWidget {
  const _UnlockDialog();

  @override
  State<_UnlockDialog> createState() => _UnlockDialogState();
}

class _UnlockDialogState extends State<_UnlockDialog> {
  final _key = TextEditingController();
  var _recovery = false;

  @override
  void dispose() {
    _key.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.syncJoinTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.syncJoinEncrypted),
          const SizedBox(height: 16),
          TextField(
            key: const ValueKey('sync-unlock'),
            controller: _key,
            obscureText: !_recovery,
            autocorrect: false,
            decoration: InputDecoration(
                labelText:
                    _recovery ? l10n.syncRecoveryKey : l10n.syncPassphrase,
                border: const OutlineInputBorder()),
          ),
          TextButton(
            onPressed: () => setState(() {
              _recovery = !_recovery;
              _key.clear();
            }),
            child: Text(
                _recovery ? l10n.syncUsePassphrase : l10n.syncUseRecoveryKey),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel)),
        FilledButton(
            key: const ValueKey('sync-unlock-confirm'),
            onPressed: () => Navigator.of(context).pop((
                  passphrase: _recovery ? null : _key.text,
                  recoveryKey: _recovery ? _key.text : null,
                )),
            child: Text(l10n.syncUnlock)),
      ],
    );
  }
}

/// Shows the recovery key once; it closes only after the user says it is
/// kept.
class _RecoveryKeyDialog extends StatefulWidget {
  const _RecoveryKeyDialog(this.recoveryKey);

  final String recoveryKey;

  @override
  State<_RecoveryKeyDialog> createState() => _RecoveryKeyDialogState();
}

class _RecoveryKeyDialogState extends State<_RecoveryKeyDialog> {
  var _saved = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: Text(l10n.syncRecoveryKeyTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.syncRecoveryKeyDescription),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SelectableText(widget.recoveryKey,
                  key: const ValueKey('sync-recovery-key'),
                  style: const TextStyle(
                      fontFamily: 'monospace', fontSize: 16, height: 1.5)),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: const Icon(Icons.copy_rounded),
                label: Text(MaterialLocalizations.of(context).copyButtonLabel),
                onPressed: () async {
                  await Clipboard.setData(
                      ClipboardData(text: widget.recoveryKey));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.syncRecoveryKeyCopied)));
                  }
                },
              ),
            ),
            CheckboxListTile(
              key: const ValueKey('sync-recovery-saved'),
              contentPadding: EdgeInsets.zero,
              value: _saved,
              title: Text(l10n.syncRecoveryKeySaved),
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
