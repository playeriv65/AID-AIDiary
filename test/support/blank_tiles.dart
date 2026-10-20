// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';

import 'package:flutter_map/flutter_map.dart';
import 'package:material_ui/material_ui.dart';

/// Serves a 1x1 transparent tile, so map tests make no network calls and
/// never start flutter_map's disk cache (its worker isolate outlives a test).
class BlankTiles extends TileProvider {
  static final _png = base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR4nGNgYGBgAAAABQABpfZFQAAAAABJRU5ErkJggg==');

  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) =>
      MemoryImage(_png);
}
