part of 'event_bloc.dart';

sealed class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object?> get props => [];
}

class EventInitState extends EventEvent {
  const EventInitState();
}

class EventLoad extends EventEvent {
  const EventLoad({
    required this.page,
    this.keyword,
    this.location,
  });

  final int page;
  final String? keyword;
  final String? location;
}

class EventLoadMore extends EventEvent {
  const EventLoadMore();
}

class EventSearch extends EventEvent {
  const EventSearch(this.keyword);

  final String? keyword;
}

class EventSuccess extends EventEvent {
  const EventSuccess({required this.events});

  final List<EventDetail> events;

  @override
  List<Object?> get props => [events];
}

class EventFailure extends EventEvent {
  const EventFailure({
    this.message = 'Something went wrong, please try again later.',
  });

  final String? message;
}

class FetchEventById extends EventEvent {
  const FetchEventById(this.eventId);

  final String eventId;

  @override
  List<Object?> get props => [eventId];
}

class JoinEvent extends EventEvent {
  const JoinEvent(this.eventId);

  final String eventId;

  @override
  List<Object?> get props => [eventId];
}

class LeaveEvent extends EventEvent {
  const LeaveEvent(this.eventId);

  final String eventId;

  @override
  List<Object?> get props => [eventId];
}

class GetMyEvents extends EventEvent {
  const GetMyEvents();
}

class GetEventsByUserId extends EventEvent {
  const GetEventsByUserId(this.userId);

  final String userId;

  @override
  List<Object?> get props => [userId];
}
