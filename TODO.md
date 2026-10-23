# TODO

Ideas collected from Journey and other diary apps, not built yet. Roughly in order of value.

## Journey parity
The reference is Journey 5.7.0C for Android tablets and phones; Windows uses the same tablet layout. Inventoried 2026-10-20 from its resources and screens, reference only. Done: shell, journal, detail, editor, calendar, media, atlas, coach with program enrolment, search, the story chain (coach prompt, wrap-up), statistics, settings tree, onboarding, help, reminders, quick-write notification, nudges, status and photo widgets, location sheet and picker, share sheet, EXIF date and place, backup.

Probably skip (Journey has them, but they need cloud or AI or add little): Google Fit, rate dialog, live chat, external-link warning, automatic media categories (an image classifier), an in-app media picker.

## Deferred features
- Finer moods: emotion words plus "who with / where" context (How We Feel). This would sharpen "What makes me feel…".
- Goals and habits on top of trackers: target values, streaks, milestones (Daylio, Stoic).
- Question grid entries, with a view of every answer to one question over time (Grid Diary / 格志).
- Voice note transcription: needs on-device speech recognition; decide whether that fits "no AI".

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

- Add a negotiated, backward-safe hidden-entry sync protocol. Current hidden
  entries remain local; sync and nearby diary transfer fail closed while any
  hidden row exists, including Recently deleted. Encrypted backups preserve
  them. Never send a visibility flag that an older client silently ignores.

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

## Decided against for now
- Duplicate-entry action: removed at the owner's request (2026-10-23); save as template remains.
- Automatic Wi-Fi Direct/hotspot creation: the implemented Wi-Fi/hotspot
  settings guidance is sufficient (2026-10-22). Automatically discover and
  connect trusted peers once a usable network exists.
- App lock timeout: phones' own app-lock features cover it.
- PDF/DOCX export and printing: JSON export (and Markdown) is enough.
- AI assistant, membership, publishing, web links.
- Journey Desktop's own layout and desktop-only extras (sidebar with tags, draggable split, settings dialog, custom title bar, calendar week strip, media strip in search, keyboard shortcuts, jump list): Windows reuses the Android tablet layout (decided 2026-10-20).
