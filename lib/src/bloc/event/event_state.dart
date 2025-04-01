part of 'event_bloc.dart';

class EventState extends Equatable {
  const EventState({
    this.events,
    this.requestState = RequestState.notInitialized,
    this.errorMessage,
  });

  final List<EventModel>? events;
  final RequestState requestState;
  final String? errorMessage;

  EventState copyWith({
    List<EventModel>? events,
    RequestState? requestState,
    String? errorMessage,
  }) {
    return EventState(
      events: events ?? this.events,
      requestState: requestState ?? this.requestState,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        events,
        requestState,
        errorMessage,
      ];
}
