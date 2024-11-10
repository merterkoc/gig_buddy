part of 'login_bloc.dart';

@immutable
class LoginState extends Equatable {
  const LoginState({
    this.email,
    this.password,
    this.emailOtpRequestState = RequestState.idle,
    this.verifyEmailOtpRequestState = RequestState.idle,
    this.authenticationStatus = AuthenticationStatus.unauthenticated,
  });

  final String? email;
  final String? password;
  final RequestState emailOtpRequestState;
  final RequestState verifyEmailOtpRequestState;
  final AuthenticationStatus authenticationStatus;

  LoginState copyWith({
    String? email,
    String? password,
    RequestState? emailOtpRequestState,
    RequestState? verifyEmailOtpRequestState,
    AuthenticationStatus? authenticationStatus,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      emailOtpRequestState: emailOtpRequestState ?? this.emailOtpRequestState,
      verifyEmailOtpRequestState:
          verifyEmailOtpRequestState ?? this.verifyEmailOtpRequestState,
      authenticationStatus: authenticationStatus ?? this.authenticationStatus,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        emailOtpRequestState,
        verifyEmailOtpRequestState,
        authenticationStatus,
      ];
}
