// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/widgets/back_gesture_transition.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  Future<void> backGesture(WidgetTester tester, String method,
      [double progress = 0]) async {
    await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
        'flutter/backgesture',
        const StandardMethodCodec().encodeMethodCall(MethodCall(method, {
          'touchOffset': [5.0, 300.0],
          'progress': progress,
          'swipeEdge': 0, // left
        })),
        (_) {});
  }

  testWidgets('a released back gesture fades the page out gradually',
      (tester) async {
    final navigator = GlobalKey<NavigatorState>();
    await tester.pumpWidget(MaterialApp(
      navigatorKey: navigator,
      theme: ThemeData(
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: DiaryPageTransitionsBuilder(),
      })),
      home: const Text('home'),
    ));
    navigator.currentState!.push(MaterialPageRoute<void>(
        builder: (_) => const Scaffold(body: Text('page'))));
    await tester.pumpAndSettle();

    double opacity() => tester
        .widget<Opacity>(find
            .ancestor(of: find.text('page'), matching: find.byType(Opacity))
            .first)
        .opacity;
    // The horizontal scale of the page, whichever transform carries it.
    double scale() => find
        .ancestor(of: find.text('page'), matching: find.byType(Transform))
        .evaluate()
        .map((e) => (e.widget as Transform).transform.storage[0])
        .reduce((a, b) => a * b);

    await backGesture(tester, 'startBackGesture');
    await backGesture(tester, 'updateBackGestureProgress', 0.6);
    await tester.pump();
    expect(opacity(), 1);
    final pulledScale = scale();
    expect(pulledScale, lessThan(1));

    await backGesture(tester, 'commitBackGesture');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    // Still nearly whole and still pulled in, not snapped back and gone.
    expect(opacity(), greaterThan(0.9));
    expect(scale(), closeTo(pulledScale, 0.001));
    await tester.pump(const Duration(milliseconds: 150));
    expect(opacity(), inExclusiveRange(0.1, 0.9));
    await tester.pumpAndSettle();
    expect(find.text('page'), findsNothing);
    expect(find.text('home'), findsOneWidget);
  }, variant: TargetPlatformVariant.only(TargetPlatform.android));
}
