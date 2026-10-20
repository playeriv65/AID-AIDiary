@Tags(['widget'])
library;

import 'package:daily_you/config_provider.dart';
import 'package:daily_you/pages/onboarding_page.dart';
import 'package:daily_you/pages/settings/help_page.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();

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
    await tester.tap(find.byKey(const ValueKey('onboard-next')));
    await tester.pump();
    EasyDebounce.cancel('save-config');
    await tester.pumpAndSettle();
    expect(find.text('home'), findsOneWidget);
    expect(ConfigProvider.instance.get(Settings.onboardingDone), isTrue);
  });

  testWidgets('skip leaves the welcome pages at once', (tester) async {
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(
        harness.app(const OnboardingPage(next: Scaffold(body: Text('home')))));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('onboard-skip')));
    await tester.pump();
    EasyDebounce.cancel('save-config');
    await tester.pumpAndSettle();
    expect(find.text('home'), findsOneWidget);
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
    expect(find.textContaining('AID Diary · 修改版'), findsOneWidget);
  });
}
