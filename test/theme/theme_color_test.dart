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
}
