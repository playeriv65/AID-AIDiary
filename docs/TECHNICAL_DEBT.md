# Technical debt

Reviewed on 2026-11-06 against the implementation starting at `e98e6c0`.
This inventory ranks work by its effect on data, releases and maintainability.
It includes existing defects, verification gaps and structural constraints.
Product ideas and deferred features belong in [TODO](../TODO.md).

## Data integrity and recovery

| Finding | Evidence and consequence | Target |
|---|---|---|
| Bulk SQL spans three failure boundaries | `sql.execute` takes a snapshot, commits the SQL transaction, then reloads stores. A reload failure happens after the commit. The caller receives an error even though the rows changed, and a blind retry can repeat the write. Foreground and background writers can also change the database between the snapshot and the transaction. | Give the operation one write coordinator and distinguish committed results from reload failures. Test retry behavior, process interruption and writes from another connection. |
| Taking in a one-sided change depends on wall time | When only one side changed an item, `SyncEngine` takes in a version newer than the base by its recorded time. An edit made on a device whose clock is far behind can carry an older time than the version it started from, and other devices then skip it as old. Entries edited on both sides become conflicts the user settles ([Conflicts](ARCHITECTURE.md#conflicts)). | Stamp a local edit later than its base if clock skew shows up in practice. Test skew before changing version times. |
| Sync target changes can interrupt local state transitions | `SyncService._connect` clears sync state, queues local changes, and saves the new target and credential in separate steps. A stop or failure between them can leave an old target with its state cleared or a partially rebuilt queue. | Put related SQLite mutations in one transaction and persist a recoverable target-switch state across the database and secret store. Verify interruption before and after each boundary. |
| Server recovery lacks a verified procedure | `server/deploy/compose.yaml` mounts the server state directory. Account and key metadata use SQLite WAL in `server/internal/accounts`; encrypted objects live on disk. The server guide leaves backups to the operator. | Document and exercise a consistent backup and restore of accounts and objects into an isolated server. Verify device sign-in, revocations and object hashes after restoration. |

## Release and operating reliability

| Finding | Evidence and consequence | Target |
|---|---|---|
| Downloads share one temporary directory | `AppUpdates.download` deletes the entire `updates` directory at the start of each call. The automatic and manual entry points share it. The downloader has no per-attempt isolation, and an interrupted stream can leave a partial file. | Serialize installation, use a private staging path for each download and clean partial files on failure. Test cancellation and overlapping requests. |
| Build inputs can drift | Flutter's version appears in both workflows, local and CI JDKs differ, and Nightly uses mutable Actions tags and runner images. The bundled cargokit Gradle code has a local Android SDK parsing patch. | Declare and verify toolchain versions, pin reviewed workflow revisions, and document the local patches and upstream versions. Record the toolchain and build inputs with the published artifacts. See [GitHub Actions secure use](https://docs.github.com/en/actions/reference/security/secure-use). |
| Go packaging has two build paths | `server/Dockerfile` builds the binary inside the image. `server/deploy/Dockerfile` receives a prebuilt binary and Compose calls the image `latest`. The current CI checks the Go source and tests. | Produce a revision-addressed deployment artifact and test the same image or binary that will run. Preserve the prior artifact for rollback. |
| Server health covers process availability | `/healthz` and request logs cover basic operation. Deploy configuration has no Compose health check, and the repository has no separate service checks for authenticated traffic, storage and certificate/endpoint readiness. | Add a small isolated deployment smoke test and measure errors by operation. Keep account identifiers and diary data out of external telemetry. |

## Architecture and contracts

| Finding | Evidence and consequence | Target |
|---|---|---|
| Global instances couple services and tests | `AppDatabase`, `EntryStore`, `ConfigProvider` and sync services reach each other through singletons. `DiaryAppHarness` changes global database and provider state during setup and teardown. | Compose repositories and platform adapters at app and background entry points. Pass instances where ownership differs, so scratch stores and parallel tests use independent state. |
| Sync orchestration still spans identity, routes and recovery | `SyncService` owns storage/backend lifecycle, sync scheduling, nearby pairing and changes to keys and identity. Its connection lifecycle spans several asynchronously closed transports. | Give storage sessions, route selection and pairing separate lifecycle owners. Test interruption and reconnect at the boundaries and keep media progress independent of transport. |
| Temporary sync backends have unclear ownership | `SyncLogin.backend` creates clients. `SyncService` closes its cached backend, while operations such as `probe` and `createSpace` allocate their own without a common close contract. | Give backends an explicit lifecycle and close temporary sessions on success and failure. Test disposal after aborted setup and reconnect. |
| Copy confirmation performs full scans | `CopyStatusStore.local` traverses sync rows and checks each attachment file. The service uses it after a sync and for copy details. | Maintain counts and file confirmation from changed entries and chunks. Compare incremental summaries against a full scan after interruption or restore. |
| The editor still combines several UI workflows | `AddEditEntryPage` owns draft lifetime, focus, fullscreen editing, media selection and metadata prompts alongside an existing view model. `SyncSettings` combines status, backend setup and key/recovery dialogs. | Extract one user flow at a time with the existing view models and actions. Preserve editor state across lifecycle changes and keep secure settings behind their current authorization. |
| CLI batch completion is ambiguous on unexpected failure | `actions.batch` reports individual `ActionException` failures and continues. Other failures escape the loop after earlier operations may already have committed. | Define which failures stop the batch and always report the completed steps. Keep non-transactional actions distinct from transactional SQL. |
| SQL result limits apply after materialization | `sql.query` and the agent shell call `rawQuery`, then truncate the Dart list. A large result can exhaust memory before the output limit takes effect. | Bound rows at the query or cursor boundary, and define timeout, cancellation and reported count semantics for large queries. |
| The in-app agent still needs its own authorization boundary | The development shell can pass confirmation to destructive actions. `AcpLink` auto-selects an allow-once option. Release availability requires a policy for user approval and data sent to a configured model. | Distinguish interactive CLI confirmation from agent authorization. Bind destructive approval to the operation and payload. Show ACP requests to the user before granting permission. |

## Verification and maintenance

| Finding | Evidence and consequence | Target |
|---|---|---|
| Native behavior is outside the current automated gate | Linux runs host Flutter, CLI and Go tests. Nightly compiles the native apps, and the repository has no Android instrumentation suite. Installer confirmation, Keystore persistence, permission denial and OEM behavior need real platform evidence. | Start with the [repeatable smoke checks](TESTING.md#repeatable-android-smoke-checks). Automate where the emulator can exercise the actual boundary, and keep OEM and hardware cases on the test tablet. |
| Protocol tests still need independent version evidence | Host tests cover sync, server behavior and interrupted media. Cross-WAN route validation is deferred, and a current client and current server passing separately leaves compatibility with an installed older client open. | Keep shared protocol fixtures for supported versions. Run an isolated old/new pairing, upgrade and media-resume matrix. Record the nominated route in physical tests. |
| Localization checks sample generated behavior | `test/l10n/catalog_test.dart` checks ARB coverage and arguments and renders representative generated messages. It does not compare every committed generated file with output from the pinned generator. | Regenerate in CI with the pinned SDK and fail on a diff. Keep behavioral tests for pluralization, layout and locale resolution. |
| Architecture checks match source text | `layer_boundaries_test.dart` scans import lines. `actions_only_test.dart` matches known receiver and method names, with a small set of file-level exceptions. Aliases and new state owners can fall outside those patterns. | Use parsed imports and explicit public module boundaries. Enforce write ownership through interfaces and add behavior tests for shared GUI/CLI paths. |
| Focused host tests can compile unrelated Rust code | `dev.ps1 test` and `test-integration` always call `Build-AgentShell`. A fresh worktree builds the Rust shell even for a SQLite or HTTP test without an agent fixture. | Make native build requirements explicit in the test entry points. Keep the agent build for the full suite and for focused paths that load it. |
| Dependency upgrades lack an explicit review cycle | App, CLI, Go and Rust lockfiles record current versions. There is no checked-in dependency review or vulnerability scanning workflow across the stacks. | Establish a regular dependency review, including Flutter plugins, native bridges, workflow actions and container bases. Validate affected platforms and document intentional patches. |
| Native runner and release tooling have separate style gaps | The Windows and Linux runner code, PowerShell development scripts, Python manifest script and Bash mirror are outside the Dart, Go, Rust and Kotlin checks. | Use each language's formatter and syntax checks on first-party sources. Keep vendor and generated files on their own regeneration paths. |

Deferred product choices such as the MapLibre trial, the album storage default,
and additional encryption at rest remain in [TODO](../TODO.md) or
[Decisions](DECISIONS.md). See [Architecture](ARCHITECTURE.md) for current
responsibilities and [Testing](TESTING.md) for test selection.
