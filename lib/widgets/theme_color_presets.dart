import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/theme_mode_provider.dart';
import 'package:aid_diary/theme_palette.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

class ThemeColorPresets extends StatelessWidget {
  const ThemeColorPresets({super.key, this.dark = false});
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<ThemeModeProvider>();
    final config = context.watch<ConfigProvider>();
    final theme = Theme.of(context);
    final previewTheme = dark
        ? ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
                seedColor: provider.darkAccentColor,
                brightness: Brightness.dark))
        : theme;
    final followingSystem =
        dark ? provider.usingDarkSystemColor : provider.usingSystemColor;
    final setting = dark ? Settings.darkAccentColor : Settings.accentColor;
    final labels = {
      'blue': l10n.themeColorBlue,
      'green': l10n.themeColorGreen,
      'brown': l10n.themeColorBrown,
      'purple': l10n.themeColorPurple,
      'rose': l10n.themeColorRose,
      'amber': l10n.themeColorAmber,
      'teal': l10n.themeColorTeal,
      'cyan': l10n.themeColorCyan,
      'indigo': l10n.themeColorIndigo,
      'coral': l10n.themeColorCoral,
      'olive': l10n.themeColorOlive,
      'slate': l10n.themeColorSlate,
    };
    final presets = [
      for (final MapEntry(:key, :value) in accentPresets.entries)
        (key, labels[key]!, Color(value)),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(dark ? l10n.themeDarkAccent : l10n.themeColorTitle,
              style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(l10n.themeColorHint, style: theme.textTheme.bodySmall),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final (id, label, color) in presets)
                Semantics(
                  selected: !followingSystem &&
                      config.get(setting) == color.toARGB32(),
                  child: OutlinedButton.icon(
                    key: ValueKey('${dark ? 'dark-' : ''}theme-color-$id'),
                    onPressed: () => dark
                        ? provider.selectDarkAccentColor(color)
                        : provider.selectAccentColor(color),
                    icon: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.colorScheme.outline),
                      ),
                      child: !followingSystem &&
                              config.get(setting) == color.toARGB32()
                          ? Icon(Icons.check,
                              size: 16,
                              color:
                                  ThemeData.estimateBrightnessForColor(color) ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black)
                          : null,
                    ),
                    label: Text(label),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Theme(
              data: previewTheme,
              child: Card.filled(
                key: ValueKey(
                    dark ? 'dark-theme-preview' : 'light-theme-preview'),
                color: previewTheme.colorScheme.surfaceContainerLow,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.auto_stories_rounded,
                          color: previewTheme.colorScheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Text(l10n.themeColorPreview,
                              style: previewTheme.textTheme.bodyMedium)),
                      Text('Aa',
                          style: previewTheme.textTheme.titleLarge?.copyWith(
                              color: previewTheme.colorScheme.primary)),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
