// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aid_diary/sync/sync_backend.dart';
import 'package:http/http.dart' as http;

/// Gives an access token for the Drive API: a fresh one when [renew] is set,
/// after the last one was refused.
typedef DriveToken = Future<String> Function({bool renew});

class GoogleDriveException implements Exception {
  const GoogleDriveException(this.method, this.path, this.status);

  final String method;
  final String path;
  final int status;

  bool get unauthorized => status == 401;

  @override
  String toString() => 'Google Drive $method $path failed with HTTP $status';
}

/// A space in a folder of the user's Google Drive. With the `drive.file`
/// scope the app sees only what it made itself, so the folder is found by
/// name and the user's other files stay out of reach.
class GoogleDriveBackend implements SyncBackend {
  GoogleDriveBackend(
      {required Uri api,
      required Uri upload,
      required DriveToken token,
      this.folder = defaultFolder,
      http.Client? client})
      : _api = api,
        _upload = upload,
        _token = token,
        _client = client ?? http.Client();

  static const String defaultFolder = 'AID Diary';
  static const String scope = 'https://www.googleapis.com/auth/drive.file';

  final Uri _api;
  final Uri _upload;
  static const String _folderType = 'application/vnd.google-apps.folder';

  /// Larger files go up in a resumable upload rather than in one request
  /// with their metadata.
  static const int _simpleUploadLimit = 5 << 20;

  final String folder;
  final DriveToken _token;
  final http.Client _client;
  String? _accessToken;

  /// Drive ids of the folders found or made, by path ('' is the space).
  final Map<String, String> _folderIds = {};

  /// Drive ids of files, by path, from listings and lookups.
  final Map<String, String> _fileIds = {};

  Uri _uri(Uri base, String path, [Map<String, String>? query]) =>
      base.resolve(path).replace(queryParameters: query);

  /// Sends a request with the access token. A refused token is renewed
  /// once, a dropped connection is tried once more, and rate limits and
  /// server errors are waited out a few times.
  Future<http.Response> _send(String method, Uri uri,
      {Map<String, String> headers = const {}, List<int>? body}) async {
    Future<http.Response> attempt() async {
      final request = http.Request(method, uri)
        ..headers.addAll({
          'Authorization': 'Bearer ${_accessToken ??= await _token()}',
          ...headers,
        });
      if (body != null) request.bodyBytes = body;
      return http.Response.fromStream(await _client.send(request));
    }

    Future<http.Response> connected() async {
      try {
        return await attempt();
      } on http.ClientException {
        return attempt();
      } on SocketException {
        return attempt();
      }
    }

    var response = await connected();
    if (response.statusCode == 401) {
      _accessToken = await _token(renew: true);
      response = await connected();
    }
    for (var wait = 1;
        wait <= 4 && (response.statusCode == 429 || response.statusCode >= 500);
        wait *= 2) {
      await Future<void>.delayed(Duration(seconds: wait));
      response = await connected();
    }
    return response;
  }

