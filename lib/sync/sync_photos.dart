// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';
import 'dart:typed_data';

import 'package:aid_diary/storage/file_store.dart';

abstract interface class SyncPhotos {
  Future<bool> exists(String name);
  Future<Uint8List?> read(String name);
  Future<void> write(String name, Uint8List bytes);
  Future<void> delete(String name);
}

/// Optional streaming access, keeping large transfers out of the Dart heap.
abstract interface class SyncPhotoFiles {
  Future<File?> file(String name);
  Future<void> importFile(String name, File source);
}

class FileStorePhotos implements SyncPhotos {
  const FileStorePhotos(this.store);
  final FileStore store;
  @override
  Future<bool> exists(String name) => store.exists(name);
  @override
  Future<Uint8List?> read(String name) => store.read(name);
  @override
  Future<void> write(String name, Uint8List bytes) async {
    if (!await store.write(name, bytes)) {
      throw FileSystemException('Could not write the attachment', name);
    }
  }

  @override
  Future<void> delete(String name) => store.delete(name);
}
