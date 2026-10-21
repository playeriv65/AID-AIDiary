// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';

import 'package:aid_diary/utils/mood_emoji.dart';
import 'package:material_ui/material_ui.dart';

class MoodIcon extends StatefulWidget {
  final int? moodValue;
  final double size;
  final bool allowScaling;

  const MoodIcon({
    super.key,
    this.moodValue,
    this.size = 20,
    this.allowScaling = true,
  });

  @override
  State<MoodIcon> createState() => _MoodIconState();

  static String getMoodIcon(int? moodValue) => moodEmoji(moodValue);
}

class _MoodIconState extends State<MoodIcon> {
  @override
  Widget build(BuildContext context) {
    return Text(
      MoodIcon.getMoodIcon(widget.moodValue),
      style: TextStyle(
        fontSize: widget.size,
        fontFamily: Platform.isLinux ? 'Noto Color Emoji' : null,
      ),
      textScaler: widget.allowScaling ? null : TextScaler.noScaling,
    );
  }
}
