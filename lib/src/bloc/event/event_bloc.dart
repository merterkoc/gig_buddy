import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:gig_buddy/src/bloc/event_avatars/event_avatars_cubit.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/bloc/pagination_event/pagination_event_bloc.dart';
import 'package:gig_buddy/src/common/manager/location_manager.dart';
import 'package:gig_buddy/src/http/dio/model/request_state.dart';
import 'package:gig_buddy/src/http/dio/model/response_entity.dart';
import 'package:gig_buddy/src/repository/event_repository.dart';
import 'package:gig_buddy/src/service/model/city/city.dart' as city;
import 'package:gig_buddy/src/service/model/event_detail/event_detail.dart';
import 'package:gig_buddy/src/service/model/suggest/suggest_dto.dart';

part 'event_event.dart';

part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  EventBloc(
    this._eventRepository,
    this._homePagePaginationBloc,
    this._venueDetailPaginationBloc,
    this._eventAvatarsCubit,
    this._loginBloc,
  ) : super(EventState.initial()) {
    on<EventInitState>(_onInit);
    on<EventLoad>(_onLoad);
    on<EventLoadMore>(_onLoadMore);
    on<EventSearch>(_onSearch, transformer: restartable());
    on<EventSuccess>(_onSuccess);
    on<EventFailure>(_onFailure);
    on<FetchEventById>(_onFetchEventById);
    on<FetchEventByVenueId>(_onFetchEventByVenueId);
    on<JoinEvent>(_onJoin);
    on<LeaveEvent>(_onLeave);
    on<GetMyEvents>(_onGetMyEvents);
    on<GetEventsByUserId>(_onGetEventsByUserId);
    on<EventLoadNearCity>(_onLoadNearCity, transformer: concurrent());
    on<Suggests>(_onSuggests);
  }

  final EventRepository _eventRepository;
  final HomePagePaginationBloc _homePagePaginationBloc;
  final VenueDetailPaginationBloc _venueDetailPaginationBloc;
  final EventAvatarsCubit _eventAvatarsCubit;
  final LoginBloc _loginBloc;

  CancelToken? _cancelToken;

  void _onInit(EventInitState event, Emitter<EventState> emit) =>
      emit(EventState.initial());

  Future<void> _onLoad(EventLoad event, Emitter<EventState> emit) async {
    emit(state.copyWith(requestState: RequestState.loading));
    final fetchData = await _eventRepository.fetchData(
      page: event.page,
      location: LocationManager.currentLocation,
    );
    if (fetchData.isOk) {
      final events = (fetchData.data['data'] as List<dynamic>)
          .map((e) => EventDetail.fromJson(e as Map<String, dynamic>))
          .toList();
      add(EventSuccess(events: events));
    } else {
      add(EventFailure(message: fetchData.message));
    }
  }

  FutureOr<void> _onLoadMore(EventLoadMore event, Emitter<EventState> emit) {}

  Future<void> _onSearch(EventSearch event, Emitter<EventState> emit) async {
    _cancelToken?.cancel();
    if (state.selectedCity == null &&
        (event.keyword == null || event.keyword!.isEmpty)) {
      emit(state.copyWith(searchEvents: []));
      add(const EventLoad(page: 0));
      return;
    }
    await Future<void>.delayed(
      Duration(milliseconds: state.selectedCity != null ? 0 : 500),
    );
    _cancelToken = CancelToken();
    emit(state.copyWith(requestState: RequestState.loading, searchEvents: []));

    try {
      final response = await _eventRepository.fetchData(
        keyword: event.keyword,
        city: state.selectedCity?.name,
        cancelToken: _cancelToken,
        page: 0,
        size: null,
        location: LocationManager.currentLocation,
      );
      if (response.isOk) {
        final events = (response.result as List<dynamic>)
            .map((e) => EventDetail.fromJson(e as Map<String, dynamic>))
            .toList();
        emit(
          state.copyWith(
            searchEvents: events,
            requestState: RequestState.success,
          ),
        );
      } else {
        add(EventFailure(message: response.message));
      }
    } catch (e) {
      add(EventFailure(message: e.toString()));
      rethrow;
    }
  }

  FutureOr<void> _onSuccess(EventSuccess event, Emitter<EventState> emit) {
    _setEventParticipantAvatars(event.events);
    emit(
      state.copyWith(
        events: event.events,
        requestState: RequestState.success,
      ),
    );
  }

  FutureOr<void> _onFailure(EventFailure event, Emitter<EventState> emit) {
    emit(
      state.copyWith(
        requestState: RequestState.error,
        events: [],
      ),
    );
  }

  FutureOr<void> _onFetchEventById(
    FetchEventById event,
    Emitter<EventState> emit,
  ) async {
    final fetchData = await _eventRepository.fetchEventById(event.eventId);
    if (fetchData.isOk) {
      final event =
          EventDetail.fromJson(fetchData.data['data'] as Map<String, dynamic>);
      emit(state.copyWith(selectedEventDetail: event));
    } else {
    }
  }

  Future<void> _onFetchEventByVenueId(
    FetchEventByVenueId event,
    Emitter<EventState> emit,
  ) async {
    final fetchData = await _eventRepository.fetchData(
      venueId: event.venueId,
      page: 20,
    );
    if (fetchData.isOk) {
      final events = (fetchData.data['data'] as List<dynamic>)
          .map((e) => EventDetail.fromJson(e as Map<String, dynamic>))
          .toList();
      _setEventParticipantAvatars(events);
    } else {}
  }

  FutureOr<void> _onJoin(JoinEvent event, Emitter<EventState> emit) async {
    unawaited(HapticFeedback.mediumImpact());
    _homePagePaginationBloc.add(JoinedTriggerEvent('homepage', event.eventId));
    _venueDetailPaginationBloc
        .add(JoinedTriggerEvent(event.pageKey, event.eventId));
    final joinData = await _eventRepository.joinEvent(event.eventId);
    if (joinData.isOk) {
      _eventAvatarsCubit.addSeenImage({
        event.eventId: EventParticipantModel(
          userId: _loginBloc.state.user!.id,
          userImage: _loginBloc.state.user!.userImage,
        ),
      });
      emit(state.copyWith(requestState: RequestState.success));
    } else {}
  }

  FutureOr<void> _onLeave(LeaveEvent event, Emitter<EventState> emit) async {
    _homePagePaginationBloc.add(LeaveTriggerEvent('homepage', event.eventId));
    _venueDetailPaginationBloc
        .add(LeaveTriggerEvent(event.pageKey, event.eventId));
    _eventAvatarsCubit.removeSeenImage({
      event.eventId: EventParticipantModel(
        userId: _loginBloc.state.user!.id,
        userImage: _loginBloc.state.user!.userImage,
      ),
    });
    final leaveData = await _eventRepository.leaveEvent(event.eventId);
    if (leaveData.isOk) {
      emit(state.copyWith(requestState: RequestState.success));
    } else {}
  }

  Future<void> _onGetMyEvents(
    GetMyEvents event,
    Emitter<EventState> emit,
  ) async {
    emit(state.copyWith(requestState: RequestState.loading));
    try {
      final response = await _eventRepository.getMyEvents();
      if (response.isOk) {
        final events = (response.data['data'] as List<dynamic>)
            .map((e) => EventDetail.fromJson(e as Map<String, dynamic>))
            .toList();
        for (final event in events) {
          _eventAvatarsCubit.addSeenImage({
            event.id: EventParticipantModel(
              userId: _loginBloc.state.user!.id,
              userImage: _loginBloc.state.user!.userImage,
            ),
          });
        }
        emit(
          state.copyWith(
            myEvents: events,
            requestState: RequestState.success,
          ),
        );
      } else {
        emit(state.copyWith(requestState: RequestState.error));
      }
    } catch (e) {
      emit(state.copyWith(requestState: RequestState.error));
      rethrow;
    }
  }

  Future<void> _onGetEventsByUserId(
    GetEventsByUserId event,
    Emitter<EventState> emit,
  ) async {
    emit(
      state.copyWith(currentProfileEventsRequestState: RequestState.loading),
    );
    try {
      final response = await _eventRepository.getEventsByUserId(event.userId);
      if (response.isOk) {
        final events = (response.data['data'] as List<dynamic>)
            .map((e) => EventDetail.fromJson(e as Map<String, dynamic>))
            .toList();
        _setEventParticipantAvatars(events);
        emit(
          state.copyWith(
            currentProfileEvents: events,
            currentProfileEventsRequestState: RequestState.success,
          ),
        );
      } else {
        emit(
          state.copyWith(
            currentProfileEventsRequestState: RequestState.error,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(currentProfileEventsRequestState: RequestState.error),
      );
      rethrow;
    }
  }

  Future<void> _onLoadNearCity(
    EventLoadNearCity event,
    Emitter<EventState> emit,
  ) async {
    final response = await _eventRepository.getNearCity(
      lat: event.lat,
      lng: event.lng,
      radius: event.radius,
      limit: event.limit,
    );
    if (response.isOk) {
      final cities = (response.data['data'] as List<dynamic>)
          .map((e) => city.City.fromJson(e as Map<String, dynamic>))
          .toList();
      emit(state.copyWith(nearCity: cities));
    } else {
      emit(
        state.copyWith(),
      );
    }
  }

  Future<void> _onSuggests(
    Suggests event,
    Emitter<EventState> emit,
  ) async {
    final data = state.suggest.data;
    emit(state.copyWith(suggest: ResponseEntity.loading(data: data)));
    try {
      final response = await _eventRepository.suggests(
        lat: event.lat,
        lng: event.lng,
      );
      if (response.isOk) {
        final suggest =
            SuggestDTO.fromJson(response.data as Map<String, dynamic>);
        emit(state.copyWith(suggest: ResponseEntity.success(data: suggest)));
      } else {
        emit(
          state.copyWith(
            suggest: ResponseEntity.error(
              message: response.message,
              displayMessage: response.message,
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          suggest: ResponseEntity.error(
            message: e.toString(),
            displayMessage: e.toString(),
          ),
        ),
      );
      rethrow;
    }
  }

  void _setEventParticipantAvatars(List<EventDetail> events) {
    for (final event in events) {
      for (final participant in event.participantAvatars ?? []) {
        if (participant != null) {
          participant as EventParticipantModel;
          _eventAvatarsCubit.addSeenImage({
            event.id: participant,
          });
        }
      }
    }
  }
}
