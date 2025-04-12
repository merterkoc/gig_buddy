part of 'event_bloc.dart';

class EventState extends Equatable {
  const EventState({
    this.events,
    this.searchEvents,
    this.requestState = RequestState.notInitialized,
    this.errorMessage,
    this.myEvents,
    this.currentProfileEvents,
    this.currentProfileEventsRequestState = RequestState.notInitialized,
  });

  final List<EventModel>? events;
  final List<EventModel>? searchEvents;
  final RequestState requestState;
  final String? errorMessage;
  final List<EventDetail>? myEvents;
  final List<EventDetail>? currentProfileEvents;
  final RequestState currentProfileEventsRequestState;

  EventState copyWith({
    List<EventModel>? events,
    List<EventModel>? searchEvents,
    RequestState? requestState,
    String? errorMessage,
    List<EventDetail>? myEvents,
    List<EventDetail>? currentProfileEvents,
    RequestState? currentProfileEventsRequestState,
  }) {
    return EventState(
      events: events ?? this.events,
      searchEvents: searchEvents ?? this.searchEvents,
      requestState: requestState ?? this.requestState,
      errorMessage: errorMessage ?? this.errorMessage,
      myEvents: myEvents ?? this.myEvents,
      currentProfileEvents: currentProfileEvents ?? this.currentProfileEvents,
      currentProfileEventsRequestState: currentProfileEventsRequestState ??
          this.currentProfileEventsRequestState,
    );
  }

  @override
  List<Object?> get props => [
        events,
        searchEvents,
        requestState,
        errorMessage,
        myEvents,
        currentProfileEvents,
        currentProfileEventsRequestState,
      ];
}
