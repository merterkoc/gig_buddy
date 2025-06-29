part of 'profile_bloc.dart';

@immutable
class ProfileState extends Equatable {
  const ProfileState({
    this.requestState = RequestState.initialized,
    this.requestSetUserAttributes,
    this.user,
  });

  final RequestState requestState;
  final ResponseEntity<dynamic>? requestSetUserAttributes;
  final PublicUserDto? user;

  ProfileState copyWith({
    RequestState? requestState,
    ResponseEntity<dynamic>? requestSetUserAttributes,
    PublicUserDto? user,
  }) {
    return ProfileState(
      requestState: requestState ?? this.requestState,
      requestSetUserAttributes:
          requestSetUserAttributes ?? this.requestSetUserAttributes,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [
        requestState,
        requestSetUserAttributes,
        user,
      ];
}
