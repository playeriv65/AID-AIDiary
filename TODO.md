# TODO

Ideas not built yet, roughly in order of value.

## Layout and features
Windows uses the tablet layout. Done: shell, journal, detail, editor, calendar, media, atlas, coach with program enrolment, search, the story chain (coach prompt, wrap-up), statistics, settings tree, onboarding, help, reminders, quick-write notification, nudges, status and photo widgets, location sheet and picker, share sheet, EXIF date and place, backup.

Probably skip (they need cloud services or add little): Google Fit, rate dialog, live chat, external-link warning, automatic media categories (an image classifier), an in-app media picker.

## Appearance (owner request 2026-10-23)
- Fewer accent colours, including a pure black-and-white one.
- The accent colours only key marks (logo, key icons, emphasised text); it
  must not tint backgrounds or surfaces.
- Backgrounds: the owner wants neutral black and grey, not the current blue
  tint; a tinted background may stay as one option for those who like it.
  Tune it together with the owner, not alone (2026-10-25).
- Weather icons (owner 2026-10-25: keep Meteocons for now, improve later).
  At 14-20 px the Meteocons clouds fill most of the drawing and the canvas
  has wide margins, so partly cloudy, overcast, fog and rain look alike.
  Compared: Fluent Emoji flat (MIT) and Twemoji (CC BY 4.0) read best among
  open sets; the iconfont.cn set "天气" by 堇年0923 (cid 38809,
  no license: needs the author's permission). A draft of our own in
  Material Symbols shapes (Apache 2.0) with colour, a large sun in partly
  cloudy and thick rain streaks, read clearly at 14 px; its generator and
  comparison sheets were not kept in the repository.

## Build automation (owner request 2026-10-23)
- Done (2026-10-24): CI on every push to main, a debug-signed nightly
  prerelease, and the repository made public after a history review
  (`docs/TESTING.md`, "Continuous integration"). Since 2026-10-29
  the nightly is signed with the release key and Android apps update
  themselves from it (`docs/UPDATES.md`). Open: Windows and Linux updates
  (download the archive, swap the files after the app exits), and the AID
  server mirroring the nightly for mainland China.
- Linux (owner request 2026-10-24): target restored and packaged nightly.
  Open: video and voice-note playback (`video_player` has no Linux
  implementation; the player shows "unavailable"), unlocking hidden
  diaries without an app password (no system authentication on Linux),
  a desktop entry and icon for the bundle, and a check on a real Linux
  desktop.
- iOS and macOS (owner 2026-10-24: "以后能做了再做"): restore the targets
  and package them once there is an Apple developer account for signing;
  CI would need a macOS runner.

## Day photos from the album (owner request 2026-10-25)
An entry shows, below it, a scrolling strip of the photos the device's own
album holds from that diary day, read in place and never copied. "Add to
entry" copies one into the entry's media, so from then on it is kept,
synced and backed up with the diary. Nothing about the strip is stored or
synced: each device shows its own album's photos of the day, so an album
that syncs itself (Google Photos, OneDrive, a NAS) shows the same day on
every device, and the diary holds only what was added.

Assessed 2026-10-25:
- Android: easy, the parts exist. `LocalPhotos.kt` (`aid.local_photos`,
  used by Photo moments) already queries MediaStore by date and copies one
  photo for import. Needed: a day range (start and end from `DiaryDay`), a
  thumbnail call (`ContentResolver.loadThumbnail`), the strip in the entry
  view, and "add" through `MediaImport.storeImage`. Same permission as Photo
  moments (`READ_MEDIA_IMAGES`; with Android 14's selected-photos access
  only those show).
- Windows and Linux: more work. Today's scan reads one folder, not
  recursively, at most 5000 files; finding a day across a whole library
  needs an index of photo dates (path, taken, size, modified) kept up to
  date incrementally. Reading EXIF from cloud placeholders (OneDrive files
  on demand) would download every file, so take the date from the file name
  or the system's property index there.
- Open: a setting to turn it on (off by default: it shows album photos
  inside the diary, also on a shared screen); whether hidden entries show
  it; videos too; `aid` actions to list a day's album photos and add one.

Where added photos live (discussed 2026-10-25): the owner wants no second
copy on a device that already has the photo, and diary photos visible in
the system gallery.
- Each entry photo records its content hash. On every device, an album file
  with exactly that hash is referenced, not copied: the original on the
  phone that took it, or a copy an album sync already put on the device.
  Only exact hashes count; a re-encoded copy (Google Photos storage saver,
  HEIC to JPEG, edited metadata) is a different photo, and photos are not
  matched by time taken (bursts would match).
- Google Photos' and Xiaomi Cloud's cloud-only photos are not files on the
  device, so they cannot be referenced; only downloaded ones can.
- The encrypted copy in the sync space always stays: a device may skip its
  own copy, never the space. A reference that breaks (photo deleted,
  edited, or replaced by a thumbnail when the gallery frees space) is
  fetched again from the space.
- A device that has no matching file stores the photo either in the app's
  private storage or in an `AID Diary` album in the system gallery
  (`Pictures/AID Diary` on Windows); the default is the owner's to decide.
  In the gallery, photos are readable by any app with photo access and
  uploaded by the gallery's own cloud backup unencrypted, so hidden
  entries' photos never go there.
- Android limits: after a reinstall the app no longer owns the files it put
  in the gallery (changing them needs the user's confirmation each time),
  and with Android 14's selected-photos access unselected photos cannot be
  referenced.
- This reworks the media layer (storage, sync, backup, deleting an entry
  must know both places): several days, Android first.

## Deferred features
- Finer moods: emotion words plus "who with / where" context (How We Feel). This would sharpen "What makes me feel…".
- Goals and habits on top of trackers: target values, streaks, milestones (Daylio, Stoic).
- Question grid entries, with a view of every answer to one question over time (Grid Diary / 格志).
- Voice note transcription: on-device speech recognition, or the model the user configured for the agent.
- In-app agent (decided 2026-10-24, docs/DECISIONS.md "What the app is"). Built without a GUI, development builds only (`agent.*`, `acp.*` actions; docs/ARCHITECTURE.md "In-app agent"): `dart_agent_core` on a user-chosen OpenAI-compatible model (DeepSeek by default), working through a bashkit shell (`rust/`) whose `aid` and read-only `sql` reach the diary; agents on a computer over ACP (`acpd`). Open:
  - Authorization, before release builds get these actions: ask the user before a destructive `aid` (today `--yes` inside the shell passes), show ACP permission requests to the user (today the first allow-once option is chosen), keep hidden diaries out of `sql` unless unlocked (today it reads every table), and decide what the model provider may receive.
  - The chat window (one window for the in-app agent and ACP agents) and a settings page for the model and key.
  - Android: the shell and `agent.ask` work in the dev app on the tablet (2026-10-24, debug build). Open: the release size per ABI, a foreground service for long runs, and bashkit's 1 MB output cap per command (it stops `sql` piped whole into jq; the model narrows with SQL instead).
  - Claude over ACP needs the `claude` command line logged in on that computer (`claude` then `/login`); Codex works with its own login.
  - cargokit's Gradle plugin is patched for AGP's `android-37.0` compile SDK (`rust_builder/cargokit/gradle/plugin.gradle`); drop the patch when cargokit fixes it upstream.
  - Ship `aid` with the desktop app so ACP agents find it without `agent.configure cli=...`.
  - Size: the shell library is 11.6 MB on Windows (bash core, jq, time zones, the Rust–Dart bridge); trim features if it matters.
  - Later: a vector index (sqlite-vec, not the Elastic-licensed sqlite-vector) and a read-only `/diary` view of entries as files.

## Frame rate (state of 2026-10-21)
The broader Android pass remains deferred by the owner from 2026-10-22.
The focused Windows scrollbar investigation is recorded in
[docs/REFRESH_RATE.md](docs/REFRESH_RATE.md). Large jumps no longer construct
the intervening diary, but the extreme 4000-entry/5-second traversal still
misses the 120 Hz/1% acceptance bar. Paragraph layout and transient widget
allocation remain the measured bottleneck; do not mark Windows universally
full-rate or treat an ordinary fling as proof about thumb dragging.
Measured with `./scripts/dev.ps1 frame-rate` on the Xiaomi tablet (3200×2136, 120 Hz, Snapdragon 7+ Gen 3, Impeller/Vulkan), skipped refreshes on screen against the 1% bar:

- Journal scroll about 1.4–1.8%, media scroll about 0.8%.
- Opening an entry about 3.5% (was 13–14% before the layer-free page transition and the shell no longer rebuilding). Left: the entry page's first build (25–34 ms on some opens, about half of it `markdown_widget` parsing the text in `build`), and the GPU drawing two whole pages for the first frames of a transition.
- Switching tabs about 7.7% as measured, mostly not what a person sees: a tab's first visit builds it (22–36 ms, deliberate so the map loads no tiles until opened), and `aid ui.navigate` sends no touch, so the system raises no clocks. Real taps on tabs already visited skip about 1.5%.
- Possible next steps: an action that tells where a widget is on screen (e.g. `ui.locate key=…`) so the script taps like a person on Android, with first visits and repeats reported apart; build the entry text after the page's first frame (the arriving page is hidden for the first quarter of the transition).
- On wide layouts tapping an entry shows it in the detail pane, while `ui.navigate to=entry` always pushes a full page; decide whether navigation should follow the layout as the tap does.
- Skia draws the open-entry transition about 3× faster than Impeller here (4× MSAA offscreen layers); staying on Impeller, as Skia's opt-out is deprecated.

## Sync, identity and encryption (state of 2026-10-22)

Local-first, always end-to-end encrypted, with identity and keys held by
devices. The approved policy and exact implementation boundaries are in
[docs/SYNC_NETWORK.md](docs/SYNC_NETWORK.md); decisions are in
[docs/DECISIONS.md](docs/DECISIONS.md).

Implemented: encrypted spaces on Google Drive, WebDAV and the AID server;
platform-stored identity/MK, wrapped data keys and Argon2id recovery;
symmetric SPAKE2 pairing through shared storage; concurrent route selection
with upgrades, dwell and quiet retries; HMAC-authenticated IPv4/IPv6 LAN
transport integrated with shared storage; persistent encrypted media chunks
and task queues; metadata-first sync and bounded operator-cache media;
account-scoped WebSocket presence/signaling, encrypted global IPv4/IPv6
address exchange, MK-authenticated public probes, WebRTC/STUN data channels
without TURN, and bounded live relay with independent persistent quotas.
Internet paths require an AID-compatible WebDAV networking service; Google
Drive and ordinary WebDAV retain LAN plus storage. Fresh client nonces and
MK confirmation protect server-session discovery from replay. Development
path restrictions and isolated Android test workspaces are implemented.
New remote spaces use format 4; older formats require a new space or an
explicitly approved reset, never an automatic deletion or migration.

Device-owned P-256 keys, challenge authentication, individual authorization,
revocation and key rotation are implemented. Nearby QR trust and offline
migration transfer identity/MK and verified chunks without copying private
signing keys. The GUI includes network diagnostics and actual server traffic
allowances. Official-server limits are opt-in server policy; self-hosting
defaults to durable storage without plan quotas.
Editable device-local names and a sync-details view of last-confirmed named
copies are implemented. Everyday status remains compact; technical network
and key details require opening further options. A matching dataset revision
and complete local media inventory are required for a peer's complete-copy
label; offline confirmations and temporary cloud storage remain explicit.
Production server source `887dd27` and nginx WebSocket headers were deployed
on 2026-10-22 with operator limits enabled and a 1 GB monthly media allowance.
External HTTPS, WebDAV and WebSocket relay acceptance passed; the temporary
account was removed and the existing account retained (`docs/SYNC_NETWORK.md`).

Remaining work:

- Carry settings and small preferences when adding a device and in full
  backups (owner decision 2026-10-23, `docs/DECISIONS.md`). Today sync and
  backups carry diary data (entries, media, tags with their order,
  templates) but no settings; decide which settings are device-specific.

- Extend the same-Wi-Fi Windows/Pad validation to another network. LAN,
  global-IPv6 direct, UDP
  ICE media, small live-relay media, quota refusal and automatic LAN upgrade
  have passed with matching hashes (`docs/SYNC_NETWORK.md`). The owner
  deferred another-network testing; cross-WAN public reachability and a
  broader NAT/carrier matrix remain unverified. The external IPv6/TCP
  probe timed out, so local global-address success must not be presented as
  cross-WAN success.
- Conflict handling beyond newer-wins with the losing local entry kept in
  Recently deleted. Field merging and a hybrid logical clock remain open
  product decisions.

## Android package name (owner to do)
The Android package `dev.aid.diary` reads as the domain `aid.dev`, which
someone else has registered and serves a site on. Nothing breaks today
(Android does not check domains), but a store or a developer registry
gives a package name to whoever claims it first. Move to a prefix from the
owner's own domain, e.g. `com.playeriv65.aiddiary` and `.beta` for the dev
flavor (2026-10-23, proposed; the owner will carry it out):

- `applicationId` in `android/app/build.gradle` (the Kotlin `namespace` may
  stay), the CLI's default package in `cli/lib/aid_cli.dart`, and the
  package names in docs and scripts.
- Google Cloud: Android OAuth clients for both new packages with the same
  SHA-1 (`docs/GOOGLE_DRIVE.md`).
- The owner's diary: install the renamed release beside the old app (a new
  package needs the HyperOS confirmation on the device), bring the diary
  over with "Connect to an existing device" or a full backup and restore,
  check it, then uninstall the old app.

## Decided against for now
- Duplicate-entry action: removed at the owner's request (2026-10-23); save as template remains.
- Automatic Wi-Fi Direct/hotspot creation: the implemented Wi-Fi/hotspot
  settings guidance is sufficient (2026-10-22). Automatically discover and
  connect trusted peers once a usable network exists.
- App lock timeout: phones' own app-lock features cover it.
- PDF/DOCX export and printing: JSON export (and Markdown) is enough.
- Membership, publishing, web links.
- Desktop-only layout and extras (sidebar with tags, draggable split, settings dialog, custom title bar, calendar week strip, media strip in search, keyboard shortcuts, jump list): Windows reuses the Android tablet layout (decided 2026-10-20).
