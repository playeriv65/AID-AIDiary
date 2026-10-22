// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['integration'])
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/storage/in_memory_file_store.dart';
import 'package:aid_diary/sync/sync_crypto.dart';
import 'package:aid_diary/sync/sync_engine.dart';
import 'package:aid_diary/sync/webdav_backend.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../support/sync_device.dart';

/// A small WebDAV server that behaves like real ones where it matters: 409
/// for a PUT into a missing folder, 405 for MKCOL on an existing one, and
/// separate property groups for found and missing properties.
class FakeDav {
  FakeDav({this.etags = true});

  final bool etags;
  final Map<String, Uint8List> files = {};
  final Map<String, String> modified = {};
  final Set<String> folders = {'/dav/'};
  final String authorization =
      'Basic ${base64.encode(utf8.encode('diary:secret'))}';
  var _clock = 0;

  /// Requests to fail as a dropped connection before any answer.
  var dropNext = 0;

  /// Every answer given, as "METHOD status".
  final List<String> answers = [];

  late final http.Client client = MockClient((request) async {
    if (dropNext > 0) {
      dropNext--;
      throw http.ClientException(
          'Connection closed before full header was received', request.url);
    }
    final response = await _handle(request);
    answers.add('${request.method} ${response.statusCode}');
    return response;
  });

  String _parent(String path) {
    final trimmed =
        path.endsWith('/') ? path.substring(0, path.length - 1) : path;
    return '${trimmed.substring(0, trimmed.lastIndexOf('/'))}/';
  }

  Future<http.Response> _handle(http.Request request) async {
    if (request.headers['Authorization'] != authorization) {
      return http.Response('', 401);
    }
    final path = Uri.decodeFull(request.url.path);
    switch (request.method) {
      case 'PROPFIND':
        if (!folders.contains(path)) return http.Response('', 404);
        final depth = request.headers['Depth'];
        final children = depth == '0'
            ? const <String>[]
            : [
                for (final file in files.keys)
                  if (_parent(file) == path) file,
                for (final folder in folders)
                  if (folder != path && _parent(folder) == path) folder,
              ];
        return http.Response.bytes(
            utf8.encode(_multistatus(path, children)), 207,
            headers: {'content-type': 'application/xml; charset=utf-8'});
      case 'GET':
        final bytes = files[path];
        return bytes == null
            ? http.Response('', 404)
            : http.Response.bytes(bytes, 200);
      case 'PUT':
        if (!folders.contains(_parent(path))) return http.Response('', 409);
        files[path] = request.bodyBytes;
        modified[path] =
            'Tue, 20 Oct 2026 10:00:${(_clock++).toString().padLeft(2, '0')} GMT';
        return http.Response('', 201,
            headers: etags ? {'etag': '"$_clock"'} : {});
      case 'DELETE':
        return http.Response('', files.remove(path) == null ? 404 : 204);
      case 'MKCOL':
        if (folders.contains(path)) return http.Response('', 405);
        if (!folders.contains(_parent(path))) return http.Response('', 409);
        folders.add(path);
        return http.Response('', 201);
    }
    return http.Response('', 405);
  }

  String _multistatus(String self, List<String> children) {
    String entry(String href) {
      final folder = href.endsWith('/');
      final found = folder
          ? '<d:resourcetype><d:collection/></d:resourcetype>'
          : '<d:resourcetype/>'
              '<d:getlastmodified>${modified[href]}</d:getlastmodified>'
              '<d:getcontentlength>${files[href]!.length}</d:getcontentlength>'
              '${etags ? '<d:getetag>"${modified[href]}"</d:getetag>' : ''}';
      return '<d:response><d:href>${Uri.encodeFull(href)}</d:href>'
          '<d:propstat><d:prop>$found</d:prop>'
          '<d:status>HTTP/1.1 200 OK</d:status></d:propstat>'
          '${etags ? '' : '<d:propstat><d:prop><d:getetag/></d:prop>'
              '<d:status>HTTP/1.1 404 Not Found</d:status></d:propstat>'}'
          '</d:response>';
    }

