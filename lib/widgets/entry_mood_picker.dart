// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/widgets/haptics.dart';
import 'package:aid_diary/widgets/material_shapes.dart';
import 'package:aid_diary/widgets/punch_scale.dart';
import 'package:material_ui/material_ui.dart';
import 'package:aid_diary/widgets/mood_icon.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';

class EntryMoodPicker extends StatelessWidget {
  final int? moodValue;
  final ValueChanged<int?> onChangedMood;

  const EntryMoodPicker(
      {super.key, this.moodValue, required this.onChangedMood});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      _moodOption(context, -2, l10n.moodAwful),
      _moodOption(context, -1, l10n.moodBad),
      _moodOption(context, 0, l10n.moodOkay),
      _moodOption(context, 1, l10n.moodGood),
      _moodOption(context, 2, l10n.moodGreat),
      _moodOption(context, null, l10n.moodClear),
    ]);
  }

  Widget _moodOption(BuildContext context, int? index, String label) {
    final isSelected = index == moodValue;
    final cs = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: Tooltip(
        message: label,
        child: InkWell(
          key: ValueKey(index == null ? 'mood-clear' : 'mood-option-$index'),
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Haptics.selection();
            onChangedMood(index);
          },
          child: SizedBox(
            width: 48,
            height: 48,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: isSelected ? 1.0 : 0.0),
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeInOut,
              builder: (context, progress, child) {
                return CustomPaint(
                  painter: MorphingBurstPainter(
                    progress: progress,
                    color: Color.lerp(
                      cs.surfaceContainerLow,
                      cs.surfaceContainerLowest,
                      progress,
                    )!,
                  ),
                  child: Center(child: child),
                );
              },
              child: PunchScale(
                key: ValueKey(index),
                trigger: isSelected,
                child: Opacity(
                    opacity: isSelected ? 1.0 : 0.6,
                    child: index == null
                        ? const Icon(Icons.clear_rounded, size: 24)
                        : MoodIcon(
                            moodValue: index,
                            size: 24,
                            allowScaling: false,
                          )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
