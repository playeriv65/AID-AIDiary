// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['widget'])
library;

import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/pages/settings/appearance_settings.dart';
import 'package:aid_diary/pages/settings/flashback_settings.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();

  // A tap changes config through the settings action: pump once and drop
  // the debounced file write before settling (see AGENTS.md).
  Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pump();
    EasyDebounce.cancel('save-config');
    await tester.pumpAndSettle();
  }

  testWidgets('a flashback switch changes its setting and what follows it',
      (tester) async {
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const FlashbackSettings()));
    await tester.pumpAndSettle();
    final yearsAgo = find.byKey(const ValueKey('showflashbackYearsAgo-switch'));
    expect(yearsAgo, findsOneWidget);

    await tapAndSettle(tester, yearsAgo);
    expect(
        ConfigProvider.instance.get(Settings.showflashbackYearsAgo), isFalse);

    // Without flashbacks the options below the switch are gone.
    await tapAndSettle(
        tester, find.byKey(const ValueKey('showFlashbacks-switch')));
    expect(ConfigProvider.instance.get(Settings.showFlashbacks), isFalse);
    expect(yearsAgo, findsNothing);
  });

  testWidgets('a mood icon is reset to its own default', (tester) async {
    await DiaryAppHarness.setSetting(Settings.happyIcon, '👍');
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const AppearanceSettings()));
    await tester.pumpAndSettle();
    final reset = find.byKey(const ValueKey('appearance-reset-mood-icons'));
    await tester.scrollUntilVisible(reset, 400,
        scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
    await tapAndSettle(tester, reset);
    expect(ConfigProvider.instance.get(Settings.happyIcon),
        Settings.happyIcon.defaultValue);
  });
}
