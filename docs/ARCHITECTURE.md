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
| Data | `database/` (`EntryStore` and DAOs over SQLite), `providers/` (stores for attachments, tags, templates), `storage/` (files, secret store, folder picker), `services/` (network and platform: place names, weather, home widget, coach schedule), `background/` (alarms and backup work that run without the UI) | Repositories (`EntryStore`, `providers/`) over services (DAOs, `storage/`, `services/`) |
| Pure | `models/`, `stats/`, most of `utils/` (dates and diary days, previews, formats, imports) | Domain models and logic |
| App | `main.dart` (start-up only), `config/` (`app_config.json` access), `l10n/` | Composition and configuration |

Some modules still sit at the top of `lib/` (`config_provider.dart`,
`notification_manager.dart`, `time_manager.dart`, `flashback_manager.dart`
and others). Treat them by role: settings and notifications are data, time
formatting is UI helper. Move one into its folder when a change touches it.

### Rules (enforced)

`test/architecture/layer_boundaries_test.dart` fails on any of these:

1. `models/` and `stats/` import no app layer and no Flutter UI library.
2. The data layer (`database/`, `storage/`, `services/`, `providers/`,
   `background/`) imports nothing from the UI (`pages/`, `widgets/`,
   `layouts/`, `routing/`) and not `main.dart`.
3. The UI never imports a DAO; it goes through the stores.
4. `widgets/` never imports `pages/`; shared widgets open screens through
   `routing/` (`AppNavigation`, `EntryNavigation`).
5. `utils/` imports no UI, so every layer may use it.
6. Nothing imports `main.dart`.

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
The entry editor (`edit_entry_page.dart`) is the first candidate.

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
3. Build the screen in `pages/`, shared pieces in `widgets/`, and its route
   in `routing/` if other screens open it.
4. Settings: a `Setting` in `Settings.all`; tunable values and endpoints in
   `assets/config/app_config.json`; user-facing text in the ARB files.
5. Tests at the layer that owns the logic (`dart_test.yaml` explains the
   unit, widget and integration tags).

## Not done yet

Kept in step with the code; remove items as they land.

- Folder names follow layers loosely rather than the guide's `ui/` and
  `data/` split; renaming waits until the open `task/cloud-sync` branch is
  merged, to avoid conflicts across the whole tree.
- The entry editor has no view model yet.
- Top-level modules in `lib/` still to be filed under their layer.
