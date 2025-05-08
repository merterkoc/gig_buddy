part of 'login_bloc.dart';

@immutable
class LoginState extends Equatable {
  const LoginState({
    required this.verifyIDTokenRequest,
    required this.createAccountRequest,
    required this.signInWithGoogleRequest,
    this.submitEmail = RequestState.initialized,
    this.verifyEmailOtpRequestState = RequestState.initialized,
    this.user,
    this.interests = const [],
    this.interestRequestState = const {},
  });

  factory LoginState.initial() {
    return LoginState(
      signInWithGoogleRequest: ResponseEntity.initial(),
      createAccountRequest: ResponseEntity.initial(),
      verifyIDTokenRequest: ResponseEntity.initial(),
    );
  }

  final ResponseEntity<void> createAccountRequest;
  final ResponseEntity<void> signInWithGoogleRequest;
  final RequestState submitEmail;
  final RequestState verifyEmailOtpRequestState;
  final ResponseEntity<void> verifyIDTokenRequest;
  final UserDto? user;
  final List<InterestDto> interests;
  final Map<int, RequestState> interestRequestState;

  LoginState copyWith({
    ResponseEntity<void>? createAccountRequest,
    ResponseEntity<void>? signInWithGoogleRequest,
    RequestState? submitEmail,
    RequestState? verifyEmailOtpRequestState,
    ResponseEntity<void>? verifyIDTokenRequest,
    AuthenticationStatus? authenticationStatus,
    UserDto? user,
    List<InterestDto>? interests,
    Map<int, RequestState>? interestRequestState,
  }) {
    return LoginState(
      createAccountRequest: createAccountRequest ?? this.createAccountRequest,
      signInWithGoogleRequest:
          signInWithGoogleRequest ?? this.signInWithGoogleRequest,
      submitEmail: submitEmail ?? this.submitEmail,
      verifyEmailOtpRequestState:
          verifyEmailOtpRequestState ?? this.verifyEmailOtpRequestState,
      verifyIDTokenRequest: verifyIDTokenRequest ?? this.verifyIDTokenRequest,
      user: user ?? this.user,
      interests: interests ?? this.interests,
      interestRequestState: interestRequestState ?? this.interestRequestState,
    );
  }

  @override
  List<Object?> get props => [
        createAccountRequest,
        signInWithGoogleRequest,
        submitEmail,
        verifyEmailOtpRequestState,
        verifyIDTokenRequest,
        user,
        interests,
        interestRequestState,
      ];
}
