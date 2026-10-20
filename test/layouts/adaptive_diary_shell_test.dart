@Tags(['widget'])
library;

import 'package:daily_you/custom_locale_delegates.dart';
import 'package:daily_you/layouts/adaptive_diary_shell.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  test('phones get a bottom bar, wider windows a rail', () {
    expect(diaryLayoutFor(const Size(390, 844)), DiaryLayout.compact);
    expect(diaryLayoutFor(const Size(599, 900)), DiaryLayout.compact);
    expect(diaryLayoutFor(const Size(844, 390)), DiaryLayout.rail);
    expect(diaryLayoutFor(const Size(2560, 1600)), DiaryLayout.rail);
    expect(diarySupportsSplit(const Size(763, 334)), isTrue);
    expect(diarySupportsSplit(const Size(640, 800)), isFalse);
    expect(diarySupportsSplit(const Size(1000, 250)), isFalse);
  });

  for (final size in [
    const Size(360, 800),
    const Size(599, 800),
    const Size(600, 360),
    const Size(844, 390),
    const Size(1024, 768),
    const Size(1280, 800),
    const Size(1920, 1080)
  ]) {
    testWidgets('navigation has no overflow at $size', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      final nav = GlobalKey<NavigatorState>();
      await tester.pumpWidget(_app(nav, const Scaffold(body: Text('Home'))));
      await tester.pumpAndSettle();
      final compact = diaryLayoutFor(size) == DiaryLayout.compact;
      expect(find.byKey(const ValueKey('diary-bottom-navigation')),
          compact ? findsOneWidget : findsNothing);
      expect(find.byKey(const ValueKey('diary-rail')),
          compact ? findsNothing : findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('rail new-entry button calls back', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    var created = 0;
    await tester.pumpWidget(_app(
        GlobalKey<NavigatorState>(), const Scaffold(body: Text('Home')),
        onNewEntry: () => created++));
    await tester.tap(find.byKey(const ValueKey('diary-new-entry')));
    expect(created, 1);
    // The rail starts at the top, not centred in a tall window.
    expect(tester.getTopLeft(find.byKey(const ValueKey('diary-new-entry'))).dy,
        lessThan(40));
  });

  testWidgets(
      'pushed editor and draft survive portrait landscape desktop resize',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1440, 900);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final nav = GlobalKey<NavigatorState>();
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_app(nav, const Scaffold(body: Text('Home'))));
    await tester.pumpAndSettle();
    nav.currentState!.push(MaterialPageRoute<void>(
        builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Editor')),
            body: TextField(controller: controller))));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '未保存的横屏日记');
    final state = nav.currentState;
    for (final size in [
      const Size(390, 844),
      const Size(844, 390),
      const Size(1024, 768),
      const Size(1440, 900)
    ]) {
      tester.view.physicalSize = size;
      await tester.pumpAndSettle();
      expect(nav.currentState, same(state));
      expect(find.text('Editor'), findsOneWidget);
      expect(controller.text, '未保存的横屏日记');
      expect(
          find.byKey(const ValueKey('diary-bottom-navigation')), findsNothing);
      expect(tester.takeException(), isNull);
    }
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('rail navigation respects an editor pop guard', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1200, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final nav = GlobalKey<NavigatorState>();
    var changed = false;
    await tester.pumpWidget(_app(nav, const Scaffold(body: Text('Home')),
        onSelect: (_) => changed = true));
    await tester.pumpAndSettle();
    nav.currentState!.push(MaterialPageRoute<void>(
        builder: (_) => const PopScope(
            canPop: false, child: Scaffold(body: Text('Guarded draft')))));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('diary-destination-1')));
    await tester.pumpAndSettle();
    expect(changed, isFalse);
    expect(find.text('Guarded draft'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('rail navigation returns through nested routes then changes tab',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1200, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final nav = GlobalKey<NavigatorState>();
    var selected = -1;
    await tester.pumpWidget(_app(nav, const Scaffold(body: Text('Home')),
        onSelect: (i) => selected = i));
    await tester.pumpAndSettle();
    for (var i = 0; i < 2; i++) {
      nav.currentState!.push(MaterialPageRoute<void>(
          builder: (_) => const Scaffold(body: Text('Settings subpage'))));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.byKey(const ValueKey('diary-destination-1')));
    await tester.pumpAndSettle();
    expect(selected, 1);
    expect(nav.currentState!.canPop(), isFalse);
    expect(tester.takeException(), isNull);
  });
}

Widget _app(GlobalKey<NavigatorState> nav, Widget home,
    {ValueChanged<int>? onSelect, VoidCallback? onNewEntry}) {
  return MaterialApp(
      localizationsDelegates: appLocalizationsDelegates,
      home: AdaptiveDiaryShell(
          navigatorKey: nav,
          home: home,
          destinations: const [
            DiaryDestination(
                '日记', Icons.auto_stories_outlined, Icons.auto_stories_rounded),
            DiaryDestination('日历', Icons.calendar_today_outlined,
                Icons.calendar_today_rounded),
            DiaryDestination('媒体', Icons.photo_outlined, Icons.photo_rounded),
            DiaryDestination('地图', Icons.map_outlined, Icons.map_rounded),
            DiaryDestination(
                '引导', Icons.favorite_border_rounded, Icons.favorite_rounded),
          ],
          selectedIndex: 0,
          onDestinationSelected: onSelect ?? (_) {},
          newEntryLabel: '写一篇日记',
          onNewEntry: onNewEntry ?? () {}));
}
