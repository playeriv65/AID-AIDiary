// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:typed_data';

import 'package:aid_diary/storage/in_memory_file_store.dart';
import 'package:aid_diary/utils/imports/import_archive.dart';

/// Archive files held in memory, by path.
class MemoryArchive implements ArchiveFiles {
  MemoryArchive(this.files);

  final Map<String, Uint8List> files;

  /// The files of [stores], each under its folder ('' for the root).
  static Future<MemoryArchive> of(Map<String, InMemoryFileStore> stores) async {
    final files = <String, Uint8List>{};
    for (final MapEntry(key: folder, value: store) in stores.entries) {
      for (final name in await store.list()) {
        files[folder.isEmpty ? name : '$folder/$name'] =
            (await store.read(name))!;
      }
    }
    return MemoryArchive(files);
  }

  static Uint8List json(Object value) =>
      Uint8List.fromList(utf8.encode(jsonEncode(value)));

  @override
  List<String> get paths => files.keys.toList()..sort();

  @override
  Future<Uint8List?> read(String path) async => files[path];
}
