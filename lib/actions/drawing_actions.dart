// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/entry_access.dart';
import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/models/drawing.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/services/drawing_renderer.dart';

const _spec = ActionParam(
    'spec',
    ParamType.string,
    'Drawing JSON: {width,height,background,strokes:[{color:ARGB,width,points:[[x,y,pressure],...]}]}. '
        'Coordinates are normalized 0..1; pressure is 0.05..1. '
        'A stroke may include outline:[[x,y],...] for its precomputed smooth polygon.');

DrawingDocument _document(ActionArgs args) {
  try {
    final text = args['spec'] as String;
    if (text.length > 12 * 1024 * 1024) {
      throw const FormatException('Drawing JSON exceeds size limit');
    }
    return DrawingDocument.fromJson((jsonDecode(text) as Map).cast());
  } catch (error) {
    throw ActionException('bad_args', 'Invalid drawing specification: $error');
  }
}

Future<String> _store(DrawingDocument document) async {
  final name = await ImageStorage.instance
      .create(null, await DrawingRenderer.png(document), fileExtension: '.png');
  if (name == null) {
    throw const ActionException('write_failed', 'Could not store the drawing');
  }
  return name;
}

final List<AppAction> drawingActions = [
  AppAction(
      id: 'drawing.render',
      describe: 'Renders local pen strokes to a PNG '
          'attachment file for an editor draft and returns its stored name.',
      risk: ActionRisk.write,
      params: const [_spec],
      run: (_, args) async {
        final document = _document(args);
        return {
          'name': await _store(document),
          'width': document.width,
          'height': document.height
        };
      }),
  AppAction(
      id: 'drawing.attach',
      describe: 'Renders local pen strokes and adds '
          'the PNG to an existing unsealed entry, without opening the GUI.',
      risk: ActionRisk.write,
      params: const [entryIdParam, _spec],
      run: (_, args) async {
        final entry = await openEntryOf(args);
        final document = _document(args);
        final name = await _store(document);
        try {
          await saveEntry(entry,
              images: EntryImage.appendRanked([
                for (final image
                    in EntryImagesProvider.instance.getForEntry(entry))
                  image.copy()
              ], [
                name
              ], entryId: entry.id!));
        } catch (_) {
          await ImageStorage.instance.delete(name);
          rethrow;
        }
        return {'id': entry.id, 'name': name};
      }),
  AppAction(
      id: 'drawing.export',
      describe: 'Renders pen strokes to a new local '
          'PNG file without overwriting an existing file or opening the GUI.',
      risk: ActionRisk.write,
      params: const [
        _spec,
        ActionParam('path', ParamType.string, 'New PNG output path')
      ],
      run: (_, args) async {
        final bytes = await DrawingRenderer.png(_document(args));
        await writeNewFile(args['path'] as String, bytes);
        return {'path': args['path'], 'bytes': bytes.length};
      }),
];
