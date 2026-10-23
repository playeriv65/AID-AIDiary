@Tags(['integration'])
library;

import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/custom_locale_delegates.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/pages/edit_entry_page.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/widgets/legacy_material_bridge.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart'
    as persian;
import 'package:provider/provider.dart';

import '../support/diary_app_harness.dart';

void main() {
  DiaryAppHarness().register();
  final store = EntryStore.instance;
  final created = DateTime(2026, 10, 21, 23, 45, 12);
  final originalDay = DateTime(2026, 10, 10);
  final selectedDay = DateTime(2026, 10, 11);

  Future<Entry> open(WidgetTester tester, String calendar,
      {double textScale = 1}) async {
    await DiaryAppHarness.setSetting(Settings.calendarSystem, calendar);
    final entry = (await tester.runAsync(() => store.add(Entry(
          text: 'Preserved diary',
          timeCreate: created,
          timeModified: created,
          day: originalDay,
          utcOffset: 330,
        ))))!;
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ConfigProvider.instance),
        ChangeNotifierProvider.value(value: TagsProvider.instance),
      ],
      child: MaterialApp(
        locale: const Locale('zh'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: [
          AppLocalizations.delegate,
          ...appLocalizationsDelegates,
        ],
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(textScale)),
          child: LegacyMaterialBridge(child: child!),
        ),
        home: Builder(builder: (context) {
          return Scaffold(
            body: FilledButton(
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                      builder: (_) => AddEditEntryPage(entry: entry))),
              child: const Text('Open editor'),
            ),
          );
        }),
      ),
    ));
    await tester.tap(find.text('Open editor'));
    await tester.pumpAndSettle();
    return entry;
  }

  for (final calendar in ['gregorian', 'jalali']) {
    testWidgets('$calendar explains diary day and preserves creation on save',
        (tester) async {
      await open(tester, calendar);
      final context = tester.element(find.byType(AddEditEntryPage));
      final l10n = AppLocalizations.of(context)!;
      final dateButton = find.byKey(const ValueKey('editor-date'));
      expect(
          find.descendant(
              of: dateButton, matching: find.text(l10n.editorDiaryDay)),
          findsOneWidget);
      expect(find.byTooltip(l10n.editorDiaryDayHint), findsOneWidget);
      await tester.tap(dateButton);
      await tester.pumpAndSettle();
      expect(find.text(l10n.editorDiaryDayPicker), findsOneWidget);

      if (calendar == 'gregorian') {
        await tester.tap(find
            .descendant(
                of: find.byType(CalendarDatePicker), matching: find.text('11'))
            .hitTestable());
      } else {
        tester
            .widget<persian.PersianCalendarDatePicker>(
                find.byType(persian.PersianCalendarDatePicker))
            .onDateChanged(persian.Jalali.fromDateTime(selectedDay));
      }
      await tester.pumpAndSettle();
      final ok = MaterialLocalizations.of(context).okButtonLabel;
      await tester.tap(find.text(ok).hitTestable());
      await tester.pumpAndSettle();
      await DiaryAppHarness.runUntil(
          tester,
          () => tester
              .widget<IconButton>(find.byKey(const ValueKey('entry-close')))
              .onPressed!(),
          () => store.entries.single.day == selectedDay);
      final saved = store.entries.single;
      expect(saved.day, selectedDay);
      expect(saved.timeCreate, created);
      expect(saved.utcOffset, 330);
      expect(saved.text, 'Preserved diary');
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }

  testWidgets('canceling the diary-day picker leaves the entry unchanged',
      (tester) async {
    final original = await open(tester, 'gregorian');
    final context = tester.element(find.byType(AddEditEntryPage));
    await tester.tap(find.byKey(const ValueKey('editor-date')));
    await tester.pumpAndSettle();
    await tester.tap(find
        .text(MaterialLocalizations.of(context).cancelButtonLabel)
        .hitTestable());
    await tester.pumpAndSettle();
    expect(store.entries.single.day, original.day);
    expect(store.entries.single.timeCreate, original.timeCreate);
    expect(store.entries.single.timeModified, original.timeModified);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('diary-day label and picker remain usable at double text size',
      (tester) async {
    await open(tester, 'gregorian', textScale: 2);
    final context = tester.element(find.byType(AddEditEntryPage));
    final l10n = AppLocalizations.of(context)!;
    expect(find.text(l10n.editorDiaryDay).hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.byKey(const ValueKey('editor-date')));
    await tester.pumpAndSettle();
    expect(find.text(l10n.editorDiaryDayPicker), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
