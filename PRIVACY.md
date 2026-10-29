# Privacy Policy

Last updated: October 29, 2026

AID Diary stores entries, photos, videos, voice notes, locations and settings on
the device, and in backups or folders you choose. It has no analytics, and it
talks to an AI model only if you configure one for the in-app agent.

Some optional features contact third-party services directly from the device:

- **Maps and places**: map tiles from OpenStreetMap; place names and place search from OpenStreetMap Nominatim, which receive coordinates or the text you search for.
- **Weather**: Open-Meteo, which receives coordinates and a date.
- **Updates** (Android, on by default, About > Check for updates automatically):
  the app asks the AID Diary server, then GitHub, for the release manifest and
  downloads a newer package from there. They see the request and its address;
  nothing from the diary is sent.
- **Feedback**: what you type on the feedback page and choose to send goes to
  the AID Diary server, with the app's version, platform and language; nothing
  from the diary. GitHub and email open your browser or mail app instead.
- **AI agent**: the model you configure receives your questions and what the
  agent reads from the diary to answer them.
- **Optional sync**: the storage provider or AID server you choose receives
  encrypted diary data. The AID service also sees account/device identifiers,
  device public keys, connection addresses and traffic counts needed for
  authentication, routing and limits. Diary content and the master key are
  encrypted before leaving a trusted device.
- **Nearby transfer**: after scanning an invitation and confirming matching
  codes, trusted devices exchange encrypted diary content and master-key
  material over the local connection. Each new device creates its own signing
  key; another device's private signing key is never copied.

Nothing is sent to these services unless you use the feature, enable sync,
turn on automatic place or weather for new entries, or leave update checks on. Their own privacy policies
apply to those requests.

Local photo suggestions inspect bounded recent photo metadata only after photo
access is granted, or in a Windows folder explicitly selected by the user.
Photo coordinates are optional and disabled initially. Grouping happens locally,
without uploading photos or querying a place-name service. Choosing a suggestion
copies its photos into the diary; originals are not changed or deleted.

Location, photo access, camera and microphone permissions
are requested only when you use the feature that needs them.
