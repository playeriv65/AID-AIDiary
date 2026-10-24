# Maintainer handoff

Checkpoint: 2026-10-23. Intended reader: the next developer continuing this
repository. This is a dated entry point, not a replacement for the owning
guides. The application-code baseline is `f13a146`; fetch and inspect the
current checkout before relying on this snapshot.

## Start here

1. Read [AGENTS](../AGENTS.md), then the [documentation index](INDEX.md).
2. Read [Decisions](DECISIONS.md) for approved scope and
   [Architecture](ARCHITECTURE.md) for code/data owners. Do not treat every
   reference-app feature or TODO as approved work.
3. Follow [Setup](SETUP.md) for the native Windows toolchain, ignored
   `scripts/dev.env`, signing, device access and external assets. Run `pub` in
   a new checkout before analysis/tests. Do not copy another machine's paths.
4. Select checks using [Testing](TESTING.md). Use the checkout lock and four
   test workers; do not run the entire suite after every small edit.
5. Operate through `aid guide` and shared CLI actions. Use Flutter/driver
   diagnostics and the screenshot harness for UI checks. **Computer Use is
   prohibited for debugging and verification.** A visible preview for the
   owner does not change that rule.

## Latest delivered work

The behavior at `f13a146` includes:

- Windows uses its native title bar with the app icon and AID Diary name.
  Caption, text and border colors follow the app palette. The final decision
  keeps search and entry actions out of that title bar; the earlier custom
  caption preview was discarded. See [Windows setup](SETUP.md#windows-personal-installation).
- Journal/media search bars remain pinned; calendar/search already keep their
  controls outside scrolling content. Long journal browsing reveals a
  back-to-top button in the search bar's free center after two viewports.
- Duplicate-entry UI and the shared operation were removed. Save as template
  remains. Do not restore the deleted feature's tests or compatibility guards.
- Settings > Help opens feedback: editable text, prefilled GitHub issue/email
  drafts and copying. Submission remains in the user's browser/mail app; no
  diary text or logs are collected automatically. Destinations are in
  `assets/config/app_config.json`. The repository is public, so anyone can
  open an issue.
- All offered locales include the new interface strings.

The [One Diary guide](ONE_DIARY_IMPORT.md#maintainer-map) identifies the v3
backup decoder, reverse-engineering evidence, shared import path and tests.
The application can read that backup without the source app or a user password.
Compatibility parameters are fixed format constants, not private user keys.

## Evidence and remaining verification

The dated verification details are in [Setup](SETUP.md#windows-personal-installation).
The full offline Flutter run passed 976 cases before the final back-to-top
placement refinement. That refinement then passed 12 focused cases, fresh
phone/tablet renders, analysis and a Windows profile build. Two screenshot
cases produced four reviewed images; these counts are not additional full-suite
cases. Detailed local logs are under ignored
`build/verification/windows-polish-20261023/`; they are not shipped in git.
This handoff update is documentation-only and does not claim a fresh app test run.

The final native title bar's appearance and window interactions still need
owner inspection or native diagnostics. Flutter screenshots contain only the
client area. The Windows preview used an existing isolated scratch store;
its executable may be running or closed by the owner, so inspect current
CLI/process state instead of relying on a saved PID. No personal release
installation was updated by this UI work.

Other open work remains in [TODO](../TODO.md), with these important boundaries:

- Cross-WAN validation and the broader Android performance pass are deferred.
  Same-Wi-Fi IPv6/STUN success is not cross-WAN evidence. See
  [Sync networking](SYNC_NETWORK.md).
- Extreme Windows scrollbar traversal still misses its acceptance target.
  Ordinary wheel smoothing results do not establish universal full-rate
  scrolling. See [Refresh-rate evidence](REFRESH_RATE.md).
- Hidden entries sync like any other and stay hidden; see
  [hidden entries](ARCHITECTURE.md#hidden-entries).
- One Diary versions other than v3, nonempty source templates and uncertain
  source timezones remain explicit limitations in its import guide.

## Data and delivery boundaries

The owner uses Android `dev.aid.diary` for real entries. Never use it, the
personal Windows installation or a live sync space as a fixture. Keep scratch
stores separate. Source diaries, personal conversion reports, signing material
and credentials remain outside git; Setup owns their locations. Do not attach
scanned diary pages as media unless requested, or delete retained source files.

Fetch before work, preserve local changes, use an isolated worktree for
substantial code tasks, then commit meaningful changes, merge to main, push,
verify the remote revision and remove the completed task branch/worktree.
Existing server-deployment authorization does not authorize personal-data
resets or a store release. Do not broaden this handoff into new product work.
