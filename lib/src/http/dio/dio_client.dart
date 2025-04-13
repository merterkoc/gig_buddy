import 'package:dio/dio.dart';
import 'package:gig_buddy/src/http/dio/interface/i_dio_client.dart';

class DioClient extends IDioClient {
  factory DioClient({Interceptor? interceptor}) {
    _instance ??= DioClient._internal(interceptor: interceptor);
    return _instance!;
  }

  DioClient._internal({this.interceptor})
      : super(
          url: 'https://mastiff-splendid-sadly.ngrok-free.app/',
          interceptor: interceptor,
        );

  static DioClient? _instance;
  final Interceptor? interceptor;
}
