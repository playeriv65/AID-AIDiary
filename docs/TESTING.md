# Testing

This is the project's testing policy, researched and adopted on 2026-10-22.
It applies to Flutter, the Go sync server, the CLI and native-device checks.
The developer making a change owns its test selection, failures and evidence.
Use `scripts/dev.ps1` for Flutter operations so native test assets cannot race
with another build in the same checkout.

The goal is fast, trustworthy feedback about user-visible behavior and data
safety. Choose the smallest scope and environment that can detect the relevant
failure, then expand when the risk crosses boundaries. A small change does not
require the whole suite before every commit. Unit-only testing is sufficient
only when the change stays within pure logic and its callers' contracts.

## Daily workflow

1. Identify the observable behavior, direct callers and failure consequences:
   appearance only, incorrect result, lost diary data, broken trust or unbounded
   operator traffic. File count alone does not determine risk.
2. Choose checks using the change matrix below. Include relevant callers and
   architecture contracts, not only a test with the same filename. Look for
   consumers with `rg`; do not maintain a brittle filename-only selector.
3. Run focused checks while editing. Expand to the affected module if the impact
   crosses several files. A tag selects a test environment, not a feature.
4. Format changed source and run the relevant static analysis for code changes.
   Review affected screenshots only for visual changes. Documentation-only
   changes need link/command review, not an app regression.
5. Apply the completion/release gates below and report the exact scope. Repeat
   checks after relevant changes or failures, not merely before each commit.

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

## Select checks by change

These are minimum scopes, not excuses to ignore affected consumers. Static
analysis and formatting accompany source changes; they are not behavior tests.

| Change | Minimum behavior checks | Expand when |
|---|---|---|
| Documentation or comments only | Links, command examples, consistency | Executable examples, manifests or configuration actually change behavior |
| Pure validation, calculations or transformations | Affected unit cases, boundaries and direct callers | Return values, serialized output or a shared contract changes |
| ARB catalogs or locale matching | `l10n` regeneration, `test/l10n/`, relevant pages and representative long-text/RTL renders | Broad changes to generated app localizations need full offline Flutter regression; native language/font behavior remains a separate device check |
| A page's rendering or interaction | Affected widget tests; render and inspect affected phone/wide views for layout changes | Navigation, state persistence or multiple pages interact |
| Action, view model or service | Owning tests plus caller behavior; use real local dependencies where the contract requires them | Work crosses GUI/CLI, storage or sync boundaries |
| Files, config persistence, SQLite, backup/import/export | Relevant host integration; round trips, failures and retained data | Schema, archive format, shared stores or migrations change: full app offline regression |
| Sync, crypto, pairing, media queues or traffic policy | Relevant sync integration, malformed/authentication failures and interrupted/retried operations | Shared wire format, trust or routing semantics change: full app offline regression; add Go checks if its contract is affected |
| Native plugin, permissions, keys, IME, widgets or networking | Owning host tests plus the affected Windows/Android build and native behavior | Platform wiring changes: smoke the affected platform; mocks cannot verify it |
| CLI | `test-cli` (the suite is currently small), plus affected action/API tests if shared behavior changes | API changes: check both producer and consumer |
| Go server | `test-server`; policy changes cover limits off and on | Concurrency/socket/accounting changes: `go test -race ./...` from `server/` on a supported configured toolchain; wire changes also need Flutter protocol tests |
| SDK/dependencies, shared test harness, startup or broad refactor | Full offline suite of each affected component | Native dependency/runner changes also need platform builds and relevant device smoke |

For example, a device-name length rule needs its unit tests; editing the rename
dialog needs its widget test; changing how the name survives restart needs
config integration. Do not run every unit test as a substitute for that widget
or persistence test. Tests under `test/actions/` or `test/pages/` are not assumed
to be unit/widget merely because of their folder name: inspect their fixtures.

## When to run full regression

"Full" must name its boundary. `test-all` is the full offline Flutter `test/`
suite, not Go, CLI, rendered screenshots, live accounts, native builds or frame
rate. A whole Go suite does not imply the client was tested either.

