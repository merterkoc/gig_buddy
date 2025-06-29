part of 'pagination_event_bloc.dart';

@immutable
sealed class PaginationEvent {}

final class FetchNextPaginationEvent<T> extends PaginationEvent {
  FetchNextPaginationEvent(
    this.pageKey, {
    this.selectedCity,
    this.keyword,
    this.venueId,
    this.cancelToken,
    this.bloc,
  });

  final City? selectedCity;
  final String? keyword;
  final String? venueId;
  final CancelToken? cancelToken;
  final T? bloc;
  final PageKey pageKey;
}

final class OnFiltered extends PaginationEvent {
  OnFiltered(this.pageKey, this.city, this.keyword, this.cancelToken);

  final City? city;
  final String? keyword;
  final CancelToken? cancelToken;
  final PageKey pageKey;
}

class JoinedTriggerEvent extends PaginationEvent {
  JoinedTriggerEvent(
    this.pageKey,
    this.eventId,
  );

  final String eventId;
  final PageKey pageKey;
}

class LeaveTriggerEvent extends PaginationEvent {
  LeaveTriggerEvent(this.pageKey, this.eventId);

  final String eventId;
  final PageKey pageKey;
}
