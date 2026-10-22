import 'dart:io';

import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/device_info_service.dart';
import 'package:uuid/uuid.dart';

/// A device-local label and stable identifier, never a diary profile or a key.
abstract final class LocalDevice {
  static String get name {
    final saved = ConfigProvider.instance.get(Settings.deviceName).trim();
    if (validName(saved)) return saved;
    final fallback = (DeviceInfoService().model ?? Platform.localHostname)
        .replaceAll(RegExp(r'[\x00-\x1f\x7f]'), '')
        .trim();
    return String.fromCharCodes(
        (fallback.isEmpty ? Platform.operatingSystem : fallback)
            .runes
            .take(32));
  }

  static bool validName(String value) =>
      value.trim().isNotEmpty &&
      value.trim().runes.length <= 32 &&
      !value.contains(RegExp(r'[\x00-\x1f\x7f]'));

  static Future<void> rename(String value) async {
    if (!validName(value)) {
      throw const FormatException('Invalid device name');
    }
    await ConfigProvider.instance.set(Settings.deviceName, value.trim());
  }

  static Future<String> id() async {
    final config = ConfigProvider.instance;
    var id = config.get(Settings.syncDeviceId);
    if (id.isEmpty) {
      id = const Uuid().v4();
      await config.set(Settings.syncDeviceId, id);
    }
    return id;
  }
}
