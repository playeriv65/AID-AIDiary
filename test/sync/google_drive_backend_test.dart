// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['integration'])
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:aid_diary/sync/google_drive_backend.dart';
import 'package:aid_diary/sync/sync_crypto.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../support/sync_device.dart';

class DriveItem {
  DriveItem(this.id, this.name, this.parent, {this.folder = false});

  final String id;
  final String name;
  final String parent;
  final bool folder;
  Uint8List bytes = Uint8List(0);
  var modified = 0;

  Map<String, Object?> get json => {
        'id': id,
        'name': name,
        if (!folder) 'md5Checksum': md5.convert(bytes).toString(),
        'modifiedTime': '2026-10-21T10:00:${'$modified'.padLeft(2, '0')}Z',
      };
}

/// The parts of the Drive v3 API the backend uses: searches by name and
/// parent with paging, media downloads, folder making, multipart, media and
/// resumable uploads, deletes, and expiring access tokens.
class FakeDrive {
  static final Uri api = Uri.parse('https://drive.example/drive/v3/');
  static final Uri upload = Uri.parse('https://drive.example/upload/drive/v3/');
  static const _folderType = 'application/vnd.google-apps.folder';

  /// In creation order, as `orderBy=createdTime` lists them.
  final List<DriveItem> items = [];
  final Map<String, ({String? id, Map<String, Object?> metadata})> _sessions =
      {};
  var _ids = 0;
  var _clock = 0;

  /// The token the fake accepts; others get 401.
  var validToken = 'token-1';
  var tokensGiven = 0;

  /// Results per page, small so that paging is exercised.
  var pageSize = 2;

  /// Every request, as "METHOD path uploadType".
  final List<String> requests = [];

  Future<String> token({bool renew = false}) async {
    tokensGiven++;
    return validToken;
  }

  late final http.Client client = MockClient(_handle);

  DriveItem? _byId(String id) =>
      items.where((item) => item.id == id).firstOrNull;

  http.Response _json(Object? json, [int status = 200]) =>
      http.Response(jsonEncode(json), status,
          headers: {'content-type': 'application/json'});

  Future<http.Response> _handle(http.Request request) async {
    final type = request.url.queryParameters['uploadType'];
    requests.add('${request.method} ${request.url.path}'
        '${type == null ? '' : ' $type'}');
    if (request.headers['Authorization'] != 'Bearer $validToken') {
      return http.Response('', 401);
    }
    final path = request.url.path;
    if (path.contains('/upload/session/')) return _finish(request);
    final segments = request.url.pathSegments;
    final id = segments.last == 'files' ? null : segments.last;
    final uploading = path.startsWith('/upload/');
    switch (request.method) {
      case 'GET' when id == null:
        return _list(request.url.queryParameters);
      case 'GET':
        final item = _byId(id!);
        return item == null
            ? http.Response('', 404)
            : http.Response.bytes(item.bytes, 200);
      case 'POST' || 'PATCH' when type == 'resumable':
        final session = 'https://drive.example/upload/session/${_ids++}';
        _sessions[session] = (
          id: id,
          metadata: jsonDecode(request.body) as Map<String, Object?>
        );
        return http.Response('', 200, headers: {'location': session});
      case 'POST' when !uploading:
        final metadata = jsonDecode(request.body) as Map<String, Object?>;
        final item = DriveItem('id${_ids++}', metadata['name'] as String,
            (metadata['parents'] as List).single as String,
            folder: metadata['mimeType'] == _folderType);
        items.add(item);
        return _json({'id': item.id});
      case 'POST' when type == 'multipart':
        final (metadata, bytes) = _multipart(request);
        return _json(_store(null, metadata, bytes).json);
      case 'PATCH' when type == 'media':
        final item = _byId(id!);
        if (item == null) return http.Response('', 404);
        return _json(_store(item, const {}, request.bodyBytes).json);
      case 'DELETE':
        final item = _byId(id!);
        if (item == null) return http.Response('', 404);
        items.remove(item);
        return http.Response('', 204);
    }
    return http.Response('', 400);
  }

  DriveItem _store(
      DriveItem? item, Map<String, Object?> metadata, Uint8List bytes) {
    item ??= DriveItem('id${_ids++}', metadata['name'] as String,
        (metadata['parents'] as List).single as String);
    if (!items.contains(item)) items.add(item);
    return item
      ..bytes = bytes
      ..modified = _clock++;
  }

  Future<http.Response> _finish(http.Request request) async {
    final session = _sessions.remove(request.url.toString());
    if (session == null) return http.Response('', 404);
    final existing = session.id == null ? null : _byId(session.id!);
    if (session.id != null && existing == null) return http.Response('', 404);
    return _json(_store(existing, session.metadata, request.bodyBytes).json);
  }

  (Map<String, Object?>, Uint8List) _multipart(http.Request request) {
    final boundary = request.headers['Content-Type']!.split('boundary=').last;
    // Latin-1 keeps every byte as one character, so the split is exact.
    final parts = latin1.decode(request.bodyBytes).split('--$boundary');
    String body(String part) =>
        part.substring(part.indexOf('\r\n\r\n') + 4, part.length - 2);
    return (
      jsonDecode(utf8.decode(latin1.encode(body(parts[1]))))
          as Map<String, Object?>,
      Uint8List.fromList(latin1.encode(body(parts[2]))),
    );
  }

