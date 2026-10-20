// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';

import 'package:aid_diary/widgets/progress_dialog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  // The tablet layout shows settings pages in a nested navigator; the dialog
  // has to close without popping the page that opened it.
  testWidgets('closes its dialog, not the page, inside a nested navigator',
      (tester) async {
    late BuildContext pageContext;
    await tester.pumpWidget(MaterialApp(
      home: Navigator(
        onGenerateRoute: (_) =>
            MaterialPageRoute(builder: (_) => const Text('root page')),
      ),
    ));
    final nested = tester.state<NavigatorState>(find.byType(Navigator).last);
    nested.push(MaterialPageRoute(builder: (context) {
      pageContext = context;
      return const Text('settings page');
    }));
    await tester.pumpAndSettle();

    final task = Completer<String>();
    final run = runWithProgress(pageContext, (update) {
      update('42%');
      return task.future;
    });
    await tester.pump();
    expect(find.text('42%'), findsOneWidget);

    task.complete('done');
    expect(await run, 'done');
    await tester.pumpAndSettle();

    expect(find.text('42%'), findsNothing);
    expect(find.text('settings page'), findsOneWidget);
  });

  testWidgets('closes when the task fails', (tester) async {
    late BuildContext context;
    await tester.pumpWidget(MaterialApp(home: Builder(builder: (c) {
      context = c;
      return const Text('page');
    })));

    final run = runWithProgress<void>(context, (update) async {
      update('working');
      throw StateError('failed');
    });
    await expectLater(run, throwsStateError);
    await tester.pumpAndSettle();

    expect(find.text('working'), findsNothing);
    expect(find.text('page'), findsOneWidget);
  });
}
