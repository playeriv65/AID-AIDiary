# Upstream source

AID Diary is a modified version of Daily You, not the official Daily You app.

- Upstream: https://github.com/Demizo/Daily_You
- Baseline commit: 4b778e0f78d5e36a3a4bbcb5cdc9018776404fef
- Baseline version: 3.6.1+3006001
- License: GPL-3.0-only, with the additional terms in ADDITIONAL_TERMS.md.
- Original authors: Demizo and Daily You contributors; original copyright headers are kept.

## Kept from upstream

Entry storage (SQLite), photos, moods, tags and trackers, templates, statistics, flashbacks, backup and restore (including encryption), imports from other diary apps, reminders, security lock, appearance settings and the Markdown editor.

## Changed locally

- Own app name, Android application ID and Windows metadata; About screen and welcome entry state that this is a modified version of Daily You.
- Layout modelled on the Journey diary app (layout and features only; no code, assets or text copied): journal with stories and day groups, calendar, media, atlas and coach destinations; navigation rail with list/detail panes on wide windows, bottom bar on phones; entry detail with star and previous/next; search with filters; editor with date title and a mood / place / tags / photo toolbar.
- Entry location (latitude, longitude, place name), database version 6; device location via geolocator, place names via OpenStreetMap Nominatim, map tiles from OpenStreetMap through flutter_map. Endpoints in `assets/config/app_config.json`.
- Theme colour presets and neutral backgrounds.
- Windows development script, native-asset packaging per the Flutter template, cooperative cancellation of archive compression, format detection for desktop thumbnails.
- Headless screenshot generation in `tool/screenshots/`.

## Removed

iOS, macOS, Linux and web targets; the upstream release scripts, Nix and AppImage packaging, store-screenshot and banner pipelines, and the Flutter SDK submodule.
