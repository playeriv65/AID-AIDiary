// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:io';

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/entry_access.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/services/media_import.dart';
import 'package:aid_diary/services/photo_compression.dart';
import 'package:aid_diary/utils/entry_share.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';

const String _exportText = 'text';
const String _exportHtml = 'html';
const String _exportZip = 'zip';

const ActionParam _indexParam = ActionParam(
    'index',
    ParamType.integer,
    'Which attachment, counting from 0 as '
        'entry.attachments lists them');

const ActionParam _pathParam =
    ActionParam('path', ParamType.string, 'A file path on this device');

/// The attachments of [entry] in the order the GUI shows them.
List<EntryImage> _attachmentsOf(Entry entry) =>
    EntryImagesProvider.instance.getForEntry(entry);

/// A copy of the attachments to change and write back, ranked as listed.
List<EntryImage> _copies(Entry entry) =>
    [for (final image in _attachmentsOf(entry)) image.copy()];

String _kindName(MediaKind kind) => switch (kind) {
      MediaKind.image => 'photo',
      MediaKind.video => 'video',
      MediaKind.audio => 'audio',
    };

Future<Map<String, Object?>> _info(EntryImage image, int index) async {
  final bytes = await ImageStorage.instance.getBytes(image.imgPath);
  final size = image.isImage && bytes != null
      ? img.findDecoderForData(bytes)?.startDecode(bytes)
      : null;
  return {
    'index': index,
    'name': image.imgPath,
    'kind': _kindName(image.kind),
    'size': bytes?.length,
    if (size != null) ...{'width': size.width, 'height': size.height},
    'added': image.timeCreate.toIso8601String(),
    if (bytes == null) 'missing': true,
  };
}

Future<Map<String, Object?>> _listing(Entry entry) async => {
      'id': entry.id,
      'attachments': [
        for (final (index, image) in _attachmentsOf(entry).indexed)
          await _info(image, index),
      ],
    };

EntryImage _attachmentAt(Entry entry, ActionArgs args) {
  final index = args['index'] as int;
  final attachments = _attachmentsOf(entry);
  if (index < 0 || index >= attachments.length) {
    throw ActionException(
        'not_found',
        'Entry ${entry.id} has ${attachments.length} attachments, '
            'none at index $index');
  }
  return attachments[index];
}

/// Photos that compressing could make smaller: every entry's (hidden ones
/// too), not videos, voice notes or animations.
List<(Entry, EntryImage)> _photos() => [
      for (final entry in EntryStore.instance.allEntries)
        for (final image in EntryImagesProvider.instance.getForEntry(entry))
          if (image.isImage && !image.imgPath.toLowerCase().endsWith('.gif'))
            (entry, image),
    ];

