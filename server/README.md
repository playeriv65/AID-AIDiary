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
name and password for the first device. The updated client recognizes this
server's device-authentication capability and registers its own native signing
key. Later devices are approved by an authorized device, normally through the
same nearby QR/SAS migration channel. No password or private signing key is
copied to the new device.

## Settings

| Variable | Default | Meaning |
| --- | --- | --- |
| `AID_SYNC_DATA` | `data` | Folder for `accounts.db` and users' files |
| `AID_SYNC_ADDR` | `:8080` | Listen address |
| `AID_SYNC_DEFAULT_QUOTA_MB` | `0` personal / `2048` operator | Disk quota for `adduser` without one; 0 is unlimited; explicit administrator overrides apply in either mode |
| `AID_SYNC_MAX_UPLOAD_MB` | `256` | Largest single file |
| `AID_SYNC_OPERATOR_LIMITS` | `false` | Opt into temporary media cache retention and daily/monthly traffic allowances; official hosting must explicitly set `true` |
| `AID_SYNC_MONTHLY_MEDIA_BYTES` | `1000000000` | Shared per-account UTC calendar-month allowance for media-cache uploads/downloads and live relay (1 GB, decimal); must be positive |
| `AID_SYNC_MEDIA_MAX_OBJECT_BYTES` | `2097152` | Largest ciphertext media chunk (2 MiB) |
| `AID_SYNC_MEDIA_MAX_MANIFEST_BYTES` | `262144` | Largest encrypted manifest (256 KiB, also subject to object limit) |
| `AID_SYNC_MEDIA_CACHE_BYTES` | `134217728` | Per-user storage for media chunks and manifests (128 MiB) |
| `AID_SYNC_MEDIA_DAILY_TRANSFER_BYTES` | `268435456` | Per-user UTC-day media uploads plus downloads (256 MiB) |
| `AID_SYNC_MEDIA_CACHE_TTL` | `168h` | Chunk retention from its last successful upload (7 days) |
| `AID_SYNC_NETWORK_SIGNAL_DAILY_BYTES` | `4194304` | Per-account UTC-day signaling and WebDAV metadata allowance (4 MiB) |
| `AID_SYNC_NETWORK_RELAY_DAILY_BYTES` | `33554432` | Per-account UTC-day live relay allowance (32 MiB) |
| `AID_SYNC_NETWORK_SIGNAL_FRAME_BYTES` | `65536` | Maximum signaling JSON frame; cannot exceed 64 KiB |
| `AID_SYNC_NETWORK_RELAY_FRAME_BYTES` | `32768` | Maximum relay JSON frame; cannot exceed 32 KiB |
| `AID_SYNC_NETWORK_MAX_PEERS` | `8` | Maximum simultaneous devices per account/room; at most 8 |
| `AID_SYNC_NETWORK_MAX_CONNECTIONS` | `16` | Maximum simultaneous connections per account; at most 128 |
| `AID_SYNC_NETWORK_QUEUE_FRAMES` | `16` | Queued outgoing messages per connection; at most 256 |
| `AID_SYNC_NETWORK_CONNECTS_PER_MINUTE` | `30` | WebSocket handshake attempts per client address; at most 600 |
| `AID_SYNC_NETWORK_FRAMES_PER_SECOND` | `32` | Incoming application messages per connection; at most 256 |
| `AID_SYNC_NETWORK_WRITE_TIMEOUT` | `10s` | Deadline for one WebSocket write or heartbeat |
| `AID_SYNC_NETWORK_HEARTBEAT_INTERVAL` | `30s` | Server ping interval and credential-revocation checks |
| `AID_SYNC_NETWORK_SESSION_TTL` | `1h` | Maximum connection lifetime before reconnecting |
| `AID_SYNC_DEVICE_CHALLENGE_TTL` | `2m` | One-time device challenge lifetime |
| `AID_SYNC_DEVICE_TOKEN_TTL` | `15m` | Device bearer-token lifetime |
| `AID_SYNC_DEVICE_MAX_DEVICES` | `16` | Maximum active device keys per account; at most 128 |
| `AID_SYNC_MIN_PASSWORD` | `12` | Shortest password `adduser` and `passwd` accept |
| `AID_SYNC_FAIL_LIMIT` | `10` | Failed sign-ins from one address or for one name before blocking |
| `AID_SYNC_FAIL_WINDOW` | `15m` | How long failures count and a block lasts |
| `AID_SYNC_CREDENTIAL_TTL` | `5m` | How long a checked password is trusted before checking again |
| `AID_SYNC_TRUST_PROXY` | `false` | Take the client address from `X-Real-IP` (behind a reverse proxy) |

Passwords are stored as Argon2id hashes (OWASP's minimum cost: 19 MiB,
two passes); checks are cached in memory for `AID_SYNC_CREDENTIAL_TTL`, so
a changed password takes effect within that time.

## Device authorization

Once an account has registered its first device, HTTP Basic no longer grants
access to its WebDAV files, policy or networking service. The initial registration
is atomic: concurrent bootstrap attempts cannot both create a first device.
Revocation retains a device tombstone, so revoking the last device does not
silently reopen password bootstrap. Losing every authorized device requires
explicit operator recovery; changing the account password alone does not reset
its device authorization history.

