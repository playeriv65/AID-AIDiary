// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/widgets/mood_picker.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// Records how you feel in a couple of taps: a mood, optionally what you
/// are doing and a line of text. Saves a new entry for now.
class QuickCheckIn extends StatefulWidget {
  const QuickCheckIn({super.key});

  @override
  State<QuickCheckIn> createState() => _QuickCheckInState();
}

class _QuickCheckInState extends State<QuickCheckIn> {
  final _note = TextEditingController();
  int? _mood;
  bool _saving = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final created = await AppActions.instance.run('entry.create', {
      'text': _note.text.trim(),
      'mood': '$_mood',
    }) as Map<String, Object?>;
    // The sheet hands the saved entry to whoever opened it.
    final entry =
        EntryStore.instance.entries.firstWhere((e) => e.id == created['id']);
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
          MoodPicker.single(
              mood: _mood,
              onChanged: (mood) => setState(() => _mood = mood),
              clearable: false,
              size: 34,
              spread: true),
          const SizedBox(height: 20),
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
