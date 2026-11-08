// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['widget'])
library;

import 'package:aid_diary/pages/settings/storage_settings.dart';
import 'package:aid_diary/widgets/failure_dialog.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();
  const folders = MethodChannel('plugins.flutter.io/path_provider');

  tearDown(() => TestDefaultBinaryMessengerBinding
      .instance.defaultBinaryMessenger
      .setMockMethodCallHandler(folders, null));

  testWidgets('a storage action that fails tells the user', (tester) async {
    // The photo folder cannot be read, so counting the photos fails.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            folders,
            (call) async =>
                throw PlatformException(code: 'unavailable', message: 'no'));
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const StorageSettings()));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('settings-compress-existing')));
    await tester.pumpAndSettle();

    expect(find.byType(FailureDialog), findsOneWidget);
    expect(
        find.descendant(
            of: find.byType(FailureDialog), matching: find.text('压缩已有照片')),
        findsOneWidget);
  });
}
