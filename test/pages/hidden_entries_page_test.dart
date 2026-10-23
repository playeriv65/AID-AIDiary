// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['integration'])
library;

import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/custom_locale_delegates.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/pages/hidden_entries_page.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/providers/templates_provider.dart';
import 'package:aid_diary/widgets/legacy_material_bridge.dart';
import 'package:aid_diary/widgets/scaled_markdown.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../support/diary_app_harness.dart';

void main() {
  DiaryAppHarness().register();
  var authenticated = false;
  var prompts = 0;
  var screenLockAllowed = false;

  setUp(() {
    authenticated = false;
    prompts = 0;
    screenLockAllowed = false;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/local_auth'), (call) async {
      if (call.method == 'authenticate') {
        prompts++;
        screenLockAllowed = (call.arguments as Map)['biometricOnly'] == false;
        return authenticated;
      }
      return null;
    });
  });

  Future<Entry> open(WidgetTester tester) async {
    DiaryAppHarness.size(tester, const Size(390, 844));
    final time = DateTime(2026, 10, 20, 9);
    final entry = (await tester.runAsync(() => EntryStore.instance.add(Entry(
        text: '# Private title\nPrivate body',
        timeCreate: time,
        timeModified: time,
        isHidden: true))))!;
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ConfigProvider.instance),
        ChangeNotifierProvider.value(value: EntriesProvider.instance),
        ChangeNotifierProvider.value(value: EntryImagesProvider.instance),
        ChangeNotifierProvider.value(value: TagsProvider.instance),
        ChangeNotifierProvider.value(value: TemplatesProvider.instance),
      ],
      child: MaterialApp(
        locale: const Locale('zh'),
        localizationsDelegates: [
          AppLocalizations.delegate,
          ...appLocalizationsDelegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (_, child) => LegacyMaterialBridge(child: child!),
        home: const HiddenEntriesPage(),
      ),
    ));
    await tester.pumpAndSettle();
    return entry;
  }

  testWidgets('opening the section never reveals content before local auth',
      (tester) async {
    await open(tester);
    expect(find.text('Private title'), findsNothing);
    expect(prompts, 0);
    await tester.tap(find.byKey(const ValueKey('hidden-unlock')));
    await tester.pumpAndSettle();
    expect(prompts, 1);
    expect(screenLockAllowed, isTrue);
    expect(find.text('Private title'), findsNothing);
    expect(EntriesProvider.instance.entries, isEmpty);
  });

  testWidgets('local auth reveals only the section and relocks its reader',
      (tester) async {
    final entry = await open(tester);
    authenticated = true;
    await tester.tap(find.byKey(const ValueKey('hidden-unlock')));
    await DiaryAppHarness.pumpUntil(
        tester, () => find.text('Private title').evaluate().isNotEmpty);
    expect(find.text('Private title'), findsOneWidget);
    expect(EntriesProvider.instance.entries, isEmpty);

    await tester.tap(find.byKey(ValueKey('hidden-entry-${entry.id}')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(ScaledMarkdown), findsOneWidget);
    expect(find.byKey(const ValueKey('entry-share')), findsNothing);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pumpAndSettle();
    expect(find.byType(ScaledMarkdown), findsNothing);
    expect(find.text('Private title'), findsNothing);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(find.byType(ScaledMarkdown), findsNothing);
    Navigator.of(tester.element(find.byType(Scaffold).last)).pop();
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('hidden-unlock')), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester
        .runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
  });

  testWidgets('unhide requires the local section and restores normal views',
      (tester) async {
    final entry = await open(tester);
    authenticated = true;
    await tester.tap(find.byKey(const ValueKey('hidden-unlock')));
    await DiaryAppHarness.pumpUntil(
        tester, () => find.text('Private title').evaluate().isNotEmpty);
    await tester.tap(find.byKey(ValueKey('hidden-entry-${entry.id}')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('entry-more')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('entry-hide')));
    await DiaryAppHarness.pumpUntil(
        tester, () => EntryStore.instance.entries.isNotEmpty);
    expect(EntryStore.instance.entries.single.isHidden, isFalse);
    expect(EntryStore.instance.entries.single.text, contains('Private body'));
    expect(find.byKey(ValueKey('hidden-entry-${entry.id}')), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester
        .runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
  });
}
