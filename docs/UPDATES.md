# App updates

Android builds outside F-Droid and the Windows app that the installer put
in place update themselves from the nightly release. Linux does not yet
(see TODO.md).

## Windows installer

The nightly builds `aid-diary-windows-setup.exe` with Inno Setup from
`windows/installer/aid_diary.iss`; `installer.ini` beside it holds the
installer's AppId, which must never change. It installs for the current
user without an administrator prompt, in
`%LOCALAPPDATA%\Programs\AID Diary`, with the Visual C++ runtime DLLs the
app imports and the `aid` command line. It adds "AID Diary" to the Start menu (and so to Windows
Search), an uninstaller in Settings > Apps, and optionally a desktop
shortcut and the install folder on the user's PATH. A newer installer
replaces the installed app in place and keeps those choices. Uninstalling
removes the installed files only; the diary in `%APPDATA%\com.playeriv65.diary`
(docs/ARCHITECTURE.md#app-identity) stays.

The ZIP stays a portable download. A copy run from it, or from a build
folder, has no uninstaller beside it and does not update itself.

## Release manifest

The nightly (`.github/workflows/nightly.yml`) publishes `latest.json` beside
its packages. The manifest keeps the same fields on GitHub and the mirror.
The names contain the Actions run ID and attempt.

```json
{
  "version": "0.1.0",
  "build": 261029183,
  "commit": "…",
  "published": "2026-10-29T18:30:00+00:00",
  "notes": ["English lines, for apps from before notesByLanguage"],
  "notesByLanguage": {"en": ["…"], "zh": ["…"], "zh_Hant": ["…"]},
  "files": {
    "android": {"name": "aid-build-1234-1-aid-diary.apk", "size": 123, "sha256": "…"},
    "android-dev": {"name": "aid-build-1234-1-aid-diary-dev.apk", "size": 123, "sha256": "…"},
    "windows": {"name": "aid-build-1234-1-aid-diary-windows-setup.exe", "size": 123, "sha256": "…"},
    "linux": {"name": "aid-build-1234-1-aid-diary-linux.tar.gz", "size": 123, "sha256": "…"}
  }
}
```

The notes are what users read: the entries of `CHANGES.json` added since
the last release, each written for users (not a commit subject) in
English, Simplified and Traditional Chinese. The app shows its language's
lines (with the script, then the language, then English); other languages
get English until they have their own lines. `notes` keeps the English
list in the shape apps before 2026-10-29 read.

Files are named, not linked: the app fetches them beside the manifest it
read, so a mirror serves the same manifest unchanged. The app asks the
addresses in `app_config.json` (`updates.manifestUrls`) in order. The AID
mirror serves its last published manifest until it catches up. A valid
manifest from that mirror is used even if GitHub already has a newer build.
If a response fails to download or validate, try the next address. Only an
accepted manifest updates the last successful check time.

## Publishing Nightly

Only Nightly runs on main can publish. `scripts/publish_nightly.py` uploads
the build's packages and candidate manifest under unused names. It verifies
the release asset state, sizes and SHA-256 digests before moving the old
`latest.json` to an archive name and promoting the candidate. GitHub can
return a 404 between those two asset renames. If promotion fails, the script
restores the archived manifest when the pointer is absent. A later run also
recovers a missing pointer after cancellation. Each successful run edits the
same prerelease, and its description links directly to that run's packages.

GitHub retains the immediately previous publication and assets from the last
seven days. Fixed-name download links stay on the last legacy publication
while its manifest is retained, then resume following the latest build.
Clients already resolve the file name beside the manifest, so they can use
both the fixed and build-specific package names.

To roll back the offered update, first pause Nightly publication. Choose a
retained `latest-*.json` asset and verify every referenced file's size and
SHA-256 at its public GitHub URL. Archive the current `latest.json` under
its publication and asset ID, rename the chosen asset to `latest.json`, and
read it back from GitHub. If promotion fails, restore the displaced asset.
Run the mirror once and check the manifest and package hashes at both sources.
This changes the offered build. Devices that already updated continue to
require a strictly newer build to install another update.

## Server mirror

On the AID server (`netlab_main`), `aid-update-mirror.timer` runs hourly.
The mirror downloads every referenced package, verifies size and SHA-256,
and switches `latest.json` with a single rename on the same filesystem.
Each package remains available for seven days after the last manifest that
referenced it is retired. nginx serves `/srv/aid-updates/www` at
`https://aid.playeriv65.com/updates/` (`server/deploy/nginx.conf`). The
server holds no GitHub credential. The mirror accepts only the package
names in its `FILES`, the same as `scripts/release_manifest.py`: deploy a
renamed package's `mirror.py` once the first manifest with that name is
published, as it refuses the older names.

For the build-specific rollout, install `mirror.py` under `/srv/aid-updates/`
and the updated unit from `server/deploy/update-mirror/`. The unit requires
Python 3.11 or later. Verify it first with `AID_UPDATES_DIR` pointing to an
isolated directory and use `AID_UPDATES_SOURCE` to select a test source if
needed. After the first build-specific manifest is visible on GitHub, stop
the timer, wait for the old service run to finish, reload systemd, run the new
service once, verify the served manifest and its packages, and restart the
timer. The new mirror accepts the initial legacy fixed-name manifest and
keeps its files. It refuses an attempt to overwrite an existing package
with different bytes. The old mirror can read build-specific names, but
still removes older packages until the unit is upgraded.

## Build numbers

Android builds carry the time as their build number, UTC `YYMMDDHH` and the
ten-minute digit (`261029183`). Nightly and `scripts/dev.ps1` stamp it
the same way. Builds stamped within the same ten-minute window share a
number. An in-app update requires a strictly newer build, and the local
install script refuses a device with the same or a higher build number.

## Signing

The nightly signs both Android packages with the release key, from the
repository secrets `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`,
`ANDROID_KEY_ALIAS` and `ANDROID_KEY_PASSWORD`, so they install over the
owner's apps. The job fails without them; the key file is removed after
the builds.

## In the app

- **Checking**: when the app opens, at most every `updates.checkHours`, if
  "Check for updates automatically" is on (About). "Check for updates" asks
  at once. `aid update.check` does the same, and also reports a version the
  user skipped, marked `skipped: true`, and the package's download state.
- **Downloading**: a build the check finds, unless the user skipped it,
  downloads in the background (`AppUpdates.prefetch`) while the app is
  open, on an unmetered network only: Android's
  `ConnectivityManager.isActiveNetworkMetered`, as Android apps leave large
  downloads on mobile data to the user. Windows counts as unmetered. A
  failed download is logged, not shown; the next start or check tries
  again. `aid update.download` starts the same download on any network
  (`wait` returns once it is verified).
- **Asking**: once the package is downloaded and verified, a dialog with
  the notes: Skip this version, Later, Update. Update goes straight to the
  installer. On a metered network the dialog comes at once and Update
  downloads with progress first; "Check for updates" also shows it at
  once, with the download under way, and Update shows what is left of it.
  Skip drops the package; Later keeps it, and the dialog comes again with
  the next due check. `aid update.install` installs the downloaded package
  when it is still the newest (or the check fails), else downloads first.
- **Silently** ("Install updates without asking", off by default): the app
  installs the downloaded package when the user leaves it. On a metered
  network the dialog asks instead. Android
  12 and later allow that only once the app installed itself; until then,
  and on older Android, the dialog asks instead. HyperOS and MIUI never
  allow it: they refuse an install session that asks for no user action
  from an app Xiaomi has not listed (`INSTALL_FAILED_ABORTED: Permission
  denied`, from `PKMSImpl.assertCallerAndPackage`), so on Xiaomi devices
  the session always asks, HyperOS shows its own confirmation, and the
  switch is not offered (tested on the Xiaomi Pad 7, 2026-10-29). Windows
  does not offer it either: a desktop app is not paused when the user
  leaves it, so the dialog always asks.
- **After an update** the app says so once, with the notes.

The package lives in the app's cache folder, `updates/` under Android's
cache directory (the only place `AppUpdater.kt` installs from) and
`%LOCALAPPDATA%\com.playeriv65.diary` on Windows, one build at a time:
`update.json` (the manifest entry), `update-<build>.<ext>.part` while it
downloads and `update-<build>.<ext>` once its size and SHA-256 match. A
download cut off, for example when the app is closed, continues on the
next start with an HTTP range request; a server that answers with the
whole file starts it again. A newer build replaces the package and stops
its download, as does an older one the manifest offers again after a
rollback; a manifest with nothing newer removes it. On start the app
checks a kept package again and removes the files of a build that is
installed, skipped or older. Android may clear the cache when storage runs
low; the package then downloads again.

Before it installs, the app checks the download's size and SHA-256 against
the manifest; the Android side (`AppUpdater.kt`) checks that the package is
this app, signed with this app's key, and newer. Android's installer does
the rest; the app closes while it installs. The first install asks the user
to allow AID Diary to install apps.

On Windows the app starts the downloaded installer with the arguments in
`app_config.json` (`updates.windowsSetup`: `/VERYSILENT /SUPPRESSMSGBOXES
/NORESTART /LOG /RELAUNCH=1`) and closes itself a second later, which
leaves a command line waiting on `update.install` time to get its answer.
The installer shows no window. If the app is still open when its files are
replaced, Restart Manager closes it (`CloseApplications=force`). The
installer then opens the app again (`/RELAUNCH=1`). Its log is `Setup Log
*.txt` in `%TEMP%`. The installer is not code-signed. Its hash in the
manifest is the only check, and a browser download of it meets SmartScreen
until it has a reputation.

The F-Droid build has no update permission and checks nothing: F-Droid's
client updates it, signed with F-Droid's key.

The manifest names packages by role (`android`, `android-dev`), and an
Android app takes `android-dev` when its package ends in `.beta`. Since
2026-11-09 those files are `com.playeriv65.diary` and
`com.playeriv65.diary.beta`. Installs of the old packages, `dev.aid.diary`
and `dev.aid.diary.beta`, still find and download them, and `AppUpdater.kt`
refuses each as another app (`wrong_app`): they no longer update. Their
owner installs the new app beside the old one and moves the diary over
(TODO.md, "App identity move").

## Database upgrades

A build that raises the database schema upgrades the diary on its first
start. Before the migration begins, `AppDatabase.copyBeforeUpgrade` reads
the version through SQLite and creates a standalone, integrity-checked
snapshot in `before-upgrade/` beside the diary. It contains the committed
SQLite view at snapshot start, including committed WAL changes. A backup
failure stops the migration. The two newest snapshots are retained in date
order across schema versions. These rules apply regardless of how the new
build is installed.

To verify a restore, stop the app and keep the active diary and its sidecars
intact. Copy the selected snapshot as `aid_diary.db` into a separate test
workspace, along with the matching `Images/` from the diary workspace or
a full backup. The automatic snapshot contains the database only. Older
raw copies may have their own matching WAL or rollback journal and should
be opened with those files present. Open the workspace with a build that
supports the snapshot's schema. Verify SQLite integrity, compare diary
records and check the hashes of referenced media before any replacement.
