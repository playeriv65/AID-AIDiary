// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/routing/destination.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class SyncScanNavigation {
  static Future<String?> open(BuildContext context, {required String kind}) {
    if (kind != 'nearby' && kind != 'device') {
      throw const ActionException('bad_args', 'Unknown sync QR kind');
    }
    return Navigator.of(context).push<String>(MaterialPageRoute<String>(
        settings: routeFor('sync/scan'),
        builder: (_) => _SyncQrScanner(kind: kind)));
  }
}

final syncScanDestinations = [
  Destination('sync/scan',
      'Scan a nearby invitation or a new-device public authorization request',
      (context, args) async {
    await SyncScanNavigation.open(context,
        kind: args['kind'] as String? ?? 'nearby');
  }, params: const [
    ActionParam('kind', ParamType.string, 'nearby or device', required: false)
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
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.kind == 'nearby'
                ? l10n.nearbyScan
                : l10n.syncDeviceAuthorize)),
        body: MobileScanner(onDetect: (capture) {
          final qr = capture.barcodes.firstOrNull?.rawValue;
          final prefix = widget.kind == 'nearby'
              ? 'aid-nearby://pair?'
              : 'aid-device://authorize?';
          if (_done || qr == null || !qr.startsWith(prefix)) return;
          _done = true;
          Navigator.pop(context, qr);
        }));
  }
}
