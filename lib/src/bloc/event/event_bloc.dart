import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:gig_buddy/src/bloc/pagination_event%20/pagination_event_bloc.dart';
import 'package:gig_buddy/src/common/manager/location_manager.dart';
import 'package:gig_buddy/src/http/dio/model/request_state.dart';
import 'package:gig_buddy/src/repository/event_repository.dart';
import 'package:gig_buddy/src/service/model/city/city.dart';
import 'package:gig_buddy/src/service/model/event_detail/event_detail.dart';

part 'event_event.dart';

part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  EventBloc(
    this._eventRepository,
    this._paginationEventBloc,
  ) : super(const EventState()) {
    on<EventInitState>(_onInit);
    on<EventLoad>(_onLoad);
    on<EventLoadMore>(_onLoadMore);
    on<EventSearch>(_onSearch, transformer: restartable());
    on<EventSuccess>(_onSuccess);
    on<EventFailure>(_onFailure);
    on<FetchEventById>(_onFetchEventById);
    on<JoinEvent>(_onJoin);
    on<LeaveEvent>(_onLeave);
    on<GetMyEvents>(_onGetMyEvents);
    on<GetEventsByUserId>(_onGetEventsByUserId);
    on<EventLoadNearCity>(_onLoadNearCity,transformer: concurrent());
  }

  final EventRepository _eventRepository;
  final PaginationEventBloc _paginationEventBloc;

  CancelToken? _cancelToken;

  void _onInit(EventInitState event, Emitter<EventState> emit) =>
      emit(const EventState());

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
      add(EventFailure(message: fetchData.message));
    }
  }

  FutureOr<void> _onJoin(JoinEvent event, Emitter<EventState> emit) async {
    _paginationEventBloc.add(JoinedTriggerEvent(event.eventId));
    final joinData = await _eventRepository.joinEvent(event.eventId);
    if (joinData.isOk) {
      emit(state.copyWith(requestState: RequestState.success));
    } else {}
  }

  FutureOr<void> _onLeave(LeaveEvent event, Emitter<EventState> emit) async {
    _paginationEventBloc.add(LeaveTriggerEvent(event.eventId));

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
        emit(
          state.copyWith(
            myEvents: events,
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
          .map((e) => City.fromJson(e as Map<String, dynamic>))
          .toList();
      emit(state.copyWith(nearCity: cities));
    } else {
      emit(
        state.copyWith(),
      );
    }
  }
}

extension on EventState {
  EventState setNullSelectCity() {
    return EventState(
      nearCity: nearCity,
      selectedEventDetail: selectedEventDetail,
      currentProfileEvents: currentProfileEvents,
      currentProfileEventsRequestState: currentProfileEventsRequestState,
      events: events,
      requestState: requestState,
      errorMessage: errorMessage,
      myEvents: myEvents,
      searchEvents: searchEvents,
    );
  }
}
