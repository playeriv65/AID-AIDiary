// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/sync/device_auth.dart';
import 'package:aid_diary/sync/nearby_service.dart';
import 'package:aid_diary/sync/local_device.dart';
import 'package:aid_diary/sync/sync_service.dart';
import 'package:aid_diary/utils/scratch_folders.dart';

const _server = ActionParam('server', ParamType.string, 'AID WebDAV base URL');
const _username = ActionParam('username', ParamType.string, 'AID account name');
DeviceAuthManager get _devices => DeviceAuthManager.instance;
NearbyService get _nearby => NearbyService.instance;
DeviceAuthSession _session(ActionArgs args) {
  final result = _devices.session(
      Uri.parse(args['server'] as String), args['username'] as String);
  if (result == null) {
    throw const ActionException(
        'not_configured', 'Sign in to this AID account first');
  }
  return result;
}

Map<String, Object?> nearbyStatus() => {
      'state': _nearby.state.name,
      'sending': _nearby.sending,
      'canResume': _nearby.canResume,
      'destinationNotEmpty': _nearby.destinationNotEmpty,
      if (_nearby.sas case final sas?) 'sas': sas,
      if (_nearby.invitation case final invite?) 'invitation': invite.qr,
      if (_nearby.report case final report?)
        'report': {
          'received': report.received,
          'mediaCompleted': report.mediaCompleted,
          'pendingMedia': report.pendingMedia,
          'mediaFailures': report.mediaFailures
        },
    };

