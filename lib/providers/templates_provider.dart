// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/database/template_dao.dart';
import 'package:aid_diary/models/template.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:material_ui/material_ui.dart';

class TemplatesProvider with ChangeNotifier {
  static final TemplatesProvider instance = TemplatesProvider._init();

  TemplatesProvider._init();

  List<Template> templates = List.empty(growable: true);

  /// Load the provider's data from the app database
  Future<void> load() async {
    templates = await TemplateDao.getAll();
    notifyListeners();
  }

  // CRUD operations

  Future<Template> add(Template template) async {
    // Insert the template into the database so that it has an ID
    final templateWithId = await TemplateDao.add(template);
    templates.add(templateWithId);
    await AppDatabase.instance.updateExternalDatabase();
    notifyListeners();
    return templateWithId;
  }

  /// Writes [template] (added when it has no id yet) with exactly the tags
  /// [tagIds], as the template editor does on saving.
  Future<Template> save(Template template, List<int> tagIds) async {
    final Template saved;
    if (template.id == null) {
      saved = await add(template);
    } else {
      await update(template);
      saved = template;
    }
    await TagsProvider.instance.setTemplateTags(saved.id!, tagIds);
    return saved;
  }

  /// Deletes [template]; when it was the default one, new entries start
  /// empty again.
  Future<void> remove(Template template) async {
    final config = ConfigProvider.instance;
    if (config.get(Settings.defaultTemplate) == template.id) {
      await config.set(Settings.defaultTemplate, -1);
    }
    await TagsProvider.instance.removeAllTemplateTagsForTemplate(template.id!);
    await TemplateDao.remove(template.id!);
    templates.removeWhere((x) => x.id == template.id);
    await AppDatabase.instance.updateExternalDatabase();
    notifyListeners();
  }

  Future<void> update(Template template) async {
    await TemplateDao.update(template);
    final index = templates.indexWhere((x) => x.id == template.id);
    templates[index] = template;
    await AppDatabase.instance.updateExternalDatabase();
    notifyListeners();
  }

  Template? getDefaultTemplate() {
    var defaultTemplateId =
        ConfigProvider.instance.get(Settings.defaultTemplate);
    return templates.where((t) => t.id == defaultTemplateId).firstOrNull;
  }

  /// The language the default templates are written in.
  static Future<AppLocalizations> defaultsLocalizations() {
    final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
    Locale locale;
    if (AppLocalizations.delegate.isSupported(deviceLocale)) {
      locale = deviceLocale;
    } else {
      final langOnly = Locale(deviceLocale.languageCode);
      locale = AppLocalizations.delegate.isSupported(langOnly)
          ? langOnly
          : const Locale('en');
    }
    return AppLocalizations.delegate.load(locale);
  }

  /// Names of the templates [createDefaultTemplates] makes, in its order.
  /// Every install makes its own, and sync recognises them by these.
  static List<String> defaultTemplateNames(AppLocalizations l10n) => [
        l10n.templateDefaultTimestampTitle,
        l10n.templateDefaultSummaryTitle,
        l10n.templateDefaultReflectionTitle,
      ];

  Future<void> createDefaultTemplates() async {
    final l10n = await defaultsLocalizations();
    final defaultTemplates = [
      Template(
          name: l10n.templateDefaultTimestampTitle,
          text: l10n.templateDefaultTimestampBody("{{date}}", "{{time}}"),
          timeCreate: DateTime.now(),
          timeModified: DateTime.now()),
      Template(
          name: l10n.templateDefaultSummaryTitle,
          text: l10n.templateDefaultSummaryBody,
          timeCreate: DateTime.now(),
          timeModified: DateTime.now()),
      Template(
          name: l10n.templateDefaultReflectionTitle,
          text: l10n.templateDefaultReflectionBody,
          timeCreate: DateTime.now(),
          timeModified: DateTime.now()),
    ];

    for (final template in defaultTemplates) {
      await add(template);
    }
  }
}
