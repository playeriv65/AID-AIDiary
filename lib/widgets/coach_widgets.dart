// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:daily_you/models/coach_program.dart';
import 'package:material_ui/material_ui.dart';

/// The coach's face on programs, tips and story slides.
class CoachAvatar extends StatelessWidget {
  const CoachAvatar({super.key, this.radius = 20});
  final double radius;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return CircleAvatar(
      radius: radius,
      backgroundColor: cs.tertiaryContainer,
      child: Icon(Icons.face_retouching_natural_rounded,
          size: radius * 1.1, color: cs.onTertiaryContainer),
    );
  }
}

/// A program's cover art: its icon on a tinted field.
class ProgramCover extends StatelessWidget {
  const ProgramCover(
      {super.key, required this.program, this.iconSize = 72, this.radius = 16});
  final CoachProgram program;
  final double iconSize;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [cs.primaryContainer, cs.tertiaryContainer],
          ),
        ),
        child: Center(
            child: Icon(program.icon,
                size: iconSize, color: cs.onPrimaryContainer)),
      ),
    );
  }
}
