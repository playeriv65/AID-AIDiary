@Tags(['integration'])
library;

import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/pages/edit_entry_page.dart';
import 'package:aid_diary/layouts/mobile_scaffold.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/pages/atlas_page.dart';
import 'package:aid_diary/pages/coach_page.dart';
import 'package:aid_diary/pages/journal_page.dart';
import 'package:aid_diary/pages/media_page.dart';
import 'package:aid_diary/pages/search_page.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/widgets/mood_icon.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/blank_tiles.dart';
import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();
  AtlasPage.tileProviderOverride = BlankTiles();

  Future<void> tapKey(WidgetTester tester, String key) async {
    await tester.tap(find.byKey(ValueKey(key)).hitTestable());
    await tester.pumpAndSettle();
  }

  testWidgets('journal groups by day and shows the selection beside the list',
      (tester) async {
    final now = DateTime.now();
    final today = await DiaryAppHarness.addEntry(tester, '# 早晨\n喝了咖啡', now,
        mood: 1, location: const EntryLocation(name: '河边'));
    await DiaryAppHarness.addEntry(
        tester, '昨天的事', now.subtract(const Duration(days: 1)));
    DiaryAppHarness.size(tester, const Size(1280, 800));
    await tester.pumpWidget(harness.app(const Scaffold(body: JournalPage())));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('story-today')), findsOneWidget);
    expect(find.text('早晨'), findsOneWidget);
    expect(find.text('河边'), findsOneWidget);
    await tapKey(tester, 'journal-entry-${today.id}');
    expect(find.byKey(ValueKey('journal-detail-${today.id}')), findsOneWidget);
    expect(find.text('${now.day}'), findsWidgets);

    await tester.runAsync(() async {
      tester
          .widget<IconButton>(find.byKey(const ValueKey('entry-favorite')))
          .onPressed!();
      await Future<void>.delayed(const Duration(milliseconds: 200));
    });
    await tester.pumpAndSettle();
    expect(TagsProvider.instance.isFavorite(today.id!), isTrue);
    await tapKey(tester, 'entry-next');
    expect(find.text('昨天的事'), findsWidgets);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  for (final dimensions in [
    const Size(360, 800),
    const Size(844, 390),
    const Size(2560, 1600),
  ]) {
    testWidgets('every destination lays out at $dimensions', (tester) async {
      await DiaryAppHarness.addEntry(tester, '一篇日记', DateTime.now());
      DiaryAppHarness.size(tester, dimensions);
      await tester.pumpWidget(harness.app(const MobileScaffold()));
      await tester.pumpAndSettle();
      // Skip the map here: it would fetch tiles. It has its own test.
      for (final destination in [0, 1, 2, 4]) {
        await DiaryAppHarness.goTo(tester, destination);
        expect(tester.takeException(), isNull);
      }
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }

  testWidgets('phone opens an entry in its own page', (tester) async {
    final entry =
        await DiaryAppHarness.addEntry(tester, '手机上的日记', DateTime.now());
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const MobileScaffold()));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('diary-new-entry')), findsOneWidget);
    await tapKey(tester, 'journal-entry-${entry.id}');
    expect(find.byKey(const ValueKey('diary-entry-edit')), findsOneWidget);
    expect(find.byKey(const ValueKey('diary-bottom-navigation')), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('media lists each attached photo', (tester) async {
    final entry = await DiaryAppHarness.addEntry(tester, '有照片', DateTime.now());
    await tester.runAsync(() => EntryImagesProvider.instance.add(EntryImage(
        entryId: entry.id,
        imgPath: 'missing.jpg',
        imgRank: 0,
        timeCreate: DateTime.now())));
    DiaryAppHarness.size(tester, const Size(1280, 800));
    await tester.pumpWidget(harness.app(const Scaffold(body: MediaPage())));
    await tester.pumpAndSettle();
    expect(find.text('媒体文件'.toUpperCase()), findsOneWidget);
    final image = EntryImagesProvider.instance.images.single;
    expect(find.byKey(ValueKey('media-${image.id}')), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('coach filters programs and starts a prompt', (tester) async {
    DiaryAppHarness.size(tester, const Size(1280, 800));
    await tester.pumpWidget(harness.app(const Scaffold(body: CoachPage())));
    await tester.pumpAndSettle();
    expect(
        find.byKey(const ValueKey('coach-program-everyday')), findsOneWidget);
    await tester.tap(find.text('模板').first);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('coach-program-everyday')), findsNothing);
    await tester.tap(find.text('全部'));
    await tester.pumpAndSettle();
    // Wide: the program opens in the list pane, the detail pane stays empty.
    await tapKey(tester, 'coach-program-everyday');
    expect(find.byKey(const ValueKey('detail-empty')), findsOneWidget);
    // Settling first would let the debounced config write start for real.
    await tester.tap(find.byKey(const ValueKey('coach-enroll')));
    await tester.pump();
    EasyDebounce.cancel('save-config');
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('coach-end')), findsOneWidget);
    expect(find.byKey(const ValueKey('coach-enrolled-tip')), findsOneWidget);

    // Day 1 waits in the stories; its prompt is answered in place.
    await tester.pumpWidget(harness.app(const Scaffold(body: JournalPage())));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('story-coach')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('第 1 天'), findsWidgets);
    // The story is a card in the middle of a wide window.
    await tester.tapAt(const Offset(900, 400));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.byKey(const ValueKey('coach-answer')));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.enterText(
        find.byKey(const ValueKey('coach-answer-field')), '和朋友去了海边');
    await tester.tap(find.byKey(const ValueKey('coach-answer-done')));
    // Wait on the save without moving fake time, which would start the
    // debounced config write for real.
    for (var i = 0;
        i < 50 && ConfigProvider.instance.get(Settings.coachAnsweredStep) != 0;
        i++) {
      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 20)));
      await tester.pump();
    }
    EasyDebounce.cancel('save-config');
    final saved = EntryStore.instance.entries.single;
    expect(saved.text, startsWith('## '));
    expect(saved.text, endsWith('和朋友去了海边'));
    await DiaryAppHarness.setSetting(Settings.coachProgram, '');
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('search matches text and the starred filter', (tester) async {
    final kept =
        await DiaryAppHarness.addEntry(tester, '去公园散步', DateTime.now());
    await DiaryAppHarness.addEntry(tester, '在家看书', DateTime.now());
    await tester
        .runAsync(() => TagsProvider.instance.setFavorite(kept.id!, true));
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const SearchPage()));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('search-field')), '公园');
    await tester.pumpAndSettle();
    expect(find.byKey(ValueKey('journal-entry-${kept.id}')), findsOneWidget);
    expect(find.text('在家看书'), findsNothing);
    await tester.enterText(find.byKey(const ValueKey('search-field')), '');
    await tapKey(tester, 'search-filter-starred');
    expect(find.byKey(ValueKey('journal-entry-${kept.id}')), findsOneWidget);
    expect(find.text('在家看书'), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('wide search shows a picked result beside the list',
      (tester) async {
    final entry =
        await DiaryAppHarness.addEntry(tester, '去公园散步', DateTime.now());
    DiaryAppHarness.size(tester, const Size(1280, 800));
    await tester.pumpWidget(harness.app(const SearchPage()));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('detail-empty')), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('search-field')), '公园');
    await tester.pumpAndSettle();
    await tapKey(tester, 'journal-entry-${entry.id}');
    expect(find.byKey(ValueKey('search-detail-${entry.id}')), findsOneWidget);
    expect(find.byType(SearchPage), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('editor close turns into done once something changes',
      (tester) async {
    DiaryAppHarness.size(tester, const Size(1280, 800));
    await tester.pumpWidget(harness.app(const MobileScaffold()));
    await tester.pumpAndSettle();
    await tapKey(tester, 'diary-new-entry');
    Icon closeIcon() => tester.widget<Icon>(find.descendant(
        of: find.byKey(const ValueKey('entry-close')),
        matching: find.byType(Icon)));
    expect(closeIcon().icon, Icons.close_rounded);
    expect(find.byKey(const ValueKey('entry-delete')), findsNothing);
    await tester.enterText(DiaryAppHarness.entryBody, '写了一句');
    await tester.pump();
    await tester.pump();
    expect(closeIcon().icon, Icons.check_rounded);
    await DiaryAppHarness.runUntil(
        tester,
        () => tester
            .widget<IconButton>(find.byKey(const ValueKey('entry-close')))
            .onPressed!(),
        () => EntryStore.instance.entries.isNotEmpty);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('going back over changes asks; not saving leaves no entry',
      (tester) async {
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const MobileScaffold()));
    await tester.pumpAndSettle();
    await tapKey(tester, 'diary-new-entry');
    await tester.enterText(DiaryAppHarness.entryBody, '不想留下');
    await tester.pump();
    // Going to the background meanwhile saves a draft.
    void lifecycle(List<AppLifecycleState> states) {
      for (final state in states) {
        tester.binding.handleAppLifecycleStateChanged(state);
      }
    }

    await DiaryAppHarness.runUntil(
        tester,
        () => lifecycle([AppLifecycleState.inactive, AppLifecycleState.hidden]),
        () => EntryStore.instance.entries.isNotEmpty);
    lifecycle([AppLifecycleState.inactive, AppLifecycleState.resumed]);
    expect(EntryStore.instance.entries.single.text, '不想留下');
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('editor-leave-save')), findsOneWidget);
    await DiaryAppHarness.runUntil(
        tester,
        () => tester
            .widget<TextButton>(
                find.byKey(const ValueKey('editor-leave-discard')))
            .onPressed!(),
        () => find.byType(AddEditEntryPage).evaluate().isEmpty);
    expect(find.byType(AddEditEntryPage), findsNothing);
    expect(EntryStore.instance.entries, isEmpty);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('the title field is the entry title, left out when empty',
      (tester) async {
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const MobileScaffold()));
    await tester.pumpAndSettle();
    await tapKey(tester, 'diary-new-entry');
    await tester.enterText(find.byKey(const ValueKey('editor-title')), '周末');
    await tester.enterText(DiaryAppHarness.entryBody, '去了公园');
    await tester.pump();
    await DiaryAppHarness.runUntil(
        tester,
        () => tester
            .widget<IconButton>(find.byKey(const ValueKey('entry-close')))
            .onPressed!(),
        () => EntryStore.instance.entries.isNotEmpty);
    expect(EntryStore.instance.entries.single.text, '# 周末\n去了公园');
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('atlas shows geotagged entries as markers', (tester) async {
    final placed = await DiaryAppHarness.addEntry(tester, '在河边', DateTime.now(),
        location: const EntryLocation(
            latitude: 31.23, longitude: 121.47, name: '外滩'));
    await DiaryAppHarness.addEntry(tester, '没有位置', DateTime.now());
    DiaryAppHarness.size(tester, const Size(1280, 800));
    await tester.pumpWidget(harness.app(Scaffold(body: const AtlasPage())));
    await tester.pumpAndSettle();
    expect(find.byKey(ValueKey('atlas-marker-${placed.id}')), findsOneWidget);
    await tester.tap(find.byKey(ValueKey('atlas-marker-${placed.id}')));
    await tester.pumpAndSettle();
    expect(find.byKey(ValueKey('atlas-detail-${placed.id}')), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('opening the atlas asks for location and marks the device',
      (tester) async {
    final calls = <String>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            const MethodChannel('flutter.baseflow.com/geolocator'),
            (call) async {
      calls.add(call.method);
      return switch (call.method) {
        'isLocationServiceEnabled' => true,
        'checkPermission' => 0, // denied: not asked yet
        'requestPermission' => 2, // while in use
        'getCurrentPosition' => {
            'latitude': 31.23,
            'longitude': 121.47,
            'timestamp': 0
          },
        _ => null,
      };
    });
    DiaryAppHarness.size(tester, const Size(1280, 800));
    await tester.pumpWidget(harness.app(Scaffold(body: const AtlasPage())));
    await tester.pumpAndSettle();
    expect(calls, contains('requestPermission'));
    expect(find.byKey(const ValueKey('atlas-here')), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('nearby atlas markers cluster and split when tapped',
      (tester) async {
    final a = await DiaryAppHarness.addEntry(tester, '外滩', DateTime.now(),
        location: const EntryLocation(latitude: 31.230, longitude: 121.470));
    final b = await DiaryAppHarness.addEntry(tester, '南京路', DateTime.now(),
        location: const EntryLocation(latitude: 31.231, longitude: 121.471));
    final far = await DiaryAppHarness.addEntry(tester, '北京', DateTime.now(),
        location: const EntryLocation(latitude: 39.9, longitude: 116.4));
    DiaryAppHarness.size(tester, const Size(1280, 800));
    await tester.pumpWidget(harness.app(Scaffold(body: const AtlasPage())));
    await tester.pumpAndSettle();
    final cluster = find.byKey(ValueKey('atlas-cluster-${a.id}'));
    expect(cluster, findsOneWidget);
    expect(
        find.descendant(of: cluster, matching: find.text('2')), findsOneWidget);
    expect(find.byKey(ValueKey('atlas-marker-${far.id}')), findsOneWidget);
    await tester.tap(cluster);
    await tester.pumpAndSettle();
    expect(cluster, findsNothing);
    expect(find.byKey(ValueKey('atlas-marker-${a.id}')), findsOneWidget);
    expect(find.byKey(ValueKey('atlas-marker-${b.id}')), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('search filters expand inline and match activity and mood',
      (tester) async {
    final walk = await DiaryAppHarness.addEntry(tester, '散步', DateTime.now(),
        mood: 1, activity: EntryActivity.walking);
    await DiaryAppHarness.addEntry(tester, '开车', DateTime.now(),
        mood: 1, activity: EntryActivity.vehicle);
    await DiaryAppHarness.addEntry(tester, '走路但难过', DateTime.now(),
        mood: -2, activity: EntryActivity.walking);
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const SearchPage()));
    await tester.pumpAndSettle();
    final activity = find.byKey(const ValueKey('search-filter-activity'));
    expect(find.descendant(of: activity, matching: find.text('7')),
        findsOneWidget);
    await tapKey(tester, 'search-filter-activity');
    await tapKey(tester, 'search-activity-walking');
    expect(find.descendant(of: activity, matching: find.text('1')),
        findsOneWidget);
    expect(find.text('开车'), findsNothing);
    expect(find.text('走路但难过'), findsOneWidget);
    for (final key in ['search-filter-mood', 'search-mood-1']) {
      await tester.ensureVisible(find.byKey(ValueKey(key)));
      await tester.pumpAndSettle();
      await tapKey(tester, key);
    }
    expect(find.byKey(ValueKey('journal-entry-${walk.id}')), findsOneWidget);
    expect(find.text('走路但难过'), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('editor saves a typed place and a mood', (tester) async {
    DiaryAppHarness.size(tester, const Size(1280, 800));
    await tester.pumpWidget(harness.app(const MobileScaffold()));
    await tester.pumpAndSettle();
    await tapKey(tester, 'diary-new-entry');
    await tester.enterText(DiaryAppHarness.entryBody, '记一下地点');
    await tapKey(tester, 'editor-location');
    // No position in tests: the sheet says so and offers the picker.
    await tapKey(tester, 'location-pick');
    await tester.enterText(find.byKey(const ValueKey('location-name')), '图书馆');
    await tester.pump();
    await tapKey(tester, 'location-custom');
    expect(
        find.descendant(
            of: find.byKey(const ValueKey('editor-location')),
            matching: find.text('图书馆')),
        findsOneWidget);
    // Mood sits beside the date.
    await tapKey(tester, 'editor-mood');
    await tester.tap(
        find.byWidgetPredicate((w) => w is MoodIcon && w.moodValue == 2).last);
    await tester.pumpAndSettle();
    await tapKey(tester, 'editor-mood-ok');
    await DiaryAppHarness.runUntil(
        tester,
        () => tester
            .widget<IconButton>(find.byKey(const ValueKey('entry-close')))
            .onPressed!(),
        () => EntryStore.instance.entries.isNotEmpty);
    final saved = EntryStore.instance.entries.single;
    expect(saved.location?.name, '图书馆');
    expect(saved.location?.hasCoordinates, isFalse);
    expect(saved.mood, 2);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
