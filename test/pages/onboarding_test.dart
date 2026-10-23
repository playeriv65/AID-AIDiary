@Tags(['widget'])
library;

import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/pages/onboarding_page.dart';
import 'package:aid_diary/pages/tutorial_page.dart';
import 'package:aid_diary/pages/settings/nearby_migration_settings.dart';
import 'package:aid_diary/pages/settings/help_page.dart';
import 'package:aid_diary/pages/settings_page.dart';
import 'package:aid_diary/sync/nearby_service.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();
  const firstRun = OnboardingPage(next: Scaffold(body: Text('home')));

  Future<void> finish(WidgetTester tester) async {
    await DiaryAppHarness.runUntil(
        tester,
        () => tester.tap(find.byKey(const ValueKey('tutorial-start'))),
        () => ConfigProvider.instance.get(Settings.onboardingDone));
    EasyDebounce.cancel('save-config');
    await tester.pumpAndSettle();
    expect(find.text('home'), findsOneWidget);
  }

  testWidgets(
      'first launch chooses a new start, reads the tutorial and opens the diary',
      (tester) async {
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(firstRun));
    expect(find.text('从这里开始'), findsOneWidget);
    expect(find.text('连接已有设备'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('onboard-new-diary')));
    await tester.pumpAndSettle();
    expect(find.byType(TutorialPage), findsOneWidget);
    expect(find.text('写下第一篇日记'), findsOneWidget);
    expect(ConfigProvider.instance.get(Settings.onboardingDone), isFalse);
    await finish(tester);
    expect(ConfigProvider.instance.get(Settings.onboardingDone), isTrue);
  });

  testWidgets(
      'back from the tutorial lets the user choose device authorization',
      (tester) async {
    await tester.pumpWidget(harness.app(firstRun));
    await tester.tap(find.byKey(const ValueKey('onboard-new-diary')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('tutorial-back')));
    await tester.pumpAndSettle();
    expect(
        find.byKey(const ValueKey('onboard-nearby-receive')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('onboard-new-diary')));
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('onboard-new-diary')), findsOneWidget);
    expect(ConfigProvider.instance.get(Settings.onboardingDone), isFalse);
  });

  testWidgets(
      'connection opens receiving mode and cancellation leaves setup unfinished',
      (tester) async {
    await tester.pumpWidget(harness.app(firstRun));
    await tester.tap(find.byKey(const ValueKey('onboard-nearby-receive')));
    await tester.pumpAndSettle();
    expect(
        tester
            .widget<NearbyMigrationSettings>(
                find.byType(NearbyMigrationSettings))
            .receive,
        isTrue);
    expect(EntryStore.instance.entries, isEmpty);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('onboard-new-diary')), findsOneWidget);
    expect(ConfigProvider.instance.get(Settings.onboardingDone), isFalse);
    await NearbyService.instance.cancel();
  });

  testWidgets('finishing setup preserves writing already saved on this device',
      (tester) async {
    await tester.runAsync(() => EntryStore.instance.add(Entry(
        text: 'Already mine',
        timeCreate: DateTime(2026, 10, 22),
        timeModified: DateTime(2026, 10, 22))));
    final id = EntryStore.instance.entries.single.id;
    await tester.pumpWidget(harness.app(firstRun));
    await tester.tap(find.byKey(const ValueKey('onboard-new-diary')));
    await tester.pumpAndSettle();
    await finish(tester);
    expect(EntryStore.instance.entries.single.text, 'Already mine');
    expect(EntryStore.instance.entries.single.id, id);
  });

  testWidgets(
      'completed device authorization opens the synchronized diary directly',
      (tester) async {
    await tester.pumpWidget(harness.app(firstRun));
    await tester.tap(find.byKey(const ValueKey('onboard-nearby-receive')));
    await tester.pumpAndSettle();
    await tester.runAsync(() => EntryStore.instance.add(Entry(
        text: 'Transferred diary',
        timeCreate: DateTime(2026, 10, 22),
        timeModified: DateTime(2026, 10, 22))));
    NearbyService.instance.state = NearbyState.complete;
    NearbyService.instance.notifyListeners();
    await tester.pumpAndSettle();
    await DiaryAppHarness.runUntil(
        tester,
        () => tester.tap(find.byKey(const ValueKey('nearby-done'))),
        () => ConfigProvider.instance.get(Settings.onboardingDone));
    EasyDebounce.cancel('save-config');
    await DiaryAppHarness.pumpUntil(
        tester, () => find.text('home').evaluate().isNotEmpty);
    EasyDebounce.cancel('save-config');
    expect(EntryStore.instance.entries.single.text, 'Transferred diary');
    await tester.pumpWidget(const SizedBox.shrink());
    await NearbyService.instance.cancel();
  });

  testWidgets(
      'settings reopens the same tutorial without changing setup or diary state',
      (tester) async {
    await DiaryAppHarness.setSetting(Settings.onboardingDone, true);
    await tester.runAsync(() => EntryStore.instance.add(Entry(
        text: 'My edited entry',
        timeCreate: DateTime(2026),
        timeModified: DateTime(2026))));
    final id = EntryStore.instance.entries.single.id;
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const SettingsPage()));
    await tester.scrollUntilVisible(find.text('使用教程'), 250);
    await tester.tap(find.text('使用教程'));
    await tester.pumpAndSettle();
    expect(find.byType(TutorialPage), findsOneWidget);
    expect(find.text('写下第一篇日记'), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsPage), findsOneWidget);
    expect(ConfigProvider.instance.get(Settings.onboardingDone), isTrue);
    expect(EntryStore.instance.entries.single.id, id);
    expect(EntryStore.instance.entries.single.text, 'My edited entry');
  });

  testWidgets(
      'choices and tutorial remain usable on a small screen with large text',
      (tester) async {
    DiaryAppHarness.size(tester, const Size(320, 600));
    await tester.pumpWidget(harness.app(const MediaQuery(
        data: MediaQueryData(
            size: Size(320, 600), textScaler: TextScaler.linear(2)),
        child: firstRun)));
    await tester.ensureVisible(find.byKey(const ValueKey('onboard-new-diary')));
    await tester.tap(find.byKey(const ValueKey('onboard-new-diary')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('tutorial-start')), findsOneWidget);
    expect(tester.takeException(), isNull);
    await finish(tester);
  });

  testWidgets('help answers questions and leads to about', (tester) async {
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const HelpPage()));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('help-faq-0')));
    await tester.pumpAndSettle();
    expect(find.textContaining('默认保存在这台设备上'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('help-about')));
    await tester.pumpAndSettle();
    expect(find.textContaining('的修改版，不是官方的'), findsOneWidget);
  });
}
