// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['widget'])
library;

import 'package:aid_diary/widgets/confirm_dialog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();

  /// A button that asks through [ask] and keeps the answer in [answers].
  Future<void> pumpAsker(WidgetTester tester, List<Object?> answers,
      Future<Object?> Function(BuildContext context) ask) async {
    await tester.pumpWidget(harness.app(Scaffold(
      body: Builder(
        builder: (context) => TextButton(
          onPressed: () async => answers.add(await ask(context)),
          child: const Text('ask'),
        ),
      ),
    )));
    await tester.tap(find.text('ask'));
    await tester.pumpAndSettle();
  }

  FilledButton confirmButton(WidgetTester tester) =>
      tester.widget<FilledButton>(find.byKey(const ValueKey('confirm')));

  testWidgets('a typed confirmation takes the phrase, in any case',
      (tester) async {
    final answers = <Object?>[];
    await pumpAsker(
        tester,
        answers,
        (context) => showConfirmDialog(context,
            title: 'Delete All Logs',
            confirm: 'Delete',
            destructive: true,
            confirmKey: const ValueKey('confirm'),
            phrase: 'Delete All Logs'));
    expect(confirmButton(tester).onPressed, isNull);

    final field = find.byKey(const ValueKey('confirm-phrase'));
    await tester.enterText(field, 'Delete All');
    await tester.pump();
    expect(confirmButton(tester).onPressed, isNull);
    await tester.enterText(field, ' delete all logs ');
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('confirm')));
    await tester.pumpAndSettle();
    expect(answers, [true]);
  });

  testWidgets('confirm or decline tells the two ways on from cancelling',
      (tester) async {
    final answers = <Object?>[];
    Future<Object?> ask(BuildContext context) =>
        showConfirmOrDeclineDialog(context,
            title: 'Save this entry?',
            confirm: 'Save',
            confirmKey: const ValueKey('confirm'),
            decline: "Don't save",
            declineKey: const ValueKey('decline'));
    await pumpAsker(tester, answers, ask);
    await tester.tap(find.byKey(const ValueKey('decline')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ask'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('confirm')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ask'));
    await tester.pumpAndSettle();
    final cancel = MaterialLocalizations.of(tester.element(find.text('ask')))
        .cancelButtonLabel;
    await tester.tap(find.text(cancel));
    await tester.pumpAndSettle();
    expect(answers, [false, true, null]);
  });
}
