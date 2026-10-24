# Architecture

AID Diary follows Flutter's official app architecture guidance
(<https://docs.flutter.dev/app-architecture>, with its recommendations at
<https://docs.flutter.dev/app-architecture/recommendations>), adapted to a
single-user, offline-first app. This file says how the guidance maps onto this
repository and which rules are enforced. Read the official guide for the
reasoning; this file only records our decisions.

The [engineering policy](ENGINEERING.md) explains how recommendations become
project rules; the [documentation index](INDEX.md) locates related guides.

## Adoption and deliberate adaptations

Status reviewed on 2026-10-22. Flutter's recommendations are not a claim that
every existing module has already been refactored to match them.

| Guidance | Current project choice | Reason and revisit condition |
|---|---|---|
| UI/data separation, owned state and one-way updates | Adopted as the boundaries below; stores/providers are repository-like owners | Keep behavior shared across screens and CLI; enforce dependency direction |
| Views and view models | Partially adopted: editor logic is extracted; some other screens still read stores directly | Extract meaningful screen logic when touched; do not claim complete MVVM |
| Dependency injection and abstract repositories | Partial substitution through constructor parameters; existing singleton stores/services remain | Improve concrete hidden-state/testing or backend-substitution problems in the affected area; no new global service locator |
| Separate domain/use-case layer | Conditional, not imposed project-wide; pure rules and shared actions already have owners | Add another layer only for demonstrated complex/repeated orchestration |
| Router, model generators and directory names from examples | Current routing, handwritten immutable models and role-based folders remain | Compare migration benefits/costs when a real limitation appears, not for sample conformity |

## Principles we take from the guide

- **Separation of concerns.** UI code shows state and forwards user intent.
  Data code reads and writes storage and the network. Rules that decide
  things (which diary day an entry belongs to, what a streak is) live in
  plain Dart that neither of them owns.
- **Layers depend downwards only.** UI → data → plain models and logic.
  Never back up. This is enforced (see below).
- **Single source of truth.** Each kind of data has exactly one owner that
  holds it in memory and writes it: `EntryStore` for entries,
  `EntryImagesProvider` for attachments, `TagsProvider`, `TemplatesProvider`,
  `ConfigProvider` for settings. Pages never keep their own copy of stored
  data beyond what they are editing.
- **Unidirectional data flow.** A page calls a store method; the store writes
  SQLite, replaces its list (lists are never mutated in place) and notifies;
  pages rebuild from the new list.
- **Immutable models.** Models are plain classes with `final` fields and a
  `copy(...)`; nothing edits a model in place.
- **Testable logic.** Logic is reachable without a widget: stores and pure
  modules have unit and integration tests, pages have widget tests.

## Layers and folders

| Layer | Folders | Role in the guide |
| --- | --- | --- |
| UI | `pages/` (screens), `layouts/` (the app shell around them), `widgets/` (shared components), `routing/` (opening screens) | Views; view models where a screen has its own logic (see below) |
| Actions | `actions/` (`AppAction`s by area, the `AppActions` registry, the agent API) | The guide's commands and use cases, named so the CLI can call them |
| Data | `database/` (`EntryStore` and DAOs over SQLite), `providers/` (stores for attachments, tags, templates), `storage/` (files, secret store, folder picker), `services/` (network and platform: place names, weather, home widget, coach schedule), `background/` (alarms and backup work that run without the UI), `sync/` (sync engine, encryption and backends) | Repositories (`EntryStore`, `providers/`) over services (DAOs, `storage/`, `services/`) |
| Pure | `models/`, `stats/`, most of `utils/` (dates and diary days, previews, formats, imports) | Domain models and logic |
| App | `main.dart` (start-up only), `config/` (`app_config.json` access), `l10n/` | Composition and configuration |

Some modules still sit at the top of `lib/` (`config_provider.dart`,
`notification_manager.dart`, `time_manager.dart`, `flashback_manager.dart`
and others). Treat them by role: settings and notifications are data, time
formatting is UI helper. Move one into its folder when a change touches it.

### Rules (enforced)

`test/architecture/layer_boundaries_test.dart` fails on any of these:

1. `models/` and `stats/` import no app layer and no Flutter UI library.
2. The data layer (`database/`, `storage/`, `services/`, `providers/`, `sync/`,
   `background/`) imports nothing from the UI (`pages/`, `widgets/`,
   `layouts/`, `routing/`) and not `main.dart`.
3. The UI never imports a DAO; it goes through the stores.
4. `widgets/` never imports `pages/`; shared widgets open screens through
   `routing/` (`AppNavigation`, `EntryNavigation`).
5. `utils/` imports no UI, so every layer may use it.
6. `actions/` imports no UI: actions also run with no screen at all.
7. Nothing imports `main.dart`.

`test/architecture/diary_day_rule_test.dart` keeps every day-based rule on
`entry.day`, never the date of `timeCreate`.

When a rule gets in the way, fix the dependency (move the code to the layer
it belongs to, or pass a callback down) rather than adding an exception;
there is no exception list.

## View models

The guide puts each screen's logic in a view model beside its view. Most of
our screens are thin and read stores directly, which is fine. A screen gets
a view model (a `ChangeNotifier` next to the page, `pages/<name>_view_model.dart`)
once it holds logic of its own: saving and discarding drafts, validation,
multi-step flows. The page then only builds widgets from the view model's
state and calls its methods; test its logic without widgets at the layer its
dependencies require.

The entry editor is the worked example. `EditEntryViewModel`
(`pages/edit_entry_view_model.dart`) holds what is edited, autosaves drafts,
keeps or rolls back the session on leaving, picks the diary day and fills in
place and weather; it takes its store, services and clock as constructor
parameters, and `test/pages/edit_entry_view_model_test.dart` covers it
without a widget, using real SQLite in the host-integration layer.
`AddEditEntryPage` keeps only the text controllers, the
dialogs and navigation, reports typing and choices to the view model and
redraws when it notifies.

`EditorKeyboardSession` consumes the current keyboard inset without a dismissal
timer; writing tools disappear in the same frame the inset reaches zero. Only
the action-bar scope observes inset changes, keeping the body text out of that
rebuild path. The editor's `MenuAnchor` owns the local mood popup; its six
accessible choices report directly to the view model, with no staged selection.

The editor labels its date control "Diary day" and explains that choosing a
date changes grouping rather than creation time. `TimeManager.pickDate` forwards
the optional contextual header to both calendar implementations. The save/cancel
flows are covered by `test/pages/editor_diary_day_test.dart`, including retained
creation timestamps, UTC offsets and body text in an isolated store.

### UI work and shared state

The shell retains four lazily built sections: journal, media, atlas and coach.
The shared top card opens `calendar` as an ordinary named route, also reached
by `ui.navigate to=calendar`. Its month/day selection survives layout changes
while open; Back returns to the section beneath it. Calendar owns its compact
new-entry button; wide layouts retain the shell's rail action.

Pages stay alive and may rebuild on each diary change. Keep per-entry work out
of build loops: use store indexes (`EntryStore.getEntriesForDate`,
`EntryImagesProvider.getForEntry`, `TagsProvider.getEntryTagsForEntry`) and cache
by list identity when appropriate; stores replace lists on change. Use
`Entry.day` for diary-day grouping and `parseLocalTime` for stored wall times
instead of repeatedly doing local time-zone conversion while building rows.
Check behavior against a seeded diary of several thousand entries when such
work changes; profile measurement remains a separate requested pass.

Desktop journal previews use font-scaled row slots and `KnownExtentSliver`
with indexed day-group extents. Cached prefix sums and binary lookup avoid
repeated linear height scans during layout. A thumb jump can skip intervening days
without building their rows. Mobile retains content-sized previews. Selection,
sorting and diary-day grouping share the same builder. Keep the far-jump build
bound and enlarged-text checks in `test/pages/journal_scroll_test.dart` passing.
The desktop journal does not prebuild offscreen rows at every thumb position;
mobile keeps Flutter's normal scroll cache. This reduces paragraph layout and
semantic-tree churn during a fast traversal without hiding visible content.

Windows routes provide a `WindowsWheelScrollScope` for their primary vertical
list. Split list/detail panes own separate scopes, and the calendar supplies
its explicit `WheelScrollController`. Only mouse-wheel pointer signals use a
short decaying tail; consecutive notches accumulate their full distance and a
reversal starts from the visible position. Native pointer-signal resolution
still chooses the nested list, axis and direction. Touch/precision-trackpad
drags, scrollbar dragging and keyboard/programmatic moves retain Flutter's
normal lifecycle and interrupt the tail. Rows remain tappable while settling.
The system's reduced-motion flag disables smoothing. The duration belongs to
`scrolling.wheelDurationMs` in the application asset configuration, rather than
another user setting. Explicit controllers outside these scopes remain native.
One activity keeps ticking throughout a burst and only updates its target;
it does not restart at zero elapsed time on every notch. Decay uses elapsed
time rather than a fixed amount per frame, and stops within the platform's
scroll-distance tolerance.

`PinnedSearchHeader` keeps the journal, media and coach list toolbar outside
scrolled content using a pinned sliver with an opaque theme surface. Calendar
and search routes already keep their controls outside their scrollable lists.

The journal observes only its list's scroll notifications for a back-to-top
shortcut after the configured viewport threshold; child/detail scrolling does
not trigger it. Returning to the beginning uses a direct jump, including for
large archives and reduced-motion users.

Feedback is a routed settings page. `assets/config/app_config.json` owns its
GitHub issue URL and contact email; only the user's entered text is prefilled.
External-launch failure retains the draft and leaves the email/copy fallback
available. The current repository is private, so issue creation requires access.
There is no feedback collection endpoint or automatic message submission.

Windows keeps the standard Win32 title bar, icon, title and caption buttons.
`WindowsCaptionTheme` sends the resolved Flutter background, foreground and
brightness over `aid/window_chrome`; the runner applies DWM caption, text and
border colors. Theme changes update the palette without reserving Flutter
space or replacing native window interactions. Windows high-contrast mode
retains system caption colors. Exact caption colors require Windows 11; older
Windows versions retain the system frame palette.

New settings must be registered in `Settings.all`: startup prunes unknown keys
and `test/config_settings_test.dart` checks the registry. Photos, videos and
voice notes share attachment storage; `MediaKind` distinguishes their type,
so backup/sync must preserve them through the same ownership path.

## Agent-native: actions shared by the GUI and the CLI

Everything the app does is an action defined once (`AppAction`: an id such
as `entry.create`, a one-sentence description, typed parameters, a risk
level and a `run` function) and listed in `AppActions`. The surfaces are
derived from that list, so the GUI and the command line always offer the
same things:

- GUI buttons call `AppActions.instance.run(id, args)` for one-step
  operations (deleting, restoring, syncing now, stopping sync). Multi-step
  flows with dialogs, such as connecting sync, call the same service
  methods the action calls, so the logic still exists once.
- The command palette (Ctrl+K, or Settings → Command line → All commands)
  lists every action and runs it through a form.
- The agent API (`actions/agent_api.dart`) serves the actions over HTTP on
  the loopback address with a token per start; the `aid` CLI under `cli/`
  talks to it, on this computer or over adb on a phone or tablet. It is
  always on in development builds and behind the "Command line interface"
  setting in others.
- `aid guide` is written from the actions themselves.

The command line covers the GUI: whatever a person can do or open in the
GUI, an action does or `ui.navigate` opens. It may do more (bulk work,
test data). Kept out on purpose, and documented as such: setting or
changing the app lock, the backup password and fingerprint unlock (an
agent must not be able to lock the user out; `security.status` reads
them), and the system's own permission prompts. Sealed time capsules stay
sealed for actions as in the GUI: they return that an entry is sealed and
when it opens, not its text.

Places: every screen, item or dialog the GUI opens is a `Destination` in
`lib/routing/` (`destinations.dart` gathers them), opened by taps through
the same code `ui.navigate` uses, with typed parameters (`ui.navigate
to=entry id=12`, `to=day day=2026-10-21`). Routes are named after their
place, so `ui.screen` reports `entry/12`; `ui.back` closes the top one.
Dialogs and sheets are places as well (`showPlaceDialog`, `showPlaceSheet`:
`tag`, `check_in`, `commands`), and so are the stories (`story from=coach`,
`review span=week`) and today's flashbacks (`flashback index=0`, numbered as
`flashback.list` counts them).

