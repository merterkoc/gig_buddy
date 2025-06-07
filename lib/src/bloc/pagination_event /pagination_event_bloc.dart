import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/common/constants/app_constants.dart';
import 'package:gig_buddy/src/common/manager/location_manager.dart';
import 'package:gig_buddy/src/repository/event_repository.dart';
import 'package:gig_buddy/src/service/model/city/city.dart';
import 'package:gig_buddy/src/service/model/event_detail/event_detail.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

part 'pagination_event_event.dart';

class PaginationEventBloc
    extends Bloc<PaginationEvent, PagingState<int, EventDetail>> {
  PaginationEventBloc({
    required EventRepository eventRepository,
    required this.loginBloc,
  })  : _eventRepository = eventRepository,
        super(PagingState()) {
    on<FetchNextPaginationEvent>(
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
    FetchNextPaginationEvent event,
    Emitter<PagingState<int, EventDetail>> emit,
  ) async {
    if (state.isLoading) return;

    emit(state.copyWith(isLoading: true, error: null));

    try {
      final newKey = (state.keys?.last ?? 0) + 1;
      final response = await _eventRepository.fetchData(
        page: newKey - 1,
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

  FutureOr<void> _onJoinedEvent(
    JoinedTriggerEvent event,
    Emitter<PagingState<int, EventDetail>> emit,
  ) {
    final updatedPages = state.pages!.map((page) {
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

    emit(state.copyWith(pages: updatedPages));
  }

  FutureOr<void> _onLeaveEvent(
      LeaveTriggerEvent event,
      Emitter<PagingState<int, EventDetail>> emit,
      ) {
    final userId = loginBloc.state.user!.id;

    final updatedPages = state.pages!.map((page) {
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

    emit(state.copyWith(pages: updatedPages));
  }

}
