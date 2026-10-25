@Tags(['widget'])
library;

import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/pages/edit_entry_page.dart';
import 'package:aid_diary/pages/journal_page.dart';
import 'package:aid_diary/pages/settings/appearance_settings.dart';
import 'package:aid_diary/widgets/entry_text_field.dart';
import 'package:aid_diary/widgets/mood_associations_card.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();

  testWidgets('the mood associations card switches mood', (tester) async {
    final tags = await tester.runAsync(() async => {
          for (final name in ['步行', '乘车'])
            name: await TagsProvider.instance.add(Tag(
                name: name,
                tagType: TagType.label,
                timeCreate: DateTime(2026, 10),
                timeModified: DateTime(2026, 10))),
        });
    for (final (day, mood, tag) in [
      (1, 2, '步行'),
      (2, 2, '步行'),
      (3, -2, '乘车'),
      (4, -2, '乘车'),
    ]) {
      final entry = await DiaryAppHarness.addEntry(
          tester, '', DateTime(2026, 10, day),
          mood: mood);
      await tester.runAsync(() => TagsProvider.instance.addEntryTag(EntryTag(
          entryId: entry.id!,
          tagId: tags![tag]!.id!,
          timeCreate: entry.timeCreate)));
    }
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(Scaffold(
        body: SingleChildScrollView(
            child: MoodAssociationsCard(
                entries: List.of(EntryStore.instance.entries))))));
    await tester.pumpAndSettle();
    expect(find.text('步行'), findsOneWidget);
    expect(find.text('100%'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('mood-option--2')));
    await tester.pumpAndSettle();
    expect(find.text('步行'), findsNothing);
    expect(find.text('乘车'), findsOneWidget);
  });

  testWidgets('entry text follows the font size and line spacing settings',
      (tester) async {
    await DiaryAppHarness.setSetting(Settings.entryFontSize, 'large');
    await DiaryAppHarness.setSetting(Settings.entryLineSpacing, 'relaxed');
    await DiaryAppHarness.setSetting(Settings.entryFontFamily, 'serif');
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const AddEditEntryPage()));
    await tester.pumpAndSettle();
    final style = tester
        .widget<EditableText>(find.descendant(
            of: find.byType(EntryTextField),
            matching: find.byType(EditableText)))
        .style;
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
    await DiaryAppHarness.setSetting(Settings.wallpaper, 'grid');
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('wallpaper-grid')), findsOneWidget);
  });

  testWidgets('general settings offer the customize options', (tester) async {
    // Tall enough for the whole page; the list builds only what shows.
    DiaryAppHarness.size(tester, const Size(390, 2400));
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
