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
    this.displayMessage,
  });

  factory ResponseEntity.error({
    String? message,
    String? displayMessage,
    int statusCode = 400,
    T? data,
  }) {
    return ResponseEntity(
      statusCode: statusCode,
      message: message,
      displayMessage: displayMessage,
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

  factory ResponseEntity.success({
    T? data,
    int statusCode = 200,
    String? displayMessage,
  }) {
    return ResponseEntity(
      statusCode: statusCode,
      data: data,
      displayMessage: displayMessage,
      status: RequestState.success,
    );
  }

  final int statusCode;
  final String? message;
  // TODO(mert): change to private
  final T? data;
  final RequestState status;
  final String? displayMessage;

  static Map<String, dynamic> toJson(ResponseEntity<dynamic> response) {
    final data = <String, dynamic>{};
    data['code'] = response.statusCode;
    data['message'] = response.message;
    data['data'] = (response.data as Map<String, dynamic>)['data'];
    return data;
  }

  bool get isOk => statusCode == 200 || statusCode == 201;

  T? get result {
    if (data == null) return null;
    if (data is Map<String, dynamic>) {
      return (data! as Map<String, dynamic>)['data'] as T?;
    } else if (data is List<dynamic>) {
      return (data! as List<dynamic>).cast<T?>() as T?;
    } else {
      throw Exception('Unknown data type');
    }
  }

  ResponseEntity<T> copyWith({
    int? statusCode,
    String? message,
    T? data,
    RequestState? status,
    String? displayMessage,
  }) {
    return ResponseEntity(
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
      data: data ?? this.data,
      status: status ?? this.status,
      displayMessage: displayMessage ?? this.displayMessage,
    );
  }

  @override
  List<Object?> get props => [statusCode, message, data, status, displayMessage, isOk];
}
