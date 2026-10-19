# AID Diary

- Talk to the user in Chinese. Code comments and docs are in English. Python uses uv.
- GPL-3.0 modification of Daily You: keep upstream copyright headers, LICENSE.txt and ADDITIONAL_TERMS.md, and keep the app clearly distinct from the official one (own name, own IDs, attribution in About and the welcome entry).
- Main branch is `main`. Larger tasks use a `task/<name>` branch in its own git worktree, merged back and removed when done. No remote is configured; do not publish or release unless asked.
- Develop natively on Windows: Flutter SDK `D:/software/flutter`, `PUB_CACHE=D:/software/pub-cache`, scripts via `scripts/dev.ps1`. Targets are Windows and Android only.
- UI reference is the Journey app (layout and features). Never copy its code, assets, illustrations or text; write prompts and copy ourselves.
- Data stays on the device. The only network use is OpenStreetMap map tiles and reverse geocoding; endpoints and settings live in `assets/config/app_config.json`, not in code. No AI, mem0 or cloud sync for now.
- Do not import data or keys from the old project, and do not delete the parent folder's `.private-legacy`.
- Verify UI without opening windows: widget tests, `./scripts/dev.ps1 screenshots`, and the Android emulator started with `-no-window`. Only launch the Windows app when the user wants to look at it.
- Before committing: `dart format`, `flutter analyze` clean, all tests passing, screenshots regenerated when the UI changed, README/SOURCE/AGENTS current.
