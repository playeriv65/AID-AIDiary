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
| `AID_SYNC_MEDIA_MAX_OBJECT_BYTES` | `2097152` | Largest ciphertext media chunk (2 MiB) |
| `AID_SYNC_MEDIA_MAX_MANIFEST_BYTES` | `262144` | Largest encrypted manifest (256 KiB, also subject to object limit) |
| `AID_SYNC_MEDIA_CACHE_BYTES` | `134217728` | Per-user storage for media chunks and manifests (128 MiB) |
| `AID_SYNC_MEDIA_DAILY_TRANSFER_BYTES` | `268435456` | Per-user UTC-day media uploads plus downloads (256 MiB) |
| `AID_SYNC_MEDIA_CACHE_TTL` | `168h` | Chunk retention from its last successful upload (7 days) |
| `AID_SYNC_MIN_PASSWORD` | `12` | Shortest password `adduser` and `passwd` accept |
| `AID_SYNC_FAIL_LIMIT` | `10` | Failed sign-ins from one address or for one name before blocking |
| `AID_SYNC_FAIL_WINDOW` | `15m` | How long failures count and a block lasts |
| `AID_SYNC_CREDENTIAL_TTL` | `5m` | How long a checked password is trusted before checking again |
| `AID_SYNC_TRUST_PROXY` | `false` | Take the client address from `X-Real-IP` (behind a reverse proxy) |

Passwords are stored as Argon2id hashes (OWASP's minimum cost: 19 MiB,
two passes); checks are cached in memory for `AID_SYNC_CREDENTIAL_TTL`, so
a changed password takes effect within that time.

## Bounded asynchronous media cache

Authenticated `GET /api/sync/policy` returns:

```json
{"media":{"maxObjectBytes":2097152,"maxManifestBytes":262144,"transferRemainingBytes":268435456,"cacheTtlSeconds":604800,"cacheBytes":134217728}}
```

The values describe server limits, not a guarantee that media is present or a
durable backup. Clients retain their own persistent copies. Media cache objects
live at `<space>/media/chunks/<photoId>/<ciphertext-sha256>`; uploads must have a
`Content-Length` and match their lowercase SHA-256 name. Small encrypted manifests
live at `<space>/media/manifests/<photoId>` and are capped at 256 KiB (also subject
to the object limit). The existing account quota still applies to all files.
Media settings must be positive: zero never means unlimited media.

The media storage limit includes manifests and chunks. Expired chunks are removed
before the next authenticated WebDAV request; manifests, pairing records, packs
and snapshots are retained. Old `blobs/` objects receive the same media limits
and expiry policy. A full cache rejects another upload rather than evicting
metadata. `413` means the object is too large, `507` means storage is full,
`422` means the chunk hash is wrong, and `429` with `Retry-After` means today's
transfer allowance is exhausted. Clients should defer media and keep syncing
small metadata; metadata never consumes the media transfer allowance.

The SQLite ledger reserves each transfer before bytes move, settles to bytes
actually read from the upload or written to the response, and survives restarts.
Concurrent reservations cannot overspend. An interrupted process can leave an
unused reservation charged until the next UTC day; this conservative accounting
keeps server costs bounded. Uploads and downloads both count, including a fully
received upload whose hash is rejected. HEAD and conditional 304 responses do not
count. Downloads support a single HTTP byte range; multiple ranges are rejected.
COPY and MOVE are disabled for every path, including parent directories, so they
cannot bypass media policy. Run a single server process per data directory;
filesystem storage accounting is serialized inside that process.

## Deploying

The image is static (`Dockerfile`); mount a volume at `/data`, put it behind
a TLS-terminating reverse proxy that sets `X-Real-IP`, and set
`AID_SYNC_TRUST_PROXY=true`. Allow request bodies up to the upload limit and
turn off request buffering for `/dav/`.
`deploy/compose.yaml` exposes finite media limits through environment variables;
`deploy/media.env.example` shows optional operator overrides. Keep the SQLite
database on the persistent data volume, alongside the files, to retain usage.

## Testing against the app

`go test ./...` covers the server. The app's live sync tests run against a
running server:

```sh
AID_SYNC_URL=http://127.0.0.1:8080/dav/ AID_SYNC_USER=NAME AID_SYNC_PASSWORD=... \
  flutter test --tags live
```
