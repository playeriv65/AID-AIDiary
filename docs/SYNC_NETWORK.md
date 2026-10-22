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
| Public direct | Known globally reachable IPv4/IPv6 addresses | Encrypted address exchange through the account-scoped directory; authenticated HTTP probes |
| ICE | Connectivity checks and UDP hole punching | WebRTC/STUN, an ordered reliable data channel and authenticated object RPC; no TURN |
| Live relay | Two online devices exchanging bounded traffic through a server | Authenticated WebSocket forwarding with separate persistent signal/relay budgets |
| Asynchronous cache | Store ciphertext until another device retrieves it | Existing shared-storage backends; bounded media on the AID server |

A live relay and an asynchronous cache solve different problems. Only the
cache lets the sender disconnect before the recipient comes online. Neither
is permission for unlimited operator-funded media traffic.

The new Internet paths require an AID-compatible WebDAV account whose server
provides `/api/sync/network`. Google Drive and ordinary WebDAV retain LAN
and their chosen storage; they do not gain an Internet directory, ICE or
live relay merely by implementing file storage. LAN discovery uses Bonsoir
on Windows and Android. The connection types are implemented in source;
their availability still depends on routing, firewall/NAT behavior, both
devices being online and the server's deployed version.

The production service at `aid.playeriv65.com` was updated on 2026-10-22
with the owner's authorization. It runs server source `887dd27` and nginx
WebSocket upgrade headers, with operator limits explicitly enabled and a
1,000,000,000-byte UTC monthly media allowance per account. Self-hosting
continues to default to limits off; both modes use the same implementation.
Earlier isolated public tests used a temporary process, data and proxy
prefix, all since removed. No new public port, Oracle firewall rule or
additional Osaka relay was needed for the production deployment.

## Verification status

### Production deployment (2026-10-22)

The existing `aid-sync` container on `netlab_main` was recreated from server
source `887dd27e86a0acd14fb2cfafa82a3eae07edb6bd`. Its persistent bind mount
remains `/srv/aid-sync/data`; the existing account was retained. nginx still
terminates TLS and forwards to `127.0.0.1:18081`, now including WebSocket
`Upgrade` and `Connection` headers. Other sites and containers were unchanged.

The Linux ARM64 binary SHA-256 is
`ec05c2337964e736f47ae0dd85f65f98d25a2931017bca2f34297d6e3586cb47`;
the running image ID is
`sha256:93e52a086636b9bcd0631a9a65c23d47026d246bcdd22a2d82b6716d7b23f66c`.
The predeployment backup is
`/srv/aid-sync/backups/20261022T203743Z-887dd27.OvpGf0`.
The prior image and backups remain available for rollback.

The initial image could not execute a Windows-built binary copied with mode
0644; automatic rollback restored the prior service. The Dockerfile now sets
mode 0755 explicitly. The successful attempt ran an image preflight before
stopping production, then passed local health and `nginx -t` checks.

External checks from Windows passed public HTTPS health (200), authenticated
policy and device capabilities, a 1024-byte WebDAV round trip, two WebSocket
upgrades (101), and an exact 16,384-byte relay-frame round trip. The policy
reported `operatorLimited: true` and `monthlyLimitBytes: 1000000000`; the
account ledger recorded traffic. The temporary acceptance account and its
data were deleted, leaving the original account count of one.

These are production deployment and proxy/protocol checks, not a new native
Windows/Pad diary transfer or proof of connectivity through different NATs.
An additional Osaka relay was cancelled; Osaka received read-only inspection.
The Go test suite and vet passed for this deployment. Flutter code was not
changed; the preceding native app validation is recorded below.

### Device authorization and policy follow-up (2026-10-22)

The final backlog binaries passed first-run nearby migration between hidden
Windows and the Xiaomi Pad 7. With the isolated local cloud service stopped,
QR-bound SAS approval transferred diary metadata, a 3 MiB audio attachment and
a rendered handwriting PNG; both attachment SHA-256 values matched, the diary
day remained 2026-10-20, media failures were zero and the source received its
final completion receipt. These devices were on the same Wi-Fi with Tailscale
available; stopping the application server does not establish a no-Internet or
cross-WAN test.

