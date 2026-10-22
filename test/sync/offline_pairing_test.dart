// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:aid_diary/sync/identity.dart';
import 'package:aid_diary/sync/offline_pairing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<(OfflinePairingHost, OfflinePairingInvite)> owner(
      {DateTime Function()? now}) async {
    final host = OfflinePairingHost(identity: DiaryIdentity.create(), now: now);
    addTearDown(() async {
      await host.close();
      host.dispose();
    });
    final invite = await host.start(
        bind: InternetAddress.loopbackIPv4,
        addresses: [InternetAddress.loopbackIPv4]);
    return (host, invite);
  }

  test(
      'offline QR pins a public key and MK is released only after both confirmations',
      () async {
    final (host, invite) = await owner();
    expect(invite.qr.contains(host.identity.userId), false);
    final parsed = OfflinePairingInvite.parse(invite.qr);
    final client = OfflinePairingClient(parsed);
    addTearDown(client.close);
    await client.start();
    expect(client.sas, host.sas);
    expect(host.stage, OfflinePairingStage.comparing);
    await expectLater(client.receive(), throwsStateError);
    expect(() => client.confirm('wrong'), throwsStateError);
    await expectLater(host.confirm('wrong'), throwsStateError);
    client.confirm(client.sas!);
    expect(await client.receive(), isNull, reason: 'owner has not approved');
    await host.confirm(host.sas!);
    final identity = (await client.receive())!;
    expect(identity.userId, host.identity.userId);
    expect(identity.masterKey, host.identity.masterKey);
    await client.acknowledge();
    await host.finished;
    expect(host.stage, OfflinePairingStage.transferred);
    await expectLater(client.receive(), throwsStateError);
  });

  test('a competing receiver cannot replace the confirmed transcript',
      () async {
    final (host, invite) = await owner();
    final first = OfflinePairingClient(invite);
    addTearDown(first.close);
    final second = OfflinePairingClient(invite);
    addTearDown(second.close);
    await first.start();
    final code = first.sas;
    await expectLater(second.start(), throwsStateError);
    expect(host.sas, code);
    first.confirm(code!);
    await host.confirm(code);
    expect((await first.receive())!.masterKey, host.identity.masterKey);
  });

  test(
      'the same SAS channel authorizes only one new-device request after owner approval',
      () async {
    var approvals = 0;
    final host = OfflinePairingHost(
        identity: DiaryIdentity.create(),
        account: {'server': 'https://example.org/dav/', 'username': 'alice'},
        authorizeDevice: (request) async {
          approvals++;
          expect(request, 'signed-public-key-request');
          return false;
        });
    addTearDown(() async {
      await host.close();
      host.dispose();
    });
    final invite = await host.start(
        bind: InternetAddress.loopbackIPv4,
        addresses: [InternetAddress.loopbackIPv4]);
    final client = OfflinePairingClient(invite);
    addTearDown(client.close);
    await client.start();
    client.confirm(client.sas!);
    await expectLater(
        client.authorizeDevice('signed-public-key-request'), throwsStateError);
    expect(approvals, 0);
    await host.confirm(host.sas!);
    final grant = (await client.receiveGrant())!;
    expect(grant['account'],
        {'server': 'https://example.org/dav/', 'username': 'alice'});
    expect(await client.authorizeDevice('signed-public-key-request'), false);
    expect(await client.authorizeDevice('signed-public-key-request'), false);
    expect(approvals, 1,
        reason: 'offline queuing is idempotent within the session');
    await expectLater(
        client.authorizeDevice('replacement-key'), throwsStateError);
    expect(approvals, 1);
    await client.acknowledge();
  });

  test('captured authenticated status requests cannot be replayed', () async {
    final (host, invite) = await owner();
    final proxy = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final forward = HttpClient();
    List<int>? captured;
    proxy.listen((request) => unawaited(() async {
          final body =
              await request.fold<List<int>>([], (a, b) => a..addAll(b));
          if (request.uri.path.endsWith('/status')) captured = List.of(body);
          final outgoing = await forward
              .postUrl(invite.endpoints.single.replace(path: request.uri.path));
          outgoing.add(body);
          final response = await outgoing.close();
          request.response.statusCode = response.statusCode;
          await response.pipe(request.response);
        }()));
    addTearDown(() async {
      forward.close(force: true);
      await proxy.close(force: true);
    });
    final client = OfflinePairingClient(OfflinePairingInvite(
        session: invite.session,
        publicKey: invite.publicKey,
        expires: invite.expires,
        endpoints: [Uri(scheme: 'http', host: '127.0.0.1', port: proxy.port)]));
    addTearDown(client.close);
    await client.start();
    client.confirm(client.sas!);
    await host.confirm(host.sas!);
    expect((await client.receive())!.masterKey, host.identity.masterKey);
    final replay = await forward
        .postUrl(invite.endpoints.single.replace(path: '/v1/nearby/status'));
    replay.add(captured!);
    final rejected = await replay.close();
    expect(rejected.statusCode, 400);
    await rejected.drain<void>();
    // A rejected replay does not break the legitimate receiver's next sequence.
    await client.acknowledge();
    expect(host.stage, OfflinePairingStage.transferred);
  });

  test(
      'an altered QR public key fails owner authentication without releasing MK',
      () async {
    final (host, invite) = await owner();
    final changed = OfflinePairingInvite(
        session: invite.session,
        publicKey: Uint8List.fromList(invite.publicKey)..[0] ^= 1,
        expires: invite.expires,
        endpoints: invite.endpoints);
    final client = OfflinePairingClient(changed);
    addTearDown(client.close);
    await expectLater(client.start(), throwsStateError);
    expect(host.stage, isNot(OfflinePairingStage.approved));
    expect(host.stage, isNot(OfflinePairingStage.transferred));
  });

  test(
      'expiry and owner cancellation invalidate even an authenticated receiver',
      () async {
    var now = DateTime(2026, 10, 22);
    final (host, invite) = await owner(now: () => now);
    final client = OfflinePairingClient(invite, now: () => now);
    addTearDown(client.close);
    await client.start();
    client.confirm(client.sas!);
    now = now.add(const Duration(minutes: 3));
    await expectLater(host.confirm(host.sas!), throwsStateError);
    await expectLater(client.receive(), throwsStateError);
    await host.close();
    expect(host.stage, OfflinePairingStage.cancelled);
  });

  test('QR refuses arbitrary origins, redirects and malformed public keys', () {
    expect(() => OfflinePairingInvite.parse('https://example.org/'),
        throwsFormatException);
    expect(
        () => OfflinePairingInvite(
            session: '0' * 32,
            publicKey: Uint8List(32),
            expires: DateTime.now(),
            endpoints: [Uri.parse('http://user:secret@192.168.1.2:80')]),
        throwsFormatException);
    expect(
        () => OfflinePairingInvite(
            session: '0' * 32,
            publicKey: Uint8List(31),
            expires: DateTime.now(),
            endpoints: [Uri.parse('http://192.168.1.2:80')]),
        throwsFormatException);
  });

  test('cancelling while bind is pending closes the late listener', () async {
    final bound = Completer<HttpServer>();
    final binding = Completer<void>();
    final host = OfflinePairingHost(
        identity: DiaryIdentity.create(),
        bindServer: (address, port) {
          binding.complete();
          return bound.future;
        });
    final starting = host.start(
        bind: InternetAddress.loopbackIPv4,
        addresses: [InternetAddress.loopbackIPv4]);
    final rejected = expectLater(starting, throwsStateError);
    await binding.future;
    await host.close();
    final listener = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final port = listener.port;
    bound.complete(listener);
    await rejected;
    await expectLater(
        Socket.connect(InternetAddress.loopbackIPv4, port,
            timeout: const Duration(milliseconds: 300)),
        throwsA(isA<SocketException>()));
    host.dispose();
  });
}
