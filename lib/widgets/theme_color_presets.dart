import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/theme_mode_provider.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

class ThemeColorPresets extends StatelessWidget {
  const ThemeColorPresets({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<ThemeModeProvider>();
    final config = context.watch<ConfigProvider>();
    final theme = Theme.of(context);
    final presets = [
      ('blue', l10n.themeColorBlue, const Color(0xff62A0EA)),
      ('green', l10n.themeColorGreen, const Color(0xff587E64)),
      ('brown', l10n.themeColorBrown, const Color(0xff967A5E)),
      ('purple', l10n.themeColorPurple, const Color(0xff8F6CAF)),
      ('rose', l10n.themeColorRose, const Color(0xffBE7589)),
      ('amber', l10n.themeColorAmber, const Color(0xffC88945)),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.themeColorTitle, style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(l10n.themeColorHint, style: theme.textTheme.bodySmall),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final (id, label, color) in presets)
                Semantics(
                  selected: !provider.usingSystemColor &&
                      config.get(Settings.accentColor) == color.toARGB32(),
                  child: OutlinedButton.icon(
                    key: ValueKey('theme-color-$id'),
                    onPressed: () => provider.selectAccentColor(color),
                    icon: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.colorScheme.outline),
                      ),
                      child: !provider.usingSystemColor &&
                              config.get(Settings.accentColor) ==
                                  color.toARGB32()
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
          Card.filled(
            color: theme.colorScheme.surfaceContainerLow,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.auto_stories_rounded,
                      color: theme.colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(child: Text(l10n.themeColorPreview)),
                  Text('Aa',
                      style: theme.textTheme.titleLarge
                          ?.copyWith(color: theme.colorScheme.primary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
