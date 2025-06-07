part of 'pagination_event_bloc.dart';

@immutable
sealed class PaginationEvent {}

final class FetchNextPaginationEvent extends PaginationEvent {
  FetchNextPaginationEvent({this.selectedCity, this.keyword, this.cancelToken});

  final City? selectedCity;
  final String? keyword;
  final CancelToken? cancelToken;
}

final class OnFiltered extends PaginationEvent {
  OnFiltered(this.city, this.keyword, this.cancelToken);

  final City? city;
  final String? keyword;
  final CancelToken? cancelToken;
}

class JoinedTriggerEvent extends PaginationEvent {
  JoinedTriggerEvent(this.eventId);

  final String eventId;
}

class LeaveTriggerEvent extends PaginationEvent {
  LeaveTriggerEvent(this.eventId);

  final String eventId;
}