Rules that keep it so:

- An action never shows UI: it takes explicit arguments and returns JSON or
  throws `ActionException(code, message)`. Asking (a dialog, `--yes`) is
  the caller's job; `ActionRisk.destructive` actions refuse to run unless
  confirmed.
- Bulk work notifies listeners once, not per item, so a CLI command that
  adds thousands of entries redraws the GUI once.
- A setting that does more than store a value (rearms a reminder, applies the
  diary day hours, starts or stops the command line server) is changed through
  `SettingsService`, which `settings.set` and `settings.set_many` call. The
  settings pages change a setting with `changeSetting` and `changeSettings`
  (`lib/actions/settings_actions.dart`), which run those actions. The theme
  needs no call: `ThemeModeProvider` follows the stored settings. Whatever
  moves data (import, export, backup, restore, storage folders, the
  wallpaper photo) is one function in `utils/`, `database/` or `services/`
  that takes the picked file or folder; the page picks and shows progress, the
  action takes a path.
- `perf.start` and `perf.stop` count the frames the app draws and their build
  and raster times; `ui.fling` swipes where no touch screen is; `aid trace`
  records the timeline from the VM service that `app.status` names. A
  development build started with `AID_DATA_DIR` keeps all its files there
  (`utils/scratch_folders.dart`), so a frame-rate run on a computer leaves
  the diary alone.