Windows CNG bootstrap, explicit approval, signing-key rotation and revocation
passed. The Pad reported a hardware-backed Android Keystore key, received
automatic authorization through the already-approved nearby channel, rotated
its own key and synchronized a new diary entry. Revocation then required fresh
approval. The final first-run GUI completed directly into the journal, without
returning through the welcome steps.

One unchanged local server URL was tested with the same executable and data:
limits off returned no quota; limits on returned the configured 8192-byte monthly
allowance; limits off again cleared the quota and transferred a new
17,825,836-byte WAV through storage only, with a matching SHA-256. This exceeds
the default limited-cache original-file ceiling and demonstrates that clients
use policy parameters rather than domain-specific behavior.

The final Flutter suite passed 789 tests with six external-service tests skipped;
analysis was clean, seven CLI tests passed, all four screenshot cases passed,
and Go tests, vet and race checks passed. Both native builds succeeded. The
headless Android emulator verified real mood-widget cold launch, bounded
MediaStore scanning, explicit two-photo import and unchanged source-file hashes.
Stylus events and handwriting rendering also have component/action tests.
Performance measurements and another-network validation remain deferred.
Production deployment is complete as recorded above.

Test native signing keys were removed through their isolated app instances,
the two Pad scratch workspaces and API forwards were removed, and local test
clients/server were stopped. The everyday app package was not changed.

### Earlier automatic-path validation

Previously checked: two isolated hidden Windows clients discovered each
other through native DNS-SD, selected LAN, and exchanged a 2 MiB attachment
with a matching SHA-256 while the test cache's file allowance was only
1 MiB. Metadata also reached the other client with that temporary cloud
server stopped. Those results establish the earlier LAN implementation,
not the new Internet paths.

The new WebSocket service has Go protocol tests for account/room/session
isolation, forwarding, quotas, reconnection and concurrency. On 2026-10-22,
the Windows PC and Xiaomi Pad 7, on the **same Wi-Fi**, established trusted
native Bonjour LAN, two verified global-IPv6 direct endpoints, ICE and
live-relay candidates. Restricting both clients to one path produced these
physical transfer results:

| Path check | Windows-to-Pad fixture | Result |
| --- | --- | --- |
| `direct` only | 5 MiB + 44-byte WAV header | Received and SHA-256 matched; no cache or relay carried this fixture |
| `ice` only, `stunOnly=true` | 3 MiB + 44-byte WAV header | Received and SHA-256 matched; nominated pair used UDP |
| `relay` only | 32,812-byte WAV | Received and SHA-256 matched; a 3 MiB attachment waited with zero media failures |

Fixture SHA-256 values, in that order:

```text
direct  2fb6db1f9644e12822f67a9b6a154b40cc765743932619f20b742c780b40414d
ice     07ea7e8cb193d728d96784576b8007de2d1f43b77806f4ee827bb3471933aea9
relay   1d9798e9a1c318c8e1106f3c1b19a17815e6720f62173241c2f23173d6cd8de0
```

The ICE run excluded exchanged host candidates and gathered `srflx`
candidates. Actual selected-pair diagnostics showed Windows local `host` /
remote `prflx` and Pad `prflx` / `prflx`, over UDP. It is evidence of this
host/peer-reflexive connection, not a claim that the nominated pair was
`srflx`/`srflx`. The nominated Windows pair sent about 4.4 MB in 291 frames,
without the earlier queue/backpressure failure.

For the cost boundary, the temporary server used a reduced **1 MiB daily
relay quota**. A separate test room exhausted it after 27 relay frames:
the server refused further budget, reported 246 bytes remaining and had
charged 1,048,330 of 1,048,576 bytes. A new small attachment stayed pending.
Restarting Windows restored automatic paths, upgraded to LAN and delivered
both that small attachment and the pending 3 MiB file while the cloud relay
allowance remained 246 bytes. No quota increase was used to finish them.

