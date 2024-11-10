part of 'event_bloc.dart';

class EventState extends Equatable {
  const EventState({
    this.events,
    this.searchEvents,
    this.requestState = RequestState.notInitialized,
    this.errorMessage,
  });

  final List<EventModel>? events;
  final List<EventModel>? searchEvents;
  final RequestState requestState;
  final String? errorMessage;

  EventState copyWith({
    List<EventModel>? events,
    List<EventModel>? searchEvents,
    RequestState? requestState,
    String? errorMessage,
  }) {
    return EventState(
      events: events ?? this.events,
      searchEvents: searchEvents ?? this.searchEvents,
      requestState: requestState ?? this.requestState,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        events,
        searchEvents,
        requestState,
        errorMessage,
      ];
}
