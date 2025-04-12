part of 'profile_bloc.dart';

@immutable
class ProfileState extends Equatable {
  const ProfileState({
    this.requestState = RequestState.initialized,
    this.user,
  });

  final RequestState requestState;
  final PublicUserDto? user;

  ProfileState copyWith({
    RequestState? requestState,
    PublicUserDto? user,
  }) {
    return ProfileState(
      requestState: requestState ?? this.requestState,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [
        requestState,
        user,
      ];
}
