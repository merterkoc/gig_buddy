part of 'login_bloc.dart';

@immutable
class LoginState extends Equatable {
  const LoginState({
    required this.verifyIDTokenRequest,
    required this.createAccountRequest,
    this.submitEmail = RequestState.initialized,
    this.verifyEmailOtpRequestState = RequestState.initialized,
    this.user,
    this.interests = const [],
    this.interestRequestState = const {},
  });

  factory LoginState.initial() {
    return LoginState(
      createAccountRequest: ResponseEntity.initial(),
      verifyIDTokenRequest: ResponseEntity.initial(),
    );
  }

  final ResponseEntity<void> createAccountRequest;
  final RequestState submitEmail;
  final RequestState verifyEmailOtpRequestState;
  final ResponseEntity<void> verifyIDTokenRequest;
  final UserDto? user;
  final List<InterestDto> interests;
  final Map<int, RequestState> interestRequestState;

  LoginState copyWith({
    ResponseEntity<void>? createAccountRequest,
    RequestState? submitEmail,
    RequestState? verifyEmailOtpRequestState,
    ResponseEntity<void>? verifyIDTokenRequest,
    AuthenticationStatus? authenticationStatus,
    UserDto? user,
    List<InterestDto>? interests,
    Map<int, RequestState>? interestRequestState,
  }) {
    return LoginState(
      createAccountRequest:
          createAccountRequest ?? this.createAccountRequest,
      submitEmail: submitEmail ?? this.submitEmail,
      verifyEmailOtpRequestState:
          verifyEmailOtpRequestState ?? this.verifyEmailOtpRequestState,
      verifyIDTokenRequest:
          verifyIDTokenRequest ?? this.verifyIDTokenRequest,
      user: user ?? this.user,
      interests: interests ?? this.interests,
      interestRequestState: interestRequestState ?? this.interestRequestState,
    );
  }

  @override
  List<Object?> get props => [
        createAccountRequest,
        submitEmail,
        verifyEmailOtpRequestState,
        verifyIDTokenRequest,
        user,
        interests,
        interestRequestState,
      ];
}
