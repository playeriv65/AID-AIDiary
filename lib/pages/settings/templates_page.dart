// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/routing/organize_destinations.dart';
import 'package:aid_diary/widgets/progress_dialog.dart';
import 'package:aid_diary/utils/templates_tags_transfer.dart';
import 'package:material_ui/material_ui.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/providers/templates_provider.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

class TemplateSettings extends StatefulWidget {
  const TemplateSettings({super.key});

  @override
  State<TemplateSettings> createState() => _TemplateSettingsState();
}

class _TemplateSettingsState extends State<TemplateSettings> {
  Future<void> _importFile(BuildContext context) async {
    await runOperation(context, TemplatesTagsTransfer.importTransferFile,
        failureDescription:
            AppLocalizations.of(context)!.importErrorDescription);
  }

  Widget _templateList(BuildContext context) {
    final templatesProvider = Provider.of<TemplatesProvider>(context);
    final configProvider = Provider.of<ConfigProvider>(context);
    final templates = templatesProvider.templates;
    final defaultTemplateId = configProvider.get(Settings.defaultTemplate);

    if (templates.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.noTemplatesDescription),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: templates.length,
      itemBuilder: (context, index) {
        final template = templates[index];
        final isDefault = defaultTemplateId == template.id;
        return ListTile(
          title: Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16, top: 8.0, bottom: 8.0),
            child: Text(
              template.name,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          contentPadding: EdgeInsets.zero,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  isDefault ? Icons.star_rounded : Icons.star_outline_rounded,
                ),
                onPressed: () async {
                  await AppActions.instance.run('settings.set', {
                    'key': Settings.defaultTemplate.key,
                    'value': '${isDefault ? -1 : template.id}',
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () =>
                    OrganizeNavigation.editTemplate(context, template),
              ),
            ],
          ),
          onTap: () => OrganizeNavigation.editTemplate(context, template),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTemplatesTitle),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_open_outlined),
            onPressed: () => _importFile(context),
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () => OrganizeNavigation.shareTemplates(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _templateList(context),
            const SizedBox(height: 90),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => OrganizeNavigation.editTemplate(context, null),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
