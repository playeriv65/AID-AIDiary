# Sync paths, media and server budgets

Design approved on 2026-10-22. This document separates the intended network
design from the paths implemented today. Product decisions are in
[DECISIONS.md](DECISIONS.md); deployment settings are in
[the server guide](../server/README.md).

## Policy and current scope

Daily sync discovers trusted devices, probes usable paths together, starts
work on an available path, and upgrades when a better connection appears.
Failures retry quietly with backoff. Diary metadata and media have separate
work queues and budgets. Path choice does not redefine an item's identity,
version ordering or confirmation semantics; staged media ciphertext is reused.

These are path types, not five serial timeout stages:

| Type | Purpose | Implementation on 2026-10-22 |
| --- | --- | --- |
| LAN | Nearby authenticated devices over IPv4 or IPv6 | DNS-SD discovery and authenticated HTTP object transport |
| Public direct | Known globally reachable IPv4/IPv6 addresses | Selector type only; no address directory or automatic public discovery |
| ICE | Connectivity checks and UDP hole punching | Selector type only; no ICE/STUN implementation |
| Live relay | Two online devices exchanging bounded traffic through a server | Selector type only; no live relay service |
| Asynchronous cache | Store ciphertext until another device retrieves it | Existing shared-storage backends; bounded media on the AID server |

A live relay and an asynchronous cache solve different problems. Only the
cache lets the sender disconnect before the recipient comes online. Neither
is permission for unlimited operator-funded media traffic.

The current app integrates LAN peers with the selected Google Drive,
WebDAV or AID server backend. It does not provide the complete five-path
network. Native DNS-SD is wired through Bonsoir on Windows and Android;
protocol tests use controlled discovery and real local sockets. Two isolated
hidden Windows clients have also discovered each other through native DNS-SD,
selected LAN automatically, and exchanged a 2 MiB attachment whose SHA-256
matched. The test cloud allowed only 1 MiB per file; its cache did not carry
that attachment. Metadata still reached the other client after the temporary
cloud server stopped. Android compilation and signing are verified; native
Windows-to-Android discovery on a physical network remains unverified.

## Connection selection

`lib/sync/connection_manager.dart` accepts candidates already bound to the
expected user and space. Discovery hints cannot grant trust. Independent
probes start concurrently and have individual deadlines: a stalled direct
candidate cannot block a usable cache. Periodic probes keep looking for
improvements after a fallback succeeds. Network generations fence out stale
results, and closing the manager cancels its timers and pending results.

Scoring considers path type, relative cost, stability and measured
throughput when supplied. An upgrade from a restricted path to direct can
happen immediately. Switching between otherwise healthy paths requires a
minimum dwell time and a sufficient score improvement. Current production
candidates do not yet have an active throughput measurement service.

The selector also supports a bounded direct-first head start for nearby
migration. The planned migration flow is scan, establish trust, find a
direct path, then transfer and verify. Offline first-time QR authorization,
Wi-Fi Direct and hotspot assistance are still future work; the current app
does not present that new flow. Existing pairing uses SPAKE2 over the
selected shared storage before devices can authenticate each other locally.

## Trusted LAN peers

`lib/sync/lan_transport.dart` advertises `_aid-diary._tcp`, resolves IPv4
and IPv6 addresses and probes each endpoint before registering it. DNS-SD
records contain an opaque tag, not a key. Requests and responses use HMACs
derived from the existing master key and bound to the user and space.
Signed probes, response verification, nonces, time windows and a server
instance audience prevent unauthenticated advertisements or replayed
requests from becoming trusted transfers. The listener exposes only allowed
encrypted sync objects, with bounded requests and concurrency.

This proves possession of the same master key, not a separate device
signing key. Devices sharing MK cannot currently be revoked individually
through this protocol. Per-device keys, server challenge/token
authentication, revocation and key rotation remain future work. The Go
server still authenticates its WebDAV accounts with their storage password;
LAN authentication does not replace that login.

## Metadata across paths

`lib/sync/routed_backend.dart` presents one `SyncBackend` over verified
peers, shared storage and a persistent local ciphertext vault. Metadata
reads and checks race remote paths; listings combine their immutable packs.
The same item IDs and last-change ordering apply everywhere. Newer entry
edits win, and a losing local entry is retained in Recently deleted.

A metadata write succeeds only after at least one remote path acknowledges
it. A local write alone is not a sync acknowledgement. If all remote writes
fail, the diary's SQLite change remains pending rather than being replayed
as an incoming pack that acknowledges itself. After a successful remote
write, the local vault retains the pack as an outbox; a later drain copies
it to routes that missed it. Received packs are also retained locally so
they can reach storage when it returns.

Compaction seals a snapshot containing item versions, tombstones and the
paths it covers. Old packs are deleted from a remote route only after that
route acknowledges the replacement snapshot. An offline route can keep its
old packs until it receives the newer state; seeing a local snapshot is not
evidence that every remote path has received it.

## Resumable media

`lib/sync/sync_engine.dart` exchanges metadata before running media tasks.
Attachment rows can exist while their bytes are missing. This is a normal
pending state, not a failed diary edit. Newer media tasks are considered
first, and a deferred large file does not block a smaller file behind it.

