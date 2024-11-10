part of 'login_bloc.dart';

@immutable
class LoginState extends Equatable {
  const LoginState({
    this.createAccountRequestState = RequestState.initialized,
    this.submitEmail = RequestState.initialized,
    this.verifyEmailOtpRequestState = RequestState.initialized,
    this.verifyIDTokenRequestState = RequestState.initialized,
    this.user,
  });

  final RequestState createAccountRequestState;
  final RequestState submitEmail;
  final RequestState verifyEmailOtpRequestState;
  final RequestState verifyIDTokenRequestState;
  final UserDto? user;

  LoginState copyWith({
    RequestState? createAccountRequestState,
    RequestState? submitEmail,
    RequestState? verifyEmailOtpRequestState,
    RequestState? verifyIDTokenRequestState,
    AuthenticationStatus? authenticationStatus,
    UserDto? user,
  }) {
    return LoginState(
      createAccountRequestState:
          createAccountRequestState ?? this.createAccountRequestState,
      submitEmail: submitEmail ?? this.submitEmail,
      verifyEmailOtpRequestState:
          verifyEmailOtpRequestState ?? this.verifyEmailOtpRequestState,
      verifyIDTokenRequestState:
          verifyIDTokenRequestState ?? this.verifyIDTokenRequestState,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [
        createAccountRequestState,
        submitEmail,
        verifyEmailOtpRequestState,
        verifyIDTokenRequestState,
        user,
      ];
}
