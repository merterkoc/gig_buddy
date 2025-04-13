part of 'buddy_bloc.dart';

@immutable
class BuddyState extends Equatable {
  const BuddyState({this.buddyRequests = const []});

  final List<BuddyRequests> buddyRequests;

  BuddyState copyWith({List<BuddyRequests>? buddyRequests}) => BuddyState(
        buddyRequests: buddyRequests ?? this.buddyRequests,
      );

  @override
  List<Object?> get props => [buddyRequests];
}
