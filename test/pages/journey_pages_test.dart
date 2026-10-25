@Tags(['integration'])
library;

import 'package:aid_diary/utils/diary_day.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/pages/entry_timeline_page.dart';
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
import 'package:aid_diary/widgets/entry_text_field.dart';
import 'package:aid_diary/widgets/mood_icon.dart';
import 'package:aid_diary/widgets/entry_mood_picker.dart';
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
    final today = await DiaryAppHarness.addEntry(tester, '喝了咖啡', now,
        title: '早晨', mood: 1, location: const EntryLocation(name: '河边'));
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
      for (final destination in [0, 1, 3]) {
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

  testWidgets('the keyboard sliding does not rebuild the entry text',
      (tester) async {
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const AddEditEntryPage()));
    await tester.pumpAndSettle();
    await tester.enterText(DiaryAppHarness.entryBody, '很长的一篇日记');
    await tester.pumpAndSettle();
    var textRebuilds = 0;
    debugOnRebuildDirtyWidget = (element, _) {
      if (element.widget is EntryTextField) textRebuilds++;
    };
    addTearDown(() => debugOnRebuildDirtyWidget = null);
    addTearDown(tester.view.resetViewInsets);
    for (final inset in [300.0, 220.0, 140.0, 60.0, 0.0]) {
      tester.view.viewInsets = FakeViewPadding(bottom: inset);
      await tester.pump(const Duration(milliseconds: 16));
      if (inset == 0) {
        expect(find.byKey(const ValueKey('editor-bar-hidden')), findsOneWidget);
      } else {
        expect(find.byKey(const ValueKey('editor-bar-hidden')), findsNothing);
      }
    }
    debugOnRebuildDirtyWidget = null;
    expect(textRebuilds, 0);
    expect(find.byKey(const ValueKey('editor-title')), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('in the asking hours the editor asks which day, time stays',
      (tester) async {
    // Every hour asks, so the test does not depend on the clock.
    DiaryDay.startHour = 0;
    DiaryDay.askUntilHour = 24;
    addTearDown(() => DiaryDay.askUntilHour = 0);
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const MobileScaffold()));
    await tester.pumpAndSettle();
    await tapKey(tester, 'diary-new-entry');
    expect(find.byKey(const ValueKey('editor-day-question')), findsOneWidget);
    await tapKey(tester, 'editor-day-yesterday');
    expect(find.byKey(const ValueKey('editor-day-question')), findsNothing);
    await tester.enterText(DiaryAppHarness.entryBody, '昨晚的事');
    await tester.pump();
    await DiaryAppHarness.runUntil(
        tester,
        () => tester
            .widget<IconButton>(find.byKey(const ValueKey('entry-close')))
            .onPressed!(),
        () => EntryStore.instance.entries.isNotEmpty);
    final saved = EntryStore.instance.entries.single;
    final today = DiaryDay.dateOf(DateTime.now());
    expect(saved.day, DateTime(today.year, today.month, today.day - 1));
    expect(DiaryDay.dateOf(saved.timeCreate), today);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('a tap anywhere above the media tile starts writing',
      (tester) async {
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const AddEditEntryPage()));
    await tester.pumpAndSettle();
    bool writing() => tester
        .state<EditableTextState>(DiaryAppHarness.entryBody)
        .widget
        .focusNode
        .hasFocus;
    final tile = tester.getRect(find.byKey(const ValueKey('editor-add-media')));
    final title = tester.getRect(find.byKey(const ValueKey('editor-title')));
    // Just above the tile, and halfway down the blank space, near the edge.
    for (final point in [
      Offset(tile.center.dx + 120, tile.top - 12),
      Offset(30, (title.bottom + tile.top) / 2),
    ]) {
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      expect(writing(), isFalse);
      await tester.tapAt(point);
      await tester.pumpAndSettle();
      expect(writing(), isTrue, reason: '$point');
    }
    // The keyboard swiped away while the field keeps focus comes back too.
    tester.testTextInput.hide();
    await tester.pump();
    expect(tester.testTextInput.isVisible, isFalse);
    await tester.tapAt(Offset(30, tile.top - 12));
    await tester.pumpAndSettle();
    expect(writing(), isTrue);
    expect(tester.testTextInput.isVisible, isTrue);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('the caret lines up with the empty editor hint', (tester) async {
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const AddEditEntryPage()));
    await tester.pumpAndSettle();
    final state = tester.state<EditableTextState>(DiaryAppHarness.entryBody);
    final render = state.renderEditable;
    final caret = MatrixUtils.transformRect(render.getTransformTo(null),
        render.getLocalRectForCaret(const TextPosition(offset: 0)));
    final hint = tester.getRect(find.text('开始写，或选择一个'));
    // Same line: the caret's middle on the hint words' middle.
    expect(caret.center.dy, closeTo(hint.center.dy, 1.5));
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
    final saved = EntryStore.instance.entries.single;
    expect((saved.title, saved.text), ('周末', '去了公园'));
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
    // One entry is a point counting 1, like a cluster.
    final point = find.byKey(ValueKey('atlas-cluster-${placed.id}'));
    expect(
        find.descendant(of: point, matching: find.text('1')), findsOneWidget);
    await tester.tap(point);
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

  testWidgets('nearby atlas entries cluster and open as a list',
      (tester) async {
    final a = await DiaryAppHarness.addEntry(tester, '外滩', DateTime.now(),
        location: const EntryLocation(latitude: 31.230, longitude: 121.470));
    await DiaryAppHarness.addEntry(tester, '南京路', DateTime.now(),
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
    expect(find.byKey(ValueKey('atlas-cluster-${far.id}')), findsOneWidget);
    await tester.tap(cluster);
    await tester.pumpAndSettle();
    // The batch, as a list of its own: these two and not the far one.
    expect(find.byType(EntryTimelinePage), findsOneWidget);
    expect(find.textContaining('外滩'), findsWidgets);
    expect(find.textContaining('南京路'), findsOneWidget);
    expect(find.textContaining('北京'), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('search matches titles and filters expand inline by mood',
      (tester) async {
    final walk = await DiaryAppHarness.addEntry(tester, '散步', DateTime.now(),
        title: '公园', mood: 1);
    await DiaryAppHarness.addEntry(tester, '开车', DateTime.now(), mood: 1);
    await DiaryAppHarness.addEntry(tester, '公园但难过', DateTime.now(), mood: -2);
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const SearchPage()));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('search-field')), '公园');
    await tester.pumpAndSettle();
    expect(find.byKey(ValueKey('journal-entry-${walk.id}')), findsOneWidget);
    expect(find.text('开车'), findsNothing);
    expect(find.text('公园但难过'), findsOneWidget);
    for (final key in ['search-filter-mood', 'search-mood-1']) {
      await tester.ensureVisible(find.byKey(ValueKey(key)));
      await tester.pumpAndSettle();
      await tapKey(tester, key);
    }
    expect(find.byKey(ValueKey('journal-entry-${walk.id}')), findsOneWidget);
    expect(find.text('公园但难过'), findsNothing);
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

  for (final size in [const Size(360, 800), const Size(1280, 800)]) {
    testWidgets('mood menu picks, keeps and clears directly at $size',
        (tester) async {
      DiaryAppHarness.size(tester, size);
      await tester.pumpWidget(harness.app(const MobileScaffold()));
      await tester.pumpAndSettle();
      await tapKey(tester, 'diary-new-entry');
      await tester.enterText(DiaryAppHarness.entryBody, '今天的记录');
      await tapKey(tester, 'editor-mood');
      final anchor = tester.getRect(find.byKey(const ValueKey('editor-mood')));
      final choices = find.byType(EntryMoodPicker);
      expect(find.descendant(of: choices, matching: find.byType(InkWell)),
          findsNWidgets(6));
      final menu = tester.getRect(choices);
      expect(menu.top, greaterThanOrEqualTo(anchor.bottom));
      expect(menu.left, greaterThanOrEqualTo(0));
      expect(menu.right, lessThanOrEqualTo(size.width));
      expect(menu.left, lessThanOrEqualTo(anchor.center.dx));
      expect(menu.right, greaterThanOrEqualTo(anchor.center.dx));
      await tapKey(tester, 'mood-option-2');
      Finder chosen() => find.descendant(
          of: find.byKey(const ValueKey('editor-mood')),
          matching:
              find.byWidgetPredicate((w) => w is MoodIcon && w.moodValue == 2));
      expect(chosen(), findsOneWidget);
      await tapKey(tester, 'editor-mood');
      await tapKey(tester, 'mood-option-2');
      expect(chosen(), findsOneWidget);
      await tapKey(tester, 'editor-mood');
      await tapKey(tester, 'mood-clear');
      expect(
          find.descendant(
              of: find.byKey(const ValueKey('editor-mood')),
              matching: find.byIcon(Icons.add_reaction_outlined)),
          findsOneWidget);
      await DiaryAppHarness.runUntil(
          tester,
          () => tester
              .widget<IconButton>(find.byKey(const ValueKey('entry-close')))
              .onPressed!(),
          () => EntryStore.instance.entries.isNotEmpty);
      expect(EntryStore.instance.entries.single.mood, isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
}