`lib/sync/media_transfer.dart` stages media in 1 MiB plaintext chunks by
default. Each chunk is AEAD-encrypted once, named by its ciphertext SHA-256,
and reused unchanged after a retry or restart. The encrypted manifest binds
chunk order, plaintext and ciphertext hashes, lengths and the total size.
Received chunks are checked before staging; reconstruction checks AEAD,
plaintext hashes and lengths before importing the complete attachment.

SQLite owns both `sync_media_tasks` (direction, file name, manifest,
completion and durable-storage receipt) and `sync_media_objects` (staged
ciphertext and metadata). Ordinary disk-backed app databases retain progress
across process restarts. Receivers skip chunks already staged locally;
senders inspect the destination's inventory before writing missing chunks. A manifest is
published only after its destination has all its chunks. Switching paths
reuses the same staged objects, while checking what the new destination
actually has. A different destination may still need chunks already sent
elsewhere.

Media selects its allowance between chunk operations. Downloads can query
all healthy authenticated direct peers, so an online device missing a video
does not hide a copy on another device. Cloud reads remain outside that pool
and retain their separate allowance. This is chunk-level resumption, not
resumption in the middle of an encrypted chunk.

Transfer completion means the task's required delivery finished. Successful
outbound delivery to user-owned durable storage is recorded separately from
delivery to the operator cache or a direct peer with unconfirmed retention.
These are task receipts, not a continuously audited count of surviving
backups. The originating diary and local media must remain usable
independently of temporary cloud retention; a cache must never become the
only intended persistent copy.

## Budgets and retries

Client values live in `assets/config/app_config.json`, under `sync.transfer`:

| Setting | Default |
| --- | --- |
| Plaintext chunk | 1024 KiB |
| Operator-cache maximum original file | 16 MiB |
| Operator-cache transfer allowance per sync run | 32 MiB |
| Probe deadline / healthy reprobe interval | 4 s / 30 s |
| Minimum healthy-path dwell / score improvement | 15 s / 20% |
| Failed-work retry base / maximum | 15 s / 600 s |

Retries use jitter and a ceiling; new diary edits do not bypass a pending
retry deadline. Discovering a direct route can wake deferred work sooner.
Personal Google Drive and ordinary WebDAV storage are separate from the
operator cache: its file/traffic limits do not restrict them, although the
provider's own quotas still apply. A self-hosted AID server advertising the
cache policy is still an expiring cache, even under a different address.

Clients probe WebDAV endpoints for an authenticated
`GET /api/sync/policy` and intersect their allowance with the server's
remaining transfer budget and object limits. If policy is unavailable,
operator-cache media is disabled for that run; metadata and reachable LAN
sync can continue. Server enforcement is authoritative, including against
modified clients.

The server defaults are 2 MiB per ciphertext object, 256 KiB per manifest,
128 MiB cached media per account, 256 MiB combined media uploads/downloads
per UTC day and a seven-day chunk TTL from its last successful upload.
The 2 GiB default total account quota and 256 MiB general upload limit still
apply. These are configurable defaults, not a deployment guarantee; see
[server/README.md](../server/README.md) for the exact environment variables.

Expired chunks are collected before authenticated WebDAV requests.
Manifests, packs, snapshots and pairing records are not TTL victims.
Metadata does not consume the separate media transfer allowance. A full
cache rejects new media, while the SQLite transfer ledger reserves and
settles actual upload/download bytes so concurrent requests cannot
overspend. A crash can conservatively charge unused reservations until the
next UTC day. None of these retention rules promises a durable media backup.

The UI reports diary sync separately from media waiting: synced, some media
still transferring, or waiting for another device. Temporary background
failures retry without connection popups. `aid sync.status` exposes the
current route, next retry time and media report. `aid sync.network` provides
`availableRoutes` (type, stability, throughput and cost), `pendingMedia`,
`durableRemoteMedia`, `temporaryOrUnconfirmedRemoteMedia`, the selected
`route` and optional `retryAt`. The two remote-media counts describe completed
outbound tasks with different retention assumptions. A dedicated advanced
network diagnostics page has not been implemented.

## Space format and operational boundaries

New spaces use format 4. Format 3 and earlier are rejected; no compatibility
layer or automatic migration is provided. This also applies to a stale
space descriptor cached locally: it is not silently rewritten as format 4.
An unsupported space must never trigger automatic remote deletion or removal
of the user's local diary. Choose a new space, or explicitly authorize the
destructive `sync.reset_space` action after reviewing its effect on the
remote copy and the need to pair other devices again. Changing a live remote
space requires the owner's approval. Local database schema updates for the
queue/vault do not convert an existing remote format.

## References

The design takes automatic direct-path upgrades from
[Tailscale's connection types](https://tailscale.com/docs/reference/connection-types)
and [Syncthing's relay behavior](https://docs.syncthing.net/users/relaying.html).
Transport-independent inventories and missing-block retrieval are informed by
[Syncthing's Block Exchange Protocol](https://docs.syncthing.net/specs/bep-v1.html).
These are design references; AID implements its own encrypted object protocol
and is not wire-compatible with either project.
