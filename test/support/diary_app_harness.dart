import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/custom_locale_delegates.dart';
import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/flashback_manager.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/providers/templates_provider.dart';
import 'package:aid_diary/theme_mode_provider.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'config_provider_harness.dart';

/// Real providers over an in-memory SQLite database, reset per test.
class DiaryAppHarness {
  late Database database;
  late ThemeModeProvider theme;

  void register() {
    TestWidgetsFlutterBinding.ensureInitialized();
    useTemporaryConfig();
    setUpAll(() async {
      sqfliteFfiInit();
      await initializeDateFormatting();
      await AppConfig.load();
    });
    setUp(() async {
      // No position in tests: location services read as off, so a lookup
      // fails at once instead of waiting on a platform that never answers.
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
              const MethodChannel('flutter.baseflow.com/geolocator'),
              (call) async =>
                  call.method == 'isLocationServiceEnabled' ? false : null);
      databaseFactory = databaseFactoryFfi;
      database = await databaseFactory.openDatabase(inMemoryDatabasePath);
      AppDatabase.instance.database = database;
      await AppDatabase.instance.createSchema(database);
      await EntryStore.instance.load();
      await EntryImagesProvider.instance.load();
      await TagsProvider.instance.load();
      // Includes the favorite tag that backs the star.
      await TagsProvider.instance.createDefaultTags();
      await TemplatesProvider.instance.load();
      await FlashbackManager.init();
      theme = ThemeModeProvider();
    });
    tearDown(() async {
      theme.dispose();
      AppDatabase.instance.database = null;
      await database.close();
    });
  }

  Widget app(Widget child, {ThemeData? themeData}) => MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: ConfigProvider.instance),
            ChangeNotifierProvider.value(value: EntriesProvider.instance),
            ChangeNotifierProvider.value(value: EntryImagesProvider.instance),
            ChangeNotifierProvider.value(value: TagsProvider.instance),
            ChangeNotifierProvider.value(value: TemplatesProvider.instance),
            ChangeNotifierProvider.value(value: theme),
          ],
          child: MaterialApp(
              theme: themeData,
              locale: const Locale('zh'),
              localizationsDelegates: [
                AppLocalizations.delegate,
                ...appLocalizationsDelegates
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              home: child));

  /// Sizes the view; [systemBars] are the status and gesture bar heights a
  /// phone keeps clear.
  static void size(WidgetTester tester, Size size,
      {({double top, double bottom}) systemBars = (top: 0, bottom: 0)}) {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    final padding =
        FakeViewPadding(top: systemBars.top, bottom: systemBars.bottom);
    tester.view.padding = padding;
    tester.view.viewPadding = padding;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetPadding);
    addTearDown(tester.view.resetViewPadding);
  }

  /// Switches destination with whichever navigation the size shows.
  static Future<void> goTo(WidgetTester tester, int index) async {
    final bar = find.byKey(const ValueKey('diary-bottom-navigation'));
    if (bar.evaluate().isNotEmpty) {
      await tester.tap(find
          .descendant(of: bar, matching: find.byType(NavigationDestination))
          .at(index));
    } else {
      final item = find.byKey(ValueKey('diary-destination-$index'));
      await tester.ensureVisible(item);
      await tester.pumpAndSettle();
      await tester.tap(item);
    }
    await tester.pumpAndSettle();
  }

  /// Adds an entry through the store, outside fake async time.
  static Future<Entry> addEntry(WidgetTester tester, String text, DateTime time,
      {int? mood,
      EntryLocation? location,
      EntryWeather? weather,
      EntryActivity? activity}) async {
    return (await tester.runAsync(() => EntryStore.instance.add(Entry(
        text: text,
        mood: mood,
        timeCreate: time,
        timeModified: time,
        location: location,
        weather: weather,
        activity: activity))))!;
  }

  /// Changes a setting in memory. The debounced file write is dropped: run
  /// for real it can outlive the test and lock its temporary config folder.
  static Future<void> setSetting<T>(Setting<T> setting, T value) async {
    await ConfigProvider.instance.set(setting, value);
    EasyDebounce.cancel('save-config');
  }

  /// Lets real time pass between frames until [until] holds, for work that
  /// started in a widget (fake time) but waits on real IO such as SQLite.
  static Future<void> pumpUntil(
      WidgetTester tester, bool Function() until) async {
    for (var i = 0; i < 50 && !until(); i++) {
      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 20)));
      await tester.pump(const Duration(milliseconds: 50));
    }
    await tester.pumpAndSettle();
  }

  /// Runs a real async action and waits until [until] holds.
  static Future<void> runUntil(
      WidgetTester tester, VoidCallback action, bool Function() until) async {
    await tester.runAsync(() async {
      action();
      for (var i = 0; i < 50 && !until(); i++) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
    });
    await tester.pumpAndSettle();
  }
}
