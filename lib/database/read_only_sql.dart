// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

// Skip leading SQL whitespace, empty statements and comments. A SELECT can
// still use the command names in its data or identifiers.
final _firstKeyword = RegExp(r'^(?:[\s;]|--[^\n]*(?:\n|$)|/\*.*?\*/)*([a-z]+)',
    caseSensitive: false, dotAll: true);

/// Identifies commands that can open or create another database file even
/// on a read-only connection.
String? databaseFileCommand(String sql) =>
    switch (_firstKeyword.firstMatch(sql)?.group(1)?.toUpperCase()) {
      final command when command == 'ATTACH' || command == 'VACUUM' => command,
      _ => null,
    };
