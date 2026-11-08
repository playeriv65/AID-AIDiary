// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:material_ui/material_ui.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// A QR code for another device to scan, the same everywhere: centred,
/// dark on a white margin so cameras read it in a dark theme too.
class QrCodeBox extends StatelessWidget {
  const QrCodeBox(this.data, {super.key});

  final String data;

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(12),
          child: QrImageView(data: data, size: 240),
        ),
      );
}
