part of 'buddy_bloc.dart';

@immutable
sealed class BuddyEvent extends Equatable {
  const BuddyEvent();

  @override
  List<Object?> get props => [];
}

class BuddyInitState extends BuddyEvent {
  const BuddyInitState();
}

class GetBuddyRequests extends BuddyEvent {
  const GetBuddyRequests();
}

class CreateBuddyRequest extends BuddyEvent {
  const CreateBuddyRequest({
    required this.eventId,
    required this.receiverId,
  });

  final String eventId;
  final String receiverId;

  @override
  List<Object?> get props => [eventId, receiverId];
}

class AcceptBuddyRequest extends BuddyEvent {
  const AcceptBuddyRequest({
    required this.buddyRequestId,
  });

  final String buddyRequestId;

  @override
  List<Object?> get props => [buddyRequestId];
}
