# App updates

Android builds outside F-Droid update themselves from the nightly release.
Windows and Linux do not yet (see TODO.md).

## Release manifest

The nightly (`.github/workflows/nightly.yml`) publishes `latest.json` beside
its packages, written by `scripts/release_manifest.py`:

```json
{
  "version": "0.1.0",
  "build": 261029183,
  "commit": "…",
  "published": "2026-10-29T18:30:00+00:00",
  "notes": ["English lines, for apps from before notesByLanguage"],
  "notesByLanguage": {"en": ["…"], "zh": ["…"], "zh_Hant": ["…"]},
  "files": {
    "android": {"name": "aid-diary.apk", "size": 0, "sha256": "…"},
    "android-dev": {"name": "aid-diary-dev.apk", "size": 0, "sha256": "…"},
    "windows": {"name": "aid-diary-windows.zip", "size": 0, "sha256": "…"},
    "linux": {"name": "aid-diary-linux.tar.gz", "size": 0, "sha256": "…"}
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
addresses in `app_config.json` (`updates.manifestUrls`) in order: the AID
server first, which mainland China reaches, then GitHub, which it often
does not. Until the server mirrors the release, its address fails and the
app goes on to GitHub.

## Server mirror

On the AID server (`netlab_main`), `aid-update-mirror.timer` runs
`/srv/aid-updates/mirror.sh` hourly (`server/deploy/update-mirror/`): it
fetches the nightly's `latest.json` from GitHub, and when its build is new,
downloads every file, checks each against the manifest's SHA-256, and puts
the manifest up last in `/srv/aid-updates/www`, which nginx serves at
`https://aid.playeriv65.com/updates/` (`server/deploy/nginx.conf`). The
server holds no GitHub credential. Deployed on 2026-10-29; the nginx site
from before is in `/srv/aid-sync/backups/`.

## Build numbers

Android builds carry the time as their build number, UTC `YYMMDDHH` and the
ten minutes (`261029183`): the nightly and `scripts/dev.ps1` stamp it the
same way, so any build updates any older one (AGENTS.md, "Versions").

## Signing

The nightly signs both Android packages with the release key, from the
repository secrets `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`,
`ANDROID_KEY_ALIAS` and `ANDROID_KEY_PASSWORD`, so they install over the
owner's apps. The job fails without them; the key file is removed after
the builds.

## In the app

- **Checking**: when the app opens, at most every `updates.checkHours`, if
  "Check for updates automatically" is on (About). "Check for updates" asks
  at once. `aid update.check` does the same.
- **Asking**: a dialog with the commit lines: Skip this version, Later,
  Update. Update downloads with progress and installs.
- **Silently** ("Install updates without asking", off by default): the app
  downloads in the background and installs when the user leaves it. Android
  12 and later allow that only once the app installed itself; until then,
  and on older Android, the dialog asks instead. HyperOS and MIUI never
  allow it: they refuse an install session that asks for no user action
  from an app Xiaomi has not listed (`INSTALL_FAILED_ABORTED: Permission
  denied`, from `PKMSImpl.assertCallerAndPackage`), so on Xiaomi devices
  the session always asks, HyperOS shows its own confirmation, and the
  switch is not offered (tested on the Xiaomi Pad 7, 2026-10-29).
- **After an update** the app says so once, with the notes.

Before it installs, the app checks the download's size and SHA-256 against
the manifest; the Android side (`AppUpdater.kt`) checks that the package is
this app, signed with this app's key, and newer. Android's installer does
the rest; the app closes while it installs. The first install asks the user
to allow AID Diary to install apps.

The F-Droid build has no update permission and checks nothing: F-Droid's
client updates it, signed with F-Droid's key.

## Database upgrades

A build that raises the database schema upgrades the diary on its first
start, which cannot be undone. Before that the app copies the diary aside,
into `before-upgrade/` beside it, keeping the two newest copies
(`AppDatabase.copyBeforeUpgrade`). This holds for every way a new build
arrives, not only updates.
