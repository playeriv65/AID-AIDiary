# AID Diary

- Talk to the user in Chinese. Code comments and docs are in English. Python uses uv.
- GPL-3.0 modification of Daily You: keep upstream copyright headers, LICENSE.txt and ADDITIONAL_TERMS.md, and keep the app clearly distinct from the official one (own name, own IDs, attribution in About and the welcome entry).
- Main branch is `main`. Larger tasks use a `task/<name>` branch in its own git worktree, merged back and removed when done. No remote is configured; do not publish or release unless asked.
- Develop natively on Windows: Flutter SDK `D:/software/flutter`, `PUB_CACHE=D:/software/pub-cache`, scripts via `scripts/dev.ps1`. Targets are Windows and Android only.
- UI reference is the Journey app (layout and features). Never copy its code, assets, illustrations or text; write prompts and copy ourselves.
- Data stays on the device. The only network use is OpenStreetMap map tiles, Nominatim (place names and place search) and Open-Meteo weather; endpoints and settings live in `assets/config/app_config.json`, not in code. No AI, mem0 or cloud sync for now.
- `EntryStore.delete` moves an entry to Recently deleted; only `erase` removes it. Anything new that lists entries must skip sealed time capsules (`Entry.isSealed`) unless it shows them locked.
- In widget tests, change settings with `DiaryAppHarness.setSetting` (a real-time config write can lock the temp folder) and wait on SQLite work started by a widget with `DiaryAppHarness.pumpUntil`.
- Feature ideas not built yet live in `TODO.md`.
- Videos and voice notes are attachments in the `entry_images` table and image folder, told apart by file extension (`MediaKind`), so backup and sync cover them unchanged.
- Build the APK with `./scripts/dev.ps1 apk` (flavors need `--flavor dev`). Test the home screen widget on the headless emulator; `am force-stop` cancels the widget's taps until it next updates, so use `am kill` for cold-start checks.
- Do not import data or keys from the old project, and do not delete the parent folder's `.private-legacy`.
- Verify UI without opening windows: widget tests, `./scripts/dev.ps1 screenshots`, and the Android emulator started with `-no-window`. Only launch the Windows app when the user wants to look at it.
- Day to day, develop and verify on Windows. Use the Android device (the user's Xiaomi Pad 7 over wireless adb, or the headless emulator) for plugin and native features, OEM behaviour, touch and IME, and profile-mode performance. Simulate a phone there with `wm size 1080x2400` and `wm density 420`, rotate with `cmd window user-rotation lock 0|1`, and restore all of them afterwards.
- The Dart and Flutter MCP server (Claude Code plugin `dart-flutter@dart-flutter`) is available. Prefer `analyze_files` and `lsp` for diagnostics and symbols, and `read_package_uris` / `rip_grep_packages` for dependency source. For device work, start `flutter run -d <device> --flavor dev` in the background; after editing `lib/**/*.dart` (not comments only), find the app with `dtd`, then `hot_reload`, or `hot_restart` when `initState`, `main` or static state changed. Check `get_runtime_errors` and use `widget_inspector` for layout questions. Screenshots stay with `adb exec-out screencap`.
- Before committing: `dart format`, `flutter analyze` clean, all tests passing, screenshots regenerated when the UI changed, README/SOURCE/AGENTS current.
