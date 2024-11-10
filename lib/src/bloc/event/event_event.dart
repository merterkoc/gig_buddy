part of 'event_bloc.dart';

sealed class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object?> get props => [];
}

class InitState extends EventEvent {
  const InitState();
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

  final List<EventModel> events;

  @override
  List<Object?> get props => [events];
}

class EventFailure extends EventEvent {
  const EventFailure({
    this.message = 'Something went wrong, please try again later.',
  });

  final String? message;
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
