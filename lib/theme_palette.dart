import 'package:material_ui/material_ui.dart';

/// Keep accent/error pairs intact while removing hue from background surfaces.
ColorScheme neutralThemeSurfaces(ColorScheme scheme) {
  final neutral = ColorScheme.fromSeed(
    seedColor: const Color(0xff808080),
    brightness: scheme.brightness,
    dynamicSchemeVariant: DynamicSchemeVariant.monochrome,
  );
  return scheme.copyWith(
    surface: neutral.surface,
    surfaceDim: neutral.surfaceDim,
    surfaceBright: neutral.surfaceBright,
    surfaceContainerLowest: neutral.surfaceContainerLowest,
    surfaceContainerLow: neutral.surfaceContainerLow,
    surfaceContainer: neutral.surfaceContainer,
    surfaceContainerHigh: neutral.surfaceContainerHigh,
    surfaceContainerHighest: neutral.surfaceContainerHighest,
    onSurface: neutral.onSurface,
    onSurfaceVariant: neutral.onSurfaceVariant,
    outline: neutral.outline,
    outlineVariant: neutral.outlineVariant,
    inverseSurface: neutral.inverseSurface,
    onInverseSurface: neutral.onInverseSurface,
    surfaceTint: neutral.surfaceTint,
  );
}

ThemeData neutralThemeData(ThemeData theme) {
  final scheme = neutralThemeSurfaces(theme.colorScheme);
  return theme.copyWith(
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    canvasColor: scheme.surface,
    cardColor: scheme.surfaceContainerLow,
    dividerColor: scheme.outlineVariant,
    textTheme: theme.textTheme.apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    ),
  );
}
