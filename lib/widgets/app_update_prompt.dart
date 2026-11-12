// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';

import 'package:aid_diary/actions/settings_actions.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/services/app_updates.dart';
import 'package:aid_diary/widgets/snack_message.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';

/// Offers newer builds when the app opens (docs/UPDATES.md). It downloads
/// one in the background and, once the package is verified, asks with a
/// dialog or, with silent updates on, installs when the user leaves the
/// app. On a metered network it asks at once, and Update downloads. After
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
      showSnackMessage(context, l10n.updatedTo(installed.label),
          action: SnackBarAction(
              label: l10n.updateWhatsNew,
              onPressed: () => showUpdateNotes(context, installed)));
    }
    var update = await updates.due();
    if (update == null) {
      // A download an earlier run did not finish carries on and is offered
      // once verified; a verified one was offered when it finished.
      final pending = await updates.pending();
      if (pending == null || updates.downloadState.value?.ready == true) {
        return;
      }
      update = pending;
    }
    if (context.mounted) await _offer(context, update);
  }

  /// Downloads [update] in the background, then asks, or with silent
  /// updates on, installs when the user leaves the app.
  Future<void> _offer(BuildContext context, AppUpdate update) async {
    final updates = AppUpdates.instance;
    if (await updates.metered()) {
      if (context.mounted) await showUpdateDialog(context, update);
      return;
    }
    final file = await updates.prefetch(update);
    if (file == null) return;
    if (ConfigProvider.instance.get(Settings.silentUpdates) &&
        await updates.canInstallSilently()) {
      if (_ready == null) WidgetsBinding.instance.addObserver(this);
      _ready = (update: update, file: file);
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

/// What [update] changed, a line each, in the app's language.
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
              for (final note
                  in update.notesFor(Localizations.localeOf(context)))
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
    final state = updates.downloadState.value;
    setState(() {
      // Usually downloaded already; else the background download's
      // progress so far.
      _progress =
          state?.update.build == widget.update.build ? state!.progress : 0;
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
    } on Exception catch (error) {
      if (mounted) {
        setState(() {
          _progress = null;
          _message = l10n.updateFailed(
              error is UpdateException ? error.message : '$error');
        });
      }
    }
  }

  /// Skips this build and drops its package.
  Future<void> _skip() async {
    await changeSetting(Settings.skippedUpdate, widget.update.build);
    await AppUpdates.instance.discard();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final busy = _progress != null;
    return AlertDialog(
      key: const ValueKey('update-dialog'),
      // Room for the three buttons in one row on a phone.
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      title: Text(l10n.updateAvailable(widget.update.label)),
      content: SizedBox(
        width: 440,
        child: Column(
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
            const SizedBox(height: 20),
            // One row: skipping on its own at the start, the two answers
            // at the end. Skipping gives way first on a narrow screen.
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Flexible(
                child: TextButton(
                    onPressed: busy ? null : _skip,
                    child: Text(l10n.updateSkip,
                        maxLines: 1, overflow: TextOverflow.ellipsis)),
              ),
              Row(mainAxisSize: MainAxisSize.min, children: [
                TextButton(
                    onPressed: busy ? null : () => Navigator.pop(context),
                    child: Text(l10n.updateLater)),
                const SizedBox(width: 8),
                FilledButton(
                    key: const ValueKey('update-install'),
                    onPressed: busy ? null : _install,
                    child: Text(l10n.updateInstall)),
              ]),
            ]),
          ],
        ),
      ),
    );
  }
}