| Endpoint | Authorization and request |
| --- | --- |
| `GET /api/sync/devices/capabilities` | Public; returns `protocol: "aid-device-auth-v1"`, challenge/token TTL seconds |
| `POST /api/sync/devices` | Basic only for first bootstrap; otherwise an authorized device bearer. Body: `id`, `label`, `publicKeySpki`, `signature` |
| `POST /api/sync/auth/challenge` | Body: `username`, `device`; returns `challenge`, base64 `message`, Unix-second `expires` |
| `POST /api/sync/auth/token` | Body: `challenge`, base64 DER ECDSA `signature`; returns opaque `token` and Unix-second `expires` |
| `GET /api/sync/devices` | Device bearer; returns account-scoped `devices` with id, label, SHA-256 SPKI fingerprint, creation time and revoked flag |
| `DELETE /api/sync/devices/{id}` | Device bearer; revokes that account's device, including self if selected |
| `POST /api/sync/devices/rotate` | Device bearer for the same `id`; enrollment-shaped body containing the new public key and rotation proof |

Only P-256 public keys in base64 DER SubjectPublicKeyInfo are accepted. Enrollment
proves possession of the new key with ECDSA-SHA256 over UTF-8
`aid-device-enroll-v1\n<username>\n<id>\n<base64-SPKI>`. Rotation signs the same
message prefixed with `aid-device-rotate-v1\n`, using the new key; the existing
bearer authorizes replacement. An authorized retry with the same id and key is
idempotent; it never restores a revoked device or replaces a different key.

Token challenges bind the normalized account, device id, current SPKI SHA-256
fingerprint and a fresh 256-bit random challenge in a separate
`aid-device-token-v1` domain. The client verifies that complete context before
asking the native key to sign. SQLite consumes each challenge once, including
failed signature attempts, and preserves replay prevention across restarts.
Token values are random 256-bit bearer credentials; only their SHA-256 hashes
are stored. A refresh replaces that device's previous token. Every bearer request
checks the live device record; it never borrows the Basic credential cache.
TLS is required outside loopback development, and credentials never belong in URL
queries, logs or device-management output.

Revocation and rotation remove the device's tokens/challenges and immediately
close its active server WebSockets. The WebSocket `device` query must match the
authenticated token's device id; an authorized account cannot impersonate another
registered device by changing that query. Token validity is rechecked for incoming
application frames and heartbeats. Clients obtain a fresh token before reconnecting.

These keys authorize server access. Revocation cannot erase diary data or MK
already copied to a device, and existing MK-authenticated direct connections have
their own lifetime. Signing-key rotation does not rotate shared MK or a space's
data key. The app uses Android Keystore and non-exportable Windows CNG keys;
hardware-backed status is reported by the provider, not assumed. The server sees
public keys and proofs, never a native private key or MK.

## Bounded asynchronous media cache

Self-hosted installations default to personal, durable storage:
`AID_SYNC_OPERATOR_LIMITS=false`. They do not charge monthly or daily traffic,
expire media, or enforce the media-cache size/object/manifest limits below.
An explicitly configured per-account disk quota, single-upload maximum, chunk hash checks,
authentication, WebSocket frame/connection limits and rate limits still apply.
Personal policy responses contain `operatorLimited: false` and network
capabilities only, with no `media` or `traffic` allowance. The app treats this
storage as a persistent copy and does not show a traffic quota card.
Persistent storage still needs an operator's backup and maintenance plan.
New accounts default to unlimited disk storage in personal mode. Operator mode
defaults to 2048 MiB; `AID_SYNC_DEFAULT_QUOTA_MB`, `adduser NAME QUOTA_MB` or
`quota NAME QUOTA_MB` can set an administrator's storage bound in either mode.
Changing mode never rewrites disk quotas already stored on existing accounts.

Official hosting explicitly sets `AID_SYNC_OPERATOR_LIMITS=true` (see
[`deploy/official.env.example`](deploy/official.env.example)); self-hosted
administrators may opt in to the same mode. The deployment template defaults
to `false`; changing environment configuration requires recreating the service.
The settings and accounting below apply only in this operator-limited mode.
There is no official-host code path: the same parameters and policy responses
govern every deployment, and clients never infer allowances from a domain.

Cache and live relay share the monthly media allowance across every device of
an account. Daily limits still apply independently. `GET /api/sync/policy`
also returns `traffic`: `monthlyLimitBytes`, `monthlyUsedBytes`,
`monthlyRemainingBytes` and `resetsAt` (next UTC month). Direct transfers use no
operator media allowance. Metadata and tightly bounded signaling remain available
when media is deferred. HTTP `429` reports `Retry-After` until the relevant daily
or monthly reset. The existing SQLite ledgers persist charges and refunds;
changing the date within one month does not grant more monthly traffic.

WebDAV metadata uploads require `Content-Length` and reserve the shared daily
control allowance before a file is written. Metadata response bodies also count,
so renaming large media as a metadata object cannot provide unlimited traffic.
Headers, authentication/policy responses and transport overhead are not media
payload bytes. A monthly media limit does not disable the separate control budget.

