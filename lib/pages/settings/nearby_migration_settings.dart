// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'dart:io';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/sync/nearby_service.dart';
import 'package:aid_diary/widgets/device_name_tile.dart';
import 'package:aid_diary/widgets/qr_code_box.dart';
import 'package:aid_diary/widgets/text_input_dialog.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:aid_diary/routing/sync_scan_navigation.dart';

/// User-assisted Wi-Fi/hotspot setup works across platforms without promising
/// an unattended Wi-Fi Direct capability that the platform does not provide.
class NearbyMigrationSettings extends StatefulWidget {
  const NearbyMigrationSettings({super.key});
  @override
  State<NearbyMigrationSettings> createState() =>
      _NearbyMigrationSettingsState();
}

class _NearbyMigrationSettingsState extends State<NearbyMigrationSettings> {
  final _service = NearbyService.instance;

  @override
  void dispose() {
    unawaited(_service.cancel(retainCompletion: true));
    super.dispose();
  }

  Future<void> _run(String action,
      [Map<String, Object?> args = const {}]) async {
    try {
      await AppActions.instance.run(action, args, confirmed: true);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!.nearbyFailed)));
      }
    }
  }

  /// Takes the existing device's invitation, pasted or scanned, and
  /// connects to that device.
  Future<void> _receive() async {
    final l10n = AppLocalizations.of(context)!;
    final invitation = await showTextInputDialog(context,
        title: l10n.nearbyReceive,
        confirm: l10n.nearbyReceive,
        label: l10n.nearbyPaste,
        maxLines: 3,
        plain: true,
        scan: Platform.isAndroid || Platform.isIOS
            ? (context) => SyncScanNavigation.open(context, kind: 'nearby')
            : null,
        fieldKey: const ValueKey('nearby-invitation'),
        confirmKey: const ValueKey('nearby-accept'));
    if (invitation != null && mounted) {
      await _run('sync.nearby_accept', {'invitation': invitation});
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
        appBar: AppBar(title: Text(l10n.nearbyTitle)),
        body: ListenableBuilder(
            listenable: _service,
            builder: (context, _) {
              final state = _service.state;
              final busy = state == NearbyState.preparing ||
                  state == NearbyState.transferring ||
                  state == NearbyState.waiting;
              return Center(
                  child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 680),
                      child: ListView(
                          padding: const EdgeInsets.all(24),
                          children: [
                            if (!busy && state != NearbyState.complete)
                              const DeviceNameTile(),
                            Text(l10n.nearbyInstructions),
                            const SizedBox(height: 16),
                            if (state != NearbyState.complete)
                              ExpansionTile(
                                  key: ValueKey(
                                      'nearby-help-${state == NearbyState.failed}'),
                                  initiallyExpanded:
                                      state == NearbyState.failed,
                                  title: Text(l10n.nearbyConnectionHelp),
                                  children: [
                                    Wrap(spacing: 8, runSpacing: 8, children: [
                                      OutlinedButton.icon(
                                          onPressed: () =>
                                              _run('sync.nearby_wifi'),
                                          icon: const Icon(Icons.wifi),
                                          label: Text(l10n.nearbyWifi)),
                                      OutlinedButton.icon(
                                          onPressed: () =>
                                              _run('sync.nearby_hotspot'),
                                          icon:
                                              const Icon(Icons.wifi_tethering),
                                          label: Text(l10n.nearbyHotspot)),
                                    ]),
                                  ]),
                            const SizedBox(height: 24),
                            if (state == NearbyState.idle ||
                                state == NearbyState.failed ||
                                state == NearbyState.complete) ...[
                              FilledButton.icon(
                                  key: const ValueKey('nearby-send'),
                                  onPressed: busy
                                      ? null
                                      : () => _run('sync.nearby_offer'),
                                  icon: const Icon(Icons.qr_code),
                                  label: Text(l10n.nearbySend)),
                              const SizedBox(height: 8),
                              OutlinedButton.icon(
                                  key: const ValueKey('nearby-receive'),
                                  onPressed: busy ? null : _receive,
                                  icon: const Icon(Icons.move_to_inbox),
                                  label: Text(l10n.nearbyReceive)),
                            ],
                            if (_service.invitation case final invitation?) ...[
                              const SizedBox(height: 24),
                              QrCodeBox(invitation.qr),
                              const SizedBox(height: 8),
                              Text(l10n.nearbyKeepOpen),
                              TextButton.icon(
                                  onPressed: () => Clipboard.setData(
                                      ClipboardData(text: invitation.qr)),
                                  icon: const Icon(Icons.copy),
                                  label: Text(MaterialLocalizations.of(context)
                                      .copyButtonLabel)),
                            ],
                            if (_service.sas case final sas?) ...[
                              const SizedBox(height: 24),
                              Text(l10n.nearbyCompare),
                              const SizedBox(height: 8),
                              Center(
                                  child: Text(sas,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall,
                                      key: const ValueKey('nearby-sas'))),
                              const SizedBox(height: 12),
                              if (state == NearbyState.comparing)
                                FilledButton(
                                    onPressed: () => _run('sync.nearby_confirm',
                                        {'sas': _service.sas}),
                                    key: const ValueKey('nearby-confirm'),
                                    child: Text(l10n.nearbyConfirm)),
                            ],
                            if (busy) ...[
                              const SizedBox(height: 20),
                              const LinearProgressIndicator(),
                              const SizedBox(height: 12),
                              Text(state == NearbyState.waiting
                                  ? l10n.nearbyWaiting
                                  : l10n.nearbyWorking)
                            ],
                            if (state == NearbyState.complete) ...[
                              Text(l10n.nearbyComplete),
                              const SizedBox(height: 16),
                              FilledButton(
                                  key: const ValueKey('nearby-done'),
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text(MaterialLocalizations.of(context)
                                      .closeButtonLabel)),
                            ],
                            if (state == NearbyState.pending)
                              Text(l10n.nearbyPending),
                            if (state == NearbyState.failed)
                              Text(_service.destinationNotEmpty
                                  ? l10n.nearbyEmptyRequired
                                  : l10n.nearbyFailed),
                            if (!busy && _service.canResume)
                              Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: FilledButton.icon(
                                      onPressed: () =>
                                          _run('sync.nearby_resume'),
                                      icon: const Icon(Icons.sync),
                                      label: Text(l10n.nearbyRetry))),
                            if (state != NearbyState.idle &&
                                state != NearbyState.complete)
                              Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: TextButton(
                                      onPressed: () =>
                                          _run('sync.nearby_cancel'),
                                      child: Text(
                                          MaterialLocalizations.of(context)
                                              .cancelButtonLabel))),
                          ])));
            }));
  }
}
