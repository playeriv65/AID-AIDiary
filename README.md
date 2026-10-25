# AID Diary

**English** | [简体中文](docs/readme/README.zh-CN.md) | [日本語](docs/readme/README.ja.md) | [한국어](docs/readme/README.ko.md)

A private diary app for Windows, Android and Linux, built with Flutter.

Builds of the latest `main` are on the [nightly prerelease](https://github.com/playeriv65/AID-AIDiary/releases/tag/nightly) (Android APKs, a Windows ZIP and a Linux tarball). They are signed with a debug key, so they install fresh but cannot update an installation signed with the release key.

## Screens

Phones get a bottom bar; tablets and desktop windows a navigation rail with list and detail panes.

Search stays pinned above scrolling lists on phones, tablets and Windows.
A small back-to-top shortcut appears during long journal browsing. Feedback
is sent from Settings > Help in one tap, or opens as a GitHub issue or an email.
Windows keeps its native title bar, with the app icon and AID Diary name, and
matches the frame colors to the app theme; see [Windows setup](docs/SETUP.md#windows-personal-installation).

| Tablet / desktop | Phone |
|---|---|
| ![Journal](artifacts/ui-tablet-journal.png) | ![Journal](artifacts/ui-phone-journal.png) ![Entry](artifacts/ui-phone-entry.png) |
| ![Calendar](artifacts/ui-tablet-calendar.png) | ![Calendar](artifacts/ui-phone-calendar.png) ![Media](artifacts/ui-phone-media.png) |
| ![Media](artifacts/ui-tablet-media.png) | ![Coach](artifacts/ui-phone-coach.png) ![Search](artifacts/ui-phone-search.png) |
| ![Coach](artifacts/ui-tablet-coach.png) | ![Editor](artifacts/ui-phone-editor.png) ![Share](artifacts/ui-phone-share.png) |
| ![Coach program](artifacts/ui-tablet-coach-program.png) | ![Location](artifacts/ui-phone-location-picker.png) ![Share as](artifacts/ui-phone-share-as.png) |
| ![Coach story](artifacts/ui-tablet-story-prompt.png) | |
| ![Handwriting](artifacts/ui-tablet-backlog-drawing.png) | ![Appearance](artifacts/ui-phone-backlog-appearance.png) |
| ![Paper](artifacts/ui-tablet-backlog-lined.png) | ![Local photo suggestions](artifacts/ui-phone-backlog-moments.png) |
| | ![Random walk](artifacts/ui-phone-random.png) ![Week review](artifacts/ui-phone-week-review.png) |
| ![First launch](artifacts/ui-tablet-first-start.png) | ![First launch](artifacts/ui-phone-first-start.png) |
| ![Tutorial](artifacts/ui-tablet-tutorial.png) | ![Tutorial](artifacts/ui-phone-tutorial.png) |
| ![Diary day](artifacts/ui-tablet-diary-day-picker.png) | ![Diary day](artifacts/ui-phone-diary-day-picker.png) |

- **Journal**: stories, then entries grouped by day with time, title, preview, mood, place, weather, tags and a thumbnail; sort by entry date (either way) or by last update. Stories: Today, the coach program's day, throwback, opened time capsules, a morning or evening prompt, quick check-in, random walk, this week and this year in review. Today, the coach day and the throwback play as one chain (statistics, 30-day mood chart, the day's prompt answered in place, the throwback, a closing card), as a card over wide windows.
- **First launch**: choose “Start here” or “Connect to an existing device.” A read-only tutorial introduces writing, media, finding entries, sync and privacy; reopen it from Settings. The existing device authorizes the connection and remains usable while the new device receives the diary.
- **Nearby migration and device authorization**: scan the old device, compare a short code, then transfer the identity and verified diary/media directly. Devices generate their own non-exportable signing keys; approving a new device never copies the old signing key. Network diagnostics explain pending media and show actual official-server usage. The official media plan defaults to 1 GB/month when enabled; self-hosting defaults to no plan quotas and durable media storage, with optional administrator limits.
- **Appearance and handwriting**: independent light/dark palettes, lined/grid/tinted writing paper and original botanical, star and washi decorations. The pen canvas uses Scribble and perfect_freehand, saves drawings as ordinary PNG attachments and supports stylus-only input.
- **Local photo suggestions**: optional, on-device grouping by time and optionally place, with bounded scans and explicit import. Source photos are never deleted or uploaded merely to create suggestions.
- **Random walk**: one random past entry at a time, no repeats until all were shown; all entries, only those with photos, or only good days.
- **Reviews**: the week or the year as story slides: counts, mood (a 7-day row, or the year in pixels), most frequent tags and places, photos, entries per month and a highlight.
- **Quick check-in**: a mood and a line of text, saved as an entry in two taps.
- **Time capsules**: seal an entry until a date; until then it shows locked and stays out of search, throwbacks, random walk, media and the map. It can be opened early.
- **Calendar**: the journal's calendar button unfolds scrolling months in place; tapping a day turns the list to that day. The calendar page (tablets, `ui.navigate`) shows the selected day beside the months.
- **Media**: every attached photo, video and voice note.
- **Atlas**: entries with a location on an OpenStreetMap map, each point a numbered circle; a point with several entries opens them as a list. A pinch does not rotate the map unless clearly turned, and a slightly turned map returns to north.
- **Comments and citations**: in an entry from an earlier day, select text to keep the passage or comment on it, or comment on the whole entry. A comment is an entry of today citing what it answers, written in a few lines or expanded into the full editor; any entry can cite others found by search, and an entry lists the entries answering it. Kept passages are listed together. Editing a past entry asks first (with "don't ask again").
- **Coach**: built-in prompt programs and templates, plus your own templates. A program shows its length, interval and difficulty; once enrolled, each day's or week's question appears in the stories (and as a notification on Android) and the answer is saved as an entry.
- **Entry**: photos, videos and voice notes, date block, metadata, text; star, share as a picture, a ZIP with the original media, plain text or an HTML page, edit, save as template, seal as time capsule, delete; previous/next.
- **Editor**: the diary day on top (the time it was written appears only when that was another day), mood and tags at the right; an optional title (an entry has a title only when one is written); the text; a + tile for photos and videos from the gallery or files, the camera (Android) and voice notes (offering a photo's day and place for the entry); place and weather rows, filled in on their own for a new entry; the weather is the diary day's at that place, looked up or set by hand, and shared by that day's entries there. While writing, a bar above the keyboard offers templates and Markdown formatting with an insert menu (checklist, numbered list, table, divider, code block); it goes away with the keyboard. Going back over changes asks whether to save; the done button saves. Built-in templates include morning pages and an evening review.
- **Time**: an entry keeps the time as it read where it was written, and records that place's UTC offset, so flying to another time zone moves nothing; entries from another zone show it (for example UTC+8). Journey and Day One imports and exports convert with each entry's own zone. Every entry stores both when it was written and the diary day it belongs to; everything counted by day (journal, calendar, streaks, reviews, statistics, reminders, the widget) uses the diary day, which can be changed in the editor at any time without touching the written time. A new entry written before 4:00 counts for the day before (marked with a small moon), between 4:00 and 6:00 the editor asks which day (today until answered), later it counts for that day; both hours are settings and only affect new entries. Entries written later about a past day show when they were written.
- **Language**: follows the system by default; one App Language selector in General settings changes it directly.
- **Mood**: five moods and an explicit clear action directly below the editor's mood button. A choice applies immediately without confirmation.
- **Place**: the current position at once, rename or remove; a picker with a custom name, saved (starred) places, place search, nearby places and recent places.
- **Search**: title and text, plus inline tag, starred and mood filters.
- **Statistics**: streaks, mood over time, "What makes me feel…" (the tags most often seen with a mood) and Year in Pixels.
- **Recently deleted**: deleted entries wait 30 days (configurable) before they are erased; restore or erase them early.
- **Sync** (optional): keeps the diary, its photos, tags and templates the same on every device through your own Google Drive (the app sees only its `AID Diary` folder), a WebDAV server of your choice (Nextcloud, Synology, 坚果云 and others) or the AID sync server in `server/`. Always end-to-end encrypted, with no diary account or password: each device holds the user's key, a new device gets it by pairing with one already set up (show a code on either, type or scan it on the other), and a recovery code, random or your own, restores it when every device is lost. The storage only ever holds ciphertext. Trusted nearby devices exchange data directly. With an AID-compatible WebDAV account and the updated networking service, devices also discover public IPv4/IPv6 paths, try WebRTC/STUN and use a bounded live relay when needed; Google Drive and ordinary WebDAV retain LAN plus storage. Diary text syncs first; verified media chunks resume across paths when their allowance permits. Status distinguishes a synced diary, some media still transferring, and waiting for another device. Live relay requires both devices online; the separate temporary media cache does not, and neither is a backup. Edits sync a few seconds later and while the app is open; when two devices change the same entry the newer wins and the other is kept in Recently deleted. Only entries that failed to sync are marked, with a small crossed-out cloud. Network paths and what has been verified: [docs/SYNC_NETWORK.md](docs/SYNC_NETWORK.md).
- **Devices and sync details**: each device starts with its model or computer name and can be renamed. Pairing starts automatic trusted-device discovery; everyday status stays simple. Open sync details to see named complete/partial copies and when another device last confirmed its contents. Temporary cloud cache is identified separately; network and key details stay inside further options.
- **Export**: JSON (every entry with title, place, weather, tags and attachment names; the JSON import reads it back), Markdown, and Journey and Day One archives that those apps import, besides the full backup.
- **Import**: [One Diary v3 backups](docs/ONE_DIARY_IMPORT.md) with original diary dates, hidden flags and local attachments; Journey backups (both schemas) and Day One JSON exports with photos, tags, stars, place and weather (activities become tags); plus Daybook, Daylio, Diarium, Diaro, My Brain, OneShot and Pixels.
- **Hidden diaries**: a locally authenticated section in Settings → Security, excluded from ordinary lists, search, widgets, exports and CLI content. Hiding is an interface matter: hidden entries sync and stay hidden on every device; full backups keep them like any entry; see [the exact boundaries](docs/ARCHITECTURE.md#hidden-entries).
- **Tags**: a new diary starts with none; tags keep the order you drag them into (long-press in the picker), journal cards name them, and imports order the tags they bring by use.
- **Photos**: kept as they come by default. Optionally new photos are stored as WebP of about 1 MB, and the photos already kept can be compressed once (it cannot be undone).
- **Settings**: general (theme, wallpaper, entry font, size and line spacing, units, 12/24-hour time, the hours that pick a new entry's diary day, add place and weather automatically), data and storage (backup, export, Recently deleted), stories (morning and evening prompts, throwbacks), notifications (Android: reminders with weekdays, on this day, a nudge after a few quiet days, a lasting quick-write notification), security, help (FAQ, privacy) and about.
- **Command line and agents**: every feature is an action that the app's buttons, its command palette (Ctrl+K on Windows; Settings → Command line → All commands) and the `aid` command line all run, so what a script or an AI agent does shows in the app as it happens. Off in release builds until Settings → Command line is turned on; the API listens on this device only, with a new token each start.
- **Android home screen widgets**: today's status, a daily diary photo, streak, daily writing prompt and quick mood. Tapping a prompt or mood opens an editable draft rather than silently saving an entry.

Entries, photos and coordinates stay on the device unless sync is turned on, and then reach the chosen storage and trusted devices, encrypted. Network use, all optional and configured in [assets/config/app_config.json](assets/config/app_config.json):

- OpenStreetMap map tiles, and Nominatim for place names and place search.
- Overpass (OpenStreetMap) for named places near the current position, only when the location picker opens with a position.
- Open-Meteo for weather (forecast for recent days, the archive for older entries); only coordinates and a date are sent.
- Google sign-in and the Drive API, only when syncing with Google Drive ([docs/GOOGLE_DRIVE.md](docs/GOOGLE_DRIVE.md)).
- Trusted-device discovery and encrypted sync transport when sync is enabled: LAN DNS-SD, and for an AID-compatible WebDAV networking service, authenticated signaling, public direct probes, configured STUN and a limited live relay. The app supplies no TURN service.

Android permissions beyond storage and notifications: location (place, asked for when a new entry or the atlas opens) and microphone (voice notes), each requested only when that feature is used.

## Languages

The interface follows system language preferences by default; Settings can
override them. Flutter's official localization pipeline bundles translations
for offline use. All 35 locale variants cover the English message template;
catalog tests check missing/empty messages and dynamic arguments. Translation
coverage does not imply native-speaker review. See [internationalization](docs/ARCHITECTURE.md#internationalization)
for matching rules, translation maintenance and validation.

## Development

Windows is the main development environment (no WSL, no SDK submodule). Start with the [documentation index](docs/INDEX.md) and [maintainer handoff](docs/HANDOFF.md): they route setup, architecture, product decisions, testing and subsystem questions to their owning guides and identify the latest dated checkpoint. [Engineering principles](docs/ENGINEERING.md) explain how we adapt Flutter/Google guidance, review changes and maintain documentation. [Setup](docs/SETUP.md) covers a new computer, local toolchain configuration, signing and test devices.

```powershell
./scripts/dev.ps1 pub          # resolve app and CLI dependencies on a new checkout
./scripts/dev.ps1 l10n         # regenerate localized source after ARB changes
./scripts/dev.ps1 test -TestFiles test/sync/local_device_test.dart # affected files/directories
./scripts/dev.ps1 test-all     # deliberate full offline regression
./scripts/dev.ps1 analyze      # static analysis
./scripts/dev.ps1 screenshots  # regenerate artifacts/ui-*.png headlessly
./scripts/dev.ps1 windows      # run the Windows app
./scripts/dev.ps1 windows-build # build Windows without opening a window
./scripts/dev.ps1 windows-stage # stage that bundle at fixed DEV_WINDOWS_RUNTIME; does not launch
./scripts/dev.ps1 windows-profile-build # isolated Windows performance build
./scripts/dev.ps1 windows-profile-stage # stage the profile bundle at the same fixed path
./scripts/windows_scroll.ps1 -Label current # verified scrollbar traversal and frame timelines
./scripts/windows_scroll.ps1 -Label wheel -WheelOnly # mouse-wheel animation and frame pacing
./scripts/dev.ps1 android      # run on the emulator
./scripts/dev.ps1 apk          # build the debug APK (dev flavor)
./scripts/dev.ps1 profile -Device <serial>     # install the dev app in profile mode
./scripts/dev.ps1 frame-rate -Device <serial>  # frame rate of it with a 4000-entry diary
./scripts/dev.ps1 frame-rate -Device windows   # the same here, hidden, on scratch data
./scripts/dev.ps1 release      # build the signed release APK and install it on connected devices
./scripts/dev.ps1 cli          # build the aid command line to build\cli\aid.exe
```

`aid` talks to the running app, on this computer or over adb (it starts the dev flavor there when needed):

```powershell
aid actions                          # every action and its arguments
aid guide                            # the same as a guide for agents
aid entry.list limit=5
aid -d <adb serial> entry.seed count=4000
aid -d <adb serial> sync.now
aid sync.network                      # routes, selected ICE pair and budgets
aid sync.network_paths paths=ice,cache stunOnly=true  # development builds only
aid entry.delete id=12 --yes         # destructive actions need --yes
```

The Android build runs on JDK 23: the root `android/build.gradle` gives every module's Kotlin the JVM target its Java already uses, since many plugins leave it unset. Flutter's Android SDK path is pinned with `flutter config --android-sdk`.

The project-wide [testing policy](docs/TESTING.md) defines the change-to-test matrix, full-regression/release gates, critical journeys and result reporting for Flutter, Go, CLI and native platforms. Isolated pure logic can use focused unit tests; UI, persistence and native behavior need their owning layers. Full regression runs for broad/high-risk changes, release gates and one active-day closing safety net, with existing results reused for an unchanged tested state. Layer targets (`test-unit`, `test-widget`, `test-integration`) also accept `-TestFiles`; external services require explicit `test-live`. GitHub Actions checks every push to `main` and packages a nightly build ([continuous integration](docs/TESTING.md#continuous-integration)).

Screenshots are rendered by widget tests in `tool/screenshots/` with real fonts (Flutter SDK icons, Windows Noto Sans SC and Segoe Emoji); no window opens. Pass `-TestFiles` to render only the affected screenshot file and inspect the images: these scripts do not automatically compare golden images.

Platforms: Windows, Android and Linux (nightly package; on Linux, video and voice notes do not play yet and hidden diaries need an app password). iOS and macOS will follow; web is not configured.

## License

GPL-3.0-only ([LICENSE.txt](LICENSE.txt)) with the additional terms in [ADDITIONAL_TERMS.md](ADDITIONAL_TERMS.md). Origin and attribution: [SOURCE.md](SOURCE.md).
