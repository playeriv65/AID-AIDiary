# Architecture

AID Diary follows Flutter's official app architecture guidance
(<https://docs.flutter.dev/app-architecture>, with its recommendations at
<https://docs.flutter.dev/app-architecture/recommendations>), adapted to a
single-user, offline-first app. This file says how the guidance maps onto this
repository and which rules are enforced. Read the official guide for the
reasoning; this file only records our decisions.

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
state and calls its methods; the view model is unit-tested without widgets.

The entry editor is the worked example. `EditEntryViewModel`
(`pages/edit_entry_view_model.dart`) holds what is edited, autosaves drafts,
keeps or rolls back the session on leaving, picks the diary day and fills in
place and weather; it takes its store, services and clock as constructor
parameters, and `test/pages/edit_entry_view_model_test.dart` covers it
without a widget. `AddEditEntryPage` keeps only the text controllers, the
dialogs and navigation, reports typing and choices to the view model and
redraws when it notifies.

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
- `ui.screen` and `ui.navigate` let an agent see and move the GUI; the GUI
  provides them through `ActionScreen`, so `actions/` still imports no UI.
- Touch feedback (`widgets/haptics.dart`) belongs to the GUI: actions run
  from the CLI stay silent.
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

## Dependencies

Stores and services are app-wide singletons (`EntryStore.instance` and so
on), reached directly rather than injected. New classes take what they use
as constructor parameters that default to those instances
(`LocationService({http.Client? client})` is the pattern), so tests can pass
fakes without global setup.

## Adding a feature

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
   unit, widget and integration tags).

## Not done yet

Kept in step with the code; remove items as they land.

- Folder names follow layers loosely rather than the guide's `ui/` and
  `data/` split; renaming waits for a quiet moment with no open task
  branch, to avoid conflicts across the whole tree.
- Other screens with logic of their own (search filters, the backup and
  sync settings) to move into view models when they are next changed.
- Top-level modules in `lib/` still to be filed under their layer.
