# Google Drive sync

Users sync to their own Google Drive and sign in with their own Google
account. For Google to show "AID Diary wants to access your Drive" and hand
out tokens, the app itself has to be registered once, in a Google Cloud
project owned by the developer. That registration is what the IDs in
`assets/config/app_config.json` (`sync.googleDrive`) come from.

## What the app asks for

Only `drive.file`: the app sees the files it made itself, in an `AID Diary`
folder in the user's Drive, and nothing else. It is a non-sensitive scope, so
Google does not review the app for it. `openid` and `email` show which
account is connected.

## How it signs in

- **Android**: Google Play services (`google_sign_in`). It needs the web
  client's ID as the "server client ID", and an Android client registered
  for the package name and the signing key's SHA-1. Builds without Play
  services cannot use Google Drive.
- **Windows**: the browser. The app listens on a loopback port, opens
  Google's sign-in page with PKCE, and keeps the refresh token it gets in
  secure storage (`syncSecrets`). The desktop client's "secret" is not
  secret for an installed app; Google still asks for it.

## The registration (project `aid-diary`, owner playeriv65@gmail.com)

1. Google Cloud console, new project `AID Diary` (`aid-diary`).
2. APIs & Services, Library: enable **Google Drive API**.
3. Google Auth Platform:
   - Branding: app name `AID Diary`, support and contact email.
   - Audience: External. While the app is in **Testing**, only listed test
     users can sign in and desktop refresh tokens expire after 7 days.
     Publishing it needs a home page and a privacy policy link on the
     Branding page; with only non-sensitive scopes no verification follows.
   - Data access: `drive.file`, `openid`, `userinfo.email`.
4. Clients:
   - Web application `AID Diary Android sign-in` → `webClientId`.
   - Android `AID Diary`, package `dev.aid.diary`, and `AID Diary Android
     Beta`, package `dev.aid.diary.beta` (the dev flavor), both with the
     release key's SHA-1 (`keytool -list -v -keystore <storeFile> -alias
     <keyAlias>`): every local build is signed with that key. The client for
     the dev flavor's former package `dev.aid.diary.dev` is no longer used
     (`docs/REFRESH_RATE.md`).
   - Desktop app `AID Diary Windows` → `desktopClientId` and
     `desktopClientSecret`.

A new signing key or package name needs another Android client.

## Testing

`test/sync/google_drive_backend_test.dart` runs the backend against a fake
Drive; `test/sync/google_auth_test.dart` runs the browser sign-in against a
fake token endpoint. `test/sync/live_google_drive_test.dart` syncs two
devices through the real Drive: set `AID_GOOGLE_LIVE` to a file path, run
`flutter test --tags live test/sync/live_google_drive_test.dart`, and open
the address written to that file in a browser on the same machine.
