// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'dart:io';

import 'package:aid_diary/actions/agent_api.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/widgets/back_gesture_transition.dart';
import 'package:aid_diary/widgets/windows_wheel_scroll.dart';
import 'package:aid_diary/custom_locale_delegates.dart';
import 'package:aid_diary/device_info_service.dart';
import 'package:aid_diary/flashback_manager.dart';
import 'package:aid_diary/notification_manager.dart';
import 'package:aid_diary/pages/launch_page.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/providers/templates_provider.dart';
import 'package:aid_diary/utils/logging.dart';
import 'package:aid_diary/utils/scratch_folders.dart';
import 'package:aid_diary/widgets/legacy_material_bridge.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:material_ui/material_ui.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/l10n/locale_resolution.dart';
import 'package:aid_diary/background/background_work.dart';
import 'package:aid_diary/layouts/mobile_scaffold.dart';
import 'package:aid_diary/routing/route_names.dart';
import 'package:aid_diary/theme_mode_provider.dart';
import 'package:aid_diary/theme_palette.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:statsfl/statsfl.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

void main() async {
  if (Platform.isLinux || Platform.isWindows) {
    // Initialize FFI
    sqfliteFfiInit();
  }
  databaseFactory = databaseFactoryFfi;
  WidgetsFlutterBinding.ensureInitialized();
  if (AppActions.instance.devBuild) await useScratchFolders();

  configureLogging();

  // The config file, the platform's key stores and the device details are
  // all slow to open and independent, so they load side by side.
  await Future.wait([
    ConfigProvider.instance.init(),
    DeviceInfoService().init(),
  ]);

  // Load any cached flashbacks
  await AppConfig.load();
  EntryStore.instance.applyDiaryDaySettings();
  await FlashbackManager.init();

  final themeProvider = ThemeModeProvider();
  await themeProvider.initializeThemeFromConfig();

  // Notification only supported on android
  if (Platform.isAndroid) {
    await FlutterDisplayMode.setHighRefreshRate();
    await NotificationManager.instance.init();

    if (scratchFolder == null) {
      await recordAlarmDispatcher();
      await Workmanager().initialize(autoBackupCallbackDispatcher);
      await armAutoBackupWork();
    }
  }

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<ThemeModeProvider>(
      create: (_) => themeProvider,
    ),
    ChangeNotifierProvider<EntriesProvider>(
      create: (_) => EntriesProvider.instance,
    ),
    ChangeNotifierProvider<EntryImagesProvider>(
      create: (_) => EntryImagesProvider.instance,
    ),
    ChangeNotifierProvider<TemplatesProvider>(
      create: (_) => TemplatesProvider.instance,
    ),
    ChangeNotifierProvider<TagsProvider>(
      create: (_) => TagsProvider.instance,
    ),
    ChangeNotifierProvider<ConfigProvider>(
      create: (_) => ConfigProvider.instance,
    )
  ], builder: (context, child) => const MainApp()));

  // After the first frame is on its way; the command line can wait that long.
  unawaited(AgentApiSwitch.instance.apply());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    final themeModeProvider = Provider.of<ThemeModeProvider>(context);
    final configProvider = Provider.of<ConfigProvider>(context);
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      ThemeData lightTheme;
      ThemeData darkTheme;

      if (themeModeProvider.usingSystemColor && lightDynamic != null) {
        // FIX: Surface colors are not correct with the dynamic theme, see https://github.com/material-foundation/flutter-packages/issues/574
        // Use dynamic theme for seed color but do not inject chroma
        bool noChroma = (lightDynamic.primary.r == lightDynamic.primary.b) &&
            (lightDynamic.primary.b == lightDynamic.primary.g);
        lightTheme = ThemeData(
            useMaterial3: true,
            materialTapTargetSize: MaterialTapTargetSize.padded,
            colorScheme: ColorScheme.fromSeed(
                seedColor: lightDynamic.primary,
                primaryContainer: lightDynamic.primaryContainer,
                dynamicSchemeVariant: noChroma
                    ? DynamicSchemeVariant.fidelity
                    : DynamicSchemeVariant.tonalSpot,
                brightness: Brightness.light));
      } else {
        lightTheme = ThemeData(
            useMaterial3: true,
            materialTapTargetSize: MaterialTapTargetSize.padded,
            colorScheme: ColorScheme.fromSeed(
                seedColor: themeModeProvider.accentColor,
                brightness: Brightness.light));
      }

      if (themeModeProvider.usingDarkSystemColor && darkDynamic != null) {
        // FIX: Surface colors are not correct with the dynamic theme, see https://github.com/material-foundation/flutter-packages/issues/574
        // Use dynamic theme for seed color but do not inject chroma
        bool noChroma = (darkDynamic.primary.r == darkDynamic.primary.b) &&
            (darkDynamic.primary.b == darkDynamic.primary.g);
        darkTheme = ThemeData(
            useMaterial3: true,
            materialTapTargetSize: MaterialTapTargetSize.padded,
            colorScheme: ColorScheme.fromSeed(
                seedColor: darkDynamic.primary,
                primaryContainer: darkDynamic.primaryContainer,
                dynamicSchemeVariant: noChroma
                    ? DynamicSchemeVariant.fidelity
                    : DynamicSchemeVariant.tonalSpot,
                brightness: Brightness.dark));
      } else {
        darkTheme = ThemeData(
          useMaterial3: true,
          materialTapTargetSize: MaterialTapTargetSize.padded,
          colorScheme: ColorScheme.fromSeed(
              seedColor: themeModeProvider.darkAccentColor,
              brightness: Brightness.dark),
        );
      }

      if (!configProvider.get(Settings.tintThemeBackground)) {
        lightTheme = neutralThemeData(lightTheme);
        darkTheme = neutralThemeData(darkTheme);
      }

      // amoled override
      if (themeModeProvider.darkIsAmoled) {
        darkTheme = ThemeData(
            useMaterial3: true,
            materialTapTargetSize: MaterialTapTargetSize.padded,
            colorScheme: ColorScheme.fromSeed(
              seedColor: themeModeProvider.darkAccentColor,
              brightness: Brightness.dark,
              surfaceContainerLowest: Colors.black,
              surfaceContainerLow: Colors.black,
              surfaceContainerHighest: Colors.black,
              surfaceContainerHigh: Colors.black,
              surfaceBright: Colors.black,
              surfaceDim: Colors.black,
              surface: Colors.black,
              surfaceContainer: Colors.black,
              onSurface: Colors.white,
              surfaceTint: Colors.black,
              primaryContainer: Colors.black,
              secondaryContainer: Colors.black,
              tertiaryContainer: Colors.black,
              inverseSurface: Colors.black,
              inversePrimary: Colors.black,
              scrim: Colors.black,
            ),
            scaffoldBackgroundColor: Colors.black);
      }

      // The back gesture follows the finger and fades out at its own pace.
      const transitions = PageTransitionsTheme(builders: {
        TargetPlatform.android: DiaryPageTransitionsBuilder(),
        TargetPlatform.windows: WindowsWheelPageTransitionsBuilder(),
      });
      lightTheme = lightTheme.copyWith(pageTransitionsTheme: transitions);
      darkTheme = darkTheme.copyWith(pageTransitionsTheme: transitions);

      return StatsFl(
        isEnabled: false,
        child: GestureDetector(
            onTap: Platform.isAndroid
                ? () => FocusManager.instance.primaryFocus
                    ?.unfocus(disposition: UnfocusDisposition.scope)
                : null,
            child: MaterialApp(
                onGenerateTitle: (context) =>
                    AppLocalizations.of(context)!.appTitle,
                themeMode: themeModeProvider.themeMode,
                debugShowCheckedModeBanner: false,
                localizationsDelegates: <LocalizationsDelegate<dynamic>>[
                  AppLocalizations.delegate,
                  ...appLocalizationsDelegates,
                ],
                locale: configProvider.getOverrideLanguage(),
                supportedLocales: appSupportedLocales,
                localeListResolutionCallback: resolveAppLocale,
                theme: lightTheme,
                darkTheme: darkTheme,
                builder: (context, child) => MediaQuery(
                    // Every time label reads this, so the setting applies
                    // app wide.
                    data: MediaQuery.of(context).copyWith(
                        alwaysUse24HourFormat:
                            configProvider.chosen24HourFormat ??
                                MediaQuery.of(context).alwaysUse24HourFormat),
                    child: LegacyMaterialBridge(child: child!)),
                navigatorObservers: [rootRoutes],
                home: const LaunchPage(nextPage: MobileScaffold()))),
      );
    });
  }
}
