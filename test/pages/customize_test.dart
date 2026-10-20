import 'package:daily_you/config_provider.dart';
import 'package:daily_you/database/entry_store.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/pages/edit_entry_page.dart';
import 'package:daily_you/pages/journal_page.dart';
import 'package:daily_you/pages/settings/appearance_settings.dart';
import 'package:daily_you/stats/entry_stats.dart';
import 'package:daily_you/widgets/mood_associations_card.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

Entry _entry(int id, int? mood, EntryActivity? activity) => Entry(
    id: id,
    text: '',
    mood: mood,
    activity: activity,
    timeCreate: DateTime(2026, 10, id),
    timeModified: DateTime(2026, 10, id));

void main() {
  final harness = DiaryAppHarness()..register();

  test('moodAssociations ranks factors by how often they had the mood', () {
    final entries = [
      _entry(1, 2, EntryActivity.walking),
      _entry(2, 2, EntryActivity.walking),
      _entry(3, 2, EntryActivity.vehicle),
      _entry(4, -2, EntryActivity.vehicle),
      _entry(5, -2, EntryActivity.vehicle),
      _entry(6, 2, EntryActivity.flying), // seen once: too little to say
      _entry(7, null, EntryActivity.walking), // unrated: ignored
    ];
    final happy =
        moodAssociations(entries, 2, (e) => [if (e.activity case final a?) a]);
    expect(happy, [
      (factor: EntryActivity.walking, matching: 2, total: 2),
      (factor: EntryActivity.vehicle, matching: 1, total: 3),
    ]);
    final sad =
        moodAssociations(entries, -2, (e) => [if (e.activity case final a?) a]);
    expect(sad.single.factor, EntryActivity.vehicle);
  });

  testWidgets('the mood associations card switches mood', (tester) async {
    for (final (day, mood, activity) in [
      (1, 2, EntryActivity.walking),
      (2, 2, EntryActivity.walking),
      (3, -2, EntryActivity.vehicle),
      (4, -2, EntryActivity.vehicle),
    ]) {
      await DiaryAppHarness.addEntry(tester, '', DateTime(2026, 10, day),
          mood: mood, activity: activity);
    }
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(Scaffold(
        body: SingleChildScrollView(
            child: MoodAssociationsCard(
                entries: List.of(EntryStore.instance.entries))))));
    await tester.pumpAndSettle();
    expect(find.text('步行'), findsOneWidget);
    expect(find.text('100%'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('mood-associations--2')));
    await tester.pumpAndSettle();
    expect(find.text('步行'), findsNothing);
    expect(find.text('乘车'), findsOneWidget);
  });

  testWidgets('entry text follows the font size and line spacing settings',
      (tester) async {
    await tester.runAsync(() async {
      await ConfigProvider.instance.set(Settings.entryFontSize, 'large');
      await ConfigProvider.instance.set(Settings.entryLineSpacing, 'relaxed');
      await ConfigProvider.instance.set(Settings.entryFontFamily, 'serif');
    });
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const AddEditEntryPage()));
    await tester.pumpAndSettle();
    final style =
        tester.widget<EditableText>(find.byType(EditableText).first).style;
    expect(style.fontSize, 18);
    expect(style.height, 1.8);
    expect(style.fontFamilyFallback, contains('serif'));
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('a pattern wallpaper sits behind the journal list',
      (tester) async {
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const Scaffold(body: JournalPage())));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('wallpaper-grid')), findsNothing);
    await tester.runAsync(
        () => ConfigProvider.instance.set(Settings.wallpaper, 'grid'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('wallpaper-grid')), findsOneWidget);
  });

  testWidgets('general settings offer the customize options', (tester) async {
    DiaryAppHarness.size(tester, const Size(390, 1400));
    await tester.pumpWidget(harness.app(const AppearanceSettings()));
    await tester.pumpAndSettle();
    for (final key in [
      'settings-wallpaper',
      'settings-font-family',
      'settings-font-size',
      'settings-line-spacing'
    ]) {
      expect(find.byKey(ValueKey(key)), findsOneWidget, reason: key);
    }
    await tester.tap(find.text('中'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('特大').last);
    await tester.pumpAndSettle();
    expect(ConfigProvider.instance.get(Settings.entryFontSize), 'extraLarge');
    // The file write is not under test; drop its fake-async timer.
    EasyDebounce.cancel('save-config');
  });
}
