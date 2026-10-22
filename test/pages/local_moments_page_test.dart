// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['widget'])
library;

import 'package:aid_diary/pages/local_moments_page.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();
  testWidgets(
      'opening photo moments never scans or requests access automatically',
      (tester) async {
    DiaryAppHarness.size(tester, const Size(360, 800));
    final calls = <MethodCall>[];
    const channel = MethodChannel('aid.local_photos');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return [];
    });
    addTearDown(() => TestDefaultBinaryMessengerBinding
        .instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null));
    await tester.pumpWidget(harness.app(const LocalMomentsPage()));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('moments-scan')), findsOneWidget);
    expect(calls, isEmpty);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets('unavailable selected photo folder shows a recoverable error',
      (tester) async {
    DiaryAppHarness.size(tester, const Size(360, 800));
    await DiaryAppHarness.setSetting(
        Settings.localPhotoFolder, 'missing-photo-folder-for-widget-test');
    await tester.pumpWidget(harness.app(const LocalMomentsPage()));
    await tester.pumpAndSettle();
    final l10n =
        AppLocalizations.of(tester.element(find.byType(LocalMomentsPage)))!;
    await tester.tap(find.byKey(const ValueKey('moments-scan')));
    await DiaryAppHarness.pumpUntil(
        tester, () => find.text(l10n.momentsError).evaluate().isNotEmpty);
    expect(find.text(l10n.momentsError), findsOneWidget);
    expect(
        tester
            .widget<FilledButton>(find.byKey(const ValueKey('moments-scan')))
            .onPressed,
        isNotNull);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 5));
  });
}
