import 'package:package_info_plus/package_info_plus.dart';

export 'package:package_info_plus/package_info_plus.dart';

class PackageInfoHelper {
  PackageInfoHelper._();

  static final PackageInfoHelper _instance = PackageInfoHelper._();

  factory PackageInfoHelper() => _instance;

  static late final PackageInfo packageInfo;

  static Future<void> init() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  static String get appName => packageInfo.appName;

  static String get packageName => packageInfo.packageName;

  static String get version => packageInfo.version;

  static String get buildNumber => packageInfo.buildNumber;

  static String get buildSignature => packageInfo.buildSignature;
}
