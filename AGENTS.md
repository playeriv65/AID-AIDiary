# AID Diary: working instructions

## Start with the owning document

Talk to the user in Chinese; code comments and documentation are in English.
Use uv for Python. Read the [documentation index](docs/INDEX.md) to find the
primary guide rather than duplicating instructions here.

For the latest dated development checkpoint, read [Maintainer handoff](docs/HANDOFF.md),
then verify the current checkout and the owning documents; a handoff is a snapshot.

- [Engineering](docs/ENGINEERING.md): principles, change/review workflow and documentation maintenance.
- [Architecture](docs/ARCHITECTURE.md): actual layers, state owners, shared actions, [internationalization](docs/ARCHITECTURE.md#internationalization) and explicit adaptations of Flutter guidance.
- [Decisions](docs/DECISIONS.md) and [TODO](TODO.md): settled product direction versus proposed/deferred work. Do not expand product scope from a reference app or an external recommendation.
- [Setup](docs/SETUP.md): toolchain, ignored local configuration, signing, devices, debugging and external asset locations.
- [Testing](docs/TESTING.md): change-to-test matrix, regression/release gates, fixtures and evidence. Follow it instead of interpreting "all tests passing" as every target after each edit.
- [Sync networking](docs/SYNC_NETWORK.md) and [server guide](server/README.md): protocol invariants, validation boundaries, operator configuration and deployment.

Update the owning document with its code/behavior change and link to it from
entry points. Keep proposals, current behavior and dated verification separate.
Do not put changing test counts, deployment revisions or recipes in this file.

## Work and delivery

- Fetch first and integrate remote updates safely. Main is `main`; the remote is the public `playeriv65/AID-AIDiary` repository. Substantial tasks use `task/<name>` in a separate worktree from current main; keep one active task worktree at a time. Finish with meaningful English commits, merge back, push, verify the remote revision and remove completed task branches/worktrees. When a task branch is merged or abandoned, remove its worktree with its `build/` and `.dart_tool/` caches; an unmerged branch stays a branch, not a worktree with caches. Never overwrite other work or force-push history.
- Resolve clear implementation bugs directly. Ask about unresolved product direction or actions outside authorization; do not ask again for authorization already established in the session. Keep the owner informed during substantial work.
- Consult current official docs/issues when something behaves oddly before speculative experiments. Explain how external advice applies here; do not add a framework, dependency migration or review ceremony just to match a sample project.
- Remove confirmed unused logic and its callers. When a feature is deleted, delete its tests too; do not add absence/anti-regression guards for the removed feature. A differential check against a reference runs once: compare, fix, then remove its scratch harness/fixtures.
- Before a code commit, format changed source, run relevant analysis and required checks from Testing, inspect the diff and update relevant docs. Documentation-only changes need link/command/structure review. Preserve actual failures and validation gaps; do not retry until green or silently lower the goal.
- Kotlin changes pass `./scripts/dev.ps1 ktlint` (CI's pinned ktlint; `ktlint-format` fixes most findings) before commit.
- Review changed files for secrets, private content and generated author/editor metadata or signatures; remove such metadata and verify the files still work. Keep local secret/config files ignored and templates safe.
- Do not publish a store release unless asked. Existing deployment authorization does not imply permission to reset live data or rotate user-held keys.
- Versions: `pubspec.yaml` holds `MAJOR.MINOR.PATCH`: use 0.x until the first real release (then 1.0.0), MINOR for features and PATCH for fixes. Raise it before a build goes to the owner's devices or out. See [Updates](docs/UPDATES.md#build-numbers) for Android build numbers and installation ordering.
- Release notes: a change users notice gets an entry in `CHANGES.json` in the same commit: a stable `id`, and what changed for the user (not the commit subject) in `en`, `zh` and `zh_Hant`. The nightly's update notes are the entries added since the last release (docs/UPDATES.md).

## Native environment and user data

- Develop natively on Windows through `scripts/dev.ps1`, configured by ignored `scripts/dev.env` (template supplied). Run `pub` in a new checkout before analysis/tests. Flutter builds, tests, screenshots, initialization and analysis share a checkout lock; do not bypass it or overlap raw Flutter invocations. Keep four test workers. Do not package Windows locally: the Windows app comes from the Nightly installer, and a local Windows build is only for a Windows-native change that cannot be checked otherwise (host `flutter test` is unaffected).
- Test and debug bottom-up by the [test pyramid](docs/TESTING.md#test-pyramid). Reproduce every bug, including one seen on a device, in a PC test (unit, widget or host integration) and fix it there. A device run is the final one-time check after the PC tests pass, never an iteration loop. Fix only scenarios real users hit: a failure that appears only in a setup you built (two apps on one device, an app frozen in the background, a harness quirk) means fixing the setup, not adding product code.
- Do not use Computer Use for debugging or verification. Use shared `aid` CLI actions for operations/state, Flutter/driver diagnostics for the running UI, and the headless screenshot harness for visual review. See Setup and Testing for commands and native-window boundaries.
- Verify UI headlessly; launch a visible Windows app only when the owner wants to inspect it. Only the test tablet and the PC are used for testing; there are no Android emulators. Android builds run on the Xiaomi Pad 7 (wireless adb, `DEV_ANDROID_DEVICE`), with arm64-only debug builds. Never use the owner's phone for tests, measurements or debugging; touch it only for an explicit job on the owner's own data that the owner requested. Native debug/driver procedures are in Setup.
- Use isolated scratch stores for multi-device/network checks. Preserve ordinary app data, signing keys and device settings. Do not uninstall the app, clear data, change its signing key or reset a live remote space without the required owner authorization. `flutter drive` can uninstall on exit; use the keep-app procedure in Setup.
- The owner uses `com.playeriv65.diary` (and the old `dev.aid.diary` until the diary is moved over by hand) for real diary data. Never use either package or its live sync space as a test fixture, import/restore target or cleanup target. Keep development in `com.playeriv65.diary.beta` and isolated scratch/sync spaces. Updating the release installation or writing its data requires a specific owner request; generic development/deployment authorization is insufficient. `scripts/dev.ps1 release` installs on connected devices and must not be used as a build-only check. See the personal-use boundary in Decisions.
- An explicitly authorized personal import is not a test fixture. Keep its inputs, conversion plans, source metadata and verification reports outside git; retain originals and verified backups. Preserve diary days independently of creation instants, use the owner's supplied timezone/travel facts, and do not attach scanned source pages unless requested. Additional local-encryption work is deferred; do not make it a prerequisite for ordinary use.
- Windows physical network checks reuse the fixed `DEV_WINDOWS_RUNTIME` executable path and `windows-stage`; do not create recurring firewall prompts with worktree-specific executables. Initial network consent and any firewall changes are explicit actions. Android scratch launches must not schedule or cancel ordinary Workmanager tasks.
- Physical route evidence needs the actual nominated path and data/hash verification. Same-Wi-Fi IPv6 or STUN gathering does not prove cross-WAN reachability. Cross-network validation and the broader Android performance pass remain deferred; the requested Windows scrollbar and mouse-wheel measurements belong in `docs/REFRESH_RATE.md`. Do not add an Osaka relay or silently claim deferred checks passed.
- Never import old-project data/keys or delete its retained files. External reference apps/assets remain outside this repository; use official installers and never copy their code, assets or text. Setup owns their locations.

## Essential application invariants

- Keep the GPL-3.0 upstream notices, license and additional terms, own app name/IDs and modified-version notice. [SOURCE.md](SOURCE.md) owns provenance. There is no compatibility with Daily You or older app formats beyond the supported local schema behavior documented by Architecture.
- The approved product is a private, local diary for Windows and Android (Linux packaged too) with optional always-encrypted sync, an optional in-app agent on a model the user chooses, and no user profile. Apply progressive disclosure: ordinary status stays simple, named copy/network/key details are reached through deeper options. Product decisions own the full scope and open questions.
- `EntryStore.delete` means Recently deleted; only `erase` removes the entry permanently. New entry listings must respect sealed time capsules. Day-based behavior uses `Entry.day`, not the date portion of `timeCreate`; changing default day-selection settings must not rewrite existing entries.
- Respect architecture boundaries and state owners. Data/actions never import UI; GUI and CLI share operations. Keep user-facing text in ARB files, tunable endpoints/settings in configuration and machine paths in ignored local config. Register new settings in `Settings.all`. Follow the architecture tests instead of adding dependency exceptions.
- One feature has one implementation: one page or widget and one action, whatever opens it (onboarding, settings, dialogs, CLI/agent API, deep links). Before adding UI or logic, search for an existing implementation and extend it; shared tiles, dialogs, pickers, forms, confirmations, list items, empty states and error messages live in `lib/widgets`. Entry points pass no flags that hide or re-label parts of a feature; different content is a different, separately named feature. The same label means the same action; controls that do different things get different labels. See [Shared components](docs/ARCHITECTURE.md#shared-components).
- Update every offered locale with English-template changes; regenerate localization code and run the catalog/locale checks in `test/l10n/`. Empty translations and missing arguments are failures, not completed language support.
- Sync item/version/progress and acknowledgements are independent of a transport. An outbox write or temporary-cache receipt is not remote delivery or a durable backup. Unsupported remote formats fail explicitly; they never authorize automatic reset or local diary deletion.
- All AID deployments use the same code and policy parameters. Operator quotas/cache retention are opt-in; the official server is one configured instance. Client behavior follows advertised policy, never the domain. Keep server configuration details in its guide.
