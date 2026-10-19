# AID Diary

A private diary app for Windows and Android, built with Flutter.

AID Diary is a modified version of [Daily You](https://github.com/Demizo/Daily_You) by Demizo and contributors (GPL-3.0). It is **not** the official Daily You app. Upstream baseline and license details: [SOURCE.md](SOURCE.md).

## Screens

The layout follows the Journey diary app: a bottom bar on phones, a navigation rail with list and detail panes on tablets and desktop windows. Only layout and features are borrowed; no code, assets or copy.

| Tablet / desktop | Phone |
|---|---|
| ![Journal](artifacts/ui-tablet-journal.png) | ![Journal](artifacts/ui-phone-journal.png) |
| ![Calendar](artifacts/ui-tablet-calendar.png) | ![Entry](artifacts/ui-phone-entry.png) |
| ![Media](artifacts/ui-tablet-media.png) | ![Editor](artifacts/ui-phone-editor.png) |
| ![Coach](artifacts/ui-tablet-coach.png) | |

- **Journal**: stories (today, throwbacks), then entries grouped by day with time, title, preview, mood, place, tags and a thumbnail.
- **Calendar**: scrolling months; wide windows list the selected day beside them.
- **Media**: every attached photo.
- **Atlas**: entries with a location on an OpenStreetMap map.
- **Coach**: built-in prompt programs and your templates.
- **Entry**: photos, date block, metadata, text; star, share, edit, delete; previous/next.
- **Editor**: date in the title, mood / place / tags / photos in the bottom toolbar, Markdown formatting.
- **Search**: text, tags, starred and mood filters.
- The profile button opens statistics, templates and settings (backup, security, appearance, reminders).

Entries, photos and coordinates stay on the device. Map tiles and place names are fetched from OpenStreetMap services; the endpoints live in [assets/config/app_config.json](assets/config/app_config.json).

## Development

Windows is the main development environment. Use the installed Flutter SDK at `D:\software\flutter` (no WSL, no SDK submodule).

```powershell
./scripts/dev.ps1 test         # all tests
./scripts/dev.ps1 analyze      # static analysis
./scripts/dev.ps1 screenshots  # regenerate artifacts/ui-*.png headlessly
./scripts/dev.ps1 windows      # run the Windows app
./scripts/dev.ps1 android      # run on the emulator
```

Screenshots are rendered by widget tests in `tool/screenshots/` with real fonts (Flutter SDK icons, Windows Noto Sans SC and Segoe Emoji); no window opens.

Platforms: Windows and Android. iOS, macOS, Linux and web are not configured.

## License

GPL-3.0-only ([LICENSE.txt](LICENSE.txt)) with the additional terms in [ADDITIONAL_TERMS.md](ADDITIONAL_TERMS.md). Upstream copyright headers are kept in the source files.