| Stage | Required scope |
|---|---|
| Editing and intermediate commits | Affected tests and direct consumers; unit-only is allowed for isolated pure logic |
| Finishing an isolated fix/page change | Affected module/flow checks and analysis; no automatic full Flutter run |
| Finishing a cross-module feature/refactor, or uncertain impact | One full offline run per affected component after focused checks; include the end-to-end critical flow the change affects |
| Safety net during active development | Once at the intentional end of a day containing app code changes, run full offline Flutter unless the same final app/test/dependency state already has a passing full run. Intermediate commits do not wait for this. No run is needed on documentation-only days |
| Dependency/SDK, shared harness/runtime, schema or sync-format change | Full affected component suite before considering the change complete; targeted tests remain the first feedback loop |
| App release candidate | Full offline Flutter, affected bundled CLI checks, successful intended Windows/Android builds, and release-build smoke of the critical journeys below. Review all relevant phone/wide views |
| Server deployment | Full Go tests and vet, race checks for the server candidate, then isolated preflight and deployed HTTPS/policy/WebSocket/data round trips as applicable; unchanged client code does not require an unrelated full Flutter rerun |

The daily safety net is a manual workflow rule, not a newly installed schedule
or CI service. If development is still ongoing, state that the batch full run
is pending rather than silently labeling focused results as full regression.
One successful full run can satisfy several gates for the same tested state.

A result belongs to the source/test state, resolved dependencies, toolchain and
relevant platform configuration it checked. Documentation-only changes do not
invalidate it. For later isolated source changes, keep the historical baseline
and add focused evidence; do not claim that the old full run tested the new
revision. For another broad change, rerun the affected full suite.

The repository currently has no `.github/workflows` test automation. If CI is
introduced, keep selected fast checks on changes and full host regression at
the integration gate; device/live checks remain separate jobs with explicit
environments. Do not add paid runners, production credentials or a complicated
dependency-graph selector merely to enforce this document. At the present
roughly minute-long Flutter full-suite duration, a batch safety net is simpler.

## Critical journeys and release evidence

Each changed journey needs an observable result, not only "the screen opened":

- Create, edit and reopen a diary entry: text, diary day, tags and media survive
  restart; deleting and restoring retains the intended data.
- Backup/export/import: restore a scratch diary and compare meaningful fields
  and original attachment bytes. Password/authentication failure or cancellation
  must preserve the pre-existing diary. Test legacy local schema upgrades with
  supported fixtures when changing migrations; incompatible remote sync formats
  must still fail explicitly rather than reset a space.
- Sync and trust: approve the intended device, merge edits, interrupt/resume media
  and verify hashes. Wrong keys, replayed/stale sessions and revoked access fail
  safely. Quota refusal defers media without losing text or progress; the same
  server implementation must work with operator limits off and on.
- Native integrations: permissions denied/granted, cold launch and the affected
  photo, drawing, widget or key action on the actual supported platform. Windows
  cannot establish Android Keystore/OEM behavior.

These are acceptance obligations when affected or preparing a release, not a
claim that every scenario is already automated. Existing tests and historical
physical evidence are described in [SYNC_NETWORK.md](SYNC_NETWORK.md). Review
the remaining gaps against the release scope instead of manufacturing a pass.
The owner has deferred cross-network and performance checks: keep them marked
unverified, and require a separate go/no-go decision if a release needs those
claims. No production reset, ordinary-diary mutation or new external endpoint
is authorized merely by this testing policy; use isolated scratch data.

The screenshot harness currently walks screens and writes PNG files; it does
not compare them to approved golden images. A passing render is not a visual
review. Inspect the affected images for clipping, wrapping, keyboard/navigation
state and phone/wide layout. Do not regenerate unrelated images or accept a new
baseline automatically to hide an unintended change. Performance requires the
existing profile/native measurement; screenshots and debug timing cannot prove it.

## Test design and failure handling

### Widget fixtures

Use `DiaryAppHarness.setSetting` for fixture setting changes and
`DiaryAppHarness.pumpUntil` for SQLite work started by widgets. When the tap
under test changes config, pump once and call `EasyDebounce.cancel('save-config')`
before settling: advancing fake time through the one-second debounce otherwise
starts a real write that can keep the temporary folder locked. This recipe
controls fixture timing; it must not skip the behavior/assertions under test.

