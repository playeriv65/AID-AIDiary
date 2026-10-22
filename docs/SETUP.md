# Setting up and handing over

What a new maintainer needs beyond the code: the toolchain, the signing
key, the test devices and the outside accounts the app depends on. Secrets
themselves are never in the repository; this file says where each one is
and who holds it.

## Toolchain

Development happens natively on Windows (no WSL). Versions in use on
2026-10-22:

| Tool | Version | Notes |
| --- | --- | --- |
| Flutter | 3.47.7 stable (Dart 3.13.5) | No SDK submodule; any install works. |
| JDK | 23.0.1 | The only JDK needed; `android/build.gradle` sets each module's Kotlin JVM target to its Java one, since many plugins leave it unset. |
| Android SDK | platform android-37, build-tools 36.0.0 | `compileSdk` 37; min and target SDK come from Flutter. |
| Visual Studio Build Tools | 2022 (17.14), Windows 10 SDK 10.0.26100 | For the Windows build. |
| Go | 1.26.0 for `server/` | `server/go.mod` selects this toolchain; the installed 1.25.6 launcher selects it automatically with `GOTOOLCHAIN=auto`. |
| Native WebRTC plugin | `flutter_webrtc` 1.6.2+hotfix.4 | Pinned Flutter dependency for Windows/Android ICE data channels; resolved by `dev.ps1 pub`. No TURN service is configured. |
| uv (Python) | 0.11 | Only for `tool/icon/export_icon.py`. |
| Tailscale | any | Reaches the test devices from anywhere (below). |

## First time on a new computer

1. Clone `playeriv65/AID-AIDiary` (private; access from the owner).
2. Copy `scripts/dev.env.example` to `scripts/dev.env` and set this
   computer's paths. `scripts/dev.ps1` reads it for every target and stops
   when it is missing. `DEV_TEMP` keeps Flutter's temp folders off a small
   system drive (interrupted runs leave gigabytes behind). Set
   `DEV_WINDOWS_RUNTIME` to one permanent absolute runtime directory outside
   disposable task worktrees before using `windows-stage`; keep test diary
   data elsewhere.
3. `flutter config --android-sdk <ANDROID_HOME>`, so Flutter and Gradle use
   the same SDK.
4. The signing key, for any Android build (next section).
5. `./scripts/dev.ps1 pub` resolves dependencies for both the Flutter app and
   the separate `cli/` Dart package. Run it in every new checkout/worktree
   before analysis or tests; the root analyzer also reads CLI sources.
6. `./scripts/dev.ps1 test` and `./scripts/dev.ps1 windows` to check.

## Sync development

[SYNC_NETWORK.md](SYNC_NETWORK.md) records the path policy, encrypted chunk
protocol, persistent queue and remaining network work. Use a local server
and scratch diary data for protocol tests; [the server guide](../server/README.md)
owns deployment variables and authoritative media-cache limits. `aid sync.status`
reports normal progress; `aid sync.network` adds candidate routes, retry
timing, Internet/relay state, actual ICE candidate-pair diagnostics and
durable versus temporary/unconfirmed media delivery counts.

The AID WebDAV networking service supplies account-authenticated WebSocket
presence/signaling at `/api/sync/network`; public address exchange, ICE/STUN
and bounded live relay require that service. Ordinary WebDAV and Google
Drive retain LAN plus their own storage. Configure STUN in
`assets/config/app_config.json`; no TURN credentials are needed. Server
operator settings, separate signal/relay/cache ledgers and nginx WebSocket
upgrade headers are documented in [server/README.md](../server/README.md).
The production service was updated on 2026-10-22 from server source `887dd27`,
including nginx WebSocket upgrades and opt-in 1 GB monthly media policy.
[SYNC_NETWORK.md](SYNC_NETWORK.md) records deployment checks and remaining
network-validation limits.

