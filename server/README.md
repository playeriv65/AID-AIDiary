# AID Diary sync server

A small Go server that gives each user a private WebDAV folder, the store
the app's sync uses. The app encrypts everything it stores end to end, so
the server only ever holds ciphertext. It authenticates users, keeps them
apart, enforces storage quotas and upload limits, and blocks repeated failed
sign-ins. Accounts live in SQLite (`accounts.db`), files under
`users/<id>/` in the data folder.

## Running

```sh
go test ./...
go run ./cmd/aid-sync serve
```

Users are added by the operator; there is no sign-up. Passwords are read
from standard input so they stay out of shell history:

```sh
aid-sync adduser NAME [QUOTA_MB]
aid-sync passwd NAME
aid-sync quota NAME QUOTA_MB
aid-sync deluser NAME        # also removes the user's files
aid-sync users
```

In the app, choose WebDAV and enter `https://<host>/dav/` with the user's
name and password.

## Settings

| Variable | Default | Meaning |
| --- | --- | --- |
| `AID_SYNC_DATA` | `data` | Folder for `accounts.db` and users' files |
| `AID_SYNC_ADDR` | `:8080` | Listen address |
| `AID_SYNC_DEFAULT_QUOTA_MB` | `2048` | Quota for `adduser` without one; 0 is unlimited |
| `AID_SYNC_MAX_UPLOAD_MB` | `256` | Largest single file |
| `AID_SYNC_MIN_PASSWORD` | `12` | Shortest password `adduser` and `passwd` accept |
| `AID_SYNC_FAIL_LIMIT` | `10` | Failed sign-ins from one address or for one name before blocking |
| `AID_SYNC_FAIL_WINDOW` | `15m` | How long failures count and a block lasts |
| `AID_SYNC_CREDENTIAL_TTL` | `5m` | How long a checked password is trusted before checking again |
| `AID_SYNC_TRUST_PROXY` | `false` | Take the client address from `X-Real-IP` (behind a reverse proxy) |

Passwords are stored as Argon2id hashes (OWASP's minimum cost: 19 MiB,
two passes); checks are cached in memory for `AID_SYNC_CREDENTIAL_TTL`, so
a changed password takes effect within that time.

## Deploying

The image is static (`Dockerfile`); mount a volume at `/data`, put it behind
a TLS-terminating reverse proxy that sets `X-Real-IP`, and set
`AID_SYNC_TRUST_PROXY=true`. Allow request bodies up to the upload limit and
turn off request buffering for `/dav/`.

## Testing against the app

`go test ./...` covers the server. The app's live sync tests run against a
running server:

```sh
AID_SYNC_URL=http://127.0.0.1:8080/dav/ AID_SYNC_USER=NAME AID_SYNC_PASSWORD=... \
  flutter test --tags live
```
