// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

// The actions a frame-rate run drives the GUI with: a swipe where no touch
// screen is, and the frame count around it.

@Tags(['widget'])
library;

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

class _Screen implements ActionScreen {
  @override
  String get current => 'journal';
  @override
  List<ScreenDestination> get destinations => const [];
  @override
  Future<void> navigate(String destination, ActionArgs args) async {}
  @override
  Future<bool> back() async => false;
}

void main() {
  testWidgets('ui.fling swipes the list under it, which scrolls on',
      (tester) async {
    final actions = AppActions(screen: _Screen());
    final list = ScrollController();
    await tester.pumpWidget(MaterialApp(
      home: ListView.builder(
          controller: list,
          itemCount: 500,
          itemBuilder: (context, index) =>
              SizedBox(height: 60, child: Text('Row $index'))),
    ));

    await tester.runAsync(() => actions.run('ui.fling', {}));
    final lifted = list.offset;
    expect(lifted, greaterThan(0));
    await tester.pumpAndSettle();
    expect(list.offset, greaterThan(lifted), reason: 'a fling carries on');

    await tester
        .runAsync(() => actions.run('ui.fling', {'from': '0.2', 'to': '0.8'}));
    await tester.pumpAndSettle();
    expect(list.offset, lessThan(lifted));

    expect(
        () => actions.run('ui.fling', {'x': '1.5'}),
        throwsA(isA<ActionException>()
            .having((error) => error.code, 'code', 'bad_args')));
  });

  testWidgets('perf.stop reports what perf.start counted', (tester) async {
    final actions = AppActions();
    expect(
        () => actions.run('perf.stop', {}),
        throwsA(isA<ActionException>()
            .having((error) => error.code, 'code', 'not_started')));
    await actions.run('perf.start', {});
    final report = await tester.runAsync(
            () => actions.run('perf.stop', {'hz': '120', 'still_ms': '100'}))
        as Map<String, Object>;
    expect(report['targetHz'], 120);
    expect(report['budgetMs'], 8.33);
    for (final key in ['frames', 'buildP99Ms', 'rasterP99Ms', 'skippedShare']) {
      expect(report, contains(key));
    }
  });
}
