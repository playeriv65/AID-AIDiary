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
| Go | 1.25 | Only for the sync server in `server/`. |
| uv (Python) | 0.11 | Only for `tool/icon/export_icon.py`. |
| Tailscale | any | Reaches the test devices from anywhere (below). |

## First time on a new computer

1. Clone `playeriv65/AID-AIDiary` (private; access from the owner).
2. Copy `scripts/dev.env.example` to `scripts/dev.env` and set this
   computer's paths. `scripts/dev.ps1` reads it for every target and stops
   when it is missing. `DEV_TEMP` keeps Flutter's temp folders off a small
   system drive (interrupted runs leave gigabytes behind).
3. `flutter config --android-sdk <ANDROID_HOME>`, so Flutter and Gradle use
   the same SDK.
4. The signing key, for any Android build (next section).
5. `./scripts/dev.ps1 test` and `./scripts/dev.ps1 windows` to check.

## Signing key

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

## Outside resources

| What | Where | Access |
| --- | --- | --- |
| Source code | GitHub `playeriv65/AID-AIDiary` (private); the old web app as tags `legacy-web`, `legacy-web-dev` | Owner |
| Release keystore | `D:\software\keys` on the development PC, read through `android/key.properties` | Owner only; never in git or chat |
| Google Cloud project `aid-diary` | Drive API and the OAuth clients (Android release, Android beta, web, Windows desktop); client IDs in `assets/config/app_config.json` | Owner's Google account (`docs/GOOGLE_DRIVE.md`) |
| AID sync server | `https://aid.playeriv65.com/dav/`, deployed from `server/deploy/` (Docker behind the host's nginx, which terminates TLS) | Owner's server and domain `playeriv65.com`; accounts are added there with `aid-sync adduser` |
| Map, place and weather services | OpenStreetMap tiles, Nominatim, Overpass, Open-Meteo; endpoints in `assets/config/app_config.json` | Public; follow their usage policies (low request rates, a real User-Agent) |
| Upstream | Daily You by Demizo (GPL-3.0); baseline in `SOURCE.md` | Public |
| UI references | Journey and 一本日记 installers, screenshots and notes in `D:\program\diary-references\` (index in its README) | Owner's PC, outside the repository: reference only, never copied |
| Old project's files | `D:\program\AID-AIDiary-legacy` | Owner's PC; kept, not imported |
| Flutter issues followed | Android refresh rate on HyperOS (`docs/REFRESH_RATE.md`), Windows Impeller start-up cost [#191860](https://github.com/flutter/flutter/issues/191860) (why Windows renders with Skia) | Public |