- `ui.screen` and `ui.navigate` let an agent see and move the GUI; the GUI
  provides them through `ActionScreen`, so `actions/` still imports no UI.
- Drawing uses a thin Scribble/PF input adapter in `widgets/`, a bounded plain
  numeric document in `models/`, and an isolate PNG renderer in `services/`.
  `drawing.render`, `drawing.attach` and `drawing.export` work without a GUI.
  Local photo suggestions follow the same direction: native/selected-folder
  metadata source, plain local grouping, then explicit import through actions.
- Nearby pairing and migration, device approval/revocation and network diagnostics
  use `device_sync_actions.dart`. Temporary encrypted migration snapshots are
  independent of the live sync vault. Identity adoption uses an SQLite writer
  transaction and compensating secure-store writes; the sender receives a final
  receipt only after recipient content and identity have committed.
- Touch feedback (`widgets/haptics.dart`) belongs to the GUI: actions run
  from the CLI stay silent. Use selection feedback sparingly for tabs, switches
  and moods, and success/warning/error feedback for outcomes or destructive
  prompts.
- The GUI changes data only by running actions (`AppActions.instance.run`),
  never by writing to the stores and services behind them;
  `test/architecture/actions_only_test.dart` checks `pages/`, `widgets/` and
  `layouts/` and names the few files that may, with why (the editor's
  draft, the app lock). A long action reports to `ActionContext.progress`,
  which the GUI passes to its progress dialog.
