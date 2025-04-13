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
    this.selectedEventDetail,
  });

  final List<EventModel>? events;
  final List<EventModel>? searchEvents;
  final RequestState requestState;
  final String? errorMessage;
  final List<EventDetail>? myEvents;
  final List<EventDetail>? currentProfileEvents;
  final RequestState currentProfileEventsRequestState;
  final EventDetail? selectedEventDetail;

  EventState copyWith({
    List<EventModel>? events,
    List<EventModel>? searchEvents,
    RequestState? requestState,
    String? errorMessage,
    List<EventDetail>? myEvents,
    List<EventDetail>? currentProfileEvents,
    RequestState? currentProfileEventsRequestState,
    EventDetail? selectedEventDetail,
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
      selectedEventDetail: selectedEventDetail ?? this.selectedEventDetail,
    );
  }

  List<EventModel> get allEvents => [...?events, ...?searchEvents];

  @override
  List<Object?> get props => [
        events,
        searchEvents,
        requestState,
        errorMessage,
        myEvents,
        currentProfileEvents,
        currentProfileEventsRequestState,
        selectedEventDetail,
      ];
}
