import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/common/firebase/manager/auth_manager.dart';
import 'package:gig_buddy/src/http/dio/dio_client.dart';
import 'package:gig_buddy/src/route/router.dart';

mixin AuthenticationRouterListener {
  static AuthenticationStatus _currentAuthenticationStatus =
      AuthenticationStatus.initial;
  static late StreamSubscription<AuthenticationStatus> _subscription;
  static final StreamController<AuthenticationStatus>
      _authenticationStatusController =
      StreamController<AuthenticationStatus>.broadcast();
  static DioClient dioClient = DioClient();

  static void listen() {
    _subscription =
        dioClient.authenticationStatus.listen(onAuthenticationChanged);
  }

  static void onAuthenticationChanged(
    AuthenticationStatus authenticationStatus,
  ) {
    _currentAuthenticationStatus = authenticationStatus;
    if (authenticationStatus == AuthenticationStatus.authenticated) {
      debugPrint('Authenticated');
      if (!goRouter.state!.fullPath!.contains(AppRoute.homeView.name)) {
        goRouter.go(AppRoute.homeView.path);
      }
      //FlutterNativeSplash.remove();
    } else if (authenticationStatus == AuthenticationStatus.unauthenticated) {
      debugPrint('Unauthenticated');
      goRouter.goNamed(AppRoute.loginView.name);
      //FlutterNativeSplash.remove();
    }
    _authenticationStatusController.add(authenticationStatus);
  }

  static void dispose() {
    _subscription.cancel();
  }

  static AuthenticationStatus get currentAuthenticationStatus =>
      _currentAuthenticationStatus;

  Stream<AuthenticationStatus> get authenticationStatusStream =>
      _authenticationStatusController.stream;
}
