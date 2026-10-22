@Tags(['widget'])
library;

import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/device_info_service.dart';
import 'package:aid_diary/launch_intent.dart';
import 'package:aid_diary/pages/edit_entry_page.dart';
import 'package:aid_diary/pages/journal_page.dart';
import 'package:aid_diary/services/home_widget_service.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();
  tearDown(() => DeviceInfoService().launchIntent = null);

  testWidgets('home mood intent opens a new draft without creating writing',
      (tester) async {
    DeviceInfoService().launchIntent = const LaunchIntent.mood(2);
    DiaryAppHarness.size(tester, const Size(900, 900));
    await tester.pumpWidget(harness.app(const Scaffold(body: JournalPage())));
    await DiaryAppHarness.runUntil(tester, () {},
        () => find.byType(AddEditEntryPage).evaluate().isNotEmpty);
    expect(
        tester
            .widget<AddEditEntryPage>(find.byType(AddEditEntryPage))
            .initialMood,
        2);
    await tester.pump(const Duration(seconds: 10));
    expect(EntryStore.instance.entries, isEmpty);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('home prompt intent opens the localized prompt without saving it',
      (tester) async {
    DeviceInfoService().launchIntent = const LaunchIntent.prompt(1);
    DiaryAppHarness.size(tester, const Size(900, 900));
    await tester.pumpWidget(harness.app(const Scaffold(body: JournalPage())));
    await DiaryAppHarness.runUntil(tester, () {},
        () => find.byType(AddEditEntryPage).evaluate().isNotEmpty);
    final editor =
        tester.widget<AddEditEntryPage>(find.byType(AddEditEntryPage));
    final l =
        AppLocalizations.of(tester.element(find.byType(AddEditEntryPage)))!;
    expect(editor.template!.text, '${dailyWidgetPrompts(l)[1]}\n\n');
    await tester.pump(const Duration(seconds: 10));
    expect(EntryStore.instance.entries, isEmpty);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
