// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['widget'])
library;

import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/routing/destinations.dart';
import 'package:aid_diary/widgets/delete_confirm_dialog.dart';
import 'package:aid_diary/widgets/settings_toggle.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();

  /// Haptics played, by the name Flutter sends to the platform.
  List<String> recordHaptics(WidgetTester tester) {
    final played = <String>[];
    tester.binding.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'HapticFeedback.vibrate') {
        played.add('${call.arguments}'.split('.').last);
      }
      return null;
    });
    addTearDown(() => tester.binding.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null));
    return played;
  }

  Future<void> openPalette(WidgetTester tester) async {
    DiaryAppHarness.size(tester, const Size(1280, 900));
    await tester.pumpWidget(harness.app(Builder(
        builder: (context) => TextButton(
            onPressed: () => openPlace(context, 'commands'),
            child: const Text('open')))));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('the palette offers every action the command line has',
      (tester) async {
    await openPalette(tester);
    for (final action in AppActions.instance.available) {
      await tester.enterText(
          find.byKey(const ValueKey('command-palette-search')), action.id);
      await tester.pump();
      expect(find.byKey(ValueKey('command-${action.id}')), findsOneWidget,
          reason: action.id);
    }
  });

  testWidgets('an action runs from the palette with its arguments',
      (tester) async {
    final played = recordHaptics(tester);
    await openPalette(tester);
    await tester.enterText(
        find.byKey(const ValueKey('command-palette-search')), 'entry.create');
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('command-entry.create')));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byKey(const ValueKey('command-arg-text')), 'From the palette');
    await tester.tap(find.byKey(const ValueKey('command-run')));
    await DiaryAppHarness.pumpUntil(
        tester, () => EntryStore.instance.entries.isNotEmpty);

    expect(EntryStore.instance.entries.single.text, 'From the palette');
    expect(find.textContaining('"ok": true'), findsOneWidget);
    expect(played, contains('successNotification'));
  });

  testWidgets('switches tick, and a delete prompt warns', (tester) async {
    final played = recordHaptics(tester);
    await tester.pumpWidget(harness.app(Scaffold(
      body: Builder(
        builder: (context) => Column(children: [
          SettingsToggle(
              title: 'Flashbacks',
              setting: Settings.showFlashbacks,
              onChanged: (value) =>
                  DiaryAppHarness.setSetting(Settings.showFlashbacks, value)),
          TextButton(
              onPressed: () =>
                  showDeleteConfirmDialog(context, message: 'Delete it?'),
              child: const Text('delete')),
        ]),
      ),
    )));

    await tester.tap(find.byType(Switch));
    await tester.pump();
    expect(played, ['selectionClick']);
    await DiaryAppHarness.setSetting(Settings.showFlashbacks, true);

    await tester.tap(find.text('delete'));
    await tester.pumpAndSettle();
    expect(played.last, 'warningNotification');
  });
}