- Only `lib/routing/` pushes routes (`test/architecture/places_test.dart`
  lists the few flows that are not places, with why), and every place
  opened by name exists.
- Tests: `test/actions/` runs actions against real stores and the API over
  HTTP; `test/widgets/command_palette_test.dart` checks the palette offers
  every action; `test/routing/` opens the places through `ui.navigate` in
  a running app shell; `cli/test/` covers the CLI, adb included.

## Sync and keys

Every sync space is end-to-end encrypted (`sync/`). On first use a device
makes the user's identity (`sync/identity.dart`): a random user id and a
256-bit master key in the platform's secure storage. A space's description
(`space.json`) names its user and holds two sealed keys: the space's data
key sealed by the master key, which encrypts every item and photo with
AES-256-GCM, and the master key sealed by the recovery code through
Argon2id (`sync/sync_crypto.dart`). Changing the recovery code or adding a
device rewraps a key; data is never re-encrypted for it.

A device without the master key gets it by pairing (`sync/pairing.dart`)
with one that has it, either way round: whichever shows the code, the key
goes from the device that holds it. The two meet in files under `pairing/`
in the space's storage and run SPAKE2 (`sync/spake2.dart`, RFC 9382 on
P-256) with the code as password, so the storage sees only protocol
messages and ciphertext, a wrong code ends the channel after one try, and
the key is sent only after both sides have confirmed the same code.

