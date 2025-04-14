import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoHelper {
  factory DeviceInfoHelper() => _instance;

  DeviceInfoHelper._();

  static final DeviceInfoHelper _instance = DeviceInfoHelper._();

  static late final BaseDeviceInfo deviceInfo;

  static Future<void> init() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      deviceInfo = await deviceInfoPlugin.androidInfo;
    } else if (Platform.isIOS) {
      deviceInfo = await deviceInfoPlugin.iosInfo;
    } else {
      throw Exception('Unsupported platform');
    }
  }

  static String get deviceName => Platform.isAndroid
      ? (deviceInfo as AndroidDeviceInfo).name
      : (deviceInfo as IosDeviceInfo).name;

  static String get deviceModel => Platform.isAndroid
      ? (deviceInfo as AndroidDeviceInfo).model
      : (deviceInfo as IosDeviceInfo).model;

  static String get systemName => Platform.isAndroid
      ? (deviceInfo as AndroidDeviceInfo).brand
      : (deviceInfo as IosDeviceInfo).utsname.machine;

  static String get systemVersion => Platform.isAndroid
      ? (deviceInfo as AndroidDeviceInfo).version.release
      : (deviceInfo as IosDeviceInfo).systemVersion;


  // static String? get identifierForVendor => Platform.isAndroid
  //     ? (deviceInfo as AndroidDeviceInfo).id
  //     : (deviceInfo as IosDeviceInfo).identifierForVendor;
}