The latest Windows and Pad binaries also verified that an established ICE
link survives signaling loss. On Windows,
`sync.network_reconnect delaySeconds=45` disconnected only its WebSocket:
Windows reported `disconnected`, the Pad stayed `online` with `peers: []`,
and both still selected `ice`. Diary text and a new 32 KiB attachment
continued to sync. Stopping only the remote isolated Go test server then
made both clients report disconnected signaling with empty peer lists;
the existing ICE link still synchronized text and media. The production
server was not stopped or changed.

To exclude an already cached attachment, that last check generated a new
random 32,812-byte audio file after signaling was unavailable. Sender and
receiver each reported one completed media task and zero failures. The
Pad's exported file and Windows source both had SHA-256
`6f160b1aaf8a997e079ae787183a5443d9d4bc3d8f852d48335d80cc8c19aa2a`.
The remote `leave` handling was corrected to retain already established
direct connections. All four `internet_transport_test` cases passed;
one is the real HMAC/TCP asymmetric-leave regression.

These are same-Wi-Fi results. A global IPv6 address used locally does not
prove cross-WAN inbound reachability, and the external OCI IPv6/TCP probe
timed out. The owner deferred testing from another network. No cross-WAN
success, NAT-type matrix or general carrier/firewall compatibility is
claimed. The signaling-loss checks above used the latest binaries on both
devices. The final full Flutter suite passed 710 tests, with six
external-service tests skipped. Static analysis is clean, all seven CLI
tests pass, and Go vet/tests/race checks pass. The final source and tested
device binaries have matching behavior; the last source cleanup only
removed an always-true type check and added braces.

Cleanup was verified after the physical checks: nginx's live configuration
SHA-256 matched its pre-test snapshot and `nginx -t` passed; production
`/healthz` returned 200 and the removed temporary prefix's `/healthz`
returned 404. The isolated Go executable was checked through `/proc` before
its process was terminated, and its `/tmp` test directory was removed.
The production `aid-sync` container remained running with health 200.
Windows test-app/local-server processes were stopped. Only the Pad's
`files/network-tests/internet-20261022` workspace was removed; the ordinary
`dev.aid.diary` installation and its data were retained. Temporary adb
forward 47829 and reverse 18082 were removed.

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

The selector also supports a bounded direct-first head start. First-time nearby
migration now has its own foreground QR/SAS flow and reuses authenticated direct
object transfer and persistent media chunks. Wi-Fi/hotspot settings assistance is
implemented; unattended Wi-Fi Direct negotiation remains outside the current
platform contract. Storage-based SPAKE2 pairing remains available independently.

## Offline nearby authorization and migration

The old device snapshots metadata in a read transaction into a separate temporary
ciphertext vault. Its ordinary cloud queue, acknowledgements and original files
are unchanged. Attachment ciphertext is prepared on demand, keeping large media
out of the initial invitation step. The public QR contains only an expiring
session, numeric local endpoints and an ephemeral X25519 public key. X25519,
HKDF-SHA256 and AES-GCM bind the channel to that physically scanned public key.
Both people-facing screens must confirm the same six-digit SAS before the owner
releases MK or a migration capability. A competing receiver cannot replace an
established transcript, and authenticated request sequence numbers reject replay.
No long-term native signing key is exported.

The recipient requires a new, unconnected diary; it must not replace an existing
user's identity or contents. Cancellation and the empty-diary check are fenced
inside SQLite write transactions before native secret-store writes. Secure-store
changes are compensated if persistence or cancellation fails. Identity adoption
waits until the requested metadata and attachments have completed. Only after
that adoption commits does an encrypted completion receipt reach the sender.
A lost final receipt is retried quietly and cannot undo an already complete local
diary. Partial transfer capabilities remain in platform secret storage for retry;
they never appear in diagnostics or the public QR. A closed or expired source
reports failure separately from successful completion and removes its temporary
staging database and files.

