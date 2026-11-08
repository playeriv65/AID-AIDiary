@Tags(['integration'])
library;

import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/layouts/mobile_scaffold.dart';
import 'package:aid_diary/pages/entries_list_page.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/utils/diary_day.dart';
import 'package:aid_diary/widgets/month_calendar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();

  Future<void> tapKey(WidgetTester tester, String key) async {
    await tester.tap(find.byKey(ValueKey(key)).hitTestable());
    await tester.pumpAndSettle();
  }

  /// The journal's calendar, as `ui.navigate to=calendar` unfolds it.
  Future<void> openCalendar(WidgetTester tester) async {
    final navigation =
        AppActions.instance.run('ui.navigate', {'to': 'calendar'});
    await tester.pumpAndSettle();
    await navigation;
  }

  final calendarPanel = find.byKey(const ValueKey('journal-calendar-panel'));

  testWidgets('calendar, settings and navigation survive every layout',
      (tester) async {
    DiaryAppHarness.size(tester, const Size(1440, 900));
    await tester.pumpWidget(harness.app(const MobileScaffold()));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('list-detail-split')), findsOneWidget);
    expect(find.byKey(const ValueKey('detail-empty')), findsOneWidget);
    await openCalendar(tester);
    expect(AppActions.instance.screen!.current, 'calendar');
    for (final dimensions in [
      const Size(844, 390),
      const Size(390, 844),
      const Size(1024, 768),
      const Size(1440, 900)
    ]) {
      tester.view.physicalSize = dimensions;
      await tester.pumpAndSettle();
      expect(calendarPanel, findsOneWidget);
      expect(find.byType(MonthCalendar), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
    await tapKey(tester, 'journal-menu');
    await tapKey(tester, 'diary-settings');
    expect(find.byKey(const ValueKey('diary-rail')), findsOneWidget);
    await tester.tap(find.text('通用'));
    await tester.pumpAndSettle();
    for (final dimensions in [const Size(844, 390), const Size(390, 844)]) {
      tester.view.physicalSize = dimensions;
      await tester.pumpAndSettle();
      expect(find.text('主题色'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(
        find.byKey(const ValueKey('diary-bottom-navigation')), findsOneWidget);
    expect(AppActions.instance.screen!.current, 'calendar');
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
      'a day held in the calendar is written, kept through rotation, saved, '
      'then deleted', (tester) async {
    DiaryAppHarness.size(tester, const Size(1440, 900));
    await tester.pumpWidget(harness.app(const MobileScaffold()));
    await tester.pumpAndSettle();
    await openCalendar(tester);
    final today = DiaryDay.today();
    await tester.longPress(find.byKey(
        ValueKey('calendar-day-${today.year}-${today.month}-${today.day}')));
    await tester.pumpAndSettle();
    expect(calendarPanel, findsNothing);
    final editable = DiaryAppHarness.entryBody;
    await tester.enterText(editable, '横屏草稿不会丢失');
    for (final dimensions in [
      const Size(844, 390),
      const Size(390, 844),
      const Size(1024, 768),
      const Size(1440, 900)
    ]) {
      tester.view.physicalSize = dimensions;
      await tester.pumpAndSettle();
      expect(tester.widget<EditableText>(editable).controller.text, '横屏草稿不会丢失');
      expect(tester.takeException(), isNull);
    }
    tester.view.physicalSize = const Size(844, 390);
    tester.view.viewInsets = const FakeViewPadding(bottom: 180);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await DiaryAppHarness.runUntil(
        tester,
        () => tester
            .widget<IconButton>(find.byKey(const ValueKey('entry-close')))
            .onPressed!(),
        () => EntryStore.instance.entries.isNotEmpty);
    final saved = EntryStore.instance.entries.single;
    expect(saved.text, '横屏草稿不会丢失');
    expect(saved.day, today);
    tester.view.viewInsets = const FakeViewPadding();
    tester.view.physicalSize = const Size(1440, 900);
    await tester.pumpAndSettle();

    await tapKey(tester, 'journal-entry-${saved.id}');
    await tapKey(tester, 'entry-more');
    await tester.tap(find.text('删除').last);
    await tester.pumpAndSettle();
    await DiaryAppHarness.runUntil(
        tester,
        () => tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, '删除'))
            .onPressed!(),
        () => EntryStore.instance.entries.isEmpty);
    expect(EntryStore.instance.entries, isEmpty);
    // Only the entry closes: the journal stays, its detail pane empty.
    expect(find.byKey(const ValueKey('diary-rail')), findsOneWidget);
    expect(find.byKey(const ValueKey('detail-empty')), findsOneWidget);
    expect(AppActions.instance.screen!.current, 'journal');
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
      'the calendar button on any tab and ui.navigate unfold the journal '
      'calendar', (tester) async {
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const MobileScaffold()));
    await tester.pumpAndSettle();
    for (final tab in [1, 2]) {
      await DiaryAppHarness.goTo(tester, tab);
      await tapKey(tester, 'journal-calendar');
      expect(AppActions.instance.screen!.current, 'calendar');
      expect(calendarPanel, findsOneWidget);
      expect(find.byKey(const PageStorageKey('journal-list')), findsOneWidget);
      // The same button folds it again.
      await tapKey(tester, 'journal-calendar');
      expect(calendarPanel, findsNothing);
      expect(AppActions.instance.screen!.current, 'journal');
    }

    await DiaryAppHarness.goTo(tester, 1);
    await openCalendar(tester);
    expect(AppActions.instance.screen!.current, 'calendar');
    expect(calendarPanel, findsOneWidget);
    // Back folds it, as leaving the journal does.
    expect(await AppActions.instance.run('ui.back', {}),
        {'closed': true, 'current': 'journal'});
    await tester.pumpAndSettle();
    expect(calendarPanel, findsNothing);
    await tapKey(tester, 'journal-calendar');
    await DiaryAppHarness.goTo(tester, 1);
    expect(AppActions.instance.screen!.current, 'media');
    await DiaryAppHarness.goTo(tester, 0);
    expect(calendarPanel, findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('phone pager steps between entries with the arrows',
      (tester) async {
    final now = DateTime.now();
    await DiaryAppHarness.addEntry(tester, '第一篇', now);
    await DiaryAppHarness.addEntry(
        tester, '第二篇', now.subtract(const Duration(days: 1)));
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(EntriesListPage(
        index: 0, getEntries: () => EntriesProvider.instance.entries)));
    await tester.pumpAndSettle();
    expect(find.text('第一篇'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('entry-next')).hitTestable());
    await tester.pumpAndSettle();
    expect(find.text('第二篇'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
