import 'package:dio/dio.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:gig_buddy/src/http/dio/dio_client.dart';
import 'package:gig_buddy/src/http/dio/model/response_entity.dart';

abstract class ApiProvider {
  ApiProvider(this._path, {this.interceptor});

  late final DioClient _dio = DioClient(interceptor: interceptor);

  final String _path;

  final Interceptor? interceptor;

  Future<ResponseEntity<dynamic>> get({
    /// The resource path
    /// e.g. delete
    /// delete is the resource
    /// if you set resource to 'delete', your url like this
    /// http://localhost:8080/yourPath/delete
    String? resource,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    resource ??= '';
    final response = await _dio.get<dynamic>(
      resource == '' ? _path : '$_path/$resource',
      queryParameters: queryParameters,
    );
    return response;
  }

  Future<ResponseEntity<dynamic>> post({
    String? resource,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '$_path/$resource',
      queryParameters: queryParameters,
      data: data,
      options: options,
      cancelToken: cancelToken,
    );
    return response;
  }

  Future<ResponseEntity<dynamic>> put({
    String? resource,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    final response = await _dio.put<Map<String, dynamic>>(
      '$_path/$resource',
      queryParameters: queryParameters,
      data: data,
      options: options,
      cancelToken: cancelToken,
    );
    return response;
  }

  Future<ResponseEntity<dynamic>> delete({
    String? resource,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.delete<Map<String, dynamic>>(
      '$_path/$resource',
      queryParameters: queryParameters,
    );
    return response;
  }

  Future<ResponseEntity<dynamic>> patch({
    String? resource,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    String url = [_path, resource]
        .where((e) => e != null && e.isNotEmpty)
        .join('/');

    if (url.endsWith('/')) {
      url = url.substring(0, url.length - 1);
    }

    final response = await _dio.patch<Map<String, dynamic>>(
      url,
      queryParameters: queryParameters,
      data: data,
    );
    return response;
  }

  Future<void> deleteById(String id) async {
    await _dio.delete<Map<String, dynamic>>('$_path/$id');
  }

  Future<void> setToken(OAuth2Token token) async {
    await _dio.setToken(token);
  }

  void logout() {
    _dio.logout();
  }
}
