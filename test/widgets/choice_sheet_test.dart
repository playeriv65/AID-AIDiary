// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['widget'])
library;

import 'package:aid_diary/widgets/choice_sheet.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();

  testWidgets('a long list of choices scrolls under its title and message',
      (tester) async {
    DiaryAppHarness.size(tester, const Size(390, 640));
    int? chosen;
    await tester.pumpWidget(harness.app(Scaffold(
      body: Builder(
        builder: (context) => TextButton(
          onPressed: () async => chosen = await showChoiceSheet(
              context,
              [
                for (var i = 1; i <= 20; i++)
                  (
                    value: i,
                    icon: null,
                    label: 'Format $i',
                    key: ValueKey('format-$i')
                  ),
              ],
              title: 'Choose Format',
              message: 'Another app may not keep everything.'),
          child: const Text('choose'),
        ),
      ),
    )));
    await tester.tap(find.text('choose'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Another app may not keep everything.'), findsOneWidget);

    final last = find.byKey(const ValueKey('format-20'));
    await tester.scrollUntilVisible(last, 200,
        scrollable: find.byType(Scrollable).last);
    await tester.tap(last);
    await tester.pumpAndSettle();
    expect(chosen, 20);
  });
}