Authenticated `GET /api/sync/policy` returns:

```json
{"operatorLimited":true,"media":{"maxObjectBytes":2097152,"maxManifestBytes":262144,"transferRemainingBytes":268435456,"cacheTtlSeconds":604800,"cacheBytes":134217728}}
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

## Presence, signaling and bounded live relay

Connect to `GET /api/sync/network?space=<room>&device=<device>` with a WebSocket
upgrade and the same Authorization header as storage (a device bearer after
bootstrap; Basic only for accounts without registered devices). TLS is required outside
local development. The opaque room is 32 to 64 hexadecimal characters; the device
is 1 to 128 ASCII letters, digits, `_` or `-`. Rooms are scoped to the authenticated
account: a matching room tag alone never grants access. Clients verify and encrypt
the opaque payload end to end; the server does not interpret signaling or media.

The server first sends:

```json
{"type":"welcome","session":"fresh-random-32-hex","peers":[{"device":"other","session":"other-session"}],"relay":{"remainingBytes":33554432,"maxFrameBytes":32768}}
```

An empty room has `peers: []`. `join` and `leave` carry `device` and `session`.
Reconnecting the same device replaces the old session and announces a fresh
`join`; a delayed old disconnect cannot remove the replacement. Client messages
use `{type: "signal" | "relay", to, session, payload}`. `session` identifies the
target's current session and `payload` is opaque standard base64. Forwarded
messages use `{type, from, session, payload}` with the sender's current session.
Targets must be in the same account and room. No payload is stored for an offline
peer, and this endpoint is not an asynchronous cache or a TURN server.

Errors use `{type: "error", code: "budget" | "offline" | "too_large", kind:
"signal" | "relay"}`. Relay sends also produce `{type: "budget", relay:
{remainingBytes, maxFrameBytes}}` for the sender. JSON UTF-8 length, including
base64 and the entire envelope, must fit the frame limit on ingress and egress.
Frames larger than the overall WebSocket read limit close the connection with
the WebSocket message-too-big status. Binary/malformed messages, invalid base64,
rate excess and unresponsive peers close the connection rather than accumulating
work. The service caps the whole process at 1024 live connections and 32 pending
handshakes; per-address rate bookkeeping is itself bounded.

`GET /api/sync/policy` also returns `network.endpoint`, `network.signal` and
`network.relay`; each budget has `remainingBytes` and `maxFrameBytes`. All limits
are positive and finite in operator-limited mode. Personal installations advertise
frame sizes without allowance fields in policy; WebSocket welcome/budget frames
retain a safe protocol ceiling (`9007199254740991` bytes), not a billed quota.
Signaling/control, live relay and asynchronous-media
cache have separate persistent SQLite ledgers, shared by every device on the
account and reset at UTC midnight. Forwarding charges both the received JSON and
the forwarded JSON, not just decoded payload bytes. Presence/errors/budget
messages charge signaling. A 256-byte signaling reserve per live connection
allows a final budget error without overspending; unused bytes are refunded at
disconnect. Outgoing messages reserve their allowance before queueing; cancelled
messages not yet attempted are refunded. An attempted partial write or a process
crash conservatively retains the reservation because WebSocket writes cannot
report partial byte counts. TLS/TCP/WebSocket headers and control ping/pong frames
are outside application-byte accounting.

The accounting class is carried by each application message: the server must
receive the frame before it knows which ledger applies. A frame exceeding its
remaining allowance is rejected and
the connection closed without forwarding. Rejected raw ingress can therefore
consume at most one bounded application frame per attempt; connection/rate limits
bound this overhead. This service does not claim to prevent arbitrary clients
from sending unaccepted TCP bytes. Basic credentials are rechecked after their
credential TTL on a heartbeat; changing a password or deleting an account
terminates that old connection. Device bearers are rechecked on incoming frames
and heartbeats, and device revocation/rotation actively closes its sockets.
Server shutdown explicitly closes upgraded sockets.

## Deploying

The image is static (`Dockerfile`); mount a volume at `/data`, put it behind
a TLS-terminating reverse proxy that sets `X-Real-IP`, and set
`AID_SYNC_TRUST_PROXY=true`. Allow request bodies up to the upload limit and
turn off request buffering for `/dav/`.
`deploy/compose.yaml` exposes finite media limits through environment variables;
`deploy/media.env.example` shows optional operator overrides. Keep the SQLite
database on the persistent data volume, alongside the files, to retain usage.
`deploy/network.env.example` shows networking overrides. nginx must forward
WebSocket `Upgrade`/`Connection` headers (`deploy/nginx.conf`); its 300-second
read timeout exceeds the default heartbeat interval. This endpoint requires
HTTP/1.1 upgrade support on the proxy-to-server connection.

## Testing against the app

`go test ./...` covers the server. The app's live sync tests run against a
running server:

```sh
AID_SYNC_URL=http://127.0.0.1:8080/dav/ AID_SYNC_USER=NAME AID_SYNC_PASSWORD=... \
  flutter test --tags live
```