For an AID account, the same confirmed SAS channel carries the new device's own
public signing-key request. The old device authorizes that key automatically or
persists its public signed request for retry when the cloud is reachable. It does
not send its Basic password, bearer token or native private key. After migration,
the new device configures the account address and existing sealed space info and
obtains its own short token. Ordinary Google Drive/WebDAV credentials are not
copied. User-assisted Wi-Fi or hotspot setup remains available when local routing
requires it; this does not promise arbitrary cross-platform offline discovery or
automatic hotspot creation.

Invitation, transfer-session and pack limits live in `sync.transfer`:
`nearbyInvitationSeconds` (120), `nearbySessionSeconds` (3600) and
`nearbyPackKiB` (1024). New GUI operations share
`sync.nearby_status/offer/accept/confirm/resume/cancel/wifi/hotspot` actions;
confirmation requires the displayed SAS. Network codes and transfer secrets have
different exposure rules: a public invitation/SAS can be displayed for this
explicit authorization, while MK, capabilities and tokens never appear in status.

## AID device keys and server authorization

Each server/account registration owns a separate P-256 key in Android Keystore
or Windows CNG. The native interface only ensures a key, signs bounded messages
and deletes a key. Hardware-backed status comes from the provider; Windows
currently uses a non-exportable software key. A new device generates its own key
and proves possession rather than receiving the old device's private key.

The first device uses the operator-issued account password for atomic bootstrap.
Once a device has been registered, Basic no longer authorizes that account's
storage or networking service. Subsequent devices require an existing authorized
device's bearer approval. Fresh, one-use server challenges bind account, device
and current public-key fingerprint; the client checks that context before native
signing. Short random tokens are held in client memory, hashed at rest on the
server and checked against active device records on every bearer request. Native
key rotation preserves old/new aliases until the new server key is proven, so a
lost response can recover without exporting either key.