Spaces created now use format 4. Earlier remote formats are rejected without
migration or automatic reset. Starting over on a live server is a destructive
owner decision: use a new space or the explicitly authorized
`sync.reset_space` action, preserve the local diary and arrange re-pairing.
Do not turn an unsupported-format error into cleanup of the remote data.

LAN discovery uses native DNS-SD on Windows and Android for devices already
sharing the user/space keys. Native LAN discovery, global-IPv6 direct,
ICE/STUN candidate checks and bounded relay have now been checked between
Windows and the Xiaomi Pad 7 on the same Wi-Fi, including matching media
hashes and relay-budget exhaustion followed by an automatic LAN upgrade.
These do not prove cross-WAN reachability: the owner deferred another-network
testing, and an external IPv6/TCP probe timed out. Exact evidence, limitations
and the verified temporary-service cleanup/final test status are in
[SYNC_NETWORK.md](SYNC_NETWORK.md). The app targets Android SDK 36
while compiling against SDK 37; local-network permission handling for a
future target-SDK upgrade remains follow-up work. Do not change global
cleartext policy merely to enable Dart-owned LAN HTTP sockets.

### Isolated physical network checks

Windows network tests should run the **same executable path** across
worktrees. First build with `./scripts/dev.ps1 windows-build`, then use
`./scripts/dev.ps1 windows-stage` to copy that existing debug bundle to
`DEV_WINDOWS_RUNTIME`. Staging neither builds nor launches the app and does
not change firewall rules. It holds the checkout build lock and a separate
destination lock; it refuses a running destination app, an overlapping
build/destination path, or a nonempty first-use directory without the
runtime marker. Stop the fixed runtime before replacing it. Launch it
hidden with separate `AID_DATA_DIR` folders and private `AID_API_INFO` files;
keep all scratch diary data outside the staged bundle.

