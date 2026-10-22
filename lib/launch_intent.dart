// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

sealed class LaunchIntent {
  const LaunchIntent();

  const factory LaunchIntent.logToday() = LogTodayIntent;
  const factory LaunchIntent.takePhoto() = TakePhotoIntent;
  const factory LaunchIntent.openEntry(int id) = OpenEntryIntent;
  const factory LaunchIntent.newEntry() = NewEntryIntent;
  const factory LaunchIntent.mood(int value) = MoodEntryIntent;
  const factory LaunchIntent.prompt(int index) = PromptEntryIntent;
}

class MoodEntryIntent extends LaunchIntent {
  const MoodEntryIntent(this.value);
  final int value;
}

class PromptEntryIntent extends LaunchIntent {
  const PromptEntryIntent(this.index);
  final int index;
}

/// The quick-write notification was tapped: start a new entry.
class NewEntryIntent extends LaunchIntent {
  const NewEntryIntent();
}

/// The photo widget was tapped: show its entry.
class OpenEntryIntent extends LaunchIntent {
  const OpenEntryIntent(this.id);
  final int id;
}

class TakePhotoIntent extends LaunchIntent {
  const TakePhotoIntent();
}

class LogTodayIntent extends LaunchIntent {
  const LogTodayIntent();
}
