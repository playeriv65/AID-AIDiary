# Product decisions

What the owner decided and why, so a new maintainer neither undoes it nor
asks again. Dates are when it was settled. Ideas not built yet are in
`TODO.md`; how the code is organised is in `docs/ARCHITECTURE.md`.

## What the app is

- Debugging tools (2026-10-23): do not use Computer Use for debugging or
  verification. Use the existing CLI and Flutter tools, with explicit native
  frame verification limits. Setup and Testing own the procedures.

- Windows frame (2026-10-23): retain the native title bar and window buttons,
  showing only the application icon and AID Diary name. Match its background,
  caption text and border to the app theme. Do not merge search or entry actions
  into the title bar. This replaces the earlier same-day custom-caption preview.
- Search visibility (2026-10-23): the search toolbar remains pinned while diary
  lists scroll, on phones, tablets and desktop. Remove the duplicate-entry
  feature and its shared action; saving an entry as a template remains.
- Long journal browsing (2026-10-23): show a small top-center shortcut after
  scrolling two viewports; clicking it returns directly to the beginning.
- Feedback (2026-10-23): Settings > Help opens a text panel with prefilled GitHub
  issue and email drafts plus text copying. The user completes submission in
  their browser/mail app. Do not collect diary content or logs automatically.

- Hidden diaries (2026-10-22): preserve the hidden designation when importing
  One Diary backups. Keep hidden entries out of everyday views, search,
  statistics, widgets, ordinary exports and CLI content. Reading or revealing
  them requires local authentication in Settings > Security; backgrounding
  removes the protected content again. Full encrypted backups preserve them.
  Cross-device compatibility is an implementation limitation, documented in
  [Architecture](ARCHITECTURE.md#hidden-entries), not a completed sync feature.

- Personal migration (2026-10-22): prioritize a usable local installation,
  diary text and correct diary days/timezones. Defer additional local-encryption
  work. Preserve original sources; do not attach scanned handwritten pages to
  the imported entries. Owner-provided travel dates are sufficient for missing
  timezone evidence; do not expand the migration into forensic research.

- Personal-use boundary (2026-10-22): the owner is starting real use and
  importing personal entries into the Android release app (`dev.aid.diary`,
  displayed as AID Diary). Preserve its data, keys, preferences and live sync
  space. Development and validation use AID Diary Dev (`dev.aid.diary.beta`)
  with isolated scratch data and sync namespaces. Separate Android packages
  isolate local stores; they do not isolate a shared sync space. Never attach
  test data to the owner's live space. A release installation/update, import,
  restore, cleanup or other write to the ordinary app requires the owner's
  specific request; general development or server deployment authorization
  does not authorize it. The owner performs the planned personal import.
- First launch and tutorial (2026-10-22): show two explicit choices, “Start
  here” and “Connect to an existing device” (Chinese: “从这里开始” and
  “连接已有设备”). The latter is authorization plus initial sync, not an
  account, a network to join or a move that retires the source device. Both
  devices remain usable. Explanatory content lives in a read-only tutorial
  shared with Settings; previously saved entries remain ordinary user data,
  including edited introductory content from older installs.
- Progressive disclosure (2026-10-22): everyday screens show only what is
  necessary. Sync shows complete, partial media or waiting; copy locations
  and last confirmations are available on request inside sync details.
  Technical paths, key fingerprints and destructive maintenance controls
  belong deeper in options. Device names default to the model/computer name
  and can be edited; they do not create a user profile. After pairing, trusted
  device discovery and connection are automatic on a reachable network.
- A private diary for Windows and Android, a GPL-3.0 modification of Daily
  You that stays clearly its own app (name, IDs, the notice in About). No
  compatibility with Daily You data or with older builds of this app.
- Data stays on the device. The network is used only for map tiles, place
  names and search, nearby places, weather, and the sync the user chooses.
  No AI, no accounts, no membership, no publishing.
- No user profile: no avatar or user name anywhere (2026-10-22). The top
  card's menu opens settings, statistics and templates.

## Layout and look

- 2026-10-22: Replace the top app branding with a calendar shortcut. Calendar
  opens over the current section and returns there on Back; it is no longer a
  bottom-bar or rail destination. Keep everyday navigation to four sections.

- Diary-day wording (2026-10-22): the editor's date control is labeled
  "Diary day" (Chinese: "日记日"). Its picker says that creation time stays
  unchanged, and its hint explains that this is the day the entry belongs to.
  Selecting a day changes `Entry.day`, never `timeCreate`; both Gregorian and
  Jalali pickers keep this distinction. This is clarification of the existing
  rule, not a migration of saved dates.
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
- 2026-10-22: The editor toolbar follows the software keyboard and disappears
  on its final inset frame, without a delayed exit. The mood control opens a
  compact menu directly beneath its anchor: five moods and an explicit clear
  choice. A tap applies immediately and closes the menu; selecting the current
  mood keeps it. No confirmation dialog or second acceptance step.
- 2026-10-22: Expose one App Language selector directly in General settings,
  with System and the offered languages. Do not add a language subpage or
  separate system-language/override controls. Existing selected languages remain
  selected; System resumes following the platform locale.
- Random walk matters to the owner, who relies on One Diary's: keep it
  good.
- Appearance is independently configurable: light/system theme, optional
  separate dark palette, diary paper, original vector decorations and typography
  (2026-10-22). Group settings with previews; using system colors takes precedence
  over custom colors. The installed Durian Diary is a reference for organization,
  without copying its assets or paid-feature behavior.

## Current feature scope (2026-10-22)

- Finish device authorization, offline nearby migration, sync diagnostics,
  handwriting, configurable appearance, local photo suggestions and Android
  widgets. Use mature, compatible drawing components.
- Automate connection, path selection, retries and already-authorized sync.
  Request user action only for trust, permissions or a connection that needs
  assistance. Show the server's actual free monthly media allowance and remaining
  bytes; the official server's cache and live relay share a default 1 GB monthly
  allowance. Direct transfers do not consume it. Defer media automatically when
  allowance is exhausted. Self-hosting defaults to no plan quotas, no media TTL
  and no cache eviction; administrators may explicitly enable and configure
  limits. Never apply the official free plan merely because a server supports
  the AID protocol. The official service is the same self-hostable server with
  selected parameters enabled, not a separate code path; clients use server
  policy rather than domain-based exceptions.
- Finer mood words, goals/habits and question-grid entries remain deferred.
  Performance work will be revisited together later.

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

- 2026-10-22: Investigate Windows scrolling and scrollbar dragging against the
  active display's refresh rate using isolated generated data. This focused
  request does not resume cross-network validation or the broader Android pass.

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
- Google Drive and ordinary WebDAV retain their provider authentication;
  the AID server uses device keys and short-lived tokens after initial
  account bootstrap.

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
  connections without interaction are not promised. On 2026-10-22 the owner
  confirmed that Wi-Fi/hotspot settings guidance is sufficient; automatic
  network creation is not required. Discovery and transfer should continue
  automatically once the devices have a usable network.
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
The owner authorized production deployment on 2026-10-22; server source
`887dd27` and nginx WebSocket headers are now deployed, with the shared
operator policy explicitly enabled at 1 GB per account per UTC month.
No additional Osaka relay is needed; different-NAT testing remains deferred.
Exact evidence belongs in
`docs/SYNC_NETWORK.md`.

Offline first-time QR trust and MK transfer, nearby migration, per-device
P-256 authorization/revocation/rotation, hotspot settings assistance and GUI
diagnostics are implemented. The two devices compare a code before adoption;
the new device generates its own non-exportable key. Revocation stops server
access but cannot recall an MK or diary already copied. Automatic Wi-Fi Direct
creation is outside the approved scope; settings guidance is sufficient.
Google Drive and ordinary WebDAV retain LAN and
storage; Internet discovery requires the compatible service. Detailed
implementation boundaries and verification results belong in
`docs/SYNC_NETWORK.md`.

## Engineering and documentation

- 2026-10-22: Use [Engineering](ENGINEERING.md) for project principles and the
  change/review workflow, with [INDEX.md](INDEX.md) locating each subject's
  primary guide. Learn from official Flutter/Google guidance while recording
  local adaptations honestly; it does not authorize new product scope or a
  wholesale architecture/tooling migration. AGENTS is an execution entry point,
  not a second operations manual or a history of test/deployment results.

## Testing

- 2026-10-22: Use the researched project-wide policy in [TESTING.md](TESTING.md):
  choose tests by behavior and risk, with focused iteration, explicit batch/full
  regression and release gates. Unit tests alone do not verify UI, persistence
  or native capabilities. Reuse results for an unchanged tested state; report
  deferred or missing validation separately. The next performance pass and
  cross-network checks remain deferred.
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
- Whether voice-note transcription on the device fits "no AI".
