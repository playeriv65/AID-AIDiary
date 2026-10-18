import 'package:daily_you/config_provider.dart';
import 'package:daily_you/custom_locale_delegates.dart';
import 'package:daily_you/database/app_database.dart';
import 'package:daily_you/database/entry_store.dart';
import 'package:daily_you/flashback_manager.dart';
import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/layouts/mobile_scaffold.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/pages/entries_list_page.dart';
import 'package:daily_you/providers/entries_provider.dart';
import 'package:daily_you/providers/entry_images_provider.dart';
import 'package:daily_you/providers/tags_provider.dart';
import 'package:daily_you/providers/templates_provider.dart';
import 'package:daily_you/theme_mode_provider.dart';
import 'package:daily_you/widgets/vertical_calendar.dart';
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

  Widget app(Widget child) => MultiProvider(
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
              home: child));

  void size(WidgetTester tester, Size size) {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
  }

  Future<void> openCalendar(WidgetTester tester) async {
    await tester.tap(find.byKey(const ValueKey('diary-destination-2')));
    await tester.pumpAndSettle();
  }

  testWidgets('real calendar, settings and navigation survive every layout',
      (tester) async {
    size(tester, const Size(1440, 900));
    await tester.pumpWidget(app(const MobileScaffold()));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('today-card')), findsOneWidget);
    await openCalendar(tester);
    expect(find.byKey(const ValueKey('diary-home-split')), findsOneWidget);
    final calendarState = tester.state(find.byType(VerticalCalendar));
    for (final dimensions in [
      const Size(844, 390),
      const Size(390, 844),
      const Size(1024, 768),
      const Size(1440, 900)
    ]) {
      tester.view.physicalSize = dimensions;
      await tester.pumpAndSettle();
      expect(tester.state(find.byType(VerticalCalendar)), same(calendarState));
      expect(tester.takeException(), isNull);
    }
    await tester.tap(find.byKey(const ValueKey('diary-settings')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('diary-sidebar')), findsOneWidget);
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

  testWidgets('real editor retains text on rotation and keyboard resize',
      (tester) async {
    size(tester, const Size(1440, 900));
    await tester.pumpWidget(app(const MobileScaffold()));
    await tester.pumpAndSettle();
    await openCalendar(tester);
    await tester.tap(find.byKey(const ValueKey('diary-day-write')));
    await tester.pumpAndSettle();
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
    // Complete the existing asynchronous save in real time, not fake time.
    await tester.runAsync(() async {
      tester
          .widget<IconButton>(find.byKey(const ValueKey('entry-done')))
          .onPressed!();
      for (var i = 0; i < 50 && EntryStore.instance.entries.isEmpty; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
    });
    await tester.pumpAndSettle();
    expect(EntryStore.instance.entries.single.text, '横屏草稿不会丢失');
    tester.view.viewInsets = const FakeViewPadding();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('diary-entry-edit')));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithIcon(IconButton, Icons.delete));
    await tester.pumpAndSettle();
    final delete = find.widgetWithText(TextButton, '删除');
    await tester.runAsync(() async {
      tester.widget<TextButton>(delete).onPressed!();
      for (var i = 0; i < 50 && EntryStore.instance.entries.isNotEmpty; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
    });
    await tester.pumpAndSettle();
    expect(EntryStore.instance.entries, isEmpty);
    expect(find.byKey(const ValueKey('diary-rail')), findsOneWidget);
    expect(find.byKey(const ValueKey('diary-home-split')), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
      'entry browser switches between list-detail and swipe without losing selection',
      (tester) async {
    final now = DateTime.now();
    await tester.runAsync(() async {
      await EntryStore.instance.add(
          Entry(text: '第一篇', timeCreate: now, timeModified: now),
          skipUpdate: true);
      await EntryStore.instance.add(
          Entry(
              text: '第二篇',
              timeCreate: now.subtract(const Duration(days: 1)),
              timeModified: now),
          skipUpdate: true);
    });
    size(tester, const Size(1024, 768));
    await tester.pumpWidget(app(EntriesListPage(
        index: 0, getEntries: () => EntriesProvider.instance.entries)));
    await tester.pumpAndSettle();
    final target = EntriesProvider.instance.entries.last.id;
    await tester.tap(find.byKey(ValueKey('diary-entry-row-$target')));
    await tester.pumpAndSettle();
    tester.view.physicalSize = const Size(390, 844);
    await tester.pumpAndSettle();
    expect(find.byKey(ValueKey(target)), findsOneWidget);
    tester.view.physicalSize = const Size(844, 390);
    await tester.pumpAndSettle();
    expect(find.byKey(ValueKey(target)), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
