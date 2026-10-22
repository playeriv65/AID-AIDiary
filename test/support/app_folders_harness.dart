// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' show join;

/// The folders of one test: what path_provider hands out, kept under a
/// temporary folder so a test never touches the real data folder.
class AppFolders {
  AppFolders._(this.root);

  final Directory root;

  Directory get temporary => Directory(join(root.path, 'temporary'));
  Directory get support => Directory(join(root.path, 'support'));

  /// A new empty folder for files the test makes itself.
  Directory folder(String name) =>
      Directory(join(root.path, name))..createSync(recursive: true);
}

/// Points path_provider at temporary folders for each test, and removes
/// them after. Call it in `main` once; read the folders from the result.
AppFolders Function() useTemporaryAppFolders() {
  late AppFolders folders;
  const channel = MethodChannel('plugins.flutter.io/path_provider');

  setUp(() async {
    folders = AppFolders._(
        await Directory.systemTemp.createTemp('aid_diary_folders'));
    folders.temporary.createSync();
    folders.support.createSync();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            channel,
            (call) async => switch (call.method) {
                  'getTemporaryDirectory' => folders.temporary.path,
                  'getApplicationSupportDirectory' => folders.support.path,
                  _ => null,
                });
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    await folders.root.delete(recursive: true);
  });

  return () => folders;
}
