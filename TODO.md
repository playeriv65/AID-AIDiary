# TODO

Ideas collected from Journey and other diary apps, not built yet. Roughly in order of value.

## Journey parity
The reference is Journey 5.7.0C for Android tablets and phones; Windows uses the same tablet layout. Inventoried 2026-10-20 from its resources and screens, reference only. Done: shell, journal, detail, editor, calendar, media, atlas, coach with program enrolment, search, the story chain (coach prompt, wrap-up), statistics, settings tree, onboarding, help, reminders, quick-write notification, nudges, status and photo widgets, location sheet and picker, share sheet, EXIF date and place, backup.

Left from Journey Android:
- Insert an image from a URL (needs the network; decide whether it fits a local diary).

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
- Read entries aloud with text-to-speech (一本日记).
- Voice note transcription: needs on-device speech recognition; decide whether that fits "no AI".
- Handwriting and drawing on tablets.
- More home-screen widget kinds: streak, prompt of the day, quick mood.

## Sync, identity and encryption (plan of 2026-10-21)
Local-first, end-to-end encrypted, device-first, with replaceable cloud storage. No sign-up, login or password: open the app and write. Devices hold the identity and the keys; the cloud only stores and syncs ciphertext.

- Identity: a random `User ID` made on first use, shared by all of one user's devices. No email, password or Google account. Google OAuth only reaches Google Drive and plays no part in who the user is.
- Encryption: a random 256-bit master key `MK` on the device protects the data keys (`DEK`); entries are sealed with AES-256-GCM or XChaCha20-Poly1305. Each device keeps MK in Android Keystore / iOS Keychain. Servers hold ciphertext only and cannot decrypt.
- New device: it makes a temporary key pair and shows a QR code; an existing device scans it, approves, and sends `User ID + MK` over a channel encrypted to that public key. The new device stores MK itself and joins the trusted-device list. No hardware-bound key is ever moved.
- Server authentication: each device has its own long-term P-256 ECDSA key pair, private key kept non-exportable where the platform allows. The device signs a server challenge, the server checks the device's public key and issues a short Access Token (e.g. 15 minutes); on expiry the app signs again in the background. No refresh tokens, passkeys, SRP or login screen. Approving a new device approves its authentication key and hands over MK in one step.
- Storage backends, all receiving only E2EE ciphertext, with sync, versions and conflicts handled by the client:

  | Storage | Authentication |
  | --- | --- |
  | Own Go server | Device signature + Access Token |
  | Google Drive | Google OAuth |
  | WebDAV / S3 | Their own |
  | Local only | None |

- Recovery and security:
  - Usual phone change: the old device approves the new one by QR code.
  - A lost device: any other trusted device can approve a new one.
  - All devices lost: needs a recovery credential saved beforehand, restoring both MK and control of the anonymous account. Random recovery code or user-chosen recovery password: still to decide.
  - Revoking a device removes its server access; an MK it already holds cannot be taken back by revoking tokens.
  - Generic phone-cloning tools cannot carry hardware-bound keys, so they are not a migration path.
- Principle: the user owns identity and keys, devices trust each other, servers only provide replaceable sync and storage.
- Still to design: disaster recovery, sync conflicts, key rotation. Also to reconcile with what exists today (the sync passphrase, Google Drive sync, the self-hosted server).

## Decided against for now
- App lock timeout: phones' own app-lock features cover it.
- PDF/DOCX export and printing: JSON export (and Markdown) is enough.
- AI assistant, membership, publishing, web links.
- Journey Desktop's own layout and desktop-only extras (sidebar with tags, draggable split, settings dialog, custom title bar, calendar week strip, media strip in search, keyboard shortcuts, jump list): Windows reuses the Android tablet layout (decided 2026-10-20).
