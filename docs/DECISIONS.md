# Product decisions

What the owner decided and why, so a new maintainer neither undoes it nor
asks again. Dates are when it was settled. Ideas not built yet are in
`TODO.md`; how the code is organised is in `docs/ARCHITECTURE.md`.

## What the app is

- A private diary for Windows and Android, a GPL-3.0 modification of Daily
  You that stays clearly its own app (name, IDs, the notice in About). No
  compatibility with Daily You data or with older builds of this app.
- Data stays on the device. The network is used only for map tiles, place
  names and search, nearby places, weather, and the sync the user chooses.
  No AI, no accounts, no membership, no publishing.
- No user profile: no avatar or user name anywhere (2026-10-22). The top
  card's menu opens settings, statistics and templates.

## Layout and look

- The layout and the set of features follow Journey's Android tablet and
  phone versions (2026-10-20): every Journey screen has its counterpart.
  Style and implementation are our own; Journey's code, assets and text are
  never copied. Gaps are judged by side-by-side screenshots and by
  inventorying its app's resources, not by screenshots alone.
- Windows uses the tablet layout. Journey Desktop's own layout and its
  desktop-only extras are out of scope (2026-10-20).
- The entry editor follows 一本日记 (One Diary): date and time on top, tags
  top right (its "groups"), an optional centred title that exists only when
  written, a tile to add media, weather and place rows. Not its crowded
  keyboard toolbar. Back over unsaved changes asks to save or discard; the
  ✓ button saves without asking.
- Random walk matters to the owner, who relies on One Diary's: keep it
  good.
- Backgrounds, stickers and more themes wait in `TODO.md`.

## Features left out on purpose

- An app-lock timeout: the phones' own app lock covers it.
- PDF or DOCX export and printing: JSON (and Markdown) export is enough.
- Per-entry "synced" badges (Journey has them): synced is the normal state
  and shows nothing; only entries whose sync failed get a small mark.

## Command line and agents

- The app is agent-native: whatever the GUI can do or open, the `aid`
  command line can too (2026-10-21). The CLI may do more (bulk import,
  test data, repairs): a superset, not a mirror. Tests enforce it: the GUI
  changes data only through actions and opens places only through the
  registry `ui.navigate` uses.
- Kept out of the CLI on purpose: setting or changing the app lock, the
  backup password and fingerprint unlock (an agent must not lock the user
  out); `security.status` only reads them. The system's own permission
  prompts stay with the person.
- Sealed time capsules stay sealed for the CLI as in the GUI.
- Tag and category names are unique, in the GUI as in the CLI.

## Performance

- Every scenario should keep the display's refresh rate; the frame-rate
  script fails above 1% skipped refreshes. On 2026-10-21 the owner accepted
  the state recorded in `TODO.md` as good enough for now ("差不多就行"):
  scrolling meets the bar, opening an entry and first visits to tabs do
  not quite.
- Android renders with Impeller (Vulkan), the engine's future; work around
  its costs (no full-screen offscreen layers in transitions) rather than
  opting out to Skia, whose opt-out is deprecated (2026-10-21).
- Windows renders with Skia: Impeller costs about a second at every start
  there and draws edges jagged (2026-10-20).

## Sync and encryption

The remaining work is in `TODO.md` ("Sync, identity and encryption").
[SYNC_NETWORK.md](SYNC_NETWORK.md) describes the network policy and the
current implementation. Decided along the way:

- No sign-up, login or password for the diary itself. Devices hold the
  user id and master key; storage only ever holds ciphertext.
- Every space is encrypted; there are no plain spaces. Spaces of earlier
  formats are not migrated: they are started again.
- Recovery: a random recovery code by default, which the user may replace
  with a password of their own. It locks only the master key, kept with the
  space as a backup.
- Pairing is symmetric: either device may show the code and either may
  type or scan it; the key goes from whichever device holds it. Relaying
  the pairing through the server or the storage is fine. The local network
  is preferred once built, and large media should travel there rather than
  through a server with limited traffic.
- Build on the existing storage backends first (Google Drive, WebDAV, the
  AID server); device keys and short-lived tokens on the AID server come
  next.

### Automatic paths and bounded media (2026-10-22)

