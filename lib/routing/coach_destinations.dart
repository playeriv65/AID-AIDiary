// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/builtin_templates.dart';
import 'package:aid_diary/models/coach_program.dart';
import 'package:aid_diary/models/template.dart';
import 'package:aid_diary/pages/coach_page.dart';
import 'package:aid_diary/providers/templates_provider.dart';
import 'package:aid_diary/routing/destination.dart';
import 'package:material_ui/material_ui.dart';

/// The detail pages of the coach catalog.
abstract final class CoachNavigation {
  static Future<void> program(BuildContext context, CoachProgram program) =>
      pushPlace(
          context,
          'coach/program',
          id: program.id,
          (_) => CoachProgramDetail(program: program));

  /// A template the user wrote.
  static Future<void> template(BuildContext context, Template template) =>
      pushPlace(
          context,
          'coach/template',
          id: template.id,
          (_) => CoachTemplateDetail(template: template));

  /// A template that ships with the app.
  static Future<void> builtinTemplate(
          BuildContext context, BuiltinTemplate builtin) =>
      pushPlace(
          context,
          'coach/template',
          id: 'builtin-${builtin.id}',
          (_) => CoachTemplateDetail(template: builtin.toTemplate()));
}

/// The coach catalog's items, for `ui.navigate`.
final List<Destination> coachDestinations = [
  Destination(
      'coach/program', 'A coach program: its cover, facts and enrolment',
      params: const [
        ActionParam(
            'id', ParamType.string, 'The program, e.g. everyday or reflect'),
      ], (context, args) {
    final id = args['id'] as String;
    return CoachNavigation.program(
        context,
        CoachProgram.byId(AppLocalizations.of(context)!, id) ??
            (throw ActionException('not_found', 'There is no program $id')));
  }),
  Destination(
      'coach/template',
      'A template of the coach catalog: one that ships with the app, or '
          "one of the user's own",
      params: const [
        ActionParam('builtin', ParamType.string,
            'A built-in template, e.g. daily; or give id',
            required: false),
        ActionParam('id', ParamType.integer, "One of the user's templates",
            required: false),
      ], (context, args) {
    final builtin = args['builtin'] as String?;
    final id = intArg(args, 'id');
    if ((builtin == null) == (id == null)) {
      throw const ActionException(
          'bad_args', 'Give either builtin or id of the template');
    }
    if (builtin != null) {
      final template = BuiltinTemplate.all(AppLocalizations.of(context)!)
          .where((template) => template.id == builtin)
          .firstOrNull;
      if (template == null) {
        throw ActionException(
            'not_found', 'There is no built-in template $builtin');
      }
      return CoachNavigation.builtinTemplate(context, template);
    }
    final template = TemplatesProvider.instance.templates
            .where((template) => template.id == id)
            .firstOrNull ??
        (throw ActionException('not_found', 'There is no template $id'));
    return CoachNavigation.template(context, template);
  }),
];