The network and media design is specified in [SYNC_NETWORK.md](SYNC_NETWORK.md).
The data layer separates these owners:

| Module | Responsibility |
| --- | --- |
| `sync_service.dart` | Compose storage, identity, discovery and the engine; expose diary/media states; schedule quiet retries |
| `connection_manager.dart` | Probe verified candidates concurrently, choose a usable route, upgrade with dwell/hysteresis and fence stale network results |
| `lan_transport.dart` | Native DNS-SD hints and HMAC-authenticated IPv4/IPv6 object transport for devices already sharing MK |
| `internet_transport.dart` | Account-scoped presence/signaling; MK-authenticated fresh-session/client-nonce handshake; public address probes and ICE/relay lifecycle |
| `ice_transport.dart` | STUN/WebRTC attempts, reliable binary framing, 256 KiB native-buffer cap with cancellable 20 ms getter fallback, bounded lifecycle and selected-pair diagnostics; no TURN |
| `relay_packets.dart` | Ordered, bounded reassembly and fragmentation sized for the server's JSON frame cap |
| `peer_object_link.dart` / `sync_object_paths.dart` | Session-bound encrypted object RPC shared by ICE and relay, replay/order checks, safe paths and object limits |
| `routed_backend.dart` | One metadata backend across authenticated peers, shared storage and a persistent ciphertext outbox; require remote acknowledgements |
| `sync_engine.dart` | Merge versioned packs and snapshots first, queue missing attachments and retain conflict copies |
| `media_transfer.dart` | Encrypted immutable chunks/manifests, integrity checks, per-route allowances and resumable transfers |
| `local_device.dart`, `copy_status.dart` | Device-local editable names/stable IDs; encrypted last-confirmed inventories bound to a space and device path, with dataset revisions and media presence |
| `sync_schema.dart` | SQLite change/version state, media task queue and ciphertext vault |

Metadata has one identity and version history across paths. A local outbox
write does not acknowledge remote delivery. Compaction removes old packs
from a route only after it acknowledges the replacement snapshot. Media
progress is owned by SQLite, not by a socket; 1 MiB plaintext chunks are
encrypted once and reused through path changes and process restarts. A
media source pool can try other authenticated online devices when the
selected peer lacks an object. Operator-cache traffic stays separately
budgeted from live relay, direct transfers and personal storage. A direct
source/writer pool contains direct routes only, so changing the selected
route cannot bypass a metered allowance. Live relay is another online object
transport; it never becomes the asynchronous cache or a durable receipt.

Internet paths require an AID-compatible WebDAV server with the authenticated
WebSocket service. Directory records do not establish trust. Both server
sessions and fresh client nonces participate in MK-authenticated hello/echo/
ready confirmation; signaling and object RPC bind the endpoint sessions,
nonces and generation. Public HTTP candidates also pass the MK/device probe.
ICE uses a fresh authenticated attempt nonce for its RPC key. On directory
loss, relay closes while established public-direct/ICE connections may stay
usable; retained peer clients and all queues remain bounded. Session-bound
route IDs prevent stale completion from restoring a replaced connection.
Google Drive and ordinary WebDAV retain LAN and shared storage rather than
implicitly supplying that server service.

