# TODO

Ideas collected from Journey and other diary apps, not built yet. Roughly in order of value.

## Journey parity gaps
From Journey 5.7.0C (Android) and Journey Desktop 6.0.1 (Windows), inventoried 2026-10-20 from their resources and bundles; reference only. Already done: shell, journal, detail, editor, calendar, media, atlas, coach list, search, stories, statistics, settings tree, reminders, widget, backup.

Layout:
- Desktop shell (Journey Desktop, for wide Windows windows): a ~200 px sidebar with search and filters on top, the five destinations, then a Tags list (Starred plus each tag); a draggable list/detail divider (starts 50/50, each side at least 40%, remembered); Settings as a 600 px dialog with vertical tabs; Coach as one full-width pane; a custom title bar, minimum width 900, remembered window size.
- Calendar day view: date header with a horizontal week strip above the day's entries; a month/year picker.
- Search: a strip of matching media above the entries; a media-type filter.
- Entry detail toolbar: open in map, export this entry as ZIP; show the time zone when it differs from the device.
- Today story: a coach-prompt slide with an inline answer box, and a closing wrap-up slide.
- Coach program page: day/week schedule, difficulty, duration and interval, enrol / end, a "Day N" story card, prompt notifications.
- Location dialog: saved (starred) places, nearby places, rename and custom names.
- Share sheet: HTML and a ZIP with the original media besides text and image.
- Onboarding pager: welcome, privacy, notification permission, done.
- Help page: FAQ and privacy.

Features:
- Keyboard: Ctrl+N new entry, Ctrl+S save and close, Ctrl+B/I and heading/list shortcuts in the editor, arrow keys through the list; Windows jump list (new entry, coach, settings).
- Media: drag and drop into the editor; offer the photo's date and place for the entry (EXIF).
- Quick-write notification, inactivity nudges, a photo home-screen widget.
- Distance unit, spell-check languages, clear cache, importing a Journey ZIP, inserting an image from a URL.

Probably skip (Journey has them, but they need cloud or AI or add little): Google Fit, rate dialog, live chat, external-link warning, automatic media categories (an image classifier), an in-app media picker.

## Look and feel
- Letter-paper backgrounds for the editor and reader (lined, grid, tinted paper).
- Sticker and washi-tape decorations, in the style of journaling ("手帐") apps.
- More colour themes and a separate dark-theme choice.

## Features
- Multiple journals, each with a colour and icon, viewed together or apart (Day One, Apple Journal).
- Finer moods: emotion words plus "who with / where" context (How We Feel). This would sharpen "What makes me feel…".
- Goals and habits on top of trackers: target values, streaks, milestones (Daylio, Stoic).
- On-device suggestion cards: "12 photos at the park today" from local photos and places (Day One Moments, Apple Journal). Offline only, no AI.
- Question grid entries, with a view of every answer to one question over time (Grid Diary / 格志).
- Nearby places in the location dialog (needs a places search near the position).
- Read entries aloud with text-to-speech (一本日记).
- Voice note transcription: needs on-device speech recognition; decide whether that fits "no AI".
- Handwriting and drawing on tablets.
- More home-screen widget kinds: streak, prompt of the day, quick mood.

## Decided against for now
- App lock timeout: phones' own app-lock features cover it.
- PDF/DOCX export and printing: JSON export (and Markdown) is enough.
- AI assistant, cloud sync, membership, publishing, web links.
