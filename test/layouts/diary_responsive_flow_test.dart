import 'package:daily_you/database/entry_store.dart';
import 'package:daily_you/layouts/mobile_scaffold.dart';
import 'package:daily_you/pages/entries_list_page.dart';
import 'package:daily_you/providers/entries_provider.dart';
import 'package:daily_you/widgets/month_calendar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();

  Future<void> tapKey(WidgetTester tester, String key) async {
    await tester.tap(find.byKey(ValueKey(key)).hitTestable());
    await tester.pumpAndSettle();
  }

  testWidgets('calendar, settings and navigation survive every layout',
      (tester) async {
    DiaryAppHarness.size(tester, const Size(1440, 900));
    await tester.pumpWidget(harness.app(const MobileScaffold()));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('list-detail-split')), findsOneWidget);
    expect(find.byKey(const ValueKey('detail-empty')), findsOneWidget);
    await tapKey(tester, 'diary-destination-1');
    final calendarState = tester.state(find.byType(MonthCalendar));
    for (final dimensions in [
      const Size(844, 390),
      const Size(390, 844),
      const Size(1024, 768),
      const Size(1440, 900)
    ]) {
      tester.view.physicalSize = dimensions;
      await tester.pumpAndSettle();
      expect(tester.state(find.byType(MonthCalendar)), same(calendarState));
      expect(tester.takeException(), isNull);
    }
    await tapKey(tester, 'journal-profile');
    await tapKey(tester, 'diary-settings');
    expect(find.byKey(const ValueKey('diary-rail')), findsOneWidget);
    await tester.tap(find.text('外观'));
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
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('editor keeps its draft through rotation, saves, then deletes',
      (tester) async {
    DiaryAppHarness.size(tester, const Size(1440, 900));
    await tester.pumpWidget(harness.app(const MobileScaffold()));
    await tester.pumpAndSettle();
    await tapKey(tester, 'diary-destination-1');
    await tapKey(tester, 'diary-day-write');
    final editable = find.byType(EditableText).first;
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
            .widget<IconButton>(find.byKey(const ValueKey('entry-done')))
            .onPressed!(),
        () => EntryStore.instance.entries.isNotEmpty);
    final saved = EntryStore.instance.entries.single;
    expect(saved.text, '横屏草稿不会丢失');
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
            .widget<TextButton>(find.widgetWithText(TextButton, '删除'))
            .onPressed!(),
        () => EntryStore.instance.entries.isEmpty);
    expect(EntryStore.instance.entries, isEmpty);
    expect(find.byKey(const ValueKey('diary-rail')), findsOneWidget);
    expect(find.byKey(const ValueKey('diary-day-pane')), findsOneWidget);
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
