@Tags(['widget'])
library;

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/widgets/windows_wheel_scroll.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  setUp(() async {
    await AppConfig.load();
  });

  Future<WheelScrollController> list(WidgetTester tester,
      {bool reducedMotion = false,
      TargetPlatform platform = TargetPlatform.windows,
      bool reverse = false,
      VoidCallback? onTap}) async {
    final controller = WheelScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(platform: platform),
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: reducedMotion),
        child: WindowsWheelScrollScope(
            controller: controller,
            child: ListView.builder(
                controller: controller,
                reverse: reverse,
                itemExtent: 60,
                itemCount: 100,
                itemBuilder: (_, i) => GestureDetector(
                    onTap: onTap,
                    behavior: HitTestBehavior.opaque,
                    child: Text('Row $i')))),
      ),
    ));
    await tester.pumpAndSettle();
    return controller;
  }

  Future<void> wheel(WidgetTester tester, double delta,
          {PointerDeviceKind kind = PointerDeviceKind.mouse,
          Offset position = const Offset(300, 250)}) =>
      tester.sendEventToBinding(PointerScrollEvent(
          kind: kind, position: position, scrollDelta: Offset(0, delta)));

  testWidgets(
      'one notch moves over frames and decelerates to its exact distance',
      (tester) async {
    final controller = await list(tester);
    await wheel(tester, 60);
    expect(controller.offset, 0);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 30));
    final first = controller.offset;
    expect(first, inExclusiveRange(0, 60));
    await tester.pump(const Duration(milliseconds: 30));
    final second = controller.offset;
    await tester.pump(const Duration(milliseconds: 30));
    expect(controller.offset - second, lessThan(second - first));
    await tester.pumpAndSettle();
    expect(controller.offset, closeTo(60, .01));
  });

  testWidgets(
      'rapid notches accumulate; reversing responds from visible position',
      (tester) async {
    final controller = await list(tester);
    for (var i = 0; i < 3; i++) {
      await wheel(tester, 60);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 20));
    }
    await tester.pumpAndSettle();
    expect(controller.offset, closeTo(180, .01));
    await wheel(tester, 240);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 40));
    final before = controller.offset;
    await wheel(tester, -60);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 20));
    expect(controller.offset, lessThan(before));
    await tester.pumpAndSettle();
    expect(controller.offset, closeTo(before - 60, .01));
  });

  testWidgets('a burst keeps moving each frame when new notches arrive',
      (tester) async {
    final controller = await list(tester);
    for (var frame = 0; frame < 30; frame++) {
      final before = controller.offset;
      if (frame % 6 == 0) await wheel(tester, 60);
      await tester.pump(const Duration(milliseconds: 8));
      if (frame > 0) {
        expect(controller.offset, greaterThan(before),
            reason:
                'A new notch must not restart the ticker with a stationary frame');
      }
    }
    await tester.pumpAndSettle();
    expect(controller.offset, closeTo(300, .01));
  });

  testWidgets('jump and touch interrupt the tail; rows stay tappable',
      (tester) async {
    var taps = 0;
    final controller = await list(tester, onTap: () => taps++);
    await wheel(tester, 240);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 20));
    await tester.tapAt(const Offset(300, 250));
    expect(taps, 1);
    await wheel(tester, 60);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 20));
    controller.jumpTo(700);
    await tester.pumpAndSettle();
    expect(controller.offset, 700);
    await wheel(tester, 60);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 20));
    await tester.dragFrom(const Offset(300, 250), const Offset(0, -100));
    await tester.pumpAndSettle();
    expect(controller.offset, greaterThan(760));
  });

  testWidgets('end clamps without bounce and reverse lists honor direction',
      (tester) async {
    final controller = await list(tester, reverse: true);
    controller.jumpTo(200);
    await wheel(tester, 60);
    await tester.pumpAndSettle();
    expect(controller.offset, closeTo(140, .01));
    controller.jumpTo(controller.position.maxScrollExtent - 5);
    await wheel(tester, -60);
    await tester.pumpAndSettle();
    expect(controller.offset, controller.position.maxScrollExtent);
    expect(tester.takeException(), isNull);
  });

  for (final kind in [PointerDeviceKind.trackpad, PointerDeviceKind.touch]) {
    testWidgets('$kind pointer signal keeps native immediate scrolling',
        (tester) async {
      final controller = await list(tester);
      await wheel(tester, 60, kind: kind);
      expect(controller.offset, 60);
      await tester.pumpAndSettle();
    });
  }

  testWidgets('reduced motion and Android retain immediate wheel behavior',
      (tester) async {
    var controller = await list(tester, reducedMotion: true);
    await wheel(tester, 60);
    expect(controller.offset, 60);
    await tester.pumpWidget(const SizedBox.shrink());
    controller = await list(tester, platform: TargetPlatform.android);
    await wheel(tester, 60);
    expect(controller.offset, 60);
    await tester.pumpAndSettle();
  });

  testWidgets(
      'Windows routes inherit independent smoothing and restore on Back',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(
          platform: TargetPlatform.windows,
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.windows: WindowsWheelPageTransitionsBuilder(),
          })),
      home: Scaffold(
          body: ListView.builder(
              itemExtent: 60,
              itemCount: 100,
              itemBuilder: (_, i) => Text('Row $i'))),
    ));
    await tester.pumpAndSettle();
    final position =
        tester.state<ScrollableState>(find.byType(Scrollable)).position;
    await wheel(tester, 60);
    expect(position.pixels, 0);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 30));
    expect(position.pixels, inExclusiveRange(0, 60));
    await tester.pumpAndSettle();
    expect(position.pixels, closeTo(60, .01));

    final navigator = Navigator.of(tester.element(find.byType(ListView)));
    navigator.push(MaterialPageRoute<void>(
        builder: (_) => Scaffold(
            body: ListView.builder(
                itemExtent: 60,
                itemCount: 100,
                itemBuilder: (_, i) => Text('Next $i')))));
    await tester.pumpAndSettle();
    final next =
        tester.state<ScrollableState>(find.byType(Scrollable)).position;
    expect(next.pixels, 0);
    await wheel(tester, 120);
    expect(next.pixels, 0);
    await tester.pumpAndSettle();
    expect(next.pixels, closeTo(120, .01));
    expect(position.pixels, closeTo(60, .01));
    navigator.pop();
    await tester.pumpAndSettle();
    expect(tester.state<ScrollableState>(find.byType(Scrollable)).position,
        position);
  });

  testWidgets('nested lists consume the wheel once and hand off at the end',
      (tester) async {
    final outer = WheelScrollController();
    final inner = WheelScrollController();
    addTearDown(outer.dispose);
    addTearDown(inner.dispose);
    await tester.pumpWidget(MaterialApp(
        theme: ThemeData(platform: TargetPlatform.windows),
        home: WindowsWheelScrollScope(
            controller: outer,
            child: ListView(controller: outer, children: [
              SizedBox(
                  height: 180,
                  child: WindowsWheelScrollScope(
                      controller: inner,
                      child: ListView.builder(
                          controller: inner,
                          itemExtent: 60,
                          itemCount: 6,
                          itemBuilder: (_, i) => Text('Inner $i')))),
              const SizedBox(height: 2000)
            ]))));
    await tester.pumpAndSettle();
    await wheel(tester, 300, position: const Offset(200, 90));
    await tester.pumpAndSettle();
    expect(inner.offset, 180);
    expect(outer.offset, 0);
    await wheel(tester, 60, position: const Offset(200, 90));
    await tester.pumpAndSettle();
    expect(inner.offset, 180);
    expect(outer.offset, closeTo(60, .01));
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
