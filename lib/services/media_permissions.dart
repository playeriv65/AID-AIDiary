// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';

import 'package:aid_diary/device_info_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

/// The Android API level: read at start-up, or asked now.
Future<int> _androidSdk() async =>
    DeviceInfoService().androidSdk ??
    (await DeviceInfoPlugin().androidInfo).version.sdkInt;

/// Android 13 (API 33) split storage access into per-media permissions.
const _mediaPermissionsSdk = 33;

/// Whether [permission] is granted, asking for it when it is not yet.
/// Access to some photos only (Android 14's selection) counts.
Future<bool> _request(Permission permission) async {
  final status = await permission.status;
  if (status.isGranted || status.isLimited) return true;
  final asked = await permission.request();
  return asked.isGranted || asked.isLimited;
}

/// Asks to read the device's photos: READ_MEDIA_IMAGES from Android 13,
/// storage before. True off Android, where no permission applies.
Future<bool> requestPhotoAccess() async {
  if (!Platform.isAndroid) return true;
  return _request(await _androidSdk() >= _mediaPermissionsSdk
      ? Permission.photos
      : Permission.storage);
}

/// Asks for storage access before picking a folder, which Android before 13
/// needs; newer versions grant the folder through the picker itself.
Future<bool> requestFolderAccess() async {
  if (!Platform.isAndroid || await _androidSdk() >= _mediaPermissionsSdk) {
    return true;
  }
  return _request(Permission.storage);
}

/// Asks to read where photos were taken (ACCESS_MEDIA_LOCATION, Android 10
/// and later; earlier versions do not hide it).
Future<bool> requestPhotoLocations() async {
  if (!Platform.isAndroid || await _androidSdk() < 29) return true;
  return _request(Permission.accessMediaLocation);
}
