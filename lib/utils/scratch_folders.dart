// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';

import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

/// The folder a development build keeps everything in when started with
/// `AID_DATA_DIR` set: the database, pictures, settings and the agent
/// API's port and token. A tool run such as the frame-rate check on a
/// computer so leaves the diary there alone. Null in a normal start.
String? scratchFolder;

/// Moves every app folder into `AID_DATA_DIR`, when set; call before
/// anything opens a file.
void useScratchFolders() {
  final folder = Platform.environment['AID_DATA_DIR'];
  if (folder == null || folder.isEmpty) return;
  Directory(folder).createSync(recursive: true);
  scratchFolder = folder;
  PathProviderPlatform.instance = _ScratchFolders(folder);
}

class _ScratchFolders extends PathProviderPlatform {
  _ScratchFolders(this.root);

  final String root;

  @override
  Future<String?> getApplicationSupportPath() async => root;
  @override
  Future<String?> getApplicationDocumentsPath() async => root;
  @override
  Future<String?> getApplicationCachePath() async => root;
  @override
  Future<String?> getTemporaryPath() async => root;
  @override
  Future<String?> getDownloadsPath() async => root;
}