  http.Response _list(Map<String, String> query) {
    final q = query['q']!;
    expect(q, endsWith(' and trashed = false'));
    String unquote(String value) =>
        value.replaceAll(r"\'", "'").replaceAll(r'\\', r'\');
    final name = RegExp(r"name = '((?:[^'\\]|\\.)*)'").firstMatch(q);
    final parent = RegExp(r"'((?:[^'\\]|\\.)*)' in parents").firstMatch(q)!;
    final folders = q.contains('mimeType = ');
    final matching = [
      for (final item in items)
        if (item.parent == unquote(parent[1]!) &&
            item.folder == folders &&
            (name == null || item.name == unquote(name[1]!)))
          item,
    ];
    final start = int.parse(query['pageToken'] ?? '0');
    final end = (start + pageSize).clamp(0, matching.length);
    return _json({
      'files': [for (final item in matching.sublist(start, end)) item.json],
      if (end < matching.length) 'nextPageToken': '$end',
    });
  }

  /// The path of [item] from the drive's root.
  String pathOf(DriveItem item) {
    final parent = _byId(item.parent);
    return parent == null ? item.name : '${pathOf(parent)}/${item.name}';
  }

  List<String> get paths => [for (final item in items) pathOf(item)];
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    sqfliteFfiInit();
  });

  GoogleDriveBackend backendFor(FakeDrive drive) => GoogleDriveBackend(
      api: FakeDrive.api,
      upload: FakeDrive.upload,
      token: drive.token,
      client: drive.client);

  test('files are written into made folders, listed, read and deleted',
      () async {
    final drive = FakeDrive();
    final backend = backendFor(drive);

    await backend.write('items/abc', Uint8List.fromList([1, 2]));

    expect(
        drive.paths, ['AID Diary', 'AID Diary/items', 'AID Diary/items/abc']);
    expect((await backend.list('items')).keys, ['items/abc']);
    expect(await backend.read('items/abc'), [1, 2]);
    expect(await backend.read('items/missing'), isNull);
    expect(await backend.list('blobs'), isEmpty);

    await backend.delete('items/abc');
    expect(await backend.list('items'), isEmpty);
    await backend.delete('items/abc');
  });

  test('a fresh backend finds what another one made, across pages', () async {
    final drive = FakeDrive();
    final writer = backendFor(drive);
    for (var i = 0; i < 5; i++) {
      await writer.write('items/$i', Uint8List.fromList([i]));
    }
    await writer.write('space.json', Uint8List.fromList([9]));

    final reader = backendFor(drive);
    expect((await reader.list('items')).keys,
        ['items/0', 'items/1', 'items/2', 'items/3', 'items/4']);
    expect(await reader.read('space.json'), [9]);
    expect(await backendFor(drive).read('items/3'), [3]);
  });

  test('writing again replaces the file and changes its version', () async {
    final drive = FakeDrive();
    final backend = backendFor(drive);
    final first = await backend.write('items/a', Uint8List.fromList([1]));
    final second = await backend.write('items/a', Uint8List.fromList([1, 2]));

    expect(first, isNot(second));
    expect((await backend.list('items'))['items/a'], second);
    expect(drive.items.where((item) => item.name == 'a'), hasLength(1));
    expect(drive.requests, contains('PATCH /upload/drive/v3/files/id2 media'));
  });

  test('a large file goes up in a resumable upload', () async {
    final drive = FakeDrive();
    final backend = backendFor(drive);
    final video = Uint8List(6 << 20)..[0] = 7;

    await backend.write('blobs/video', video);
    await backend.write('blobs/video', video);

    expect(drive.requests.where((r) => r.endsWith('resumable')), hasLength(2));
    expect((await backend.read('blobs/video'))![0], 7);
    expect(drive.items.where((item) => item.name == 'video'), hasLength(1));
  });

  test('an expired token is renewed once', () async {
    final drive = FakeDrive();
    final backend = backendFor(drive);
    await backend.write('items/a', Uint8List.fromList([1]));
    final given = drive.tokensGiven;

    drive.validToken = 'token-2';
    expect(await backend.read('items/a'), [1]);
    expect(drive.tokensGiven, given + 1);
  });

  test('devices racing to make the space folder settle on the oldest',
      () async {
    final drive = FakeDrive();
    drive.items
      ..add(DriveItem('first', 'AID Diary', 'root', folder: true))
      ..add(DriveItem('second', 'AID Diary', 'root', folder: true));

    await backendFor(drive).write('items/a', Uint8List.fromList([1]));

    expect(drive.paths, contains('AID Diary/items/a'));
    expect(
        drive.items.firstWhere((item) => item.name == 'items').parent, 'first');
  });

  test('a name with quotes is found again', () async {
    final drive = FakeDrive();
    await backendFor(drive).write("items/it's", Uint8List.fromList([4]));
    expect(await backendFor(drive).read("items/it's"), [4]);
  });

  test('two devices sync an encrypted diary through Google Drive', () async {
    final drive = FakeDrive();
    final keys = await SpaceEncryption.create('passphrase',
        kdf: const KdfParams(memoryKiB: 1024, iterations: 1));
    final cipher = ItemCipher(keys.key);
    final phone = await Device.create();
    final laptop = await Device.create();
    addTearDown(() async {
      await phone.db.close();
      await laptop.db.close();
    });

    await phone.write('written on the phone');
    await phone.sync(backendFor(drive), cipher: cipher);
    final report = await laptop.sync(backendFor(drive), cipher: cipher);

    expect(report.received, 1);
    expect(await laptop.texts(), ['written on the phone']);
    expect((await laptop.sync(backendFor(drive), cipher: cipher)).received, 0);
  });
}
