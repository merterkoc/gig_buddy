import 'package:dio/dio.dart';
import 'package:fresh_dio/fresh_dio.dart';

import 'package:gig_buddy/src/http/dio/interceptors/http_handler/default_http_handler.dart';
import 'package:gig_buddy/src/http/dio/interceptors/warning/warning_interceptor.dart';
import 'package:gig_buddy/src/http/dio/model/response_entity.dart';
import 'package:gig_buddy/src/http/dio/token_storage/token_storage.dart';
export 'package:gig_buddy/src/http/dio/extensions/authentication_status_extension.dart';

/// [IDioClient] is used to handle http rest api calls.
abstract class IDioClient {
  IDioClient({
    required String url,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Interceptor? interceptor,
  }) {
    baseUrl = url;
    _dio
      ..options.baseUrl = url.endsWith('/') ? url : '$url/'
      ..options.connectTimeout = connectTimeout ?? const Duration(seconds: 20)
      ..options.receiveTimeout = receiveTimeout ?? const Duration(seconds: 20)
      ..options.responseType = ResponseType.json
      ..interceptors.add(interceptor ?? DefaultHttpHeaderInterceptor())
      ..interceptors.addAll(
        [
          WarningInterceptor(),
          LogInterceptor(
            requestBody: true,
            responseBody: true,
          ),
        ],
      )
      ..interceptors.add(_fresh);
  }

  late final String baseUrl;

  final Dio _dio = Dio();

  final _fresh = Fresh.oAuth2(
    tokenHeader: (token) {
      return {
        'Authorization': token.accessToken,
      };
    },
    tokenStorage: TokenStorageImpl(),
    shouldRefresh: (response) {
      return response?.statusCode == 401 || response?.statusCode == 403;
    },
    refreshToken: (token, client) {
      throw RevokeTokenException();
    },
  );

  /// http get call
  Future<ResponseEntity<T>> get<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<T>(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      if (response.statusCode == 200) {}
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// http post call
  Future<ResponseEntity<T>> post<T>(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post<T>(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// http put call
  Future<ResponseEntity<T>> put<T>(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put<T>(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// http delete call
  Future<ResponseEntity<T>> delete<T>(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete<T>(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseEntity<T>> patch<T>(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.patch<T>(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }


  Future<ResponseEntity<T>> _handleResponse<T>(
    Response<T> response,
  ) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Future.value(
        ResponseEntity<T>.success(
          statusCode: response.statusCode!,
          data: response.data as T,
        ),
      );
    } else {
      return Future.value(
        ResponseEntity.error(
          message: response.statusMessage,
          statusCode: response.statusCode!,
        ),
      );
    }
  }

  Future<ResponseEntity<T>> _handleError<T>(
    dynamic e,
  ) {
    final error = e as DioException;
    if (error.response != null) {
      return Future.value(
        ResponseEntity<T>.error(
          statusCode: error.response!.statusCode!,
          message: getMessage(error),
          data:
              error.response!.statusCode == 200 && error.response?.data != null
                  ? error.response?.data as T
                  : null,
        ),
      );
    } else {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return Future.value(
          ResponseEntity<T>.error(
            statusCode: 408,
            message: 'Connection timeout',
          ),
        );
      } else {
        return Future.value(
          ResponseEntity<T>.error(
            statusCode: 601,
            message: 'Unknown error',
          ),
        );
      }
    }
  }

  String? getMessage(DioException error) {
    try {
      return (error.response?.data is String
              ? error.response?.data
              : (error.response?.data['message'] != null)
                  ? error.response?.data['message']
                  : error.response?.data['error'] ??
                      'Error message not found') as String?;
    } catch (e) {
      return null;
    }
  }

  /// Listener for authorization status changes
  Stream<AuthenticationStatus> get authenticationStatus =>
      _fresh.authenticationStatus;

  Future<void> setToken(OAuth2Token token) => _fresh.setToken(token);

  void logout() {
    _fresh.clearToken();
  }
}
