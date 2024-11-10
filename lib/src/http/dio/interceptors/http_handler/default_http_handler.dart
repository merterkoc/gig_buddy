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
    final iosDeviceInfo = DeviceInfoHelper.iosDeviceInfo;
    final packageInfo = PackageInfoHelper.packageInfo;
    final lang = Platform.localeName.replaceAll('_', '-');
    final locale = Platform.localeName.split('_')[1];
    options.headers.addAll({
      'Content-Type': 'application/json',
      'platform': 2,
      'language': lang,
      'country': locale,
      'app_version': packageInfo.version,
      'device': iosDeviceInfo.identifierForVendor,
      'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NDM2MjI3MzksImlhdCI6MTc0MzUzNjMzOSwicm9sZSI6InVzZXIiLCJ1c2VyaWQiOiJlYjU3ZTI1YS04OThjLTQ0MjQtYmM3NS05Y2Q1MDI0MWQ0ZmYiLCJ1c2VybmFtZSI6ImViNTdlMjVhLTg5OGMtNDQyNC1iYzc1LTljZDUwMjQxZDRmZiJ9.cZaSgwuUZtK8WCGxHfzhuKNz5EAwJ73dv-Idfg-6mSA',
    });
    handler.next(options);
  }
}
