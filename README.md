# AID Diary

A private diary app for Windows and Android, built with Flutter.

AID Diary is a modified version of [Daily You](https://github.com/Demizo/Daily_You) by Demizo and contributors (GPL-3.0). It is **not** the official Daily You app. Upstream baseline and license details: [SOURCE.md](SOURCE.md).

## Screens

The layout follows the Journey diary app: a bottom bar on phones, a navigation rail with list and detail panes on tablets and desktop windows. Only layout and features are borrowed; no code, assets or copy.

| Tablet / desktop | Phone |
|---|---|
| ![Journal](artifacts/ui-tablet-journal.png) | ![Journal](artifacts/ui-phone-journal.png) ![Entry](artifacts/ui-phone-entry.png) |
| ![Calendar](artifacts/ui-tablet-calendar.png) | ![Calendar](artifacts/ui-phone-calendar.png) ![Media](artifacts/ui-phone-media.png) |
| ![Media](artifacts/ui-tablet-media.png) | ![Coach](artifacts/ui-phone-coach.png) ![Search](artifacts/ui-phone-search.png) |
| ![Coach](artifacts/ui-tablet-coach.png) | ![Editor](artifacts/ui-phone-editor.png) ![Share](artifacts/ui-phone-share.png) |
| ![Coach program](artifacts/ui-tablet-coach-program.png) | ![Location](artifacts/ui-phone-location-picker.png) ![Share as](artifacts/ui-phone-share-as.png) |
| ![Coach story](artifacts/ui-tablet-story-prompt.png) | |
| | ![Random walk](artifacts/ui-phone-random.png) ![Week review](artifacts/ui-phone-week-review.png) |

- **Journal**: stories, then entries grouped by day with time, title, preview, mood, place, weather, activity, tags and a thumbnail; sort by entry date (either way) or by last update. Stories: Today, the coach program's day, throwback, opened time capsules, a morning or evening prompt, quick check-in, random walk, this week and this year in review. Today, the coach day and the throwback play as one chain (statistics, 30-day mood chart, the day's prompt answered in place, the throwback, a closing card), as a card over wide windows.
- **First launch**: welcome pages (what the diary does, privacy with a passcode, reminders).
- **Random walk**: one random past entry at a time, no repeats until all were shown; all entries, only those with photos, or only good days.
- **Reviews**: the week or the year as story slides: counts, mood (a 7-day row, or the year in pixels), most frequent tags, activities and places, photos, entries per month and a highlight.
- **Quick check-in**: a mood and a line of text, saved as an entry in two taps.
- **Time capsules**: seal an entry until a date; until then it shows locked and stays out of search, throwbacks, random walk, media and the map. It can be opened early.
- **Calendar**: scrolling months; wide windows list the selected day beside them.
- **Media**: every attached photo, video and voice note.
- **Atlas**: entries with a location on an OpenStreetMap map; nearby markers merge into numbered clusters that zoom in when tapped.
- **Coach**: built-in prompt programs and templates, plus your own templates. A program shows its length, interval and difficulty; once enrolled, each day's or week's question appears in the stories (and as a notification on Android) and the answer is saved as an entry.
- **Entry**: photos, videos and voice notes, date block, metadata, text; star, share as a picture, a ZIP with the original media, plain text or an HTML page, edit, duplicate, save as template, seal as time capsule, delete; previous/next.
- **Editor**: date and time on top with the mood beside it and tags at the right; an optional title (an entry has a title only when one is written); the text; a + tile for photos and videos from the gallery or, on Android, the camera (offering a photo's time and place for the entry); place and weather rows, filled in on their own for a new entry. The keyboard toolbar keeps templates, photos and voice notes plus Markdown formatting with an insert menu (checklist, numbered list, table, divider, code block). Going back over changes asks whether to save; the done button saves. Built-in templates include morning pages and an evening review.
- **Time**: an entry keeps the time as it read where it was written, and records that place's UTC offset, so flying to another time zone moves nothing; entries from another zone show it (for example UTC+8). Journey and Day One imports and exports convert with each entry's own zone. Entries written before 4:00 count for the day before (a setting, on by default), marked with a small moon.
- **Place**: the current position at once, rename or remove; a picker with a custom name, saved (starred) places, place search, nearby places and recent places.
- **Search**: text plus inline tag, starred and mood filters (and activity, for imported entries that have one).
- **Statistics**: streaks, mood over time, "What makes me feel…" (the activities and tags most often seen with a mood) and Year in Pixels.
- **Recently deleted**: deleted entries wait 30 days (configurable) before they are erased; restore or erase them early.
- **Export**: JSON (every entry with place, weather, activity, tags and attachment names; the JSON import reads it back), Markdown, and Journey and Day One archives that those apps import, besides the full backup.
- **Import**: Journey backups (both schemas) and Day One JSON exports with photos, tags, stars, place and weather, plus Daybook, Daylio, Diarium, Diaro, My Brain, OneShot and Pixels.
- **Settings**: general (theme, wallpaper, entry font, size and line spacing, units, 12/24-hour time, late nights count as the day before, add place and weather automatically), data and storage (backup, export, Recently deleted), stories (morning and evening prompts, throwbacks), notifications (Android: reminders with weekdays, on this day, a nudge after a few quiet days, a lasting quick-write notification), security, help (FAQ, privacy) and about.
- **Android home screen widgets**: today's status (date, whether today has an entry, the latest entry's first line, the streak and a Write button), and a photo from the diary, a different one each day, that opens its entry.

Entries, photos and coordinates stay on the device. Network use, all optional and configured in [assets/config/app_config.json](assets/config/app_config.json):

- OpenStreetMap map tiles, and Nominatim for place names and place search.
- Overpass (OpenStreetMap) for named places near the current position, only when the location picker opens with a position.
- Open-Meteo for weather (forecast for recent days, the archive for older entries); only coordinates and a date are sent.

Android permissions beyond storage and notifications: location (place, asked for when a new entry or the atlas opens) and microphone (voice notes), each requested only when that feature is used.

## Development

Windows is the main development environment. Use the installed Flutter SDK at `D:\software\flutter` (no WSL, no SDK submodule).

```powershell
./scripts/dev.ps1 test         # all tests
./scripts/dev.ps1 analyze      # static analysis
./scripts/dev.ps1 screenshots  # regenerate artifacts/ui-*.png headlessly
./scripts/dev.ps1 windows      # run the Windows app
./scripts/dev.ps1 android      # run on the emulator
./scripts/dev.ps1 apk          # build the debug APK (dev flavor)
./scripts/dev.ps1 release      # build the signed release APK and install it on connected devices
```

The Android build runs on the installed JDK 23: the root `android/build.gradle` gives every module's Kotlin the JVM target its Java already uses, since many plugins leave it unset. Flutter's Android SDK path is pinned with `flutter config --android-sdk D:\software\android-sdk`.

Screenshots are rendered by widget tests in `tool/screenshots/` with real fonts (Flutter SDK icons, Windows Noto Sans SC and Segoe Emoji); no window opens.

Platforms: Windows and Android. iOS, macOS, Linux and web are not configured.

## License

GPL-3.0-only ([LICENSE.txt](LICENSE.txt)) with the additional terms in [ADDITIONAL_TERMS.md](ADDITIONAL_TERMS.md). Upstream copyright headers are kept in the source files.
