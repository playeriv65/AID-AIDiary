// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:typed_data';

import 'package:aid_diary/sync/sync_backend.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class WebDavException implements Exception {
  const WebDavException(this.method, this.path, this.status);

  final String method;
  final String path;
  final int status;

  bool get unauthorized => status == 401 || status == 403;

  @override
  String toString() => 'WebDAV $method $path failed with HTTP $status';
}

/// A space in a folder of a WebDAV server: Nextcloud, ownCloud, Synology,
/// Jianguoyun (坚果云) and the like.
class WebDavBackend implements SyncBackend {
  WebDavBackend(
      {required Uri server,
      required String username,
      required String password,
      this.folder = defaultFolder,
      http.Client? client})
      : _server = server.path.endsWith('/')
            ? server
            : server.replace(path: '${server.path}/'),
        _authorization =
            'Basic ${base64.encode(utf8.encode('$username:$password'))}',
        _client = client ?? http.Client();

  /// The folder the space lives in, inside the server's address.
  static const String defaultFolder = 'AID Diary';

  final Uri _server;
  final String folder;
  final String _authorization;
  final http.Client _client;
  final Set<String> _madeFolders = {};

  Uri _uri(String path, {bool directory = false}) {
    final segments = [
      ..._server.pathSegments.where((segment) => segment.isNotEmpty),
      folder,
      ...path.split('/').where((segment) => segment.isNotEmpty),
    ];
    return _server.replace(pathSegments: [...segments, if (directory) '']);
  }

  Future<http.Response> _send(String method, Uri uri,
      {Map<String, String> headers = const {}, List<int>? body}) async {
    final request = http.Request(method, uri)
      ..headers.addAll({'Authorization': _authorization, ...headers});
    if (body != null) request.bodyBytes = body;
    return http.Response.fromStream(await _client.send(request));
  }

  WebDavException _failure(
          String method, String path, http.Response response) =>
      WebDavException(method, path, response.statusCode);

  /// Signs in and makes sure the space folder exists, so wrong addresses
  /// and passwords show up at once.
  Future<void> check() async {
    final response = await _send('PROPFIND', _server, headers: {'Depth': '0'});
    if (response.statusCode != 207) {
      throw _failure('PROPFIND', _server.path, response);
    }
    await _makeFolder('');
  }

  @override
  Future<Map<String, String>> list(String path) async {
    final uri = _uri(path, directory: true);
    final response = await _send('PROPFIND', uri,
        headers: {'Depth': '1', 'Content-Type': 'application/xml'},
        body: utf8.encode(_propfindBody));
    if (response.statusCode == 404) return {};
    if (response.statusCode != 207) {
      throw _failure('PROPFIND', path, response);
    }
    final files = <String, String>{};
    final document = XmlDocument.parse(utf8.decode(response.bodyBytes));
    for (final item
        in document.findAllElements('response', namespaceUri: '*')) {
      final href = item.getElement('href', namespaceUri: '*')?.innerText;
      if (href == null) continue;
      // Servers report found and missing properties in separate groups.
      final found = [
        for (final group in item.findAllElements('propstat', namespaceUri: '*'))
          if (group
                  .getElement('status', namespaceUri: '*')
                  ?.innerText
                  .contains(' 200 ') ??
              false)
            ...group.findAllElements('prop', namespaceUri: '*'),
      ];
      final isFolder = found.any((prop) =>
          prop.findAllElements('collection', namespaceUri: '*').isNotEmpty);
      final name = Uri.decodeFull(Uri.parse(href)
          .pathSegments
          .lastWhere((segment) => segment.isNotEmpty, orElse: () => ''));
      if (isFolder || name.isEmpty || found.isEmpty) continue;
      String? field(String name) => found
          .map((prop) =>
              prop.getElement(name, namespaceUri: '*')?.innerText.trim())
          .nonNulls
          .where((value) => value.isNotEmpty)
          .firstOrNull;
      final version = field('getetag') ??
          '${field('getlastmodified')}|${field('getcontentlength')}';
      files['${path.isEmpty ? '' : '$path/'}$name'] = version;
    }
    return files;
  }

  @override
  Future<Uint8List?> read(String path) async {
    final response = await _send('GET', _uri(path));
    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) throw _failure('GET', path, response);
    return response.bodyBytes;
  }

  @override
  Future<String?> write(String path, Uint8List bytes) async {
    var response = await _put(path, bytes);
    if (response.statusCode == 409 || response.statusCode == 404) {
      // The folder is missing.
      final parent =
          path.contains('/') ? path.substring(0, path.lastIndexOf('/')) : '';
      await _makeFolder(parent);
      response = await _put(path, bytes);
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw _failure('PUT', path, response);
    }
    return response.headers['etag'];
  }

  Future<http.Response> _put(String path, Uint8List bytes) =>
      _send('PUT', _uri(path),
          headers: {'Content-Type': 'application/octet-stream'}, body: bytes);

  @override
  Future<void> delete(String path) async {
    final response = await _send('DELETE', _uri(path));
    if (response.statusCode == 404) return;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw _failure('DELETE', path, response);
    }
  }

  /// Makes [path] and the folders above it, inside the space folder.
  Future<void> _makeFolder(String path) async {
    final parts = path.split('/').where((part) => part.isNotEmpty).toList();
    for (var depth = 0; depth <= parts.length; depth++) {
      final folder = parts.take(depth).join('/');
      if (_madeFolders.contains(folder)) continue;
      final response = await _send('MKCOL', _uri(folder, directory: true));
      // 405: it already exists.
      if (response.statusCode != 201 && response.statusCode != 405) {
        throw _failure('MKCOL', folder, response);
      }
      _madeFolders.add(folder);
    }
  }

  void close() => _client.close();
}

const String _propfindBody = '<?xml version="1.0" encoding="utf-8"?>'
    '<d:propfind xmlns:d="DAV:"><d:prop>'
    '<d:resourcetype/><d:getetag/><d:getlastmodified/><d:getcontentlength/>'
    '</d:prop></d:propfind>';