- Daily sync is best effort: discover, probe paths together, start work on
  an available connection, upgrade when a worthwhile direct path appears,
  and retry quietly after failure. Avoid strict LAN-then-IPv6-then-UDP-then-
  relay timeout chains. Stability, cost and throughput matter; use dwell
  and hysteresis to avoid frequent path changes.
- LAN, public direct, ICE, live relay and asynchronous cache are path types,
  not sequential stages. Live relay needs both devices online; asynchronous
  cache does not. Operator servers must never default to unlimited media
  relay or storage.
- Connection selection and sync work are separate. All paths share item
  IDs, ciphertext hashes, versions and acknowledgement semantics. Transfer
  media as verified resumable chunks so changing networks does not restart
  the entire attachment.
- Sync diary text and indexes first, then media permitted by the current
  path and budget. A synced diary with media waiting is normal. Large media
  waits for direct transfer when the operator-cache allowance is too small;
  it must not silently consume unlimited paid server traffic. Personal
  storage has its own provider limits, separate from the operator budget.
- Keep ordinary status simple: synced, some media pending, or waiting for
  another device. Background failures back off without immediate popups.
  Protocol and route details belong in diagnostics, not the daily workflow.
- Nearby device migration should favor direct transfer while reusing
  discovery, authentication and chunk protocols. The intended flow is scan,
  find a fast connection, transfer and verify. Same-Wi-Fi or hotspot
  assistance may require user action; arbitrary cross-platform offline
  connections without interaction are not promised.
- A temporary cache is not a backup. Transfer completion and the existence
  of durable copies must remain separate concepts. Do not discard the last
  intended persistent media copy merely because the cache accepted it.
- New spaces use format 4; older sync formats are rejected. Unsupported
  formats do not authorize deleting a diary or resetting a live remote
  space. Start a new space or use an explicitly approved reset; there is no
  automatic migration.

Implemented now: the path selector, authenticated LAN transport integrated
with shared storage, persistent chunk tasks, operator-cache limits, and for
AID-compatible WebDAV accounts, an authenticated Internet directory,
encrypted public address exchange, WebRTC/STUN and bounded live relay.
Live relay and cache use separate finite budgets. Directory presence does
not grant trust: peers confirm MK with fresh client nonces as well as server
sessions, and object RPC is bound to the resulting sessions/generation.
The app configures no TURN service. Same-Wi-Fi Windows/Pad checks verified
LAN, global-IPv6 direct, UDP ICE and bounded relay transfers, quota refusal
and an automatic LAN upgrade. The owner deferred a different-network test;
cross-WAN reachability and a general NAT matrix remain unverified. With
the latest binaries, established ICE also continued syncing text and new
hash-verified media after a one-sided signaling disconnect and after the
isolated test server stopped; directory `leave` must not discard a working
direct link. Temporary-service/device-test cleanup was verified, including
restored nginx, production health 200 and removed test endpoint health 404.
The final Flutter suite passed 710 tests, with six external-service tests
skipped; the production server still needs the networking release deployed.
Exact evidence belongs in
`docs/SYNC_NETWORK.md`.

Offline first-time trust, Wi-Fi Direct/hotspot assistance and individual
device-key revocation remain future work. Network authentication currently
proves possession of the same MK, rather than a separate device signing
key. Google Drive and ordinary WebDAV retain LAN and storage; the directory
and Internet transports require the compatible server service. The new
nearby migration flow and an advanced GUI diagnostics page have not been
implemented. Detailed implementation boundaries and verification results
belong in `docs/SYNC_NETWORK.md`.

## Testing

- The Xiaomi Pad 7 is the test device; the owner's phone only when asked
  (`docs/SETUP.md`).
- Windows test runs never show or focus a window; they run hidden.
- Reference apps are installed only from official stores on the owner's
  devices and pulled with adb, never from third-party sites.

## Open questions

- Whether the default sync service is for users mainly in China or
  abroad: it decides where the AID server runs and how much Google Drive
  matters.
- Conflicts: today the newer edit of an entry wins and the other goes to
  Recently deleted. Merging by field with a hybrid logical clock is
  proposed, not decided.
- Whether `ui.navigate to=entry` should follow the layout as a tap does
  (detail pane on wide windows) instead of always pushing a page.
- Whether voice-note transcription on the device fits "no AI", and
  whether inserting an image from a web address fits a local diary.
