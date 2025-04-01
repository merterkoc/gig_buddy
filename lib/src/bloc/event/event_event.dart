part of 'event_bloc.dart';

sealed class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object?> get props => [];
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
  const EventSearch();
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
