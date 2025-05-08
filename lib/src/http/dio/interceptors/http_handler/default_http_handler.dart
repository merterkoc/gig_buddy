import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gig_buddy/src/helper/device_info/device_info_helper.dart';
import 'package:gig_buddy/src/helper/device_info/package_info_helper.dart';

/// [DefaultHttpHeaderInterceptor] is used to send default http headers during
/// network request.
class DefaultHttpHeaderInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final deviceInfo = DeviceInfoHelper.deviceInfo;
    final packageInfo = PackageInfoHelper.packageInfo;
    final lang = Platform.localeName.replaceAll('_', '-');
    final locale = Platform.localeName.split('_')[1];
    options.headers.addAll({
      'Content-Type': 'application/json',
      'platform': 2,
      'language': lang,
      'country': locale,
      'app_version': packageInfo.version,
    });
    handler.next(options);
  }
}
