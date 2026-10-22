@Tags(['widget'])
library;

import 'dart:io';

import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/custom_locale_delegates.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/theme_mode_provider.dart';
import 'package:aid_diary/theme_palette.dart';
import 'package:aid_diary/widgets/theme_color_presets.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final config = ConfigProvider.instance;
  late Directory directory;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('diary_theme_test');
    config.configFilePath = '${directory.path}/config.json';
    await config.readConfig();
  });

  tearDown(() async {
    EasyDebounce.cancelAll();
    await directory.delete(recursive: true);
  });

  test('theme selection disables system color and survives config reload',
      () async {
    final provider = ThemeModeProvider();
    await provider.selectAccentColor(const Color(0xff587E64));
    await config.set(Settings.tintThemeBackground, false);
    expect(provider.usingSystemColor, isFalse);
    expect(provider.accentColor, const Color(0xff587E64));
    EasyDebounce.fire('save-config');
    final file = File(config.configFilePath);
    while (!file.existsSync()) {
      await Future<void>.delayed(Duration.zero);
    }
    await config.readConfig();
    final restored = ThemeModeProvider()..updateAccentColor();
    expect(restored.accentColor, const Color(0xff587E64));
    expect(restored.usingSystemColor, isFalse);
    expect(config.get(Settings.tintThemeBackground), isFalse);
    provider.dispose();
    restored.dispose();
  });

  for (final brightness in Brightness.values) {
    test('neutral $brightness surfaces retain accent and readable text', () {
      final original = ColorScheme.fromSeed(
          seedColor: const Color(0xff587E64), brightness: brightness);
      final neutral = neutralThemeSurfaces(original);
      expect(neutral.primary, original.primary);
      expect(neutral.onPrimary, original.onPrimary);
      expect(neutral.error, original.error);
      final theme = neutralThemeData(ThemeData(colorScheme: original));
      expect(theme.scaffoldBackgroundColor, neutral.surface);
      expect(theme.canvasColor, neutral.surface);
      expect(theme.textTheme.bodyLarge?.color, neutral.onSurface);
      for (final surface in [
        neutral.surface,
        neutral.surfaceContainerLow,
        neutral.surfaceContainerHighest
      ]) {
        final argb = surface.toARGB32();
        expect((argb >> 16) & 255, (argb >> 8) & 255);
        expect((argb >> 8) & 255, argb & 255);
        final a = surface.computeLuminance();
        final b = neutral.onSurface.computeLuminance();
        final contrast =
            (a > b ? a + .05 : b + .05) / (a > b ? b + .05 : a + .05);
        expect(contrast, greaterThanOrEqualTo(4.5));
      }
    });
  }

  test('dark palette and AMOLED choice remain independent of light mode',
      () async {
    final provider = ThemeModeProvider();
    addTearDown(provider.dispose);
    await provider.selectAccentColor(const Color(0xff587e64));
    await config.set(Settings.darkTheme, 'dark');
    await provider.selectDarkAccentColor(const Color(0xff6671b8));
    expect(provider.accentColor, const Color(0xff587e64));
    expect(provider.darkAccentColor, const Color(0xff6671b8));
    expect(provider.usingDarkSystemColor, isFalse);
    await config.set(Settings.theme, 'system');
    await config.set(Settings.darkTheme, 'amoled');
    expect(provider.themeMode, ThemeMode.system);
    expect(provider.darkIsAmoled, isTrue);
    await config.set(Settings.darkTheme, 'same');
    expect(provider.darkAccentColor, provider.accentColor);
  });

  testWidgets(
      'color presets work at mobile width without disabling system first',
      (tester) async {
    tester.view.physicalSize = const Size(360, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final provider = ThemeModeProvider();
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: config),
        ChangeNotifierProvider.value(value: provider),
      ],
      child: MaterialApp(
        locale: const Locale('zh'),
        localizationsDelegates: [
          AppLocalizations.delegate,
          ...appLocalizationsDelegates
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
            body: SingleChildScrollView(child: ThemeColorPresets())),
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.text('主题色'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('theme-color-brown')));
    await tester.pumpAndSettle();
    expect(config.get(Settings.followSystemColor), isFalse);
    expect(config.get(Settings.accentColor), 0xff967A5E);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    EasyDebounce.cancel('save-config');
    provider.dispose();
  });
  testWidgets('dark palette preview and selection stay independent of light',
      (tester) async {
    await config.set(Settings.followSystemColor, false);
    await config.set(Settings.accentColor, 0xff587e64);
    await config.set(Settings.darkTheme, 'dark');
    await config.set(Settings.darkFollowSystemColor, false);
    await config.set(Settings.darkAccentColor, 0xff8f6caf);
    final provider = ThemeModeProvider()..updateAccentColor();
    await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: config),
          ChangeNotifierProvider.value(value: provider),
        ],
        child: MaterialApp(
            theme: ThemeData(
                colorScheme:
                    ColorScheme.fromSeed(seedColor: provider.accentColor)),
            locale: const Locale('zh'),
            localizationsDelegates: [
              AppLocalizations.delegate,
              ...appLocalizationsDelegates
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: const Scaffold(
                body: SingleChildScrollView(
                    child: ThemeColorPresets(dark: true))))));
    await tester.pumpAndSettle();
    final preview =
        tester.element(find.byKey(const ValueKey('dark-theme-preview')));
    expect(Theme.of(preview).brightness, Brightness.dark);
    expect(
        Theme.of(preview).colorScheme.primary,
        ColorScheme.fromSeed(
                seedColor: provider.darkAccentColor,
                brightness: Brightness.dark)
            .primary);
    await tester.tap(find.byKey(const ValueKey('dark-theme-color-brown')));
    await tester.pump();
    EasyDebounce.cancel('save-config');
    await tester.pumpAndSettle();
    expect(config.get(Settings.darkAccentColor), 0xff967a5e);
    expect(config.get(Settings.accentColor), 0xff587e64);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    provider.dispose();
  });
}
