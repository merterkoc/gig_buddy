import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:gig_buddy/src/http/dio/model/response_entity.dart';
import 'package:gig_buddy/src/repository/buddy_repository.dart';
import 'package:gig_buddy/src/service/model/buddy_requests/buddy_requests.dart';
import 'package:gig_buddy/src/service/model/enum/buddy_request_status.dart';

part 'buddy_event.dart';

part 'buddy_state.dart';

class BuddyBloc extends Bloc<BuddyEvent, BuddyState> {
  BuddyBloc(this._buddyRepository) : super(BuddyState.initial()) {
    on<BuddyInitState>(_onInit);
    on<GetBuddyRequests>(
      _onGetBuddyRequests,
    );
    on<CreateBuddyRequest>(_onCreateBuddyRequest);
    on<AcceptBuddyRequest>(_onAcceptBuddyRequest, transformer: sequential());
    on<RejectBuddyRequest>(_onRejectBuddyRequest, transformer: sequential());
    on<BlockBuddyRequest>(_onBlockBuddyRequest, transformer: sequential());
  }

  final BuddyRepository _buddyRepository;

  Future<void> _onInit(BuddyInitState event, Emitter<BuddyState> emit) async {
    emit(BuddyState.initial());
  }

  Future<void> _onGetBuddyRequests(
    GetBuddyRequests event,
    Emitter<BuddyState> emit,
  ) async {
    try {
      emit(state.copyWith(buddyRequests: ResponseEntity.loading()));
      final responseEntity = await _buddyRepository.getBuddyRequests();

      emit(
        state.copyWith(
          buddyRequests: responseEntity,
        ),
      );
    } catch (e) {
      emit(state.copyWith(buddyRequests: ResponseEntity.error()));
      rethrow;
    }
  }

  Future<void> _onCreateBuddyRequest(
    CreateBuddyRequest event,
    Emitter<BuddyState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          createBuddyRequest: ResponseEntity.loading(),
          currentCreateBuddyRequestEventId: event.eventId,
        ),
      );
      final responseEntity = await _buddyRepository.createBuddyRequest(
        eventId: event.eventId,
        receiverId: event.receiverId,
      );
      if (responseEntity.isOk) {
        emit(state.copyWith(createBuddyRequest: ResponseEntity.success()));
      } else {
        emit(state.copyWith(createBuddyRequest: responseEntity));
      }
    } catch (e) {
      emit(state.copyWith(buddyRequests: ResponseEntity.error()));
      rethrow;
    } finally {
      emit(state.copyWith(currentCreateBuddyRequestEventId: ''));
    }
  }

  Future<void> _onAcceptBuddyRequest(
    AcceptBuddyRequest event,
    Emitter<BuddyState> emit,
  ) async {
    {
      final oldBuddyRequests = state.buddyRequests.data;
      final newBuddyRequests = oldBuddyRequests?.map((buddyRequest) {
        if (buddyRequest.id == event.buddyRequestId) {
          return buddyRequest.copyWith(status: BuddyRequestStatus.accepted);
        }
        return buddyRequest;
      }).toList();
      try {
        // 1. Optimistic UI update
        emit(
          state.copyWith(
            buddyRequests: state.buddyRequests.copyWith(
              data: newBuddyRequests,
            ),
            acceptBuddyRequest: {
              event.buddyRequestId: ResponseEntity.loading(),
            },
          ),
        );

        final responseEntity = await _buddyRepository.acceptBuddyRequest(
          buddyRequestId: event.buddyRequestId,
        );

        emit(
          state.copyWith(
            acceptBuddyRequest: {
              ...state.acceptBuddyRequest,
              event.buddyRequestId: responseEntity,
            },
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            buddyRequests: state.buddyRequests.copyWith(
              data: oldBuddyRequests,
            ),
            acceptBuddyRequest: {
              ...state.acceptBuddyRequest,
              event.buddyRequestId: ResponseEntity.error(),
            },
          ),
        );

        rethrow;
      }
    }
  }

  Future<void> _onRejectBuddyRequest(
    RejectBuddyRequest event,
    Emitter<BuddyState> emit,
  ) async {
    {
      final oldBuddyRequests = state.buddyRequests.data;
      final newBuddyRequests = oldBuddyRequests?.map((buddyRequest) {
        if (buddyRequest.id == event.buddyRequestId) {
          return buddyRequest.copyWith(status: BuddyRequestStatus.rejected);
        }
        return buddyRequest;
      }).toList();
      try {
        // 1. Optimistic UI update
        emit(
          state.copyWith(
            buddyRequests: state.buddyRequests.copyWith(
              data: newBuddyRequests,
            ),
            rejectBuddyRequest: {
              event.buddyRequestId: ResponseEntity.loading(),
            },
          ),
        );

        final responseEntity = await _buddyRepository.rejectBuddyRequest(
          buddyRequestId: event.buddyRequestId,
        );

        emit(
          state.copyWith(
            rejectBuddyRequest: {
              ...state.rejectBuddyRequest,
              event.buddyRequestId: responseEntity,
            },
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            buddyRequests: state.buddyRequests.copyWith(
              data: oldBuddyRequests,
            ),
            rejectBuddyRequest: {
              ...state.rejectBuddyRequest,
              event.buddyRequestId: ResponseEntity.error(),
            },
          ),
        );

        rethrow;
      }
    }
  }

  Future<void> _onBlockBuddyRequest(
    BlockBuddyRequest event,
    Emitter<BuddyState> emit,
  ) async {
    {
      final oldBuddyRequests = state.buddyRequests.data;
      final newBuddyRequests = oldBuddyRequests?.map((buddyRequest) {
        if (buddyRequest.id == event.buddyRequestId) {
          return buddyRequest.copyWith(status: BuddyRequestStatus.blocked);
        }
        return buddyRequest;
      }).toList();
      try {
        // 1. Optimistic UI update
        emit(
          state.copyWith(
            buddyRequests: state.buddyRequests.copyWith(
              data: newBuddyRequests,
            ),
            blockBuddyRequest: {
              event.buddyRequestId: ResponseEntity.loading(),
            },
          ),
        );

        final responseEntity = await _buddyRepository.blockBuddyRequest(
          buddyRequestId: event.buddyRequestId,
        );

        emit(
          state.copyWith(
            blockBuddyRequest: {
              ...state.blockBuddyRequest,
              event.buddyRequestId: responseEntity,
            },
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            buddyRequests: state.buddyRequests.copyWith(
              data: oldBuddyRequests,
            ),
            blockBuddyRequest: {
              ...state.blockBuddyRequest,
              event.buddyRequestId: ResponseEntity.error(),
            },
          ),
        );

        rethrow;
      }
    }
  }
}
