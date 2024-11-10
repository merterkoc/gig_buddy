part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}

class InitializeAuthEvent extends AuthEvent {
  const InitializeAuthEvent();
}

class AuthStateChanged extends AuthEvent {
  const AuthStateChanged(this.status);

  final AuthenticationStatus status;
}
