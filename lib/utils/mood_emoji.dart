// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/config_provider.dart';

/// The emoji the user picked for a mood, or an empty string for none.
String moodEmoji(int? moodValue) {
  final setting = Settings.moodIcons[moodValue];
  if (setting == null) return "";
  return ConfigProvider.instance.get(setting);
}
