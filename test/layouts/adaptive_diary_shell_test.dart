import 'package:daily_you/custom_locale_delegates.dart';
import 'package:daily_you/layouts/adaptive_diary_shell.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  test('layout uses width and height, not orientation alone', () {
    expect(diaryLayoutFor(const Size(390, 844)), DiaryLayout.compact);
    expect(diaryLayoutFor(const Size(844, 390)), DiaryLayout.rail);
    expect(diaryLayoutFor(const Size(1280, 500)), DiaryLayout.rail);
    expect(diaryLayoutFor(const Size(1280, 800)), DiaryLayout.expanded);
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
    const Size(1280, 500),
    const Size(1440, 900),
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
      final expected = switch (diaryLayoutFor(size)) {
        DiaryLayout.compact => 'diary-bottom-navigation',
        DiaryLayout.rail => 'diary-rail',
        DiaryLayout.expanded => 'diary-sidebar',
      };
      expect(find.byKey(ValueKey(expected)), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

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

  testWidgets('wide navigation respects an editor pop guard', (tester) async {
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

  testWidgets('wide navigation returns through nested routes then changes tab',
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
    {ValueChanged<int>? onSelect}) {
  return MaterialApp(
      localizationsDelegates: appLocalizationsDelegates,
      home: AdaptiveDiaryShell(
          navigatorKey: nav,
          home: home,
          title: 'AID Diary',
          destinations: const [
            DiaryDestination('日记', Icons.home_rounded),
            DiaryDestination('日记图库', Icons.photo_library_rounded),
            DiaryDestination('统计', Icons.auto_graph_rounded)
          ],
          selectedIndex: 0,
          onDestinationSelected: onSelect ?? (_) {},
          settingsLabel: '设置',
          onSettings: () => nav.currentState!.push(MaterialPageRoute<void>(
              settings: const RouteSettings(name: 'settings'),
              builder: (_) => const Scaffold(body: Text('Settings'))))));
}