The device-management page and `sync.devices_accounts/check/authorize/revoke/rotate`
actions expose public fingerprints and authorization status. They never return
native key aliases, signing material, account passwords or access tokens.
The exact endpoint payloads, finite defaults and revocation behavior are in
[the server guide](../server/README.md#device-authorization).

Revoking a device blocks its future server access and closes its server
WebSockets; it cannot erase MK or diary copies already held by that device.
Rotating a device signing key does not rotate shared MK or a space data key.
Shared-MK rotation and independent revocation of the current MK-based direct
protocol remain separate product/security work. New source implementation and
the physical validation/deployment evidence above must be assessed separately.

## Trusted LAN peers

`lib/sync/lan_transport.dart` advertises `_aid-diary._tcp`, resolves IPv4
and IPv6 addresses and probes each endpoint before registering it. DNS-SD
records contain an opaque tag, not a key. Requests and responses use HMACs
derived from the existing master key and bound to the user and space.
Signed probes, response verification, nonces, time windows and a server
instance audience prevent unauthenticated advertisements or replayed
requests from becoming trusted transfers. The listener exposes only allowed
encrypted sync objects, with bounded requests and concurrency.

This proves possession of the same master key. AID server access now uses the
device challenge/token scheme above, but MK-based LAN authentication still cannot
independently exclude one device already holding MK. Server revocation does not
retroactively revoke that shared secret or an established direct connection.

## Internet directory and public direct paths

`lib/sync/internet_transport.dart` connects to the account-authenticated
WebSocket endpoint `/api/sync/network`, using the storage credentials.
Its room tag is derived from MK and bound to the user and space; the
directory returns fresh 32-hex server sessions and peer presence. An
account login and a directory record are hints, not proof of device trust.

Each client also generates its own fresh nonce. MK-derived AEAD protects a
hello/echo/ready exchange before a peer can provide a route. Signaling
sequence numbers bind both endpoint sessions and the client nonce; an
untrusted server replaying earlier server-assigned sessions cannot replay
that handshake as a fresh device. Object RPC also binds both sessions and
client nonces. This authenticates possession of MK, not an individually
revocable device signing key.

Numeric global-unicast IPv4/IPv6 listener addresses are exchanged only
inside encrypted signaling. Loopback, local/private, link-local, multicast,
overlay and documentation addresses, DNS names, credentials and arbitrary
URL paths are excluded. A received address still needs the existing signed
HTTP probe, including the expected device ID and MK, before it becomes a
direct candidate. The app advertises real interface addresses; it cannot
make an inbound-blocked address or a NAT mapping reachable by advertising it.

## ICE and the shared object protocol

`lib/sync/ice_transport.dart` uses `flutter_webrtc` 1.6.2+hotfix.4. STUN
servers are configured in `sync.transfer.stunUrls`; no TURN credentials or
TURN media path are supplied. Both peers exchange encrypted SDP and
candidates through the directory. A fresh authenticated ICE generation
nonce distinguishes new attempts and binds their object protocol keys.

The reliable ordered data channel carries binary frames of at most 16 KiB
and reassembles logical packets up to 24 MiB. `peer_object_link.dart` owns
the same authenticated, encrypted object RPC on ICE and live relay: it
checks sessions, replay order, allowed object paths, ciphertext chunk hashes,
concurrency and response bounds. An object is limited to 16 MiB plus 64 KiB;
larger media still travels as the persistent 1 MiB chunks, rather than one
unbounded RPC. Opening a native data channel alone never grants trust.

Diagnostics use WebRTC `getStats` to report the actual selected candidate
pair, candidate types and protocol. Seeing an `ice` route or configuring
STUN is not evidence that server-reflexive UDP connectivity was selected;
host candidates can also establish an ICE connection. Physical STUN checks
must inspect the selected pair rather than infer NAT traversal from a route
label.

Windows desktop WebRTC does not currently emit the expected buffered-amount
callbacks ([upstream #2206](https://github.com/flutter-webrtc/flutter-webrtc/issues/2206)).
The sender still caps its native buffer at 256 KiB; while blocked, one
cancellable 20 ms timer rechecks `getBufferedAmount`, with callbacks also
waking it where supported. No timer runs once the buffer has drained or
the link closes. Diagnostics expose `queuedBytes`, `bufferedBytes`,
`txFrames`, `rxFrames`, `rxPartialBytes`, `backpressurePolling` and a sanitized
`lastFailure`, without endpoint IPs or secrets. The physical 3 MiB transfer
above exercised the corrected backpressure path; the final full Flutter
suite passed 710 tests, with six external-service tests skipped.

## Live relay is separate from cache

The server forwards opaque base64 messages only between current sessions
in the same account and room. Both endpoints must be online. No relay
payload is persisted or made into a durable receipt. `relay_packets.dart`
fragments a packet into at most 12 KiB of raw data plus an 8-byte header,
reduced further when the server advertises a smaller JSON frame allowance.
The whole WebSocket sender waits 50 ms between application frames (at most
20 frames/s), including signaling and concurrent peer operations. Relay
RPC uses a three-minute deadline and two-minute packet assembly deadline
to accommodate that deliberately restricted throughput.

Server limits default to 32 KiB per encoded relay JSON frame and 64 KiB per
signaling JSON frame. Each account has separate persistent UTC-day ledgers:
32 MiB for relay and 4 MiB for signaling/control. Both received and forwarded
UTF-8 JSON bytes count, including base64 and envelopes; TCP/TLS/WebSocket
headers and ping/pong frames are outside that application-byte count.
These ledgers never borrow the asynchronous media-cache budget. Finite
queues, connection/peer limits, deadlines and rate limits bound work; the
server guide owns their exact settings and conservative failure accounting.

The client permits originals up to 256 KiB and at most 2 MiB of media per
relay sync run, further restricted by the server's remaining relay allowance
divided by four for transport expansion. The server remains authoritative
across devices. Metadata also consumes relay bytes: a large metadata
snapshot is not free merely because it is not an attachment. Files beyond
the applicable allowance wait for direct transfer or another permitted path.

Closing the directory WebSocket closes relay links but retains already
established public-direct and ICE links. At most 16 retired peer clients
are retained across such disconnections. Reconnection uses fresh sessions
and client nonces; route identity includes the peer/session binding, so a
late result from a previous link cannot become the new route.

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
and retain their separate allowance. A direct allowance writes through a
pool containing direct writers only; a route switch cannot silently turn a
direct write into a metered relay write. This is chunk-level resumption, not
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
| Live-relay maximum original file | 256 KiB |
| Live-relay media allowance per sync run | 2 MiB, further bounded by remaining server relay bytes / 4 |
| Probe deadline / healthy reprobe interval | 4 s / 30 s |
| Minimum healthy-path dwell / score improvement | 15 s / 20% |
| Failed-work retry base / maximum | 15 s / 600 s |

The relay values are separate from the cache values. A file that fits the
cache allowance does not automatically fit the live-relay allowance.

Retries use jitter and a ceiling; new diary edits do not bypass a pending
retry deadline. Discovering a direct route can wake deferred work sooner.
Personal Google Drive and ordinary WebDAV storage are separate from the
operator cache: its file/traffic limits do not restrict them, although the
provider's own quotas still apply. Self-hosted AID defaults to durable storage
without monthly/daily plan quotas, media TTL or cache eviction. An administrator
may opt into the bounded cache policy using `AID_SYNC_OPERATOR_LIMITS=true`.
The official deployment enables it explicitly. It uses the same server and
client behavior as any other deployment; the domain never determines limits.

Clients probe WebDAV endpoints for an authenticated
`GET /api/sync/policy` and intersect their allowance with the server's
remaining transfer budget and object limits when `operatorLimited` is true.
If policy refresh fails after that server advertised limits, operator-cache
media is disabled for that run; metadata and reachable LAN sync can continue.
A server without an enabled limit policy is treated as personal storage. Server
enforcement is authoritative, including against modified clients.

When operator limits are enabled, defaults are 2 MiB per ciphertext object, 256 KiB per manifest,
128 MiB cached media per account, 256 MiB combined media uploads/downloads
per UTC day and a seven-day chunk TTL from its last successful upload.
Cache and relay share a 1,000,000,000-byte UTC monthly media allowance, in
addition to their independent daily limits. Metadata/control traffic uses a
separate allowance and cannot bypass billing by renaming media as a pack.
The 2 GiB account plan quota is also opt-in; the 256 MiB general upload safety
limit remains enabled for self-hosting. These are configurable defaults, not a deployment guarantee; see
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
outbound tasks with different retention assumptions. The advanced network
diagnostics page presents those counts separately, with selected/available paths,
signaling state, authenticated peer count and actual ICE candidate types/protocol.
Its presentation model whitelists fields and does not display endpoint addresses,
tokens, keys or arbitrary exception strings. A durable-storage receipt is not a
proof that a peer will retain a copy forever; cache and unconfirmed receipts remain
explicitly separate from durable-storage receipts.

Development builds also expose `aid sync.network_paths
paths=lan,direct,ice,relay,cache` to restrict a physical test to the requested
paths; omit unwanted names to isolate a path. The optional `stunOnly=true`
filters exchanged ICE candidates to `srflx`/`prflx` for NAT-traversal
diagnostics. It does not configure TURN or prove that STUN succeeded.
Restarting the app restores normal automatic paths. This is a development
action, not a persistent user network setting. Isolated Android test
workspaces, CLI access and the fixed Windows runtime used to avoid new
firewall identities per worktree are documented in [SETUP.md](SETUP.md).

`aid sync.network_reconnect delaySeconds=45` is another development-only
check: it disconnects signaling, preserves established direct links and
delays reconnection. The accepted delay is 1 to 60 seconds, default 5. It
does not stop the production service or change a persistent user setting.
An empty directory peer list after a remote `leave` is not permission to
close an already authenticated working direct connection.

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
