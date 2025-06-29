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
    this.nearCity,
    this.selectedCity,
    this.suggest,
  });

  final List<EventDetail>? events;
  final List<EventDetail>? searchEvents;
  final RequestState requestState;
  final String? errorMessage;
  final List<EventDetail>? myEvents;
  final List<EventDetail>? currentProfileEvents;
  final RequestState currentProfileEventsRequestState;
  final EventDetail? selectedEventDetail;
  final List<city.City>? nearCity;
  final city.City? selectedCity;
  final SuggestDTO? suggest;

  EventState copyWith({
    List<EventDetail>? events,
    List<EventDetail>? searchEvents,
    RequestState? requestState,
    String? errorMessage,
    List<EventDetail>? myEvents,
    List<EventDetail>? currentProfileEvents,
    RequestState? currentProfileEventsRequestState,
    EventDetail? selectedEventDetail,
    List<city.City>? nearCity,
    city.City? selectedCity,
    SuggestDTO? suggest,
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
      nearCity: nearCity ?? this.nearCity,
      selectedCity: selectedCity ?? this.selectedCity,
      suggest: suggest ?? this.suggest,
    );
  }

  List<EventDetail> get allEvents =>
      [...?events, ...?searchEvents, ...?myEvents];

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
        nearCity,
        selectedCity,
        suggest,
      ];
}
