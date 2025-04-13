import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:gig_buddy/src/repository/buddy_repository.dart';
import 'package:gig_buddy/src/service/model/buddy_requests/buddy_requests.dart';

part 'buddy_event.dart';

part 'buddy_state.dart';

class BuddyBloc extends Bloc<BuddyEvent, BuddyState> {
  BuddyBloc(this._buddyRepository) : super(const BuddyState()) {
    on<BuddyInitState>(_onInit);
    on<GetBuddyRequests>(_onGetBuddyRequests);
    on<CreateBuddyRequest>(_onCreateBuddyRequest);
    on<AcceptBuddyRequest>(_onAcceptBuddyRequest);
  }

  final BuddyRepository _buddyRepository;

  Future<void> _onInit(BuddyInitState event, Emitter<BuddyState> emit) async {
    emit(const BuddyState());
  }
  Future<void> _onGetBuddyRequests(
    GetBuddyRequests event,
    Emitter<BuddyState> emit,
  ) async {
    try {
      final responseEntity = await _buddyRepository.getBuddyRequests(
      );
      final map = (responseEntity.data as List<dynamic>)
          .map<BuddyRequests>(
            (dynamic e) => BuddyRequests.fromJson(e as Map<String, dynamic>),
          )
          .toList();
      if (responseEntity.isOk) {
        emit(
          state.copyWith(
            buddyRequests: map,
          ),
        );
      }else{
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _onCreateBuddyRequest(
    CreateBuddyRequest event,
    Emitter<BuddyState> emit,
  ) async {
    try {
      final responseEntity = await _buddyRepository.createBuddyRequest(
        eventId: event.eventId,
        receiverId: event.receiverId,
      );
      if (responseEntity.isOk) {}
    } catch (e) {
      rethrow;
    } finally {}
  }

  Future<void> _onAcceptBuddyRequest(
    AcceptBuddyRequest event,
    Emitter<BuddyState> emit,
  ) async {
    try {
      final responseEntity = await _buddyRepository.acceptBuddyRequest(
        buddyRequestId: event.buddyRequestId,
      );
      if (responseEntity.isOk) {}
    } catch (e) {
      rethrow;
    } finally {}
  }
}
