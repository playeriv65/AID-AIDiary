# Maintainer handoff

Checkpoint: 2026-11-06, application baseline `bf9d297`. Fetch and inspect
the current checkout before using this snapshot.

## Start here

1. Read [AGENTS](../AGENTS.md) and the [documentation index](INDEX.md).
2. Use [Setup](SETUP.md) to configure a checkout and [Testing](TESTING.md)
   to choose checks. Use scratch data and the development app for device
   validation.
3. Check [Decisions](DECISIONS.md) for settled behavior and
   [TODO](../TODO.md) for pending work.

## Changes since the October checkpoint

- Android can install signed nightly updates. Releases use one rolling
  prerelease and an hourly server mirror. See [Updates](UPDATES.md) for
  localized notes, artifact verification and HyperOS confirmation.
- The CLI provides `sql.query`, `sql.execute` and `actions.batch`. Entry
  timestamp arguments require an explicit UTC offset. See
  [shared actions](ARCHITECTURE.md#agent-native-actions-shared-by-the-gui-and-the-cli).
- Desktop Google Drive configuration takes its client secret from build
  configuration. See [Google Drive](GOOGLE_DRIVE.md).
- The MapLibre atlas trial is on the local `task/maplibre-map` branch
  (`57cb796`). At this checkpoint it is one commit ahead of its base,
  which is ten commits behind main. The owner has yet to choose it, and
  Windows validation is pending.

## Find the code and its checks

| Area | Start with | Verification |
|---|---|---|
| Flutter screens, actions and persistence | [Architecture](ARCHITECTURE.md), then `lib/pages/`, `lib/actions/` and `lib/database/` | `test/architecture/`, affected widget and persistence tests |
| Android, Windows and Linux | `android/app/`, `packages/`, `windows/runner/`, `linux/runner/` | [Native acceptance](TESTING.md#critical-journeys-and-release-evidence) |
| CLI and in-app agent | `cli/`, `lib/agent/`, `rust/`, `rust_builder/` | `cli/test/`, `test/actions/` and `test/agent/` |
| Sync and deployment | [Sync networking](SYNC_NETWORK.md), `lib/sync/`, [Go service](../server/README.md) | `test/sync/`, Go tests and isolated endpoint/device checks |
| Packaging and automation | [Updates](UPDATES.md), `.github/workflows/`, `scripts/` | [CI](TESTING.md#continuous-integration) and release artifact checks |
| Configuration and localized UI | [Setup](SETUP.md), `assets/config/`, [internationalization](ARCHITECTURE.md#internationalization) | `test/config/`, `test/l10n/` and affected renders in `tool/screenshots/` |

## Verification and next work

- GitHub [CI](https://github.com/playeriv65/AID-AIDiary/actions/runs/42252783750)
  and [Nightly](https://github.com/playeriv65/AID-AIDiary/actions/runs/42254176022)
  passed on `bf9d297`. Nightly took about 13 minutes from its first job to
  release completion. GitHub and the official mirror both served build
  `261106163` for that revision when checked.
- See [maintenance priorities](../TODO.md#maintenance-priorities) for
  release consistency, native acceptance and maintainability work.
  [Sync networking](SYNC_NETWORK.md#verification-status) and
  [Refresh rate](REFRESH_RATE.md) own the deferred cross-network and
  performance evidence.
- The owner's personal data operations, backups and per-device state
  belong in the private handoff outside git. Use the repository's
  [data and device rules](../AGENTS.md#native-environment-and-user-data)
  when operating the app.
