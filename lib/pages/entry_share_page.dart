// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:daily_you/config/app_config.dart';
import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/models/image.dart';
import 'package:daily_you/pages/entry_view_page.dart';
import 'package:daily_you/utils/entry_context_display.dart';
import 'package:daily_you/utils/entry_typography.dart';
import 'package:daily_you/widgets/local_image_loader.dart';
import 'package:daily_you/widgets/mood_icon.dart';
import 'package:daily_you/widgets/scaled_markdown.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:share_plus/share_plus.dart';

/// Previews an entry as a card and shares or saves it as a picture.
class EntrySharePage extends StatefulWidget {
  const EntrySharePage({super.key, required this.entry, required this.images});

  final Entry entry;
  final List<EntryImage> images;

  @override
  State<EntrySharePage> createState() => _EntrySharePageState();
}

class _EntrySharePageState extends State<EntrySharePage> {
  final _cardKey = GlobalKey();
  bool _busy = false;

  String get _fileName =>
      'aid-diary-${DateFormat('yyyy-MM-dd-HHmm').format(widget.entry.timeCreate)}.png';

  /// The card as PNG bytes, at the configured pixel ratio.
  Future<Uint8List?> _render() async {
    final boundary =
        _cardKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image =
        await boundary.toImage(pixelRatio: AppConfig.instance.sharePixelRatio);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    return data?.buffer.asUint8List();
  }

  Future<void> _run(Future<void> Function(Uint8List png) action) async {
    setState(() => _busy = true);
    try {
      final png = await _render();
      if (png != null) await action(png);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _shareImage() =>
      _run((png) => SharePlus.instance.share(ShareParams(
          files: [XFile.fromData(png, mimeType: 'image/png')],
          fileNameOverrides: [_fileName])));

  Future<void> _saveImage() => _run((png) async {
        final messenger = ScaffoldMessenger.of(context);
        final saved = AppLocalizations.of(context)!.shareSaved;
        final uri = await FilePicker.saveFile(
            fileName: _fileName,
            bytes: png,
            mimeType: 'image/png',
            type: FileType.image);
        if (uri != null) {
          messenger.showSnackBar(SnackBar(content: Text(saved)));
        }
      });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surfaceContainer,
      appBar: AppBar(
        title: Text(l10n.entryShare),
        backgroundColor: cs.surfaceContainer,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: RepaintBoundary(
              key: _cardKey,
              child: EntryShareCard(entry: widget.entry, images: widget.images),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                key: const ValueKey('share-save'),
                onPressed: _busy ? null : _saveImage,
                icon: const Icon(Icons.download_rounded),
                label: Text(l10n.shareSaveImage),
              ),
              FilledButton.icon(
                key: const ValueKey('share-image'),
                onPressed: _busy ? null : _shareImage,
                icon: const Icon(Icons.share_rounded),
                label: Text(l10n.shareImage),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The picture that gets shared: first photo, date, mood and context, the
/// text (shortened) and the app name.
class EntryShareCard extends StatelessWidget {
  const EntryShareCard({super.key, required this.entry, required this.images});

  final Entry entry;
  final List<EntryImage> images;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final config = AppConfig.instance;
    final photo = images.where((image) => image.isImage).firstOrNull;
    final muted = theme.textTheme.labelMedium?.copyWith(color: cs.outline);
    final details = [
      if (entry.location?.name case final name?) (Icons.place_rounded, name),
      if (entry.weather case final weather?)
        (weatherIcon(weather.code), weatherSummary(weather, l10n)),
      if (entry.activity case final activity?)
        (activityIcon(activity), activityLabel(activity, l10n)),
    ];
    return Container(
      width: config.shareCardWidth,
      color: cs.surfaceContainerLowest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (photo != null)
            SizedBox(
                height: config.shareCardWidth * .62,
                child: LocalImageLoader(
                    imagePath: photo.imgPath, cacheSize: 1200)),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(child: EntryDateBlock(entry: entry)),
                  if (MoodIcon.getMoodIcon(entry.mood).isNotEmpty)
                    MoodIcon(moodValue: entry.mood, size: 30),
                ]),
                if (details.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(spacing: 12, runSpacing: 4, children: [
                    for (final (icon, label) in details)
                      Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(icon, size: 15, color: cs.outline),
                        const SizedBox(width: 3),
                        Text(label, style: muted),
                      ]),
                  ]),
                ],
                if (entry.text.trim().isNotEmpty) ...[
                  const SizedBox(height: 14),
                  ScaledMarkdown(
                      data: entry.text.trim(),
                      maxCharacters: config.shareMaxCharacters,
                      selectable: false,
                      typography: EntryTypography.of(context)),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 18),
            child: Row(children: [
              Icon(Icons.auto_stories_rounded, size: 16, color: cs.primary),
              const SizedBox(width: 6),
              Text(l10n.appTitle,
                  style: theme.textTheme.labelLarge?.copyWith(
                      color: cs.primary, fontWeight: FontWeight.w600)),
            ]),
          ),
        ],
      ),
    );
  }
}