Diary metadata may be synchronized while attachment bytes remain pending.
Temporary cache receipt and durable remote storage are distinct facts;
neither a route change nor a successful cache upload changes that distinction.
The GUI shows simple sync/media states. `sync.status` and `sync.network`
remain separate from `sync.copies`: the latter supplies named copy details
only when requested. `copies/<device-id>` objects are encrypted with the space
data key and authenticated by path and space ID. A receipt records a dataset
revision, local media counts and a confirmation time; it is not an audit of
an offline device's surviving backups. Details compare revisions before
showing another device as complete and choose the newest valid confirmation
across available sources. Their publication is optional metadata, never an
alternative acknowledgement for diary changes. Public discovery retains
opaque IDs rather than user labels. The `sync.status` and `sync.network`
actions expose route, retry and media diagnostics; the advanced diagnostics
page renders only allowlisted operational fields and actual server allowances.

Current remote spaces use format 4. Older formats fail explicitly rather
than being migrated or reset automatically; local database schema updates
only add queue/vault state. Public IPv4/IPv6 address exchange, WebRTC/STUN
and bounded live relay are implemented. Windows/Pad same-Wi-Fi transfers,
actual nominated UDP pair diagnostics, quota refusal and automatic LAN
upgrade have passed; this is not cross-WAN or general NAT compatibility
evidence. The latest binaries also retained ICE text and fresh media sync
through one-sided signaling loss and a stopped isolated test server.
The temporary process, data and proxy have been removed with production
health verified. Production server source `887dd27` and nginx WebSocket
headers were deployed on 2026-10-22; acceptance evidence and remaining NAT
validation limits are in `docs/SYNC_NETWORK.md`. Device-key authentication
and individual revocation, offline
first-time QR trust and Wi-Fi/hotspot settings assistance are implemented.
Automatic OS-specific Wi-Fi Direct creation remains future work. All AID
deployments share the same policy-driven implementation: quota and cache
retention parameters are opt-in, with no domain-based client behavior.
Implementation and validation/deployment evidence are tracked separately in
[SYNC_NETWORK.md](SYNC_NETWORK.md).

## Hidden entries

`Entry.isHidden` is an explicit column, defaulting to false for earlier diaries.
`EntryStore.entries` and its day indexes contain only ordinary entries. The
store retains `allEntries` for internal persistence and import reconciliation;
UI lists, search, statistics, widgets and actions must not use that raw list.
Tags and ordinary status counts also use the visible entry IDs.

Settings > Security > Hidden entries requires a fresh local app-lock or device
authentication. Its short-lived `HiddenDiarySession` never becomes a setting,
action argument or global unlocked flag. Backgrounding revokes it; guarded
reader, editor and attachment routes remove their content. Revealing, restoring,
opening a hidden capsule and deleting hidden entries are deliberately local
authenticated operations, like app-lock changes. The ordinary `entry.hide`
action can conceal a visible entry, but actions cannot read or reveal it.
Sharing, duplication and template creation require making the entry ordinary
first; this avoids implicit copies outside the protected section.

Ordinary exports omit hidden entries. Full database backups preserve them and
therefore require backup-password encryption while any hidden row exists,
including Recently deleted. Hidden is an application visibility feature, not a
claim that a plaintext SQLite file is independently encrypted.

Sync and nearby diary transfer carry hidden entries like any other: the
`is_hidden` column travels with the row, so another device keeps the entry
hidden, and hiding or showing it again is an ordinary edit that syncs. Every
synced device is end-to-end encrypted and runs this version; a client from
before the column existed would show a hidden row, so all of the owner's
devices are updated together.

## Internationalization

Keep Flutter's `flutter_localizations`, `intl` and `gen-l10n` pipeline;
`l10n.yaml` selects the English ARB template and generated Dart output.
Framework control translations and app-specific ARB translations are separate:
adding a supported locale does not translate our tutorial, settings or errors.
Translations are bundled for offline use. Missing app messages fall back through
the generator's locale inheritance to English; this is not full localization.
The generator reports missing translations when run through the Setup workflow.

