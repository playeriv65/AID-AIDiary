import 'package:daily_you/config_provider.dart';
import 'package:daily_you/custom_locale_delegates.dart';
import 'package:daily_you/database/app_database.dart';
import 'package:daily_you/database/entry_store.dart';
import 'package:daily_you/flashback_manager.dart';
import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/layouts/mobile_scaffold.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/providers/entries_provider.dart';
import 'package:daily_you/providers/entry_images_provider.dart';
import 'package:daily_you/providers/tags_provider.dart';
import 'package:daily_you/providers/templates_provider.dart';
import 'package:daily_you/theme_mode_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../support/config_provider_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  useTemporaryConfig();
  late Database database;
  late ThemeModeProvider theme;

  setUpAll(() async {
    sqfliteFfiInit();
    await initializeDateFormatting();
  });
  setUp(() async {
    databaseFactory = databaseFactoryFfi;
    database = await databaseFactory.openDatabase(inMemoryDatabasePath);
    AppDatabase.instance.database = database;
    await AppDatabase.instance.createSchema(database);
    await EntryStore.instance.load();
    await EntryImagesProvider.instance.load();
    await TagsProvider.instance.load();
    await TemplatesProvider.instance.load();
    await FlashbackManager.init();
    theme = ThemeModeProvider();
  });
  tearDown(() async {
    theme.dispose();
    AppDatabase.instance.database = null;
    await database.close();
  });

  Widget app() => MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: ConfigProvider.instance),
            ChangeNotifierProvider.value(value: EntriesProvider.instance),
            ChangeNotifierProvider.value(value: EntryImagesProvider.instance),
            ChangeNotifierProvider.value(value: TagsProvider.instance),
            ChangeNotifierProvider.value(value: TemplatesProvider.instance),
            ChangeNotifierProvider.value(value: theme),
          ],
          child: MaterialApp(
              locale: const Locale('zh'),
              localizationsDelegates: [
                AppLocalizations.delegate,
                ...appLocalizationsDelegates
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              home: const MobileScaffold()));

  void size(WidgetTester tester, Size size) {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
  }

  Future<void> addEntry(WidgetTester tester, String text, DateTime time,
      {int? mood}) async {
    await tester.runAsync(() => EntryStore.instance.add(
        Entry(text: text, mood: mood, timeCreate: time, timeModified: time)));
  }

  Future<void> pressDone(WidgetTester tester, bool Function() until) async {
    await tester.runAsync(() async {
      tester
          .widget<IconButton>(find.byKey(const ValueKey('entry-done')))
          .onPressed!();
      for (var i = 0; i < 50 && !until(); i++) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
    });
    await tester.pumpAndSettle();
  }

  for (final dimensions in [
    const Size(360, 800),
    const Size(844, 390),
    const Size(1440, 900),
  ]) {
    testWidgets('today page lays out without overflow at $dimensions',
        (tester) async {
      final now = DateTime.now();
      await addEntry(tester, '# 早晨\n喝了咖啡', now, mood: 1);
      await addEntry(tester, '昨天的事', now.subtract(const Duration(days: 1)));
      size(tester, dimensions);
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('today-card')), findsOneWidget);
      expect(find.byKey(const ValueKey('today-continue')), findsOneWidget);
      expect(find.text('连续 2 天'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }

  testWidgets('quick mood starts an entry that keeps the mood', (tester) async {
    size(tester, const Size(1440, 900));
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('today-mood-2')));
    await tester.pumpAndSettle();
    await pressDone(tester, () => EntryStore.instance.entries.isNotEmpty);
    expect(EntryStore.instance.entries.single.mood, 2);
    expect(find.byKey(const ValueKey('today-continue')), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('an unanswered prompt is not saved', (tester) async {
    size(tester, const Size(1440, 900));
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('today-prompt-write')));
    await tester.pumpAndSettle();
    final editable = find.byType(EditableText).first;
    expect(tester.widget<EditableText>(editable).controller.text,
        startsWith('## '));
    await pressDone(tester, () => false);
    expect(EntryStore.instance.entries, isEmpty);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('journal groups entries under month headers', (tester) async {
    final now = DateTime.now();
    final lastMonth = DateTime(now.year, now.month - 1, 10, 9);
    await addEntry(tester, '本月的一篇', now);
    await addEntry(tester, '上个月的一篇', lastMonth);
    size(tester, const Size(1440, 900));
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('diary-destination-1')));
    await tester.pumpAndSettle();
    expect(find.textContaining('1/${now.day} 天有记录'), findsOneWidget);
    final daysLastMonth = DateTime(now.year, now.month, 0).day;
    expect(find.textContaining('1/$daysLastMonth 天有记录'), findsOneWidget);
    final older = EntryStore.instance.entries.last;
    await tester.tap(find.byKey(ValueKey('journal-entry-${older.id}')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('diary-entry-edit')), findsWidgets);
    expect(find.text('上个月的一篇'), findsWidgets);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
