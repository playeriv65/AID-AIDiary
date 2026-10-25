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

- Own app name, Android application ID and Windows metadata; the About screen states that this is a modified version of Daily You and shows LICENSE.txt and ADDITIONAL_TERMS.md. Package, file, database, backup and notification-channel names use `aid_diary`; data from Daily You or older builds is not read.
- Own app icon (a blue spiral notebook with a sparkle, flat shapes), drawn from scratch by `tool/icon/export_icon.py`.
- Own layout: journal with stories and day groups, calendar, media, atlas and coach destinations; navigation rail with list/detail panes on wide windows, bottom bar on phones; entry detail with star and previous/next; search with filters; editor with date title and an attachment / place / weather / activity / mood / tags toolbar.
- Privacy policy rewritten for this build (local storage, optional network services); the upstream contact address is not used.
- Entry location (latitude, longitude, place name and how it was set) and the weather of each day at each place (WMO code, temperature and source; database version 17, which also gives entries a title column of their own and turns rows that belong to an entry into foreign keys). Device location via geolocator, place names and place search via OpenStreetMap Nominatim, map tiles from OpenStreetMap through flutter_map with marker clustering, weather from Open-Meteo. Optional automatic place and weather for new entries. Endpoints in `assets/config/app_config.json`.
- Video and voice note attachments (video_player, video_player_win, record) stored alongside photos.
- Today story (statistics, mood chart, throwback), built-in templates and a template link in the editor, duplicate and save-as-template for entries, inline search filters, "What makes me feel…" mood associations, entry font / size / line spacing and list wallpapers, settings regrouped into General, Data & storage, Stories, Notifications, Security and Help & about.
- Android home screen widgets (home_widget): today's status, a daily photo,
  streak, daily prompt and quick mood.
- Coach programs with enrolment, a story chain (today, coach prompt answered in place, throwback, closing card), a location sheet and picker with saved and nearby places (OpenStreetMap Overpass), a share sheet (image, ZIP with media, text, HTML), first-run device choices with a reusable tutorial, a help page, the photo's time and place offered from EXIF, a quick-write notification and nudges after quiet days.
- Recently deleted and time capsules (database version 8: `deleted_at` and `open_at` on entries), random walk, week and year reviews, Year in Pixels, quick check-in, morning and evening templates, entry share pictures, JSON export, a Markdown insert menu, journal sorting by last update, reminder weekdays, 12/24-hour setting and recent places. Backlog in `TODO.md`.
- Theme colour presets and neutral backgrounds.
- Independent dark palettes, diary paper and original vector decorations;
  regrouped settings.
- Tablet drawing uses [Scribble 0.10.0+1](https://github.com/timcreatedit/scribble)
  and [perfect_freehand 2.5.2+1](https://pub.dev/packages/perfect_freehand), both
  MIT licensed. Their license notices are bundled by Flutter. Drawing documents
  and headless PNG exports are implemented locally.
- Weather icons are eight static "fill" SVGs from
  [Meteocons](https://github.com/basmilius/meteocons) by Bas Milius
  (`@meteocons/svg-static` 0.1.0, MIT), unmodified in `assets/weather/` with
  their license, which the app lists among its licenses.
- Local photo suggestions use bounded on-device metadata and explicitly selected
  folders; photos are imported only after choosing a suggestion.
- Windows development script, native-asset packaging per the Flutter template, cooperative cancellation of archive compression, format detection for desktop thumbnails.
- Headless screenshot generation in `tool/screenshots/`.
- End-to-end encrypted format-4 sync through personal storage and trusted peers,
  persistent chunked media tasks, automatic LAN/public/ICE path selection and
  a Go signaling service with separately bounded live relay and temporary cache
  (`docs/SYNC_NETWORK.md`).

## Removed

iOS, macOS and web targets (Linux was removed too and recreated from the Flutter template on 2026-10-24); the upstream release scripts, Nix and AppImage packaging, store-screenshot and banner pipelines, and the Flutter SDK submodule.
