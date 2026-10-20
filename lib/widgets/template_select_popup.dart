// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/models/template.dart';
import 'package:aid_diary/template_renderer.dart';
import 'package:aid_diary/utils/text_editing.dart';
import 'package:aid_diary/widgets/template_select.dart';
import 'package:material_ui/material_ui.dart';

Future<void> showTemplateSelectPopup(
    BuildContext context, TextEditingController controller,
    {required bool hasFocus,
    void Function(Template template)? onTemplateSelected}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return TemplateSelect(
        onTemplatesSelected: (Template template) {
          final templateText =
              TemplateRenderer.populate(context, template.text ?? "");
          insertTemplateText(controller, templateText, hasFocus: hasFocus);
          onTemplateSelected?.call(template);
        },
      );
    },
  );
}
