// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:typed_data';

import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';

/// An entry with everything an export writes: its tags by name, whether it
/// is starred, and its images with their bytes.
class ExportedEntry {
  const ExportedEntry(this.entry,
      {this.tags = const [], this.favorite = false, this.images = const []});

  final Entry entry;
  final List<({String name, String? value})> tags;
  final bool favorite;
  final List<(EntryImage, Uint8List)> images;
}

/// Writes entries one by one into the folder that becomes an export zip.
abstract interface class ArchiveExportWriter {
  Future<void> write(ExportedEntry entry);

  /// Writes what can only be written once every entry is known.
  Future<void> close();
}