final List<AppAction> deviceSyncActions = [
  AppAction(
      id: 'sync.device_name',
      describe:
          'Reads this device name or saves a local label for pairing and copy details.',
      params: const [
        ActionParam(
            'name', ParamType.string, 'A device label of 1 to 32 characters',
            required: false)
      ],
      risk: ActionRisk.write,
      run: (_, args) async {
        if (args['name'] case final String name) {
          if (!LocalDevice.validName(name)) {
            throw const ActionException('bad_args',
                'Use 1 to 32 characters without control characters');
          }
          await SyncService.instance.renameDevice(name);
        }
        return {'name': LocalDevice.name};
      }),
  AppAction(
      id: 'sync.copies',
      describe:
          'Reads named device copies and last confirmations; temporary storage is never a backup.',
      risk: ActionRisk.read,
      run: (_, args) => SyncService.instance.copyStatus()),
  AppAction(
      id: 'sync.devices_test_cleanup',
      describe:
          'Deletes native signing keys belonging to this isolated test workspace.',
      devOnly: true,
      risk: ActionRisk.destructive,
      run: (_, args) async {
        if (scratchFolder == null) {
          throw const ActionException(
              'not_isolated', 'An isolated development workspace is required');
        }
        await _nearby.cancel();
        await SyncService.instance.disconnect();
        final aliases = <String>{
          for (final record in _devices.registrations) ...[
            record.alias,
            if (record.next case final next?) next.alias,
          ],
        };
        for (final alias in aliases) {
          await _devices.keys.delete(alias);
        }
        await ConfigProvider.instance.set(Settings.deviceAuthorizations, '');
        await ConfigProvider.instance.set(Settings.pendingDeviceApprovals, '');
        await ConfigProvider.instance.flushConfig();
        return {'deleted': aliases.length};
      }),
  AppAction(
      id: 'sync.nearby_status',
      describe:
          'Reads the foreground nearby transfer status and public invitation; never returns MK or transfer keys.',
      risk: ActionRisk.read,
      run: (_, args) async => nearbyStatus()),
  AppAction(
      id: 'sync.nearby_offer',
      describe:
          'Prepares an encrypted read-only snapshot and a short-lived public QR on the old device.',
      risk: ActionRisk.write,
      run: (_, args) async {
        await _nearby.offer();
        return nearbyStatus();
      }),
  AppAction(
      id: 'sync.nearby_accept',
      describe:
          'Pins a scanned old-device public key and displays the comparison code. Does not adopt identity.',
      params: const [
        ActionParam(
            'invitation', ParamType.string, 'The public aid-nearby QR URI')
      ],
      risk: ActionRisk.write,
      run: (_, args) async {
        await _nearby.accept(args['invitation'] as String);
        return nearbyStatus();
      }),
  AppAction(
      id: 'sync.nearby_confirm',
      describe:
          'Confirms the code personally compared on both devices, then automatically transfers authorized diary/media data.',
      params: const [
        ActionParam('sas', ParamType.string,
            'The matching six-digit code displayed on both devices')
      ],
      risk: ActionRisk.write,
      run: (_, args) async {
        if (args['sas'] != _nearby.sas) {
          throw const ActionException(
              'code_mismatch', 'Compare the code on both devices first');
        }
        await _nearby.confirm();
        return nearbyStatus();
      }),
  AppAction(
      id: 'sync.nearby_resume',
      describe:
          'Resumes missing encrypted chunks from an already authorized nearby session.',
      risk: ActionRisk.write,
      run: (_, args) async {
        await _nearby.resume();
        return nearbyStatus();
      }),
  AppAction(
      id: 'sync.nearby_cancel',
      describe:
          'Stops nearby listeners and transfer work; retains received data and an authorized resume capability.',
      risk: ActionRisk.write,
      run: (_, args) async {
        await _nearby.cancel();
        return nearbyStatus();
      }),
  AppAction(
      id: 'sync.nearby_wifi',
      describe:
          'Opens operating-system Wi-Fi settings for user-assisted nearby connection.',
      risk: ActionRisk.write,
      run: (_, args) async {
        await _nearby.openWifiSettings();
        return {'opened': true};
      }),
  AppAction(
      id: 'sync.nearby_hotspot',
      describe:
          'Opens operating-system hotspot settings for user-assisted nearby connection.',
      risk: ActionRisk.write,
      run: (_, args) async {
        await _nearby.openHotspotSettings();
        return {'opened': true};
      }),
  AppAction(
      id: 'sync.devices_accounts',
      describe:
          'Lists local device registration metadata without private aliases, credentials or tokens.',
      risk: ActionRisk.read,
      run: (_, args) async => {
            'accounts': [
              for (final r in _devices.registrations)
                {
                  'server': r.server.toString(),
                  'username': r.username,
                  'device': r.id,
                  'fingerprint': r.fingerprint,
                  'hardwareBacked': r.hardwareBacked,
                  'provider': r.provider
                }
            ]
          }),
  AppAction(
      id: 'sync.devices_check',
      describe:
          'Authenticates with the native signing key and lists devices, or returns a public authorization QR for another device to approve.',
      params: const [_server, _username],
      risk: ActionRisk.write,
      run: (_, args) async {
        final current = _session(args);
        try {
          await _devices.prepare(
              current.registration.server, current.registration.username, '');
          return {'devices': await _devices.devices(_session(args))};
        } on DeviceAuthorizationNeeded {
          return {
            'request': await _devices.authorizationRequest(
                current.registration.server, current.registration.username)
          };
        }
      }),
  AppAction(
      id: 'sync.devices_authorize',
      describe:
          'Authorizes the new device key scanned and compared on this already-authorized device. Transfers no private signing key.',
      params: const [
        _server,
        _username,
        ActionParam(
            'request', ParamType.string, 'The new device authorization QR URI')
      ],
      risk: ActionRisk.write,
      run: (_, args) async {
        await _devices.authorize(_session(args), args['request'] as String);
        return {'authorized': true};
      }),
  AppAction(
      id: 'sync.devices_revoke',
      describe:
          'Revokes one device and its server tokens. Cannot erase MK or diary data already copied to that device.',
      params: const [
        _server,
        _username,
        ActionParam('device', ParamType.string, 'Device id to revoke')
      ],
      risk: ActionRisk.destructive,
      run: (_, args) async {
        await _devices.revoke(_session(args), args['device'] as String);
        return {'revoked': true};
      }),
  AppAction(
      id: 'sync.devices_rotate',
      describe:
          'Rotates this device’s native non-exportable signing key and invalidates old tokens; does not rotate shared MK.',
      params: const [_server, _username],
      risk: ActionRisk.write,
      run: (_, args) async {
        await _devices.rotate(_session(args));
        return {'rotated': true};
      }),
];
