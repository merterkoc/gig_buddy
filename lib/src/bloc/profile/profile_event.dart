part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class UpdateUserDetails extends ProfileEvent {
  const UpdateUserDetails(this.userAttributes);

  final UpdateUserRequestDTO userAttributes;

  @override
  List<Object> get props => [userAttributes];
}

class FetchUserProfile extends ProfileEvent {
  const FetchUserProfile(this.userId);

  final String userId;

  @override
  List<Object> get props => [userId];
}