### Review and diagnose tests

- Assert behavior at public boundaries and meaningful invariants. Cover normal,
  boundary and failure paths where they matter; prefer one clear reason to fail.
  Avoid checking private calls, widget-tree trivia or source strings just to
  mirror implementation. Existing architecture contracts protect genuine shared
  rules and must change with the architecture they enforce.
- Put exhaustive rule permutations at the lowest useful layer. Add integration
  for real storage/protocol wiring and a few critical end-to-end flows; do not
  repeat every permutation through every screen. No fixed unit/integration
  percentage, test-count target or blanket coverage percentage is a release gate.
  Use coverage to find untested important branches when useful.
- Reproduce a substantive bug and keep a regression test at its owning boundary
  when it adds lasting value. Do not add tests for every reversible cosmetic
  edit. When a feature is removed, remove its tests; no checks for its absence.
- Keep fixtures local and isolated, with fresh temp stores, ephemeral socket
  ports and explicit cleanup. Control time, randomness and remote responses when
  possible. Prefer conditions with bounded deadlines over arbitrary sleeps;
  mock external boundaries in host tests, and use real local stores where their
  semantics are what is being tested. Keep live credentials opt-in.
- Failures stop the gate. Diagnose product, test, fixture or environment causes;
  fix the root cause and rerun the failed scope plus affected consumers. Expand
  only when the failure reveals wider impact. A diagnostic rerun may expose a
  flaky result, but a later pass does not erase the original failure.
- Do not repeatedly rerun until green, increase timeouts blindly, or silently
  skip a failing test. If an unavoidable external failure blocks a check, record
  the blocker and the missing claim. Unsupported race tooling is a gap to fix
  or verify in a supported environment, not a race-check pass.
- Diagnose flaky tests with the original seed, configuration and logs. Temporary
  quarantine needs a tracked reason, repair task and explicit report; it cannot
  silently satisfy a data-safety, authentication or release-critical gate.

## Evidence and execution cost

Record the tested revision (and relevant uncommitted state), commands/files,
platform/toolchain, pass/fail/skip counts, and what was not tested. Keep detailed
logs under ignored `build/` paths when useful; summarize results in the handover.
Never put credentials, diary content or signing keys in reports. A useful record
distinguishes a fresh execution from a cached result and a historical baseline.

Timing must say whether it is whole-command wall time, runner time, cold setup
or a warm repeat. Counts describe cases or files explicitly. Do not sum focused
subsets into the full-suite count, or equate four render cases with four images.
Budget changes should come from measured bottlenecks, not guesses. Keep four
Flutter workers and the workspace lock. Do not run layers repeatedly after a
passing full suite unless later edits affect them; do not disable dependency
validation just to make timings look shorter.

## Research behind this policy

The run matrix and daily cadence above are project decisions, not universal
requirements copied from a framework. Primary guidance consulted on 2026-10-22:

- [Android testing strategies](https://developer.android.com/training/testing/fundamentals/strategies): choose scope, environment and execution stage together, starting with the lowest layer that provides useful confidence.
- [Flutter testing overview](https://docs.flutter.dev/testing/overview) and [native integration tests](https://docs.flutter.dev/testing/integration-tests): combine unit/widget coverage with important application flows and real platform execution.
- [Google Test Sizes](https://testing.googleblog.com/2010/12/test-sizes.html): define test boundaries by dependencies such as disk, local sockets and external systems, not ambiguous names alone. Its historical timeout values are not our thresholds.
- [The Practical Test Pyramid](https://martinfowler.com/articles/practical-test-pyramid.html), Ham Vocke: organize feedback by speed/scope and avoid duplicating the same assertions across layers.
- [Google on flaky tests](https://testing.googleblog.com/2016/05/flaky-tests-at-google-and-how-we.html): retries/quarantine have tradeoffs and can hide real faults; this project requires visible diagnosis and tracking.
- [Go race detector](https://go.dev/doc/articles/race_detector): race detection is dynamic and covers only executed paths, so relevant concurrent scenarios still matter.

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
