// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

// The actions a frame-rate run drives the GUI with: a swipe where no touch
// screen is, and the frame count around it.

@Tags(['widget'])
library;

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:flutter/gestures.dart';
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
  testWidgets('mouse drag moves a desktop scrollbar across a long list',
      (tester) async {
    final actions = AppActions(screen: _Screen());
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(platform: TargetPlatform.windows),
      scrollBehavior:
          const MaterialScrollBehavior().copyWith(scrollbars: false),
      home: Scrollbar(
        controller: controller,
        child: ListView.builder(
          controller: controller,
          itemExtent: 60,
          itemCount: 4000,
          itemBuilder: (_, index) => Text('Row $index'),
        ),
      ),
    ));
    await tester.pumpAndSettle();
    final action = actions.run('ui.fling', {
      'mouse': true,
      'x': .995,
      'from': .02,
      'to': .8,
      'duration_ms': 96,
    });
    for (var step = 0; step < 20; step++) {
      await tester.pump(const Duration(milliseconds: 8));
    }
    final result = await action as Map;
    await tester.pumpAndSettle();
    expect(controller.offset,
        greaterThan(controller.position.maxScrollExtent * .5));
    expect(result['scrollStart'], 0);
    expect(result['scrollEnd'], controller.offset);
  });

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

    Future<void> fling(Map<String, Object?> args) async {
      final action = actions.run('ui.fling', args);
      for (var step = 0; step < 10; step++) {
        await tester.pump(const Duration(milliseconds: 8));
      }
      await action;
    }

    await fling({});
    final lifted = list.offset;
    expect(lifted, greaterThan(0));
    await tester.pumpAndSettle();
    expect(list.offset, greaterThan(lifted), reason: 'a fling carries on');

    await fling({'from': '0.2', 'to': '0.8'});
    await tester.pumpAndSettle();
    expect(list.offset, lessThan(lifted));

    expect(
        () => actions.run('ui.fling', {'x': '1.5'}),
        throwsA(isA<ActionException>()
            .having((error) => error.code, 'code', 'bad_args')));
  });

  testWidgets('ui.fling keeps requested event timing across delayed frames',
      (tester) async {
    final actions = AppActions(screen: _Screen());
    await tester.pumpWidget(const MaterialApp(home: SizedBox.expand()));
    final events = <PointerEvent>[];
    void capture(PointerEvent event) => events.add(event);
    GestureBinding.instance.pointerRouter.addGlobalRoute(capture);
    addTearDown(
        () => GestureBinding.instance.pointerRouter.removeGlobalRoute(capture));

    final action = actions.run('ui.fling', {'duration_ms': '96'});
    expect(events.whereType<PointerMoveEvent>(), isEmpty);
    await tester.pump(const Duration(milliseconds: 7));
    expect(events.whereType<PointerMoveEvent>(), isEmpty,
        reason: 'real timers still pace delivery before the first sample');
    // Rendering need not keep up with the requested synthetic event cadence.
    await tester.pump(const Duration(milliseconds: 65));
    await tester.pump(const Duration(milliseconds: 70));
    await action;

    final down = events.whereType<PointerDownEvent>().single;
    final moves = events.whereType<PointerMoveEvent>().toList();
    final up = events.whereType<PointerUpEvent>().single;
    expect(down.timeStamp, Duration.zero);
    expect(moves.length, greaterThanOrEqualTo(3));
    var previousTime = down.timeStamp;
    for (final move in moves) {
      expect(move.pointer, down.pointer);
      expect(move.timeStamp, greaterThan(previousTime));
      expect(move.timeStamp - previousTime,
          lessThanOrEqualTo(const Duration(milliseconds: 9)));
      previousTime = move.timeStamp;
    }
    expect(up.timeStamp, const Duration(milliseconds: 96));
    expect(up.timeStamp, moves.last.timeStamp);
    expect(up.position, moves.last.position);
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
