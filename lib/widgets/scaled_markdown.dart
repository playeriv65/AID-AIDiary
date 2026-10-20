// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/utils/entry_typography.dart';
import 'package:aid_diary/widgets/markdown_highlight_syntax.dart';
import 'package:material_ui/material_ui.dart';
import 'package:markdown_widget/markdown_widget.dart';

// Fixes duplicate scaling issues with markdown_widget
// See: https://github.com/asjqkkkk/markdown_widget/issues/208
class ScaledMarkdown extends StatelessWidget {
  final String data;
  final int? maxCharacters;
  final double scaleFactor;
  final bool compact;
  final bool selectable;

  /// Entry font, size and line spacing; null keeps the markdown defaults.
  final EntryTypography? typography;

  const ScaledMarkdown({
    super.key,
    required this.data,
    this.maxCharacters,
    this.scaleFactor = 1,
    this.compact = false,
    this.selectable = true,
    this.typography,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String text = data;

    if (maxCharacters != null && text.length > maxCharacters!) {
      text = "${text.substring(0, maxCharacters)}…";
    }

    // Get the device's current text scaling to respect user settings
    final deviceScaler = MediaQuery.textScalerOf(context);
    // Apply custom scaling to the user's text scale
    final customScaler = TextScaler.linear(
        deviceScaler.scale(scaleFactor * (typography?.scale ?? 1)));

    var config = theme.brightness == Brightness.light
        ? MarkdownConfig.defaultConfig
        : MarkdownConfig.darkConfig;
    if (typography case final typography?) {
      config = config.copy(configs: [
        PConfig(
            textStyle: TextStyle(
                fontSize: EntryTypography.baseFontSize,
                height: typography.lineSpacing)),
      ]);
    }

    return MarkdownBlock(
      selectable: selectable,
      config: config,
      generator: MarkdownGenerator(
        inlineSyntaxList: [HighlightSyntax()],
        generators: [highlightGenerator(Colors.yellow.shade700)],
        richTextBuilder: (span) {
          return Builder(builder: (context) {
            final shouldIgnoreTextScaler =
                context.getInheritedWidgetOfExactType<_WithTextScalar>() !=
                    null;

            final child = Text.rich(
              typography == null
                  ? span
                  : TextSpan(style: typography!.familyStyle, children: [span]),
              textScaler:
                  shouldIgnoreTextScaler ? TextScaler.noScaling : customScaler,
            );

            return shouldIgnoreTextScaler
                ? child
                : _WithTextScalar(child: child);
          });
        },
        linesMargin: compact
            ? EdgeInsets.zero
            : const EdgeInsets.only(bottom: 8, top: 2),
      ),
      data: text,
    );
  }
}

class _WithTextScalar extends InheritedWidget {
  const _WithTextScalar({required super.child});

  @override
  bool updateShouldNotify(covariant _WithTextScalar oldWidget) {
    return false;
  }
}