  Map<String, Object?> _json(
      String method, String path, http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw GoogleDriveException(method, path, response.statusCode);
    }
    return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, Object?>;
  }

  static String _quote(String value) =>
      "'${value.replaceAll(r'\', r'\\').replaceAll("'", r"\'")}'";

  /// Every page of a search, oldest first so that devices racing to make
  /// the same folder settle on the same one.
  Future<List<Map<String, Object?>>> _search(String path, String q) async {
    final found = <Map<String, Object?>>[];
    String? page;
    do {
      final response = await _send(
          'GET',
          _uri(_api, 'files', {
            'q': '$q and trashed = false',
            'fields': 'nextPageToken,files(id,name,md5Checksum,modifiedTime)',
            'orderBy': 'createdTime',
            'pageSize': '1000',
            'spaces': 'drive',
            if (page != null) 'pageToken': page,
          }));
      final json = _json('LIST', path, response);
      found.addAll((json['files'] as List).cast<Map<String, Object?>>());
      page = json['nextPageToken'] as String?;
    } while (page != null);
    return found;
  }

  /// The Drive id of the folder at [path], made when [make] is set; null
  /// when it is missing.
  Future<String?> _folderId(String path, {bool make = false}) async {
    final known = _folderIds[path];
    if (known != null) return known;
    final String parentId;
    final String name;
    if (path.isEmpty) {
      parentId = 'root';
      name = folder;
    } else {
      final cut = path.lastIndexOf('/');
      final parent =
          await _folderId(cut < 0 ? '' : path.substring(0, cut), make: make);
      if (parent == null) return null;
      parentId = parent;
      name = path.substring(cut + 1);
    }
    final existing = await _search(
        path,
        'name = ${_quote(name)} and ${_quote(parentId)} in parents '
        'and mimeType = ${_quote(_folderType)}');
    var id = existing.firstOrNull?['id'] as String?;
    if (id == null && make) {
      final response =
          await _send('POST', _uri(_api, 'files', {'fields': 'id'}),
              headers: {'Content-Type': 'application/json'},
              body: utf8.encode(jsonEncode({
                'name': name,
                'mimeType': _folderType,
                'parents': [parentId],
              })));
      id = _json('MKDIR', path, response)['id'] as String;
    }
    if (id != null) _folderIds[path] = id;
    return id;
  }

  ({String parent, String name}) _split(String path) {
    final cut = path.lastIndexOf('/');
    return cut < 0
        ? (parent: '', name: path)
        : (parent: path.substring(0, cut), name: path.substring(cut + 1));
  }

  Future<String?> _fileId(String path) async {
    final known = _fileIds[path];
    if (known != null) return known;
    final (:parent, :name) = _split(path);
    final parentId = await _folderId(parent);
    if (parentId == null) return null;
    final found = await _search(
        path,
        'name = ${_quote(name)} and ${_quote(parentId)} in parents '
        'and mimeType != ${_quote(_folderType)}');
    final id = found.lastOrNull?['id'] as String?;
    if (id != null) _fileIds[path] = id;
    return id;
  }

  @override
  Future<void> check() async {
    await _folderId('', make: true);
  }

  @override
  Future<Map<String, String>> list(String path) async {
    final id = await _folderId(path);
    if (id == null) return {};
    final files = <String, String>{};
    // Oldest first, so of two files that raced to the same name the newer
    // one wins, as it would on a file system.
    for (final file in await _search(path,
        '${_quote(id)} in parents and mimeType != ${_quote(_folderType)}')) {
      final filePath = '${path.isEmpty ? '' : '$path/'}${file['name']}';
      _fileIds[filePath] = file['id'] as String;
      files[filePath] = (file['md5Checksum'] ?? file['modifiedTime']) as String;
    }
    return files;
  }

  @override
  Future<Uint8List?> read(String path) async {
    final id = await _fileId(path);
    if (id == null) return null;
    final response =
        await _send('GET', _uri(_api, 'files/$id', {'alt': 'media'}));
    if (response.statusCode == 404) {
      _fileIds.remove(path);
      return null;
    }
    if (response.statusCode != 200) {
      throw GoogleDriveException('GET', path, response.statusCode);
    }
    return response.bodyBytes;
  }

  @override
  Future<String?> write(String path, Uint8List bytes) async {
    final (:parent, :name) = _split(path);
    final parentId = (await _folderId(parent, make: true))!;
    final id = await _fileId(path);
    if (id != null) {
      final response = await _put(path, bytes, id: id);
      if (response.statusCode != 404) return _written(path, response);
      // Gone meanwhile: make it anew.
      _fileIds.remove(path);
    }
    return _written(
        path,
        await _put(path, bytes, metadata: {
          'name': name,
          'parents': [parentId]
        }));
  }

  String? _written(String path, http.Response response) {
    final json = _json('PUT', path, response);
    _fileIds[path] = json['id'] as String;
    return json['md5Checksum'] as String?;
  }

  /// Uploads [bytes] as the file [id], or as a new file with [metadata].
  Future<http.Response> _put(String path, Uint8List bytes,
      {String? id, Map<String, Object?>? metadata}) async {
    final target = id == null ? 'files' : 'files/$id';
    final method = id == null ? 'POST' : 'PATCH';
    const fields = 'id,md5Checksum';
    if (bytes.length > _simpleUploadLimit) {
      final session = await _send(method,
          _uri(_upload, target, {'uploadType': 'resumable', 'fields': fields}),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'X-Upload-Content-Type': 'application/octet-stream',
            'X-Upload-Content-Length': '${bytes.length}',
          },
          body: utf8.encode(jsonEncode(metadata ?? const {})));
      final location = session.headers['location'];
      if (session.statusCode != 200 || location == null) return session;
      return _send('PUT', Uri.parse(location),
          headers: {'Content-Type': 'application/octet-stream'}, body: bytes);
    }
    if (metadata == null) {
      return _send(method,
          _uri(_upload, target, {'uploadType': 'media', 'fields': fields}),
          headers: {'Content-Type': 'application/octet-stream'}, body: bytes);
    }
    const boundary = 'aid-diary-part';
    final body = BytesBuilder(copy: false)
      ..add(utf8.encode('--$boundary\r\n'
          'Content-Type: application/json; charset=UTF-8\r\n\r\n'
          '${jsonEncode(metadata)}\r\n'
          '--$boundary\r\n'
          'Content-Type: application/octet-stream\r\n\r\n'))
      ..add(bytes)
      ..add(utf8.encode('\r\n--$boundary--'));
    return _send(method,
        _uri(_upload, target, {'uploadType': 'multipart', 'fields': fields}),
        headers: {'Content-Type': 'multipart/related; boundary=$boundary'},
        body: body.takeBytes());
  }

  @override
  Future<void> delete(String path) async {
    final id = await _fileId(path);
    if (id == null) return;
    final response = await _send('DELETE', _uri(_api, 'files/$id'));
    _fileIds.remove(path);
    if (response.statusCode == 404) return;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw GoogleDriveException('DELETE', path, response.statusCode);
    }
  }

  void close() => _client.close();
}