    return '<?xml version="1.0"?><d:multistatus xmlns:d="DAV:">'
        '${[self, ...children].map(entry).join()}</d:multistatus>';
  }
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    sqfliteFfiInit();
  });

  WebDavBackend backendFor(FakeDav server, {String password = 'secret'}) =>
      WebDavBackend(
          server: Uri.parse('https://dav.example/dav'),
          username: 'diary',
          password: password,
          client: server.client);

  test('files are written into made folders, listed, read and deleted',
      () async {
    final server = FakeDav();
    final dav = backendFor(server);

    await dav.write('items/abc', Uint8List.fromList([1, 2]));

    expect(server.folders,
        containsAll(['/dav/AID Diary/', '/dav/AID Diary/items/']));
    final listed = await dav.list('items');
    expect(listed.keys, ['items/abc']);
    expect(await dav.read('items/abc'), [1, 2]);
    expect(await dav.read('items/missing'), isNull);
    expect(await dav.list('blobs'), isEmpty);

    await dav.delete('items/abc');
    expect(await dav.list('items'), isEmpty);
  });

  test('a write makes its folder first instead of meeting a 409', () async {
    final server = FakeDav();
    final dav = backendFor(server);
    await dav.write('blobs/photo', Uint8List.fromList([7]));
    expect(server.answers, isNot(contains('PUT 409')));
    expect(server.answers.last, 'PUT 201');
    // A folder made once is not made again.
    server.answers.clear();
    await dav.write('blobs/other', Uint8List.fromList([8]));
    expect(server.answers, ['PUT 201']);
  });

  test('a dropped connection is tried once more', () async {
    final server = FakeDav();
    final dav = backendFor(server);
    await dav.write('items/abc', Uint8List.fromList([1]));
    server.dropNext = 1;
    expect(await dav.read('items/abc'), [1]);
    // Twice in a row is a real failure.
    server.dropNext = 2;
    expect(dav.read('items/abc'), throwsA(isA<http.ClientException>()));
  });

  test('versions fall back to the date and size without ETags', () async {
    final server = FakeDav(etags: false);
    final dav = backendFor(server);

    await dav.write('items/a', Uint8List.fromList([1]));
    final first = (await dav.list('items'))['items/a'];
    await dav.write('items/a', Uint8List.fromList([1, 2]));

    expect(first, isNotNull);
    expect((await dav.list('items'))['items/a'], isNot(first));
  });

  test('a wrong password is reported as such', () async {
    final dav = backendFor(FakeDav(), password: 'wrong');

    expect(
        dav.check(),
        throwsA(isA<WebDavException>()
            .having((e) => e.unauthorized, 'unauthorized', isTrue)));
  });

  test('two devices sync an encrypted diary through WebDAV', () async {
    final server = FakeDav();
    final keys = newDataKey();
    final devices = <Database>[];
    for (var i = 0; i < 2; i++) {
      final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath,
          options: OpenDatabaseOptions(singleInstance: false));
      await AppDatabase.instance.createSchema(db);
      devices.add(db);
    }
    addTearDown(() async {
      for (final db in devices) {
        await db.close();
      }
    });
    Future<SyncReport> sync(Database db) => SyncEngine(
            db: db,
            backend: backendFor(server),
            photos: FileStorePhotos(InMemoryFileStore()),
            limits: testLimits,
            cipher: ItemCipher(keys))
        .sync();

    await devices[0].insert(entriesTable, {
      EntryFields.text: '坚果云 works',
      EntryFields.timeCreate: '2026-10-20T09:00:00.000',
      EntryFields.timeModified: '2026-10-20T09:00:00.000',
    });
    await sync(devices[0]);
    final report = await sync(devices[1]);

    expect(report.received, 1);
    expect((await devices[1].query(entriesTable)).single[EntryFields.text],
        '坚果云 works');
    expect((await sync(devices[1])).received, 0);
  });
}
