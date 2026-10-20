// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/widgets/scaled_markdown.dart';
import 'package:material_ui/material_ui.dart';

class LargeCard extends StatelessWidget {
  const LargeCard({super.key, this.media, this.header, this.body});

  final Widget? media;
  final Widget? header;
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: Theme.of(context).colorScheme.surfaceContainer,
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (media != null)
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: media,
              ),
            ),
          if (header != null || body != null)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (header != null)
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: header,
                    )
                  else
                    const SizedBox(height: 8),
                  if (body != null)
                    Expanded(
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black, Colors.transparent],
                            stops: [0.8, 0.95],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.dstIn,
                        child: ClipRect(
                          clipBehavior: Clip.hardEdge,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: IgnorePointer(child: body),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  static Widget markdownBody(String text) => OverflowBox(
        alignment: AlignmentDirectional.topStart,
        maxHeight: double.infinity,
        child: ScaledMarkdown(
          data: text,
          maxCharacters: 500,
          scaleFactor: 0.95,
        ),
      );
}
