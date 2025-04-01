import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class WarningInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _checkForErrors(response);
    if (response.statusCode == HttpStatus.forbidden) {
      debugPrint('*** Forbidden ***: ${response.data}');
    }
    handler.next(response);
  }

  void _checkForErrors(Response response) {}
}
