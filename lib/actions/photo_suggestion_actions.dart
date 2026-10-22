// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/services/local_photo_suggestions.dart';
import 'package:flutter/services.dart';

final photoSuggestionActions = [
  AppAction(
      id: 'moments.scan',
      describe: 'Finds bounded groups of recent local '
          'photos using timestamps and optional coordinates, without copying images '
          'into the diary or accessing the network. Photo permission or an explicit '
          'desktop folder is required first.',
      risk: ActionRisk.read,
      params: const [
        ActionParam(
            'days', ParamType.integer, 'Recent days, 1 to 30; default 7',
            required: false)
      ],
      run: (_, args) async {
        try {
          final service = LocalPhotoSuggestions.instance;
          final cards = await service.scan(days: args['days'] as int? ?? 7);
          return {
            'cards': [
              for (final card in cards)
                {...card.toJson(), 'place': service.placeName(card)}
            ]
          };
        } on PlatformException catch (error) {
          throw ActionException(
              error.code, error.message ?? 'Local photo scan failed');
        } on ArgumentError catch (error) {
          throw ActionException('bad_args', '$error');
        }
      }),
  AppAction(
      id: 'moments.create',
      describe: 'Copies the selected photo card into '
          'a new entry for its photo day. Requires a preceding scan; originals stay untouched.',
      risk: ActionRisk.write,
      params: const [
        ActionParam('id', ParamType.string, 'Card id from moments.scan'),
        ActionParam('text', ParamType.string, 'Optional entry text',
            required: false)
      ],
      run: (context, args) async {
        final saved = await LocalPhotoSuggestions.instance.create(
            args['id'] as String,
            text: args['text'] as String? ?? '',
            progress: context.progress);
        return {'id': saved.id};
      }),
  AppAction(
      id: 'moments.dismiss',
      describe: 'Hides a photo suggestion locally '
          'without deleting, modifying or importing any source photo.',
      risk: ActionRisk.write,
      params: const [
        ActionParam('id', ParamType.string, 'Card id from moments.scan')
      ],
      run: (_, args) async {
        final id = args['id'] as String;
        if (!RegExp(r'^[a-f0-9]{64}$').hasMatch(id)) {
          throw const ActionException('bad_args', 'Invalid photo card id');
        }
        await LocalPhotoSuggestions.instance.dismiss(id);
        return {'dismissed': id};
      }),
];
