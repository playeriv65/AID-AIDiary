// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Sync ids (the `uuid` column) that every device derives the same way from
/// the same input. Two devices that make the same item on their own, such as
/// importing one file or naming the same tag, then hold one item that sync
/// merges, instead of two that both survive. What a person writes on one
/// device keeps a random id; a day's weather has its own (`DayWeather`).
String _derived(List<Object> parts) =>
    md5.convert(utf8.encode(jsonEncode(parts))).toString();

/// An entry imported from the item [id] of [format] at revision [hash]: what
/// `import_sources` records, so a changed revision stays a separate entry.
String importedSourceSyncId(String format, String id, String hash) =>
    _derived(['import', format, id, hash]);

/// An entry imported from a format that names no item: its written time,
/// which is also what makes a second import skip it.
String importedTimeSyncId(DateTime timeCreate) =>
    _derived(['import', timeCreate.toIso8601String()]);

/// The attachment at [index], in rank order, of the imported entry
/// [entrySyncId].
String importedImageSyncId(String entrySyncId, int index) =>
    _derived([entrySyncId, 'image', index]);

/// A tag named [name], whatever its case and surrounding spaces.
String tagSyncId(String name) => _derived(['tag', _nameKey(name)]);

/// A tag category named [name], like [tagSyncId].
String categorySyncId(String name) => _derived(['category', _nameKey(name)]);

/// The conflict between the version of entry [entrySyncId] a device held
/// back, changed at [heldModified], and the space's, changed at
/// [syncedModified]. Finding the same pair again keeps one conflict.
String conflictSyncId(
        String entrySyncId, int heldModified, int syncedModified) =>
    _derived(['conflict', entrySyncId, heldModified, syncedModified]);

/// The second entry made when both versions of a conflict are kept: the
/// held-back version of entry [entrySyncId], changed at [heldModified].
/// Keeping both on two devices makes one second entry.
String conflictBothSyncId(String entrySyncId, int heldModified) =>
    _derived(['both', entrySyncId, heldModified]);

String _nameKey(String name) => name.trim().toLowerCase();