Windows Win32 firewall application rules use the executable's full path,
not the Android package ID ([Microsoft's application-rule documentation](https://learn.microsoft.com/en-us/windows/security/operating-system-security/network-security/windows-firewall/rules#applications-rules)).
Moving between worktree build directories can therefore prompt again.
Authorize the fixed runtime's required network profiles once on first use;
updating the executable at that same path can reuse its existing grants.
This does not disable the firewall or authorize an automatic elevation.
The current session confirmed eight existing TCP/UDP Allow rules across
four executable paths for Private/Public profiles. Retargeting those rules
to the new stable path failed with non-admin `AccessDenied`; no firewall
rules changed. The current validation continued from its already authorized
fixed runtime. Future runs should stage to the configured permanent path
and obtain its initial consent if it has no matching grant.

The Android **dev flavor only** accepts a launch-intent string extra named
`aid_test_workspace`. Its value must be 1 to 64 ASCII letters, digits, `_`
or `-`. For example, launch the dev activity with
`--es aid_test_workspace network-check`; its app-private root becomes
`files/network-tests/network-check`. Database, media, preferences, temporary
files, API info and secrets all use that root. The regular app folders and
platform secret store are not modified. Test secrets are plain files in
this private scratch directory, so use test credentials only and keep the
workspace, copied API token and logs out of git. A normal launch without
the extra uses the usual app data again; changing the intent requires a
fresh dev-app process to select the new stores. Scratch launches do not
schedule or cancel the regular app's Workmanager background tasks.

For CLI access, privately copy that workspace's `agent_api.json` with
`adb run-as dev.aid.diary.beta`, forward the API's port to the matching local
port, and point `AID_API_INFO` at the copied file. The ordinary `aid -d`
lookup uses the normal app location and does not discover this scratch
file automatically. Do not clear app data, reinstall with a different key
or use the owner's everyday `dev.aid.diary` package to obtain isolation.

Development-only `aid sync.network_paths paths=ice,cache stunOnly=true`
restricts a test without changing persistent settings. Valid path names are
`lan`, `direct`, `ice`, `relay`, `cache`; use the required subset, then restart
to restore automatic selection. `stunOnly=true` filters exchanged ICE
candidates to `srflx`/`prflx`. Inspect `sync.network` for the actual selected
pair and protocol, and compare attachment hashes on both devices. A route
label or gathered STUN candidate is not proof that the selected pair used it.

Use the development action `aid sync.network_reconnect delaySeconds=45`
to disconnect just signaling while retaining established direct links.
The delay accepts 1 to 60 seconds and defaults to 5. The latest Windows/Pad
binaries passed this one-sided test, then continued ICE text and newly
generated, hash-verified media sync with the isolated Go test server
stopped and both directory peer lists empty. A remote directory `leave`
must not tear down that working direct link. See `SYNC_NETWORK.md` for the
exact fixture/hash. These were same-Wi-Fi checks; they do not establish
cross-NAT reachability. Temporary-service/device-test cleanup is verified.
The earlier network-validation Flutter suite passed 710 tests, with six
external-service tests skipped; analysis is clean, seven CLI tests passed and Go vet/tests/race
checks passed. Later app validation and the completed production deployment
are recorded in [SYNC_NETWORK.md](SYNC_NETWORK.md).

A public endpoint under the owner's AID domain may be used only when
authorized. Keep it under a temporary proxy prefix, with a separate server,
port, accounts and data directory. Remove the endpoint and test artifacts
afterward. This does not update the production container or authorize a
production release. Never put an authenticated test URL or credential in
the repository.

The completed check restored the original nginx configuration, passed
`nginx -t`, confirmed production health 200 and temporary-prefix health 404,
and removed the isolated server/data, Windows test processes, the one
Android scratch workspace and temporary adb mappings. Production and
ordinary diary data were retained. The primary checkout's
`build/windows-runtime` now contains the latest bundle, staged but not
launched to avoid a new firewall authorization. The matching APK is kept
at `build/handover/app-dev-debug.apk`, SHA-256
`8B33B6C5306AB6E456EFB836B9FBBC2F5C2F2493CDD7547285CD6940DB10A5B7`.

## Signing key

Native Flutter run/build targets take an exclusive per-checkout file lock.
Windows and Android builds share Flutter asset staging and must not run
concurrently in the same checkout: this can produce an APK without its Dart
kernel. `./scripts/dev.ps1 windows-build` builds without opening a window;
use another worktree for concurrent platform builds. An existing lock file
does not block a build when its owning process has closed it.

Every Android build, debug and profile included, is signed with the
release key whenever `android/key.properties` exists (template:
`android/key.properties.example`; git ignores the real one). That is what
lets any build install over any other on the owner's devices; HyperOS asks
on the device before every new install and before any install whose key
changed, so a build signed differently means uninstalling, with the
device's data, and a prompt on the device.

- The keystore is the owner's, kept at `D:\software\keys` on the
  development PC and never committed or shared in chat. A worktree has no
  `key.properties`: copy it from the main checkout (`dev.ps1` stops early
  when it is missing).
- A maintainer without that key makes their own with `keytool -genkeypair`
  and points `key.properties` at it. Their builds then cannot update the
  owner's installs, and Google Drive sign-in needs the new key's SHA-1
  registered (`docs/GOOGLE_DRIVE.md`).

## Test devices

| Device | Role | How it is reached |
| --- | --- | --- |
| Windows PC (16 threads, 23 GB RAM, small C: drive) | Day-to-day development; hidden app windows for tests (`dev.ps1 windows-background`, `AID_DATA_DIR`) | Local. Builds share RAM with many other programs: `dev.ps1` stops Gradle after Android builds. |
| Xiaomi Pad 7 (2410CRP4CC, Snapdragon 7+ Gen 3, Android 16 / HyperOS, 3200×2136 at 120 Hz) | The test device: profile builds, frame rate, touch, camera, OEM behaviour | adb over TCP, `adb connect 100.79.141.50:5555` (Tailscale name `xiaomi-pad-7`). |
| Redmi K80 (HyperOS) | The owner's own phone: test only when asked | Tailscale `100.124.182.51:5555`. Its dev app holds test data only. |
| Emulators `diary_api36` (headless, `-no-window`) and `journey_tablet` (rootable) | Home-screen widget checks; `journey_tablet` can fire alarms with `adb root` and `date` | `ANDROID_AVD_HOME` from `dev.env`. |
| Nubia Z17 (LineageOS, rooted) | Planned as an unrestricted development phone | Not set up yet. |

Connecting the tablet:

- adb's TCP mode lasts until the tablet restarts. After a restart, pair it
  again under Developer options → Wireless debugging, `adb connect` to the
  port shown there, then `adb tcpip 5555`.
- A sleeping tablet drops off Tailscale: `tailscale ping 100.79.141.50`
  wakes the link when the screen is on, otherwise someone has to unlock it.
- On the same Wi-Fi without TCP mode, adb finds it by mDNS as
  `adb-53e18407-…_adb-tls-connect._tcp`; from elsewhere, scan
  100.79.141.50 ports 30000–50000 for the wireless-debugging port.

HyperOS behaviour that shapes testing:

- A new install asks for confirmation on the device; updates signed with
  the same key do not. Never tap that prompt remotely: the person at the
  device does.
- The dev flavor is `dev.aid.diary.beta`, never `.dev`: HyperOS put that
  package name on its 60 Hz game list for good (`docs/REFRESH_RATE.md`).
- Turning on any accessibility service turns on Flutter's semantics tree,
  which costs frame time; measure with them off.
- To check phone layouts on the tablet: `wm size 1080x2400`,
  `wm density 420`, rotate with `cmd window user-rotation lock 0|1`, and
  restore (`wm size reset`, `wm density reset`,
  `cmd window user-rotation free`) afterwards.

Isolated device-authorization tests also create native signing keys outside the
scratch files. Before removing a test workspace, run the development-only,
destructively confirmed `sync.devices_test_cleanup` action inside that workspace,
then stop its process and remove its files. The action refuses ordinary data
directories. Android test launches must be force-stopped before selecting a
different `aid_test_workspace`, so the engine and native key namespace are
initialized for the same workspace. Never clear the everyday package.

## Outside resources

| What | Where | Access |
| --- | --- | --- |
| Source code | GitHub `playeriv65/AID-AIDiary` (private); the old web app as tags `legacy-web`, `legacy-web-dev` | Owner |
| Release keystore | `D:\software\keys` on the development PC, read through `android/key.properties` | Owner only; never in git or chat |
| Google Cloud project `aid-diary` | Drive API and the OAuth clients (Android release, Android beta, web, Windows desktop); client IDs in `assets/config/app_config.json` | Owner's Google account (`docs/GOOGLE_DRIVE.md`) |
| AID sync server | `https://aid.playeriv65.com/dav/`; SSH alias `netlab_main`, installation `/srv/aid-sync`, Docker behind nginx TLS; server source `887dd27` and WebSocket headers deployed 2026-10-22 | Owner's server and domain `playeriv65.com`; maintain through native SSH and `server/deploy/`; accounts use `aid-sync adduser`; deployment and backup evidence in `docs/SYNC_NETWORK.md` |
| Map, place and weather services | OpenStreetMap tiles, Nominatim, Overpass, Open-Meteo; endpoints in `assets/config/app_config.json` | Public; follow their usage policies (low request rates, a real User-Agent) |
| Upstream | Daily You by Demizo (GPL-3.0); baseline in `SOURCE.md` | Public |
| UI references | Journey and 一本日记 installers, screenshots and notes in `D:\program\diary-references\` (index in its README) | Owner's PC, outside the repository: reference only, never copied |
| Old project's files | `D:\program\AID-AIDiary-legacy` | Owner's PC; kept, not imported |
| Flutter issues followed | Android refresh rate on HyperOS (`docs/REFRESH_RATE.md`), Windows Impeller start-up cost [#191860](https://github.com/flutter/flutter/issues/191860) (why Windows renders with Skia) | Public |
