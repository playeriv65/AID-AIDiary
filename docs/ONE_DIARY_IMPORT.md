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

The source-app reader `m3.C1500.C` / inner class `c.m2085` identifies the members
and their fixed format keys. `k7.C1415.a`, `.b`, `.e` and static initializer
establish Base64, SHA-256 of the UTF-8 format key, AES-256-CBC, a zero IV and
PKCS#7 padding. The parameters are in
[`assets/config/one_diary_v3.json`](../assets/config/one_diary_v3.json).
They are constants embedded in that format, **not user-held encryption keys**.
CBC has no authentication tag, so a decoded backup is not authenticated data.
The diary importer validates its version, schema and referenced attachments.

### How the format was reconstructed

The recorded investigation followed the backup import/export call sites in
the decompiled APK, then traced the crypto helper they called. The reader
established which member used which embedded string; the helper established
the byte encoding, key derivation, block mode, IV and padding. This recovered
the format parameters rather than guessing a password or breaking AES.
Class/method names above are obfuscated names from this specific APK and are
not stable identifiers for another release.

The retained `base.apk` in the external reference location listed in
[Setup](SETUP.md#outside-resources) was hashed again on 2026-10-23 and matched
the SHA-256 above. This checks artifact identity, not its signature. The
repository preserves the independent reader, compatibility constants and
fictional test vectors; it does not contain the APK, decompiled source, a
complete REA session transcript or a fixture-generation script. Another
maintainer should not claim a fresh decompilation merely from reading this
guide. To repeat static analysis, obtain the matching reference APK, verify
its hash and inspect its own import/export and crypto call chain. Do not
copy application code into this project.

### Exact v3 envelope

The ZIP is an archive container, not a password-protected ZIP envelope. Its
metadata members contain separately encrypted Base64 text. Media referenced
inside it is read as original attachment bytes.

| ZIP member | Required | Decoded JSON |
|---|---|---|
| `version` | Yes | Number `3` |
| `source.json` | Yes | Array of diary records |
| `category.json` | Yes | Array mapping category UUIDs to names |
| `tag.json` | No | Array mapping tag UUIDs to names; absent means empty |
| `model.json` | No | Array of templates; nonempty is currently rejected |

For a member named `name`, use the corresponding `payloadKeys[name]` from
the [protocol configuration](../assets/config/one_diary_v3.json). Treat that
string as UTF-8 input to SHA-256, not as a hexadecimal key or user password:

```text
seed = protocol.payloadKeys[name]
key  = SHA256(UTF8(seed))             # raw 32-byte digest, not hex text
iv   = 00 repeated 16 times

write: JSON -> UTF8 -> PKCS7 -> AES-256-CBC(key, iv) -> Base64 -> ZIP member
read:  ZIP member -> UTF8/trim -> Base64 decode -> AES-256-CBC decrypt
       -> PKCS7 unpad -> UTF8 -> JSON parse
```

The block size is 16 bytes. The current decoder rejects empty ciphertext
and ciphertext whose decoded length is not a multiple of 16. Any member
decode failure reports only its member name, never ciphertext or diary text.
The seed is fixed per member across backups, and the IV is fixed at zero;
there is no per-backup salt, user-password KDF, MAC or authentication tag in
this observed envelope. Successful padding/JSON parsing is not authenticity
verification. These observations do not establish how other backup versions,
the source app's live database or its cloud synchronization are encrypted.

For a small interoperability check, decrypt `versionCiphertext` in
the [fictional vector](../test/fixtures/one_diary/vector.json) using the
configured `version` seed: the parsed plaintext is JSON number `3`.
The same vector's diary payload must contain two records and first
content `Evening notes.`. The committed test checks those expectations with
the Dart reader; the earlier independent Python vector is historical
cross-library evidence, not evidence of running the original APK.

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

## Maintainer map

| Responsibility | Entry point |
|---|---|
| Fixed member keys, version and coordinate/weather compatibility data | [Protocol JSON](../assets/config/one_diary_v3.json), [loader](../lib/config/one_diary_config.dart) |
| Base64/AES decoding and source-record conversion | [OneDiaryCodec / decodeOneDiaryArchive](../lib/utils/formats/one_diary_format.dart) |
| GUI and `data.import format=one_diary` registration | [ImportRegistry](../lib/utils/imports/import_registry.dart), [data actions](../lib/actions/data_actions.dart) |
| ZIP lifecycle and decode-before-write boundary | [importArchive](../lib/utils/imports/import_archive.dart) |
| Provenance, retries and attachment rollback | [import helpers](../lib/utils/imports/import_helpers.dart), [source integration tests](../test/utils/imports/import_source_test.dart) |
| Fictional vectors and format edge cases | [format tests](../test/utils/formats/one_diary_format_test.dart), [fixture ZIP](../test/fixtures/one_diary/v3.zip) |
| Registry wiring | [registry tests](../test/utils/imports/import_registry_test.dart) |
| Opt-in, decode-only personal-backup review | [verification tool](../tool/verify_one_diary_backup_test.dart) |

For a new failure, first distinguish ZIP/member lookup, Base64/block decoding,
padding/JSON/schema, timezone mapping, missing attachments and storage commit.
Run the focused checks above against fictional data before considering an
explicitly selected personal archive. Never make an unreadable backup look
successful by skipping a member or record. Unknown versions require new
format evidence, not trial decryption followed by an import.
