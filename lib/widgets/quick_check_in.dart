// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/utils/entry_context_display.dart';
import 'package:aid_diary/widgets/mood_icon.dart';
import 'package:material_ui/material_ui.dart';

/// Records how you feel in a couple of taps: a mood, optionally what you
/// are doing and a line of text. Saves a new entry for now.
Future<Entry?> showQuickCheckIn(BuildContext context) =>
    showModalBottomSheet<Entry>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const _QuickCheckIn(),
    );

class _QuickCheckIn extends StatefulWidget {
  const _QuickCheckIn();

  @override
  State<_QuickCheckIn> createState() => _QuickCheckInState();
}

class _QuickCheckInState extends State<_QuickCheckIn> {
  final _note = TextEditingController();
  int? _mood;
  EntryActivity? _activity;
  bool _saving = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final now = DateTime.now();
    final entry = await EntryStore.instance.add(Entry(
        text: _note.text.trim(),
        mood: _mood,
        activity: _activity,
        timeCreate: now,
        timeModified: now));
    if (mounted) Navigator.of(context).pop(entry);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 0, 20, 20 + MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.checkInMood,
              textAlign: TextAlign.center, style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            for (final mood in const [-2, -1, 0, 1, 2])
              InkWell(
                key: ValueKey('check-in-mood-$mood'),
                customBorder: const CircleBorder(),
                onTap: () => setState(() => _mood = mood),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _mood == mood
                        ? moodColor(mood, theme.colorScheme)
                        : Colors.transparent,
                  ),
                  child: MoodIcon(moodValue: mood, size: 34),
                ),
              ),
          ]),
          const SizedBox(height: 20),
          Text(l10n.checkInActivity, style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(spacing: 6, runSpacing: 6, children: [
            for (final activity in EntryActivity.values)
              ChoiceChip(
                key: ValueKey('check-in-activity-${activity.name}'),
                avatar: Icon(activityIcon(activity), size: 18),
                label: Text(activityLabel(activity, l10n)),
                selected: _activity == activity,
                onSelected: (on) =>
                    setState(() => _activity = on ? activity : null),
              ),
          ]),
          const SizedBox(height: 16),
          TextField(
            key: const ValueKey('check-in-note'),
            controller: _note,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
                hintText: l10n.checkInNote, border: const OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            key: const ValueKey('check-in-save'),
            onPressed: _mood == null || _saving ? null : _save,
            icon: const Icon(Icons.check_rounded),
            label: Text(l10n.checkInSave),
          ),
        ],
      ),
    );
  }
}
