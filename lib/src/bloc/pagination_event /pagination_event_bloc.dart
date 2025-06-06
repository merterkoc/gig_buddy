import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:gig_buddy/src/common/manager/location_manager.dart';
import 'package:gig_buddy/src/repository/event_repository.dart';
import 'package:gig_buddy/src/service/model/city/city.dart';
import 'package:gig_buddy/src/service/model/event_detail/event_detail.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meta/meta.dart';

part 'pagination_event_event.dart';

class PaginationEventBloc
    extends Bloc<PaginationEvent, PagingState<int, EventDetail>> {
  PaginationEventBloc({
    required EventRepository eventRepository,
  })  : _eventRepository = eventRepository,
        super(PagingState()) {
    on<FetchNextPaginationEvent>(_onFetchNextPaginationEvent,transformer: sequential());
    on<OnFiltered>(_onOnFiltered);
  }

  late final EventRepository _eventRepository;

  Future<void> _onFetchNextPaginationEvent(
    FetchNextPaginationEvent event,
    Emitter<PagingState<int, EventDetail>> emit,
  ) async {
    if (state.isLoading) return;

    emit(state.copyWith(isLoading: true, error: null));

    try {
      final newKey = (state.keys?.last ?? 0) + 1;
      final response = await _eventRepository.fetchData(
        page: newKey - 1,
        size: 10,
        location: LocationManager.currentLocation,
        city: event.selectedCity?.name,
        keyword: event.keyword,
        cancelToken: event.cancelToken,
      );

        final events = (response.data['data'] as List<dynamic>)
            .map((e) => EventDetail.fromJson(e as Map<String, dynamic>))
            .toList();
        final isLastPage = events.isEmpty;

        emit(
          state.copyWith(
            pages: [...?state.pages, events],
            keys: [...?state.keys, newKey],
            hasNextPage: !isLastPage,
            isLoading: false,
          ),
        );
    } catch (error) {
      emit(
        state.copyWith(
          error: error,
          isLoading: false,
        ),
      );
      rethrow;
    }
  }

  FutureOr<void> _onOnFiltered(
    OnFiltered event,
    Emitter<PagingState<int, EventDetail>> emit,
  ) {
    emit(PagingState());
    add(
      FetchNextPaginationEvent(
        selectedCity: event.city,
        keyword: event.keyword,
        cancelToken: event.cancelToken,
      ),
    );
  }
}
