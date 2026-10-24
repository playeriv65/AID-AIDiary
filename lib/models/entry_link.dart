// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/utils/local_time.dart';

/// Entries citing other entries; part of the citing entry.
const String entryRefsTable = 'entry_refs';

/// Passages kept from entries.
const String passagesTable = 'kept_passages';

class EntryRefFields {
  static const String id = 'id';
  static const String entryId = 'entry_id';
  static const String target = 'target_uuid';
  static const String quote = 'quote';
  static const String quoteStart = 'quote_start';
  static const String rank = 'rank';
  static const String timeCreate = 'time_create';
}

/// An entry citing another, or a passage of it: what a comment is. The
/// other entry is named by its sync id, so the citation holds across
/// devices whatever order they arrive in, and outlives that entry.
class EntryRef {
  const EntryRef({
    this.id,
    this.entryId,
    required this.target,
    this.targetId,
    this.quote,
    this.quoteStart,
    this.rank = 0,
    required this.timeCreate,
  });

  final int? id;
  final int? entryId;

  /// The cited entry's sync id, and its local id while it is here.
  final String target;
  final int? targetId;

  /// The words cited, and where they begin in the cited entry's text.
  final String? quote;
  final int? quoteStart;

  /// The order citations show in.
  final int rank;
  final DateTime timeCreate;

  EntryRef copy({int? entryId, int? rank}) => EntryRef(
        id: id,
        entryId: entryId ?? this.entryId,
        target: target,
        targetId: targetId,
        quote: quote,
        quoteStart: quoteStart,
        rank: rank ?? this.rank,
        timeCreate: timeCreate,
      );

  bool sameAs(EntryRef other) =>
      target == other.target &&
      quote == other.quote &&
      quoteStart == other.quoteStart;

  /// A row, with `target_id` joined in from the entries table.
  static EntryRef fromJson(Map<String, Object?> json) => EntryRef(
        id: json[EntryRefFields.id] as int?,
        entryId: json[EntryRefFields.entryId] as int?,
        target: json[EntryRefFields.target] as String,
        targetId: json['target_id'] as int?,
        quote: json[EntryRefFields.quote] as String?,
        quoteStart: json[EntryRefFields.quoteStart] as int?,
        rank: json[EntryRefFields.rank] as int? ?? 0,
        timeCreate: parseLocalTime(json[EntryRefFields.timeCreate] as String),
      );

  Map<String, Object?> toJson() => {
        EntryRefFields.entryId: entryId,
        EntryRefFields.target: target,
        EntryRefFields.quote: quote,
        EntryRefFields.quoteStart: quoteStart,
        EntryRefFields.rank: rank,
        EntryRefFields.timeCreate: timeCreate.toIso8601String(),
      };
}

class PassageFields {
  static const String id = 'id';
  static const String entryId = 'entry_id';
  static const String quote = 'quote';
  static const String quoteStart = 'quote_start';
  static const String timeCreate = 'time_create';
}

/// Words kept from an entry, to come back to.
class KeptPassage {
  const KeptPassage({
    this.id,
    required this.entryId,
    required this.quote,
    this.quoteStart,
    required this.timeCreate,
  });

  final int? id;
  final int entryId;
  final String quote;
  final int? quoteStart;
  final DateTime timeCreate;

  KeptPassage copy({int? id}) => KeptPassage(
      id: id ?? this.id,
      entryId: entryId,
      quote: quote,
      quoteStart: quoteStart,
      timeCreate: timeCreate);

  static KeptPassage fromJson(Map<String, Object?> json) => KeptPassage(
        id: json[PassageFields.id] as int?,
        entryId: json[PassageFields.entryId] as int,
        quote: json[PassageFields.quote] as String,
        quoteStart: json[PassageFields.quoteStart] as int?,
        timeCreate: parseLocalTime(json[PassageFields.timeCreate] as String),
      );

  Map<String, Object?> toJson() => {
        PassageFields.entryId: entryId,
        PassageFields.quote: quote,
        PassageFields.quoteStart: quoteStart,
        PassageFields.timeCreate: timeCreate.toIso8601String(),
      };
}
