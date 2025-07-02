import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/common/manager/location_manager.dart';
import 'package:gig_buddy/src/repository/event_repository.dart';
import 'package:gig_buddy/src/service/model/city/city.dart';
import 'package:gig_buddy/src/service/model/event_detail/event_detail.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

part 'pagination_event_event.dart';

typedef PageKey = String;

class HomePagePaginationBloc extends PaginationEventBloc {
  HomePagePaginationBloc({
    required super.eventRepository,
    required super.loginBloc,
  });
}

class VenueDetailPaginationBloc extends PaginationEventBloc {
  VenueDetailPaginationBloc({
    required super.eventRepository,
    required super.loginBloc,
  });
}

class PaginationEventBloc
    extends Bloc<PaginationEvent, Map<PageKey, PagingState<int, EventDetail>>> {
  PaginationEventBloc({
    required EventRepository eventRepository,
    required this.loginBloc,
  })  : _eventRepository = eventRepository,
        super({}) {
    on<FetchNextPaginationEvent<PaginationEventBloc>>(
      _onFetchNextPaginationEvent,
      transformer: sequential(),
    );
    on<OnFiltered>(_onOnFiltered);
    on<JoinedTriggerEvent>(_onJoinedEvent);
    on<LeaveTriggerEvent>(_onLeaveEvent);
  }

  late final EventRepository _eventRepository;
  late final LoginBloc loginBloc;

  Future<void> _onFetchNextPaginationEvent(
    FetchNextPaginationEvent<PaginationEventBloc> event,
    Emitter<Map<PageKey, PagingState<int, EventDetail>>> emit,
  ) async {
    if (state[event.pageKey]?.isLoading == true) return;

    final currentVenueState = state[event.pageKey] ?? PagingState<int, EventDetail>();

// Step 1: loading flag true yap
    emit({
      ...state,
      event.pageKey: currentVenueState.copyWith(
        isLoading: true,
        error: null,
      )
    });

    try {
      final newKey = (currentVenueState.keys?.last ?? 0) + 1;

      final response = await _eventRepository.fetchData(
        page: newKey - 1,
        location: LocationManager.currentLocation,
        city: event.selectedCity?.name,
        keyword: event.keyword,
        cancelToken: event.cancelToken,
        venueId: event.venueId,
      );

      final events = (response.data['data'] as List<dynamic>)
          .map((e) => EventDetail.fromJson(e as Map<String, dynamic>))
          .toList();

      final isLastPage = events.isEmpty;

      emit({
        ...state,
        event.pageKey: PagingState<int, EventDetail>(
          pages: [...?currentVenueState.pages, events],
          keys: [...?currentVenueState.keys, newKey],
          hasNextPage: !isLastPage,
          isLoading: false,
          error: null,
        ),
      });
    } catch (error) {
      emit({
        ...state,
        event.pageKey: currentVenueState.copyWith(
          isLoading: false,
          error: error,
        )
      });

      rethrow;
    }
  }

  FutureOr<void> _onOnFiltered(
    OnFiltered event,
    Emitter<Map<PageKey, PagingState<int, EventDetail>>> emit,
  ) {
    emit({
      ...state,
      'homepage': PagingState(),
      'venue': PagingState(),
    });
    add(
      FetchNextPaginationEvent<PaginationEventBloc>(
        event.pageKey,
        selectedCity: event.city,
        keyword: event.keyword,
        cancelToken: event.cancelToken,
      ),
    );
  }

  FutureOr<void> _onJoinedEvent(
    JoinedTriggerEvent event,
    Emitter<Map<PageKey, PagingState<int, EventDetail>>> emit,
  ) {
    final currentStateByKey = state[event.pageKey] ?? PagingState<int, EventDetail>();
    final updatedPages = currentStateByKey.pages!.map((page) {
      return page.map((pageEvent) {
        if (pageEvent.id == event.eventId) {
          return pageEvent.copyWith(
            participantAvatars: [
              ...(pageEvent.participantAvatars ?? []),
              EventParticipantModel(
                userId: loginBloc.state.user!.id,
                userImage: loginBloc.state.user!.userImage,
              ),
            ],
            isJoined: true,
          );
        }
        return pageEvent;
      }).toList();
    }).toList();

    emit({
      ...state,
      event.pageKey: currentStateByKey.copyWith(pages: updatedPages),
    });
  }

  FutureOr<void> _onLeaveEvent(
    LeaveTriggerEvent event,
    Emitter<Map<PageKey, PagingState<int, EventDetail>>> emit,
  ) {
    final currentStateByKey = state[event.pageKey] ?? PagingState<int, EventDetail>();
    final userId = loginBloc.state.user!.id;

    final updatedPages = currentStateByKey.pages!.map((page) {
      return page.map((pageEvent) {
        if (pageEvent.id == event.eventId) {
          return pageEvent.copyWith(
            participantAvatars: (pageEvent.participantAvatars ?? [])
                .where((e) => e.userId != userId)
                .toList(),
            isJoined: false,
          );
        }
        return pageEvent;
      }).toList();
    }).toList();

    emit({
      ...state,
      event.pageKey: currentStateByKey.copyWith(pages: updatedPages),
    });
  }
}
