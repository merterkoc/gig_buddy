import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fresh/src/fresh.dart';
import 'package:gig_buddy/src/route/authentication_listener.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>
    with AuthenticationRouterListener {
  AuthBloc() : super(AuthInitial()) {
    _authStateStream = authenticationStatusStream.listen((status) {
      add(AuthStateChanged(status));
    });

    on<AuthStateChanged>(
      (event, emit) {
        if (event.status == AuthenticationStatus.authenticated) {
          emit(AuthAuthenticated());
        } else if (event.status == AuthenticationStatus.unauthenticated) {
          emit(AuthUnauthenticated());
        } else {
          emit(AuthInitial());
        }
      },
    );
  }

  late StreamSubscription<AuthenticationStatus> _authStateStream;

  @override
  Future<void> close() {
    _authStateStream.cancel();
    return super.close();
  }
}
