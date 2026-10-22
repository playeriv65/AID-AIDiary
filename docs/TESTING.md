# Testing

Choose tests by the behavior changed, then by layer. A small change does not
require the whole suite before every commit. Use `scripts/dev.ps1` so native
test assets cannot race with another build in the same checkout.

## Daily workflow

1. Identify the changed behavior and its direct callers. Run their test files;
   include the relevant architecture contract when changing a shared rule.
2. Expand to the affected module if the impact crosses several files. A tag
   selects the kind of test, not the feature affected.
3. Format changed Dart files and run static analysis for code changes. Inspect
   affected screenshots only when appearance changes. Documentation-only
   changes need link/command review, not an app regression.
4. Report the scope, results and anything still unverified. Repeat checks only
   after a relevant change, a failure, or a new unresolved concern.

```powershell
# One rule; paths may be files or directories, across layers.
./scripts/dev.ps1 test -TestFiles test/sync/local_device_test.dart
# A component plus its related persistence behavior.
./scripts/dev.ps1 test -TestFiles test/widgets/device_name_tile_test.dart,test/sync/copy_status_test.dart
# A module; narrower layer selection is optional.
./scripts/dev.ps1 test -TestFiles test/sync/
./scripts/dev.ps1 test-integration -TestFiles test/sync/
./scripts/dev.ps1 analyze
# Render only the screenshot file affected by a visual change.
./scripts/dev.ps1 screenshots -TestFiles tool/screenshots/phone_screenshots_test.dart
```

Check the actual screenshot filenames in `tool/screenshots/` before selecting
one. Running `screenshots` without paths deliberately renders all of them.
Running `test` without paths fails with a usage hint instead of starting the
whole suite. `test-all` rejects paths: use `test` for a scoped run.

## Layers and triggers

| Layer / command | What it verifies | When to use it |
|---|---|---|
| Untagged / `test-unit` | Logic and source contracts, without app, database, file-store or socket fixtures | Rules, validation, transformations; use affected files first |
| `widget` / `test-widget` | A page or component in a Flutter test environment, sometimes with `DiaryAppHarness` | UI state, interactions and layout |
| `integration` / `test-integration` | Host integration with real files, SQLite, local sockets, isolates or app flows | Persistence, migrations, sync protocols and interacting modules |
| `live` / `test-live` | External Google Drive or sync service | An explicitly authorized service check with scratch data and credentials |
| `test-server` | Go server vet and tests | Server implementation or policy changes |
| `test-cli` | CLI analysis and tests | CLI parsing, protocol and command changes |
| `screenshots` | Headless visual artifacts | Appearance changes to the affected screens |
| Native Windows / Android checks | Plugins, OS permissions, hardware keys, device networking, IME and OEM behavior | Changes involving those capabilities; host tests cannot establish them |
| `frame-rate` | Profile-mode timing on seeded data | A requested performance pass, not routine UI iteration |

Layer commands without paths run that entire layer. They are useful for broad
changes, but are not mandatory checkpoints for an unrelated edit. Mixed files
belong to the most demanding fixture they actually use; move independent pure
rules out of widget files when practical. In-memory archive encoding does not
become integration merely because it produces ZIP bytes. Reading repository
source for an architecture contract also does not need a storage fixture.

Our `integration` tag names **host integration**, not native end-to-end tests.
Flutter's [testing overview](https://docs.flutter.dev/testing/overview)
distinguishes unit, widget and full-app integration tests. Local HTTP sockets
or mocked WebRTC do not prove cross-NAT reachability. Native checks must record
the actual path and data verification separately in [SYNC_NETWORK.md](SYNC_NETWORK.md).
Cross-network validation and the next performance pass remain deferred.

All offline Flutter commands exclude `live`, even if the shell has service
credentials. `test-live` is explicit opt-in; it may change remote scratch
data. See the service tests and [SETUP.md](SETUP.md) for required configuration.
No credentials belong in commands saved to the repository or test reports.

## Full regression

Use `./scripts/dev.ps1 test-all` for a deliberate whole offline regression:
dependency or SDK updates, shared runtime/test-harness changes, database/sync
format changes, large cross-module refactors, and release preparation. Add
server, CLI and native checks only where affected. A full Flutter pass does
not imply those other layers passed.

A full pass applies to the code it checked. Do not rerun it merely because a
commit is about to happen, a document changed, or another check finished.
Select focused checks for subsequent local changes; rerun the full suite if
the subsequent change is itself broad enough to require it.

## Audit, 2026-10-22

The last recorded full Flutter regression passed 799 cases and skipped six
external-service cases. That count is cases, not files: the audit found 122
test files. The prior instructions required a full run before every commit,
and `test` with no arguments selected the entire `test/` directory.

Three widget files and twelve files using real storage or sockets lacked
their layer tags. These are now classified correctly; a pure device-name
validation case is separate from its widget file. The resulting 123 files
are 50 unit, 29 widget, 42 host integration and two live files. Counts are a
snapshot, not a target or a CI assertion. The previous 799-case result remains
historical evidence; this workflow change is validated with focused checks.

Per-file Flutter compilation and test-environment startup can dominate tiny
assertions. Selecting a small affected scope saves this overhead as well as
the unrelated assertions. Keep the existing four-worker limit; raising it
does not fix unnecessary work.

Measured on the maintainer's Windows machine in this audit, including wrapper
startup and Flutter's dependency check:

| Selected scope | Passed cases | Wall time |
|---|---:|---:|
| Device-name validation, first run in a new worktree | 1 | 29.33 s |
| The same file after cache initialization | 1 | 6.86 s |
| The four affected widget files | 5 | 9.26 s |
| The twelve reclassified host-integration files | 165 | 13.07 s |

These are observations, not timing assertions or performance benchmarks. The
first-run cost is distinct from the test runner's sub-second assertion time;
do not promise that every tiny edit finishes in under a second.
