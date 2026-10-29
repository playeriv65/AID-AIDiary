// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';

import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/services/app_updates.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';

/// Offers newer builds when the app opens (docs/UPDATES.md): a dialog, or
/// with silent updates on, an install when the user leaves the app. After
/// an update it says so once.
class AppUpdatePrompt with WidgetsBindingObserver {
  AppUpdatePrompt._();

  static final instance = AppUpdatePrompt._();
  static final _logger = Logger('AppUpdatePrompt');

  ({AppUpdate update, File file})? _ready;

  /// Runs once the shell is on screen.
  Future<void> start(BuildContext context) async {
    final updates = AppUpdates.instance;
    final installed = await updates.justInstalled();
    if (installed != null && context.mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(l10n.updatedTo(installed.label)),
        action: SnackBarAction(
            label: l10n.updateWhatsNew,
            onPressed: () => showUpdateNotes(context, installed)),
      ));
    }
    final update = await updates.due();
    if (update == null || !context.mounted) return;
    if (ConfigProvider.instance.get(Settings.silentUpdates) &&
        await updates.canInstallSilently()) {
      try {
        _ready = (update: update, file: await updates.download(update));
        WidgetsBinding.instance.addObserver(this);
      } catch (error, stackTrace) {
        _logger.info('Background update download failed', error, stackTrace);
      }
      return;
    }
    if (context.mounted) await showUpdateDialog(context, update);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final ready = _ready;
    if (state != AppLifecycleState.paused || ready == null) return;
    _ready = null;
    WidgetsBinding.instance.removeObserver(this);
    AppUpdates.instance
        .install(ready.update, ready.file)
        .catchError((Object error, StackTrace stackTrace) {
      _logger.warning('Silent update failed', error, stackTrace);
      return UpdateInstall.started;
    });
  }
}

/// What [update] changed, one commit a line.
Future<void> showUpdateNotes(BuildContext context, AppUpdate update) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(update.label),
        content: _Notes(update),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(MaterialLocalizations.of(context).closeButtonLabel)),
        ],
      ),
    );

/// Asks whether to install [update], then downloads and installs it.
Future<void> showUpdateDialog(BuildContext context, AppUpdate update) =>
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _UpdateDialog(update),
    );

class _Notes extends StatelessWidget {
  const _Notes(this.update);

  final AppUpdate update;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 280),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final note in update.notes)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('• $note'),
                ),
            ],
          ),
        ),
      );
}

class _UpdateDialog extends StatefulWidget {
  const _UpdateDialog(this.update);

  final AppUpdate update;

  @override
  State<_UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<_UpdateDialog> {
  double? _progress;
  String? _message;

  Future<void> _install() async {
    final l10n = AppLocalizations.of(context)!;
    final updates = AppUpdates.instance;
    setState(() {
      _progress = 0;
      _message = null;
    });
    try {
      final file = await updates.download(widget.update, progress: (done) {
        if (mounted) setState(() => _progress = done);
      });
      final outcome = await updates.install(widget.update, file);
      if (!mounted) return;
      if (outcome == UpdateInstall.needsPermission) {
        setState(() {
          _progress = null;
          _message = l10n.updateAllowInstall;
        });
      } else {
        Navigator.pop(context);
      }
    } on UpdateException catch (error) {
      if (mounted) {
        setState(() {
          _progress = null;
          _message = l10n.updateFailed(error.message);
        });
      }
    }
  }

  Future<void> _skip() async {
    await ConfigProvider.instance
        .set(Settings.skippedUpdate, widget.update.build);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final busy = _progress != null;
    return AlertDialog(
      key: const ValueKey('update-dialog'),
      title: Text(l10n.updateAvailable(widget.update.label)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(child: _Notes(widget.update)),
          const SizedBox(height: 12),
          if (busy) ...[
            LinearProgressIndicator(value: _progress),
            const SizedBox(height: 8),
            Text(l10n.updateDownloading((_progress! * 100).round())),
          ] else
            Text(_message ?? l10n.updateClosesNote,
                style: _message == null
                    ? theme.textTheme.bodySmall
                    : theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.error)),
        ],
      ),
      actions: [
        TextButton(
            onPressed: busy ? null : _skip, child: Text(l10n.updateSkip)),
        TextButton(
            onPressed: busy ? null : () => Navigator.pop(context),
            child: Text(l10n.updateLater)),
        FilledButton(
            key: const ValueKey('update-install'),
            onPressed: busy ? null : _install,
            child: Text(l10n.updateInstall)),
      ],
    );
  }
}
