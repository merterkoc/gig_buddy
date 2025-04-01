import 'package:device_info/device_info.dart';

class DeviceInfoHelper {
  factory DeviceInfoHelper() => _instance;

  DeviceInfoHelper._();

  static final DeviceInfoHelper _instance = DeviceInfoHelper._();

  static late final IosDeviceInfo iosDeviceInfo;

  static Future<void> init() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    iosDeviceInfo = await deviceInfoPlugin.iosInfo;
  }

  static String get deviceName => iosDeviceInfo.name;

  static String get deviceModel => iosDeviceInfo.model;

  static String get systemName => iosDeviceInfo.systemName;

  static String get systemVersion => iosDeviceInfo.systemVersion;
}
