import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gig_buddy/src/common/constants/app_constants.dart';
import 'package:gig_buddy/src/http/dio/model/request_state.dart';
import 'package:gig_buddy/src/repository/event_repository.dart';
import 'package:gig_buddy/src/service/model/event/event.dart';

part 'event_event.dart';

part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  EventBloc(
    this._eventRepository,
  ) : super(const EventState()) {
    on<EventLoad>(_onLoad);
    on<EventLoadMore>(_onLoadMore);
    on<EventSearch>(_onSearch);
    on<EventSuccess>(_onSuccess);
    on<EventFailure>(_onFailure);
  }

  final EventRepository _eventRepository;

  Future<void> _onLoad(EventLoad event, Emitter<EventState> emit) async {
    final fetchData = await _eventRepository.fetchData(
      page: event.page,
    );
    if (fetchData.isOk) {
      final events = (fetchData.data as List<dynamic>).map((e) => EventModel.fromJson(e as Map<String, dynamic>)).toList();
      add(EventSuccess(events: events));
    } else {
      add(EventFailure(message: fetchData.message));
    }
  }

  FutureOr<void> _onLoadMore(EventLoadMore event, Emitter<EventState> emit) {}

  FutureOr<void> _onSearch(EventSearch event, Emitter<EventState> emit) {}

  FutureOr<void> _onSuccess(EventSuccess event, Emitter<EventState> emit) {
    emit(state.copyWith(events: event.events));
  }

  FutureOr<void> _onFailure(EventFailure event, Emitter<EventState> emit) {
    emit(state.copyWith(
      requestState: RequestState.error,
    ));
  }
}
