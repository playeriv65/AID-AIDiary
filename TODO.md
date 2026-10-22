# TODO

Ideas collected from Journey and other diary apps, not built yet. Roughly in order of value.

## Journey parity
The reference is Journey 5.7.0C for Android tablets and phones; Windows uses the same tablet layout. Inventoried 2026-10-20 from its resources and screens, reference only. Done: shell, journal, detail, editor, calendar, media, atlas, coach with program enrolment, search, the story chain (coach prompt, wrap-up), statistics, settings tree, onboarding, help, reminders, quick-write notification, nudges, status and photo widgets, location sheet and picker, share sheet, EXIF date and place, backup.

Left from Journey Android:
- Insert an image from a URL (needs the network; decide whether it fits a local diary).

Probably skip (Journey has them, but they need cloud or AI or add little): Google Fit, rate dialog, live chat, external-link warning, automatic media categories (an image classifier), an in-app media picker.

## Look and feel
- Letter-paper backgrounds for the editor and reader (lined, grid, tinted paper).
- Sticker and washi-tape decorations, in the style of journaling ("手帐") apps.
- More colour themes and a separate dark-theme choice.

## Features
- Multiple journals, each with a colour and icon, viewed together or apart (Day One, Apple Journal).
- Finer moods: emotion words plus "who with / where" context (How We Feel). This would sharpen "What makes me feel…".
- Goals and habits on top of trackers: target values, streaks, milestones (Daylio, Stoic).
- On-device suggestion cards: "12 photos at the park today" from local photos and places (Day One Moments, Apple Journal). Offline only, no AI.
- Question grid entries, with a view of every answer to one question over time (Grid Diary / 格志).
- Read entries aloud with text-to-speech (一本日记).
- Voice note transcription: needs on-device speech recognition; decide whether that fits "no AI".
- Handwriting and drawing on tablets.
- More home-screen widget kinds: streak, prompt of the day, quick mood.

## Frame rate (state of 2026-10-21)
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
and task queues; metadata-first sync and bounded operator-cache media.
New remote spaces use format 4; older formats require a new space or an
explicitly approved reset, never an automatic deletion or migration.

Remaining work:

- Validate Windows-to-Android mDNS discovery and path changes on the physical
  test devices. Native discovery between isolated Windows clients, LAN media
  hash verification and metadata sync with the test cloud offline pass.
- Public address directory and reachable IPv4/IPv6 candidates outside LAN;
  ICE/STUN and UDP connectivity checks; bounded live relay. Selector types
  alone do not implement these paths. Keep live relay distinct from the
  asynchronous media cache that already exists.
- First-time offline QR trust and MK transfer, a nearby migration flow,
  Wi-Fi Direct/hotspot assistance and platform permission handling. Reuse
  chunk semantics and prefer direct transfer; assistance can require user
  interaction. Current storage-based pairing remains necessary to establish
  the shared MK before LAN authentication.
- Per-device P-256 signing keys and server challenges/short-lived access
  tokens instead of the AID server's WebDAV passwords; authorization and
  revocation of individual devices, then key rotation. Current LAN HMAC
  proves a shared MK, so it cannot revoke one device independently. Revoking
  tokens cannot take away an MK already held by a lost device. Keep signing
  keys non-exportable where supported: approving a new device authorizes
  its own key and transfers MK, rather than copying a hardware-bound key.
- Advanced network diagnostics UI. `sync.status` and `sync.network` already
  expose routes, retry times and media/durability counts to the CLI.
- A user-facing durable-copy view, separate from transfer completion. The
  operator cache can expire; successful transfer does not by itself prove
  a reliable backup, and a peer's retention is not guaranteed.
- Conflict handling beyond newer-wins with the losing local entry kept in
  Recently deleted. Field merging and a hybrid logical clock remain open
  product decisions.

## Decided against for now
- App lock timeout: phones' own app-lock features cover it.
- PDF/DOCX export and printing: JSON export (and Markdown) is enough.
- AI assistant, membership, publishing, web links.
- Journey Desktop's own layout and desktop-only extras (sidebar with tags, draggable split, settings dialog, custom title bar, calendar week strip, media strip in search, keyboard shortcuts, jump list): Windows reuses the Android tablet layout (decided 2026-10-20).
