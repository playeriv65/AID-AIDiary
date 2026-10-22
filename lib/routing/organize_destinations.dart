// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/models/tag_category.dart';
import 'package:aid_diary/models/template.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/providers/templates_provider.dart';
import 'package:aid_diary/routing/destination.dart';
import 'package:aid_diary/widgets/edit_category.dart';
import 'package:aid_diary/widgets/edit_tag.dart';
import 'package:aid_diary/widgets/edit_template.dart';
import 'package:aid_diary/widgets/share_tags_dialog.dart';
import 'package:aid_diary/widgets/share_templates_dialog.dart';
import 'package:material_ui/material_ui.dart';

/// The editors of tags, categories and templates, and their sharing pages.
abstract final class OrganizeNavigation {
  /// The tag editor for [tag], or for a new tag, which starts with [name].
  static Future<void> editTag(BuildContext context, Tag? tag, {String? name}) =>
      showPlaceDialog<void>(
          context,
          'tag',
          id: tag?.id,
          (_) => EditTag(tag: tag, initialName: name));

  /// The category editor for [category], or for a new one.
  static Future<void> editCategory(
          BuildContext context, TagCategory? category) =>
      showPlaceDialog<void>(
          context,
          'category',
          id: category?.id,
          (_) => EditCategory(category: category));

  /// The template editor for [template], or for a new template.
  static Future<void> editTemplate(BuildContext context, Template? template) =>
      pushPlace(
          context,
          'template',
          id: template?.id,
          fullscreenDialog: true,
          (_) => EditTemplate(template: template));

  static Future<void> shareTags(BuildContext context) => pushPlace(
      context,
      'tags/share',
      fullscreenDialog: true,
      (_) => const ShareTagsDialog());

  static Future<void> shareTemplates(BuildContext context) => pushPlace(
      context,
      'templates/share',
      fullscreenDialog: true,
      (_) => const ShareTemplatesDialog());
}

const _idForNew = 'The one to edit; a new one when absent';

/// The editors and sharing pages for `ui.navigate`.
final List<Destination> organizeDestinations = [
  Destination('tag', 'The tag editor: a tag by id, or a new tag',
      params: const [
        ActionParam('id', ParamType.integer, _idForNew, required: false),
        ActionParam('name', ParamType.string, 'For a new tag: its name',
            required: false),
      ], (context, args) {
    final id = intArg(args, 'id');
    final tag = id == null
        ? null
        : TagsProvider.instance.tags.where((tag) => tag.id == id).firstOrNull ??
            (throw ActionException('not_found', 'There is no tag $id'));
    return OrganizeNavigation.editTag(context, tag,
        name: args['name'] as String?);
  }),
  Destination(
      'category', 'The category editor: a tag category by id, or a new one',
      params: const [
        ActionParam('id', ParamType.integer, _idForNew, required: false),
      ], (context, args) {
    final id = intArg(args, 'id');
    final category = id == null
        ? null
        : TagsProvider.instance.categories
                .where((category) => category.id == id)
                .firstOrNull ??
            (throw ActionException('not_found', 'There is no category $id'));
    return OrganizeNavigation.editCategory(context, category);
  }),
  Destination(
      'template', 'The template editor: a template by id, or a new template',
      params: const [
        ActionParam('id', ParamType.integer, _idForNew, required: false),
      ], (context, args) {
    final id = intArg(args, 'id');
    final template = id == null
        ? null
        : TemplatesProvider.instance.templates
                .where((template) => template.id == id)
                .firstOrNull ??
            (throw ActionException('not_found', 'There is no template $id'));
    return OrganizeNavigation.editTemplate(context, template);
  }),
  Destination('tags/share', 'Share or export tags',
      (context, args) => OrganizeNavigation.shareTags(context)),
  Destination('templates/share', 'Share or export templates',
      (context, args) => OrganizeNavigation.shareTemplates(context)),
];
