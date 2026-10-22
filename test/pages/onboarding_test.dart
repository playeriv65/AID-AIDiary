@Tags(['widget'])
library;

import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/storage/in_memory_file_store.dart';
import 'package:aid_diary/pages/settings/nearby_migration_settings.dart';
import 'package:aid_diary/pages/onboarding_page.dart';
import 'package:aid_diary/pages/settings/help_page.dart';
import 'package:aid_diary/sync/nearby_service.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();
  setUp(() => ImageStorage.instance
      .overrideStores(InMemoryFileStore(), InMemoryFileStore()));
  tearDown(ImageStorage.instance.clearStoreOverrides);

  testWidgets('welcome pages step through and open the app once',
      (tester) async {
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(
        harness.app(const OnboardingPage(next: Scaffold(body: Text('home')))));
    await tester.pumpAndSettle();
    expect(find.text('欢迎使用 AID Diary'), findsOneWidget);
    for (var i = 0; i < 4; i++) {
      await tester.tap(find.byKey(const ValueKey('onboard-next')));
      await tester.pumpAndSettle();
    }
    expect(find.text('准备好了'), findsOneWidget);
    expect(find.text('开始写'), findsOneWidget);
    await DiaryAppHarness.runUntil(
        tester,
        () => tester.tap(find.byKey(const ValueKey('onboard-next'))),
        () => ConfigProvider.instance.get(Settings.onboardingDone));
    EasyDebounce.cancel('save-config');
    await tester.pumpAndSettle();
    expect(find.text('home'), findsOneWidget);
    expect(ConfigProvider.instance.get(Settings.onboardingDone), isTrue);
    expect(EntryStore.instance.entries, hasLength(1));
  });

  testWidgets('skip leaves the welcome pages at once', (tester) async {
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(
        harness.app(const OnboardingPage(next: Scaffold(body: Text('home')))));
    await tester.pumpAndSettle();
    await DiaryAppHarness.runUntil(
        tester,
        () => tester.tap(find.byKey(const ValueKey('onboard-skip'))),
        () => ConfigProvider.instance.get(Settings.onboardingDone));
    EasyDebounce.cancel('save-config');
    await tester.pumpAndSettle();
    expect(find.text('home'), findsOneWidget);
  });

  testWidgets('the first welcome page opens migration with an empty diary',
      (tester) async {
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(
        harness.app(const OnboardingPage(next: Scaffold(body: Text('home')))));
    await tester.pumpAndSettle();
    expect(EntryStore.instance.entries, isEmpty);
    await tester.tap(find.byKey(const ValueKey('onboard-nearby-receive')));
    await tester.pumpAndSettle();
    expect(find.byType(NearbyMigrationSettings), findsOneWidget);
    expect(
        tester
            .widget<NearbyMigrationSettings>(
                find.byType(NearbyMigrationSettings))
            .receive,
        isTrue);
    expect(EntryStore.instance.entries, isEmpty);
    expect(ConfigProvider.instance.get(Settings.onboardingDone), isFalse);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('finishing onboarding preserves an existing diary',
      (tester) async {
    await tester.runAsync(() => EntryStore.instance.add(Entry(
        text: 'Already mine',
        timeCreate: DateTime(2026, 10, 22),
        timeModified: DateTime(2026, 10, 22))));
    await tester.pumpWidget(
        harness.app(const OnboardingPage(next: Scaffold(body: Text('home')))));
    await DiaryAppHarness.runUntil(
        tester,
        () => tester.tap(find.byKey(const ValueKey('onboard-skip'))),
        () => ConfigProvider.instance.get(Settings.onboardingDone));
    EasyDebounce.cancel('save-config');
    await tester.pumpAndSettle();
    expect(find.text('home'), findsOneWidget);
    expect(EntryStore.instance.entries.single.text, 'Already mine');
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('a completed nearby migration opens the diary directly',
      (tester) async {
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(
        harness.app(const OnboardingPage(next: Scaffold(body: Text('home')))));
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
    expect(find.text('home'), findsOneWidget);
    expect(EntryStore.instance.entries.single.text, 'Transferred diary');
    await tester.pumpWidget(const SizedBox.shrink());
    await NearbyService.instance.cancel();
  });

  testWidgets('help answers questions and leads to about', (tester) async {
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const HelpPage()));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('help-faq-0')));
    await tester.pumpAndSettle();
    expect(find.textContaining('只保存在这台设备上'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('help-about')));
    await tester.pumpAndSettle();
    expect(find.textContaining('的修改版，不是官方的'), findsOneWidget);
  });
}
