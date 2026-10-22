// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:ui';

import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/time_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

class TemplateRenderer {
  static final Logger _logger = Logger('TemplateRenderer');

  static final RegExp _variablePattern = RegExp(r"\{\{(\w+)(?::([^}]+))?\}\}");

  /// Populates template variables: {{date}}, {{time}}
  /// Variables can have optional formatting like so, {{date:yyyy-MM-dd}} or {{time:HH:mm}}
  static String populate(BuildContext context, String template) =>
      render(template,
          locale: Localizations.localeOf(context).toString(),
          use24Hour: MediaQuery.alwaysUse24HourFormatOf(context));

  /// [populate] without a widget tree, in the app's language and with the
  /// device's clock style: for what runs without a screen.
  static String populateForDevice(String template) {
    final dispatcher = PlatformDispatcher.instance;
    return render(template,
        locale:
            (ConfigProvider.instance.getOverrideLanguage() ?? dispatcher.locale)
                .toString(),
        use24Hour: dispatcher.alwaysUse24HourFormat);
  }

  static String render(String template,
      {required String locale, required bool use24Hour}) {
    final now = DateTime.now();

    return template.replaceAllMapped(_variablePattern, (match) {
      final variable = match.group(1);
      final format = match.group(2);

      switch (variable) {
        case "date":
          return _formatDate(now, locale, format);

        case "time":
          return _formatTime(now, locale, format, use24Hour);

        default:
          return match.group(0)!; // leave unknown variables unchanged
      }
    });
  }

  static String _formatDate(DateTime dt, String locale, String? format) {
    try {
      if (format != null && format.isNotEmpty) {
        return DateFormat(format, locale).format(dt);
      }
    } catch (error) {
      _logger.warning(
          'Template date format "$format" could not be applied', error);
    }

    return DateFormat.yMd(locale).format(dt);
  }

  static String _formatTime(
      DateTime dt, String locale, String? format, bool use24Hour) {
    try {
      if (format != null && format.isNotEmpty) {
        return DateFormat(format, locale).format(dt);
      }
    } catch (error) {
      _logger.warning(
          'Template time format "$format" could not be applied', error);
    }

    return TimeManager.timeFormat(locale, use24Hour: use24Hour).format(dt);
  }
}