System language is the default. `l10n/locale_resolution.dart` passes the system's
ordered language preferences to Flutter's resolver, preserving script/region
matches and using English if none match. Chinese region-only preferences for
TW, HK and MO are normalized to Hant; an explicit script takes precedence.
General settings exposes a single App Language dropdown directly in the page.
An app language selected there takes precedence over system preferences until
the user selects System again. The existing stored selection is retained; no
separate override control or language subpage is exposed. Test locale matching
and runtime language changes with `test/l10n/` and persisted selections with
the settings action tests.

All 35 offered locale variants now cover the English message template, including
formerly empty catalogs. `test/l10n/catalog_test.dart` requires every template
message to be present, nonempty and to preserve dynamic arguments. Product and
import-format names retain their original spelling. Run `scripts/dev.ps1 l10n`
and `scripts/dev.ps1 test -TestFiles test/l10n/` after changing app copy; update
each offered locale in the same change. Counts and allowances are exercised
through generated delegates, including Arabic duals and Russian singulars at 21.

The 2026-10-22 completion used batch translation, contextual correction and
sampled review. Complete key coverage is not native-speaker certification of
every sentence. Small-screen enlarged-text navigation tests cover every offered
locale and RTL direction. Representative rendered views check actual fonts;
native device installation and full native-language review remain separate.
No runtime translation service or new localization library is used by the app.

Catalog-completion baseline (2026-10-22, `0febd38`): all catalogs covered the
then-804 English-template messages, with no missing/empty values or lost
arguments. That offline Flutter run
passed 921 tests (79.82 seconds wall time), including 122 localization checks.
Eight first-run/tutorial renders using actual Latin, Arabic and Tamil fonts
were inspected at phone and desktop sizes. The generator reported no missing
messages or ICU warnings; static analysis found no issues. These checks do not
certify every translation with a native speaker or replace a Windows/Android
installation check.

References: [Flutter internationalization](https://docs.flutter.dev/ui/internationalization)
and [locale resolution](https://api.flutter.dev/flutter/widgets/basicLocaleListResolution.html).

## Dependencies

Stores and services are app-wide singletons (`EntryStore.instance` and so
on), reached directly rather than injected. New classes take what they use
as constructor parameters that default to those instances
(`LocationService({http.Client? client})` is the pattern), so tests can pass
fakes without global setup.

## Adding a feature

First-run setup is an example of these boundaries: `OnboardingPage` owns only
the choice and navigation state; `TutorialPage` is reusable read-only content,
also registered as `settings/tutorial` for GUI/CLI navigation. The existing
`app.finish_onboarding` action persists completion, while nearby authorization
continues through its own service/action flow. A canceled connection returns
to the choice, and a completed one opens the received diary directly.

1. Put new data in a model (`models/`, immutable, `copy`), its column in the
   schema with a migration, and its reads and writes in the owning store.
2. Put rules in pure code (`utils/` or `stats/`) with unit tests.
3. Make what it does an action in `actions/` and register it in
   `AppActions`; the screen's buttons call the action.
4. Build the screen in `pages/`, shared pieces in `widgets/`, and make it a
   `Destination` in `routing/`, which taps and `ui.navigate` both open.
5. Settings: a `Setting` in `Settings.all`; tunable values and endpoints in
   `assets/config/app_config.json`; user-facing text in the ARB files.
6. Tests at the layer that owns the logic (`dart_test.yaml` explains the
   unit, widget and host-integration tags). [TESTING.md](TESTING.md) selects
   affected checks and explains when full or native regression is needed.

## Not done yet

Kept in step with the code; remove items as they land.

- Folder names follow layers loosely rather than the guide's `ui/` and
  `data/` split; renaming waits for a quiet moment with no open task
  branch, to avoid conflicts across the whole tree.
- Other screens with logic of their own (search filters, the backup and
  sync settings) to move into view models when they are next changed.
- Top-level modules in `lib/` still to be filed under their layer.
