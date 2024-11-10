import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:gig_buddy/src/http/dio/model/request_state.dart';

@immutable
class ResponseEntity<T> extends Equatable {
  const ResponseEntity({
    required this.statusCode,
    this.message,
    this.data,
    this.status = RequestState.initialized,
  });

  factory ResponseEntity.error({
    String? message,
    int statusCode = 400,
    T? data,
  }) {
    return ResponseEntity(
      statusCode: statusCode,
      message: message,
      status: RequestState.error,
      data: data,
    );
  }

  factory ResponseEntity.initial({T? data, int statusCode = 200}) {
    return ResponseEntity(
      statusCode: statusCode,
      data: data,
    );
  }

  factory ResponseEntity.loading({T? data, int statusCode = 200}) {
    return ResponseEntity(
      statusCode: statusCode,
      data: data,
      status: RequestState.loading,
    );
  }

  factory ResponseEntity.success({T? data, int statusCode = 200}) {
    return ResponseEntity(
      statusCode: statusCode,
      data: data,
      status: RequestState.success,
    );
  }

  final int statusCode;
  final String? message;
  final T? data;
  final RequestState status;

  static Map<String, dynamic> toJson(ResponseEntity<dynamic> response) {
    final data = <String, dynamic>{};
    data['code'] = response.statusCode;
    data['message'] = response.message;
    data['data'] = response.data;
    return data;
  }

  bool get isOk => statusCode == 200 || statusCode == 201;

  @override
  List<Object?> get props => [statusCode, message, data, status];
}
