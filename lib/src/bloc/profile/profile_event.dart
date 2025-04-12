part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class FetchUserProfile extends ProfileEvent {
  const FetchUserProfile(this.userId);

  final String userId;

  @override
  List<Object> get props => [userId];
}
