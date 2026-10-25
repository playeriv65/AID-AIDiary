// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';
import 'dart:convert';
import 'package:aid_diary/widgets/confirm_dialog.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/sync/device_auth.dart';
import 'package:aid_diary/sync/local_device.dart';
import 'package:aid_diary/widgets/device_name_tile.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:aid_diary/routing/sync_scan_navigation.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SyncDeviceSettings extends StatefulWidget {
  const SyncDeviceSettings({super.key});
  @override
  State<SyncDeviceSettings> createState() => _SyncDeviceSettingsState();
}

class _SyncDeviceSettingsState extends State<SyncDeviceSettings> {
  final _manager = DeviceAuthManager.instance;
  DeviceRegistration? _selected;
  List<Map<String, dynamic>> _devices = [];
  Map<String, String> _names = {};
  String? _request;
  bool _busy = false, _failed = false;
  @override
  void initState() {
    super.initState();
    _selected = _manager.registrations.firstOrNull;
    if (_selected != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _load());
    }
  }

  Map<String, Object?> get _accountArgs =>
      {'server': _selected!.server.toString(), 'username': _selected!.username};
  Future<void> _load() async {
    if (_busy || _selected == null) return;
    setState(() {
      _busy = true;
      _failed = false;
      _devices = [];
      _request = null;
    });
    try {
      final result = await AppActions.instance
          .run('sync.devices_check', _accountArgs, confirmed: true) as Map;
      var copies = <Object?, Object?>{};
      try {
        copies = (await AppActions.instance.run('sync.copies', {})) as Map;
      } catch (_) {
        // A missing optional copy receipt must not block account management.
      }
      if (mounted) {
        setState(() {
          _devices =
              ((result['devices'] as List?) ?? []).cast<Map<String, dynamic>>();
          _request = result['request'] as String?;
          _names = {
            for (final copy in copies['devices'] as List? ?? const [])
              if (copy is Map && copy['id'] is String && copy['name'] is String)
                copy['id'] as String: copy['name'] as String
          };
        });
      }
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<bool> _confirm(String title, String body) async =>
      showConfirmDialog(context,
          title: title,
          message: body,
          confirm: MaterialLocalizations.of(context).okButtonLabel);
  Future<void> _run(String action,
      [Map<String, Object?> args = const {}]) async {
    setState(() => _busy = true);
    try {
      await AppActions.instance
          .run(action, {..._accountArgs, ...args}, confirmed: true);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(AppLocalizations.of(context)!.syncDeviceUnavailable)));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
    if (mounted) await _load();
  }

  Future<void> _authorize() async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    final result = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
                title: Text(l10n.syncDeviceAuthorize),
                content: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        labelText: l10n.syncDeviceAuthorizeDescription),
                    maxLines: 3,
                    autocorrect: false,
                    enableSuggestions: false),
                actions: [
                  if (Platform.isAndroid || Platform.isIOS)
                    TextButton(
                        onPressed: () async {
                          final scanned = await SyncScanNavigation.open(context,
                              kind: 'device');
                          if (scanned != null && context.mounted) {
                            Navigator.pop(context, scanned);
                          }
                        },
                        child: const Icon(Icons.qr_code_scanner)),
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                          MaterialLocalizations.of(context).cancelButtonLabel)),
                  FilledButton(
                      onPressed: () =>
                          Navigator.pop(context, controller.text.trim()),
                      child: Text(l10n.syncDeviceAuthorize)),
                ]));
    controller.dispose();
    if (result == null || !mounted) return;
    try {
      final uri = Uri.parse(result);
      final request = jsonDecode(
              utf8.decode(base64Url.decode(uri.queryParameters['request']!)))
          as Map;
      final spki = request['publicKeySpki'] as String;
      final candidate = DeviceRegistration(
          server: Uri.parse(request['server'] as String),
          username: request['username'] as String,
          id: request['id'] as String,
          alias: '',
          publicKeySpki: spki,
          hardwareBacked: false,
          provider: '');
      if (await _confirm(l10n.syncDeviceAuthorize,
          '${l10n.nearbyCompare}\n\n${candidate.fingerprint}')) {
        await _run('sync.devices_authorize', {'request': result});
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.syncDeviceUnavailable)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final records = _manager.registrations;
    final selected = _selected == null
        ? null
        : _manager.registration(_selected!.server, _selected!.username);
    return Scaffold(
        appBar: AppBar(title: Text(l10n.syncDevicesTitle)),
        body: Center(
            child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: ListView(padding: const EdgeInsets.all(24), children: [
                  DeviceNameTile(onChanged: () => setState(() {})),
                  if (records.isEmpty)
                    Text(l10n.syncDeviceUnavailable)
                  else ...[
                    if (records.length > 1)
                      DropdownButtonFormField<String>(
                          initialValue: selected?.alias,
                          items: [
                            for (final r in records)
                              DropdownMenuItem(
                                  value: r.alias,
                                  child:
                                      Text('${r.username} · ${r.server.host}'))
                          ],
                          onChanged: _busy
                              ? null
                              : (alias) {
                                  setState(() => _selected = records
                                      .firstWhere((r) => r.alias == alias));
                                  _load();
                                }),
                    const SizedBox(height: 12),
                    if (selected != null)
                      ExpansionTile(
                          title: Text(l10n.syncDeviceKeyDetails),
                          children: [
                            Text(l10n.syncDevicesDescription),
                            Text(selected.hardwareBacked
                                ? l10n.syncDeviceHardware
                                : l10n.syncDeviceSoftware),
                            const SizedBox(height: 8),
                            SelectableText(selected.fingerprint),
                            OutlinedButton.icon(
                                onPressed: _busy
                                    ? null
                                    : () => _run('sync.devices_rotate'),
                                icon: const Icon(Icons.key),
                                label: Text(l10n.syncDeviceRotate)),
                          ]),
                    const SizedBox(height: 16),
                    if (_busy) const LinearProgressIndicator(),
                    OutlinedButton.icon(
                        onPressed: _busy ? null : _load,
                        icon: const Icon(Icons.refresh),
                        label: Text(l10n.syncDeviceCheck)),
                    if (_failed) Text(l10n.syncDeviceUnavailable),
                    if (_request case final request?) ...[
                      const SizedBox(height: 16),
                      Text(l10n.syncDeviceRequest),
                      Center(
                          child: Container(
                              color: Colors.white,
                              padding: const EdgeInsets.all(12),
                              child: QrImageView(data: request, size: 300))),
                      TextButton.icon(
                          onPressed: () =>
                              Clipboard.setData(ClipboardData(text: request)),
                          icon: const Icon(Icons.copy),
                          label: Text(MaterialLocalizations.of(context)
                              .copyButtonLabel)),
                    ] else if (_devices.isNotEmpty) ...[
                      FilledButton.icon(
                          onPressed: _busy ? null : _authorize,
                          icon: const Icon(Icons.add_moderator),
                          label: Text(l10n.syncDeviceAuthorize)),
                      for (final device in _devices)
                        ExpansionTile(
                            title: Text(device['id'] == selected?.id
                                ? LocalDevice.name
                                : _names[device['id']] ?? '${device['label']}'),
                            subtitle: Text(
                                '${device['id'] == selected?.id ? l10n.syncDeviceLocal : ''}${device['revoked'] == true ? l10n.syncDeviceRevoked : ''}'),
                            children: [
                              SelectableText('${device['fingerprint']}'),
                              if (device['revoked'] != true)
                                TextButton(
                                    onPressed: _busy
                                        ? null
                                        : () async {
                                            if (await _confirm(
                                                l10n.syncDeviceRevoke,
                                                l10n.syncDevicesDescription)) {
                                              await _run(
                                                  'sync.devices_revoke', {
                                                'device': device['id'] as String
                                              });
                                            }
                                          },
                                    child: Text(l10n.syncDeviceRevoke))
                            ]),
                      const SizedBox(height: 12),
                    ],
                  ],
                ]))));
  }
}
