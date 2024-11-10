import 'package:fresh_dio/fresh_dio.dart';

extension AuthenticationStatusExtension on AuthenticationStatus {
  bool get isAuthenticated => this == AuthenticationStatus.authenticated;

  bool get isUnauthenticated => this == AuthenticationStatus.unauthenticated;
}
