# Testing

This is the project's testing policy, adopted on 2026-10-22; the test pyramid
below was added on 2026-11-09. It applies to Flutter, the Go sync server, the
CLI and native-device checks, and to people and AI agents alike. The developer
making a change owns its test selection, failures and evidence. Use
`scripts/dev.ps1` for Flutter operations so native test assets cannot race
with another build in the same checkout.

## Test pyramid

Testing goes layer by layer, from the bottom up. Most checks run on the PC in
seconds; a device run comes last, once, and only for what the PC cannot show.
This follows the guidance in [Research behind this policy](#research-behind-this-policy):
many small tests, fewer integration tests, very few end-to-end tests, and
each check at the lowest layer that can catch the failure.

| Layer, bottom to top | Runs on | Rough share | What belongs here | AID examples |
|---|---|---|---|---|
| Unit: pure Dart logic | PC, `./scripts/dev.ps1 test-unit` | Most cases | Rules, validation, parsing, formats, crypto, calculations, architecture contracts. No database, files, sockets or widget tree | `test/utils/diary_day_test.dart`, `test/sync/spake2_test.dart`, `test/sync/sync_crypto_test.dart`, `test/utils/formats/one_diary_format_test.dart`, `test/architecture/layer_boundaries_test.dart`, `test/l10n/catalog_test.dart` |
| Widget: UI behaviour with fakes | PC, `test-widget`; headless `screenshots` | Many | A page or component: state, taps, text entry, layout, semantics, phone/wide renders. Stores and services are fakes or `DiaryAppHarness` | `test/widgets/device_name_tile_test.dart`, `test/widgets/entry_card_test.dart`, `test/widgets/app_update_prompt_test.dart`, `test/pages/onboarding_test.dart`, `test/pages/home_widget_launch_test.dart`, `tool/screenshots/phone_screenshots_test.dart` |
| Host integration (`integration` tag) | PC, `test-integration`, `test-cli` | Fewer | Real SQLite and files, schema upgrades, the sync engine between in-process devices over in-memory or loopback transports, the Rust shell, the agent API the CLI calls | `test/database/entry_store_test.dart`, `test/database/version17_upgrade_test.dart`, `test/sync/sync_engine_test.dart`, `test/sync/lan_transport_test.dart`, `test/sync/nearby_receipt_test.dart`, `test/agent/aid_shell_test.dart`, `test/actions/app_actions_test.dart`, `cli/test/aid_cli_test.dart` |
| Device end-to-end | The test tablet; the native Windows app on the PC only for Windows-native changes | A short list per release | Frame rate, platform channels without host fakes, install/update, OS behaviour | `./scripts/dev.ps1 frame-rate`, [Repeatable Android smoke checks](#repeatable-android-smoke-checks), [REFRESH_RATE.md](REFRESH_RATE.md) |

The shares are a guide, not a gate. Google suggests 70/20/10 for unit,
integration and end-to-end as a first guess, and about 80/15/5 in its book.
On 2026-11-09 the host suite held about 320 unit, 160 widget and 500
integration cases, so our integration layer is heavier than that. Most of it
covers sync and storage, where real SQLite and sockets are the contract. When
an integration test only checks a pure rule, move that rule to a unit test.

### The debugging rule

Develop and debug at the lowest layer that can reproduce the problem.

1. A bug seen on a device is first reproduced in a PC test: unit if it is a
   rule, widget if it is the UI, host integration if it needs storage, sync
   or the CLI. Then fix it there, with that test failing first and passing
   after.
2. A device run is the final, one-time verification after the PC tests pass.
   It is never an iteration loop. Do not edit, reinstall and retry on a
   device until a symptom goes away.
3. When the problem is OS behaviour that no host test can reproduce, collect
   the device evidence in one planned session (logcat, `dumpsys`, a timeline
   trace), then work from that evidence on the PC. The logic around the OS
   boundary still gets PC tests.
4. If an end-to-end check finds a bug and no lower test fails, add the lower
   test before fixing it.

### Devices

- Only the test tablet (Xiaomi Pad 7, `DEV_ANDROID_DEVICE`) and the PC are
  used for testing, measuring and debugging. See [Setup](SETUP.md#test-devices).
- The owner's phone is the owner's daily device. Never use it for tests,
  measurements or debugging. Touch it only for an explicit job on the
  owner's own data that the owner requested.
- No emulators.

### No invented scenarios

Test and fix only the scenarios real users hit. Nearby transfer, for
example, means two people's devices side by side, each app in the
foreground. A failure that appears only in a setup you built yourself, such as
two copies of the app on one device, an app the OS froze in the background,
or a quirk of the test harness, means fixing the setup, not adding product
code. If you are unsure whether a scenario is real, ask the owner.

### Only on a device

Keep this list short; everything else is checked on the PC.

- Real OS behaviour: HyperOS prompts and limits, permission dialogs,
  Keystore, OEM refresh-rate classification.
- Install and update prompts, signing and package identity.
- Refresh rate and frame timing, measured in profile mode.
- Platform channels without host fakes: home-screen widget, MediaStore,
  camera, alarms, IME.

Even then, the logic around them gets PC tests, for example
`test/services/app_updates_test.dart` for updates and
`test/services/home_widget_service_test.dart` for the home-screen widget.

### Anti-patterns

- The ice-cream cone: many end-to-end or manual device checks over few unit
  and widget tests. The hourglass, many unit and end-to-end tests with too
  few integration tests, also leaves failures to the slowest layer.
- The same assertion repeated across layers. Put each permutation at the
  lowest layer that can check it; higher layers check only the wiring the
  lower ones cannot.
- Flaky end-to-end runs as the safety net. A device run that passes on retry
  proves nothing; a device-only failure needs a PC reproduction.

## Working rules

Debugging and verification must not use Computer Use (owner decision,
2026-10-23). Use `aid` for shared actions/state, Flutter/driver tools for a live
widget tree and app screenshots, and the headless screenshot harness for visual
review. Flutter captures its rendered client area, not the Windows system title
bar. Check native frame behavior through runner/platform diagnostics or explicit
owner inspection and record any remaining gap; a Flutter image does not prove
the native frame's appearance. Launching a preview for the owner does not lift
this debugging rule. [Setup](SETUP.md#local-development-and-diagnostics) owns procedures.

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

The commands for each layer of the [test pyramid](#test-pyramid):

| Layer / command | What it verifies | When to use it |
|---|---|---|
| Untagged / `test-unit` | Logic and source contracts, without app, database, file-store or socket fixtures | Rules, validation, transformations; use affected files first |
| `widget` / `test-widget` | A page or component in a Flutter test environment, sometimes with `DiaryAppHarness` | UI state, interactions and layout |
| `integration` / `test-integration` | Host integration with real files, SQLite, local sockets, isolates or app flows | Persistence, migrations, sync protocols and interacting modules |
| `live` / `test-live` | External Google Drive or sync service | An explicitly authorized service check with scratch data and credentials |
| `test-server` | Go server vet and tests | Server implementation or policy changes |
| `test-cli` | CLI analysis and tests | CLI parsing, protocol and command changes |
| `screenshots` | Headless visual artifacts | Appearance changes to the affected screens |
| Native Windows / Android checks | Plugins, OS permissions, hardware keys, device networking, IME and OEM behavior | Changes involving those capabilities, once, after the host tests pass; host tests cannot establish them |
| `frame-rate` | Profile-mode timing on seeded data, on the test tablet or `-Device windows` | A requested performance pass, not routine UI iteration |

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
Cross-network validation and the broader Android performance pass remain
deferred. The requested Windows scrollbar and mouse-wheel results belong in [REFRESH_RATE.md](REFRESH_RATE.md).

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
| Native plugin, permissions, keys, IME, widgets or networking | Owning host tests first, then one check of the affected Windows/Android build and native behavior (Android on the test tablet; a local Windows build only when the change is Windows-native) | Platform wiring changes: smoke the affected platform; mocks cannot verify it |
| Device installs in `scripts/android_device.ps1` | `pwsh scripts/test_android_device.ps1` (fake adb, no device) | One real install on the tablet, without a prompt, once the script tests pass |
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
| App release candidate | Full offline Flutter, affected bundled CLI checks, successful intended Windows/Android builds (the Nightly's; Windows is not packaged locally), and release-build smoke of the critical journeys below. Review all relevant phone/wide views |
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

Use the affected paths locally. [CI](#continuous-integration) runs the full
offline suite on code pushes and gates Nightly. Keep device and live checks
separate so credentials, hardware and service availability cannot affect the
offline gate.

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
- Android lifecycle and layout: for changes to the shell, editor or a native
  integration, exercise the affected journey after background/resume and after
  rotation or resizing when relevant. For changed controls, check semantics,
  focus order and large text on the affected layouts. Use scratch data and
  record the device, flavor and Android version for native evidence.

These are acceptance obligations when affected or preparing a release, not a
claim that every scenario is already automated. Existing tests and historical
physical evidence are described in [SYNC_NETWORK.md](SYNC_NETWORK.md). Review
the remaining gaps against the release scope instead of manufacturing a pass.
The owner has deferred cross-network and broader performance checks; a focused
Windows scrollbar pass was requested on 2026-10-22. Keep other scenarios marked
unverified, and require a separate go/no-go decision if a release needs those
claims. No production reset, ordinary-diary mutation or new external endpoint
is authorized merely by this testing policy; use isolated scratch data.

The screenshot harness currently walks screens and writes PNG files; it does
not compare them to approved golden images. A passing render is not a visual
review. Inspect the affected images for clipping, wrapping, keyboard/navigation
state and phone/wide layout. Do not regenerate unrelated images or accept a new
baseline automatically to hide an unintended change. Performance requires the
existing profile/native measurement; screenshots and debug timing cannot prove it.

### Repeatable Android smoke checks

These are the top of the [test pyramid](#test-pyramid): run them once, after
the PC tests for the change pass. Use the development app on the test tablet;
there are no emulators, and the owner's phone is not a test device. Follow the
[isolated workspace procedure](SETUP.md#isolated-physical-network-checks)
and record the source revision, APK build number, package, Android version
and workspace name. Seed a small scratch diary before exercising a journey
that must preserve existing data. Start upgrade cases from an existing
eligible development installation. Never downgrade an installed package to
prepare the fixture.

| Changed boundary | Procedure | Evidence |
|---|---|---|
| Update and signing | Install an older development APK, then use About to check and install a newer APK of the same package and signer. Cancel the installer once before accepting the update. On HyperOS, the operator confirms the system prompt. | The cancelled attempt leaves the build and scratch entries intact. The accepted attempt advances the build number and preserves the same entry IDs and attachment bytes. Check signer and package identity when preparing the APKs. |
| SQLite migration | Open a scratch store using the oldest fixture affected by the change. Upgrade in place with the candidate development APK and reopen the same workspace. | Compare the affected fields and media hashes before and after. Verify the pre-upgrade snapshot exists and restores into a separate workspace. |
| Keystore and trust | Pair the tablet's scratch workspace with a scratch Windows instance on the PC, restart the Android app, then connect again with the existing identity. When changing revocation or rotation, test the retired identity against the scratch peer or service. | The existing key works after restart. A revoked identity is rejected, and the trusted peer still reads the same synced entry. |
| Runtime permission or native UI | Exercise the affected action with permission denied, grant it through the system prompt, then repeat after background/resume. Rotate or resize if it affects the flow. | Denial preserves the current entry and shows a usable path forward. The granted action works and survives the affected lifecycle transition. |

Use the CLI to compare the scratch data before and after each case. For
visual results, use Flutter diagnostics or an adb screenshot. Record each
case separately from host integration tests.

## Test design and failure handling

### Widget fixtures

Load shared asset configuration in asynchronous `setUp`, before entering a
widget test's fake clock, as the frame-action fixture does.

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

## Continuous integration

Two workflows run on GitHub's runners:

- `.github/workflows/ci.yml` checks pushes with code or configuration
  changes to `main` on Linux. It runs Dart and Go formatting checks,
  `flutter analyze`, CLI analysis and tests, the offline Flutter suite,
  Go vet and tests, Rust formatting and Clippy, ktlint, and actionlint.
  It builds the Rust library loaded by the host tests. Pushes limited to
  Markdown and `docs/` skip it. A burst of pushes runs only for the latest.
- `.github/workflows/nightly.yml` packages once a day (09:00 UTC) and on
  demand (Actions > Nightly > Run workflow, or `gh workflow run
  nightly.yml`). A scheduled run with no commits in the last 25 hours does
  nothing. It runs, in parallel:

- Checks: `ci.yml` itself, with the same format, lint and offline test gates
  as a code push.
- Windows: the `aid.exe` executable, and a Windows release bundle as a
  per-user installer and a portable ZIP ([Updates](UPDATES.md#windows-installer)).
  The bundle carries the Visual C++ runtime DLLs it imports (app-local), so
  it starts without the VC++ Redistributable.
- Android: release APKs of the everyday and development flavors.
- Linux: a release bundle (GTK) and the `aid` executable.

Runs keep the Flutter SDK, pub packages, Gradle's caches and the Rust
builds (the test library and cargokit's per-platform builds) in the
Actions cache, 10 GB per repository, evicted after 7 days unused; files get
their last commit's time after checkout so cargo finds unchanged Rust
current. With warm caches a nightly takes about 11 minutes (23 without;
measured 2026-10-29), the
Android job being the longest: Dart's release compile and R8 run whole for
each of the two flavours.

When all pass, the rolling prerelease `nightly` gets build-specific APKs,
the Windows installer, ZIP and `aid.exe`, the Linux tarball and `aid`. Nightly
verifies the assets before it promotes `latest.json` and edits the release
in place. The offline publication checks exercise upload failures, mirror
verification, an older reader and rollback.

```powershell
uv run --no-project python -m unittest discover -s scripts -p test_release_publication.py
```

The APKs are signed with the release key from
the repository secrets and stamped with a time build number, so they update
installed apps ([UPDATES.md](UPDATES.md)). The
repository is public, so Actions minutes are free. iOS, macOS and web are
not targets, so CI does not package them.

## Research behind this policy

The run matrix and daily cadence above are project decisions, not universal
requirements copied from a framework. Primary guidance consulted on 2026-10-22
and checked again for the test pyramid on 2026-11-09:

- [Android testing strategies](https://developer.android.com/training/testing/fundamentals/strategies): most apps should have many small tests and relatively few big tests, forming a pyramid; big tests have more fidelity (closeness to production) but are slower and harder to maintain. Use the lowest layer that gives the right feedback. A bug a unit test catches is fixed in minutes; an end-to-end test may take days to find it.
- [Flutter testing overview](https://docs.flutter.dev/testing/overview) and [native integration tests](https://docs.flutter.dev/testing/integration-tests): unit, widget and integration tests trade confidence against maintenance cost, dependencies and speed (integration is the slowest). A well-tested app has many unit and widget tests plus enough integration tests to cover the important use cases.
- [Just Say No to More End-to-End Tests](https://testing.googleblog.com/2015/04/just-say-no-to-more-end-to-end-tests.html), Mike Wacker, Google Testing Blog, 2015: a good feedback loop is fast, reliable and isolates failures, which end-to-end tests are not. Google suggests 70/20/10 unit/integration/end-to-end as a first guess, and warns against the inverted pyramid (ice-cream cone) and the hourglass.
- [Software Engineering at Google, chapter 11: Testing Overview](https://abseil.io/resources/swe-book/html/ch11.html), Adam Bender: small tests run in one process without disk or network, medium tests may use several processes and `localhost`, large tests span machines. It aims for about 80% unit, 15% integration and 5% end-to-end tests, and names the ice-cream cone and hourglass anti-patterns.
- [Google Test Sizes](https://testing.googleblog.com/2010/12/test-sizes.html): define test boundaries by dependencies such as disk, local sockets and external systems, not ambiguous names alone. Its historical timeout values are not our thresholds.
- [The Practical Test Pyramid](https://martinfowler.com/articles/practical-test-pyramid.html), Ham Vocke, 2018: write tests with different granularity, fewer the higher they go; push tests as far down the pyramid as you can and do not duplicate them across layers; when a higher-level test finds an error and no lower-level test fails, write a lower-level test.
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