final List<AppAction> entryMediaActions = [
  AppAction(
    id: 'media.compress_all',
    describe: 'Compresses every photo larger than about 1 MB to WebP, '
        'replacing the original for good, as Settings > Data & storage does. '
        'Videos, voice notes and animations stay as they are.',
    risk: ActionRisk.destructive,
    run: (context, args) async {
      final photos = _photos();
      final storage = ImageStorage.instance;
      var compressed = 0;
      var saved = 0;
      var looked = 0;
      final byEntry = <Entry, List<EntryImage>>{};
      for (final (entry, _) in photos) {
        byEntry[entry] ??=
            EntryImagesProvider.instance.getForEntry(entry).toList();
      }
      for (final MapEntry(key: entry, value: images) in byEntry.entries) {
        var changed = false;
        final kept = <EntryImage>[];
        for (final image in images) {
          final bytes =
              image.isImage ? await storage.getBytes(image.imgPath) : null;
          final small = bytes == null
              ? null
              : await PhotoCompression.compress(bytes, name: image.imgPath);
          final name = small == null
              ? null
              : await storage.create(null, small,
                  currTime: image.timeCreate,
                  fileExtension: PhotoCompression.extension);
          if (image.isImage) {
            context.progress('${++looked}/${photos.length}');
          }
          if (name == null) {
            kept.add(image.copy());
            continue;
          }
          // A new photo in the old one's place; the old file goes on commit.
          kept.add(EntryImage(
              entryId: entry.id,
              imgPath: name,
              imgRank: image.imgRank,
              timeCreate: image.timeCreate));
          compressed++;
          saved += bytes!.length - small!.length;
          changed = true;
        }
        if (!changed) continue;
        final session = EntryStore.instance.beginDraft(entry);
        await session.save((_) => EntryDraft(
            entry: entry,
            tags: TagsProvider.instance.getEntryTagsForEntry(entry.id!),
            images: kept));
        await session.commit();
      }
      return {
        'photos': photos.length,
        'compressed': compressed,
        'savedBytes': saved,
      };
    },
  ),
  AppAction(
    id: 'media.photo_count',
    describe: 'Counts the photos compressing could act on, and their size.',
    risk: ActionRisk.read,
    run: (context, args) async {
      final photos = _photos();
      final sizes = await ImageStorage.instance.sizes();
      return {
        'photos': photos.length,
        'bytes': photos.fold<int>(
            0, (sum, photo) => sum + (sizes[photo.$2.imgPath] ?? 0)),
      };
    },
  ),
  AppAction(
    id: 'entry.attachments',
    describe: 'Lists the photos, videos and voice notes of an entry in the '
        'order it shows them, with kind, size in bytes and, for photos, '
        'width and height.',
    risk: ActionRisk.read,
    params: const [entryIdParam],
    run: (context, args) async => _listing(await openEntryOf(args)),
  ),
  AppAction(
    id: 'entry.attach',
    describe: 'Adds a photo, video or voice note from a file to the end of '
        'an entry. Photos are compressed as the image quality setting asks '
        'and videos above the size limit are refused, as in the editor. The '
        'file itself stays as it is.',
    risk: ActionRisk.write,
    params: const [entryIdParam, _pathParam],
    run: (context, args) async {
      final entry = await openEntryOf(args);
      final path = args['path'] as String;
      if (!await File(path).exists()) {
        throw ActionException('not_found', 'There is no file $path');
      }
      if (!MediaImport.supports(path)) {
        throw ActionException('bad_args',
            'Only photo, video and audio files can be attached, not $path');
      }
      final String? name;
      try {
        name = await MediaImport.store(path);
      } on MediaTooLargeException catch (error) {
        throw ActionException('too_large', '$error');
      }
      if (name == null) {
        throw ActionException('write_failed', 'Could not store $path');
      }
      final Entry saved;
      try {
        saved = await saveEntry(entry,
            images: EntryImage.appendRanked(_copies(entry), [name],
                entryId: entry.id!));
      } catch (_) {
        // Nothing refers to the stored file then.
        await ImageStorage.instance.delete(name);
        rethrow;
      }
      return _listing(saved);
    },
  ),
  AppAction(
    id: 'entry.detach',
    describe: 'Removes one attachment from an entry and deletes its file.',
    risk: ActionRisk.destructive,
    params: const [entryIdParam, _indexParam],
    run: (context, args) async {
      final entry = await openEntryOf(args);
      final removed = _attachmentAt(entry, args);
      final images = _copies(entry)
        ..removeWhere((image) => image.id == removed.id);
      EntryImage.rankInOrder(images);
      return _listing(await saveEntry(entry, images: images));
    },
  ),
  AppAction(
    id: 'entry.reorder_attachments',
    describe: 'Puts the attachments of an entry in a new order.',
    risk: ActionRisk.write,
    params: const [
      entryIdParam,
      ActionParam(
          'order',
          ParamType.string,
          'Every current index once, in the new order, comma-separated: '
              '2,0,1 shows the third first'),
    ],
    run: (context, args) async {
      final entry = await openEntryOf(args);
      final current = _copies(entry);
      final order = [
        for (final word in (args['order'] as String).split(','))
          int.tryParse(word.trim()),
      ];
      final valid = order.length == current.length &&
          order.toSet().length == order.length &&
          order.every((index) => index != null && index < current.length);
      if (!valid || order.any((index) => index! < 0)) {
        throw ActionException(
            'bad_args',
            'order must list each index 0 to ${current.length - 1} once, '
                'comma-separated');
      }
      final images = [for (final index in order) current[index!]];
      EntryImage.rankInOrder(images);
      return _listing(await saveEntry(entry, images: images));
    },
  ),
  AppAction(
    id: 'entry.export_attachment',
    describe: 'Saves the original file of one attachment to a new file; an '
        'existing file is never replaced.',
    risk: ActionRisk.write,
    params: const [entryIdParam, _indexParam, _pathParam],
    run: (context, args) async {
      final attachment = _attachmentAt(await openEntryOf(args), args);
      final bytes = await ImageStorage.instance.getBytes(attachment.imgPath);
      if (bytes == null) {
        throw ActionException(
            'not_found', '${attachment.imgPath} is not available');
      }
      await writeNewFile(args['path'] as String, bytes);
      return {'path': args['path'], 'name': attachment.imgPath};
    },
  ),
  AppAction(
    id: 'entry.export',
    describe: 'Saves an entry to a new file as plain text, an HTML page or a '
        'ZIP with the original media; an existing file is never replaced.',
    risk: ActionRisk.write,
    params: const [
      entryIdParam,
      ActionParam('format', ParamType.string,
          '$_exportText, $_exportHtml or $_exportZip'),
      _pathParam,
    ],
    run: (context, args) async {
      final entry = await openEntryOf(args);
      final format = args['format'] as String;
      final heading =
          EntryShare.heading(entry, DateFormat.yMMMEd().format(entry.day));
      final List<int> bytes = switch (format) {
        _exportText => utf8.encode(EntryShare.plainText(entry, heading)),
        _exportHtml => utf8.encode(EntryShare.html(entry, heading)),
        _exportZip => await EntryShare.zip(entry, heading,
            _attachmentsOf(entry), ImageStorage.instance.getBytes),
        _ => throw ActionException('bad_args',
            'format is $_exportText, $_exportHtml or $_exportZip, not $format'),
      };
      await writeNewFile(args['path'] as String, bytes);
      return {'path': args['path'], 'format': format, 'bytes': bytes.length};
    },
  ),
];
