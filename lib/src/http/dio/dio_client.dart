import 'package:dio/dio.dart';
import 'package:gig_buddy/src/common/environment_manager/env_variables.dart';
import 'package:gig_buddy/src/common/environment_manager/environment_manager.dart';
import 'package:gig_buddy/src/http/dio/interface/i_dio_client.dart';

class DioClient extends IDioClient {
  factory DioClient({Interceptor? interceptor}) {
    _instance ??= DioClient._internal(interceptor: interceptor);
    return _instance!;
  }

  DioClient._internal({this.interceptor})
      : super(
          url: EnvironmentManager().getValue(EnvVariables.BASE_URL),
          interceptor: interceptor,
        );

  static DioClient? _instance;
  final Interceptor? interceptor;
}
