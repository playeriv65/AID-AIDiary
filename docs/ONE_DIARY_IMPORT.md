# One Diary backup import

The Data settings import menu offers **One Diary** (`一本日记` in Chinese).
Select its original v3 ZIP backup. The shared `data.import` action accepts
`format=one_diary`; it runs the same importer as the GUI. No password, external
service, One Diary installation or network request is needed to read this
backup format.

## Supported data and safety

- Original `createTime` and `updateTime` are epoch milliseconds. `recordTime`
  may describe a later import and must not replace creation time.
- `year`, `monthOfYear` (1 through 12) and `dayOfMonth` are the explicit diary
  day. They remain independent of the creation instant and this app's
  late-night day preference. A PDF's displayed time is not authoritative.
- Source coordinates are restored from the original thousandths-of-a-degree
  representation. Already valid degree pairs are accepted. An offline
  coordinate-to-zone lookup and the existing IANA timezone database recover
  the local clock and daylight-saving offset. This is geographic inference,
  not a timezone identifier stored by One Diary. Boundary cases and records
  without locations need review before a personal archive is consolidated.
- Without usable coordinates, the importing device's offset displays the
  original instant; the explicit diary day is still preserved. The importer
  never guesses a country from a diary category or applies an owner's travel
  dates to everybody. It does not claim to reconstruct missing source zones.
- Titles and bodies become the entry text. Categories become tags; the
  source category/type is not a new notebook. A hidden entry retains its
  hidden flag; [Architecture](ARCHITECTURE.md) describes access and current
  sync restrictions. Deleted source tombstones are not resurrected.
- Referenced photos, drawings and recordings must be inside the archive.
  Their order and original bytes are retained. HEIC is retained as HEIC;
  rendering depends on the platform codec. Remote URLs identify ZIP members
  by filename and are never fetched. Missing, empty or ambiguous attachments
  fail before any entries are added.
- Recognized weather descriptions with explicit Celsius temperatures become
  structured weather. Unknown weather/mood/color codes are retained in the
  original metadata rather than assigned a guessed meaning.
- `import_sources` records the external ID, exact revision hash, original
  record JSON and the new local entry ID. Unmapped metadata such as source
  weather/device/color remains in that provenance instead of being discarded
  or inserted as visible prose. This is local provenance, not a sync protocol.
- Reimporting the same revision leaves user edits and Recently deleted
  entries alone. Different IDs sharing a timestamp are separate entries.
  Changed source revisions are retained separately rather than overwriting
  local edits. The revision includes attachment content hashes.
- The whole archive is decoded and validated before writes. Entries commit
  individually; an attachment/storage failure rolls back the new incomplete
  entry and reports failure. Previously completed entries remain, and retry
  skips their recorded revisions. An OS crash can interrupt an individual
  write; do not delete the input archive after an unverified import.

Only v3 is supported. Unknown versions, malformed manifests and unreadable
payloads fail explicitly. Nonempty source templates are not yet supported;
they fail instead of silently disappearing. No source files or old databases
are deleted by importing.

## Consolidating other local sources

The JSON importer also accepts optional `isHidden`, `importSource` and
`photos` fields for an explicitly prepared local consolidation. An
`importSource` contains `format`, `id`, `hash` and `metadata`; this preserves
source identity and permits a retry without overwriting edits or merging
different entries that share a midnight timestamp. A `photos` item contains
`name` and Base64 `base64` bytes, validated before any entries are written.
Attachments retain their original order. Ordinary JSON exports still exclude
hidden entries and list attachment names; a full backup is a separate operation.

Keep personal conversion plans, text, source metadata and output files outside
the repository. Use owner-supplied travel dates for missing source zones and
IANA historical offsets, preserving the original instant and explicit diary
day. Date-only handwritten records must retain that precision in provenance;
an unknown date must not be silently assigned a guessed day. Scanned source
pages are reference material, not diary attachments unless explicitly requested.
Verify imported text hashes, dates, offsets, hidden flags and any requested
attachment hashes against a local manifest before considering cleanup. Retain
the original sources and a verified pre-import backup.

## Format evidence

The reader was implemented independently from static inspection of an
owner-supplied Android APK with REA/JADX, package `com.chenupt.day`, version
`1.96.62` (4669), SHA-256
`c9dd6b5829179e24cd5f95368ae0ec233b8cd5db91afdc64e0432b27c1d02bda`.
The APK was not executed; its signature was not verified. No application
code, artwork or diary content is embedded in this repository.

The native reader `m3.C1500.C` / inner class `c.m2085` identifies the members
and their fixed format keys. `k7.C1415.a`, `.b`, `.e` and static initializer
establish Base64, SHA-256 of the UTF-8 format key, AES-256-CBC, a zero IV and
PKCS#7 padding. The parameters are in
[`assets/config/one_diary_v3.json`](../assets/config/one_diary_v3.json).
They are constants embedded in that format, **not user-held encryption keys**.
CBC has no authentication tag, so a decoded backup is not authenticated data.
The diary importer validates its version, schema and referenced attachments.

Export method `m3.C1500.B` formats `createTime` using the export device's
timezone. Consequently, a PDF exported in China can show the following date
for an entry written the previous evening in Minnesota. The ZIP supplies the
original instant and explicit diary date and avoids that conversion loss.

Offline geographic lookup uses
[`lat_lng_to_timezone` 0.2.0](https://pub.dev/packages/lat_lng_to_timezone)
(MIT); its boundary map is older and approximate. Offset transitions are
handled by the app's existing `timezone` package, not a fixed US offset.

## Verification

The committed fixture is entirely fictional. Independent Python AES vectors,
same-instant records, hidden records, dates, scaled coordinates, ZIP media,
source revisions and failure handling are covered by:

```powershell
./scripts/dev.ps1 test -TestFiles test/utils/formats/one_diary_format_test.dart,test/utils/imports/import_source_test.dart,test/utils/imports/import_registry_test.dart
```

To inspect a personal backup without importing it, set `ONE_DIARY_BACKUP`
and `ONE_DIARY_REPORT` to local paths and run:

```powershell
./scripts/dev.ps1 test -TestFiles tool/verify_one_diary_backup_test.dart
```

This opt-in check decodes in memory, verifies every original creation instant
and diary date, checks attachment availability and rechecks the input hash.
The report contains local date/time metadata and hashes, never diary bodies;
keep it outside version control. It does not open the user's app database,
repair a source database or authorize import/cleanup. A passing format check
does not mean a full personal consolidation or timezone review is complete.
