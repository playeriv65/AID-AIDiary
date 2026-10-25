// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/widgets/haptics.dart';
import 'package:aid_diary/widgets/material_shapes.dart';
import 'package:aid_diary/widgets/mood_icon.dart';
import 'package:aid_diary/widgets/punch_scale.dart';
import 'package:material_ui/material_ui.dart';

/// The moods, worst first, as every picker lists them.
const List<int> moodValues = [-2, -1, 0, 1, 2];

/// What a mood is called.
String moodName(int mood, AppLocalizations l10n) => switch (mood) {
      2 => l10n.moodGreat,
      1 => l10n.moodGood,
      0 => l10n.moodOkay,
      -1 => l10n.moodBad,
      _ => l10n.moodAwful,
    };

/// How a mood is picked everywhere: the five faces in a row, the picked
/// ones lit. One mood for an entry ([MoodPicker.single], which can also
/// clear it), or several to search by ([MoodPicker.multi]).
class MoodPicker extends StatelessWidget {
  const MoodPicker.single({
    super.key,
    required int? mood,
    required ValueChanged<int?> onChanged,
    this.clearable = true,
    this.size = 24,
    this.spread = false,
  })  : _picked = mood,
        _onSingle = onChanged,
        _selected = const {},
        _onToggle = null;

  const MoodPicker.multi({
    super.key,
    required Set<int> selected,
    required ValueChanged<int> onToggle,
    this.size = 24,
    this.spread = false,
  })  : _selected = selected,
        _onToggle = onToggle,
        _picked = null,
        _onSingle = null,
        clearable = false;

  final int? _picked;
  final ValueChanged<int?>? _onSingle;
  final Set<int> _selected;
  final ValueChanged<int>? _onToggle;

  /// Offers to take the mood off, after the faces.
  final bool clearable;

  /// Size of a face.
  final double size;

  /// Spread across the width rather than packed together.
  final bool spread;

  bool _isPicked(int mood) =>
      _onToggle == null ? _picked == mood : _selected.contains(mood);

  void _tap(int? mood) {
    Haptics.selection();
    if (_onToggle case final toggle?) {
      toggle(mood!);
    } else {
      _onSingle!(mood);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
        mainAxisSize: spread ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment:
            spread ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.start,
        children: [
          for (final mood in moodValues)
            _option(context, mood, moodName(mood, l10n), _isPicked(mood)),
          if (clearable) _option(context, null, l10n.moodClear, false),
        ]);
  }

  Widget _option(BuildContext context, int? mood, String label, bool picked) {
    final cs = Theme.of(context).colorScheme;
    final extent = size * 2;
    return Semantics(
      button: true,
      selected: picked,
      label: label,
      child: Tooltip(
        message: label,
        child: InkWell(
          key: ValueKey(mood == null ? 'mood-clear' : 'mood-option-$mood'),
          borderRadius: BorderRadius.circular(size / 2),
          onTap: () => _tap(mood),
          child: SizedBox(
            width: extent,
            height: extent,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: picked ? 1.0 : 0.0),
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
                key: ValueKey(mood),
                trigger: picked,
                child: Opacity(
                    opacity: picked ? 1.0 : 0.6,
                    child: mood == null
                        ? Icon(Icons.clear_rounded, size: size)
                        : MoodIcon(
                            moodValue: mood,
                            size: size,
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
