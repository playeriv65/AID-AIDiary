// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:daily_you/models/flashback.dart';
import 'package:daily_you/utils/entry_navigation.dart';
import 'package:daily_you/widgets/flashback_card.dart';
import 'package:material_ui/material_ui.dart';

/// Horizontally scrolling flashback cards with faded edges.
class FlashbacksRow extends StatelessWidget {
  const FlashbacksRow({super.key, required this.flashbacks, this.height = 130});

  final List<Flashback> flashbacks;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ShaderMask(
        shaderCallback: (Rect bounds) => const LinearGradient(
          stops: [0, 0.02, 0.98, 1],
          colors: [
            Colors.transparent,
            Colors.white,
            Colors.white,
            Colors.transparent
          ],
        ).createShader(bounds),
        blendMode: BlendMode.dstIn,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          itemCount: flashbacks.length,
          itemBuilder: (context, index) {
            final flashback = flashbacks[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: GestureDetector(
                onTap: () => EntryNavigation.flashback(context, flashback),
                child: FlashbackCard(
                    title: flashback.title, entries: flashback.entries),
              ),
            );
          },
        ),
      ),
    );
  }
}
