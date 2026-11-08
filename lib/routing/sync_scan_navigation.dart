// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/routing/destination.dart';
import 'package:aid_diary/sync/pairing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// The one QR scanner of sync: a pairing code, a nearby invitation or a new
/// device's authorization request, each recognised by how it starts.
class SyncScanNavigation {
  static const kinds = ['pairing', 'nearby', 'device'];

  static Future<String?> open(BuildContext context, {required String kind}) {
    if (!kinds.contains(kind)) {
      throw const ActionException('bad_args', 'Unknown sync QR kind');
    }
    return Navigator.of(context).push<String>(MaterialPageRoute<String>(
        settings: routeFor('sync/scan'),
        builder: (_) => _SyncQrScanner(kind: kind)));
  }
}

final syncScanDestinations = [
  Destination(
      'sync/scan',
      'Scan a pairing code, a nearby invitation or a new device '
          'authorization request', (context, args) async {
    await SyncScanNavigation.open(context,
        kind: args['kind'] as String? ?? 'nearby');
  }, params: [
    ActionParam('kind', ParamType.string, SyncScanNavigation.kinds.join(', '),
        required: false)
  ]),
];

class _SyncQrScanner extends StatefulWidget {
  const _SyncQrScanner({required this.kind});
  final String kind;
  @override
  State<_SyncQrScanner> createState() => _SyncQrScannerState();
}

class _SyncQrScannerState extends State<_SyncQrScanner> {
  bool _done = false;

  bool _accepts(String qr) => switch (widget.kind) {
        'pairing' => PairingCode.isScanned(qr),
        'nearby' => qr.startsWith('aid-nearby://pair?'),
        _ => qr.startsWith('aid-device://authorize?'),
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
        appBar: AppBar(
            title: Text(switch (widget.kind) {
          'pairing' => l10n.syncPairTitle,
          'nearby' => l10n.nearbyScan,
          _ => l10n.syncDeviceAuthorize,
        })),
        body: MobileScanner(onDetect: (capture) {
          final qr = capture.barcodes.firstOrNull?.rawValue;
          if (_done || qr == null || !_accepts(qr)) return;
          _done = true;
          Navigator.pop(context, qr);
        }));
  }
}
