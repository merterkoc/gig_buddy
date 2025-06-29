import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:gig_buddy/src/service/model/event_detail/event_detail.dart';

part 'event_avatars_state.dart';

class EventAvatarsCubit extends Cubit<EventAvatarsState> {
  EventAvatarsCubit() : super(const EventAvatarsState(seenImages: {}));

  void addSeenImage(Map<EventID, EventParticipantModel> map) {
    final newSeenImages = Map<EventID, List<EventParticipantModel>>.from(state.seenImages);

    map.forEach((eventId, participant) {
      final currentList = newSeenImages[eventId] ?? [];
      final isAlreadySeen = currentList.any((p) => p.userId == participant.userId);

      if (!isAlreadySeen) {
        newSeenImages[eventId] = [...currentList, participant];
      }
    });

    emit(state.copyWith(seenImages: newSeenImages));
  }
  void removeSeenImage(Map<EventID, EventParticipantModel> image) {
    final newSeenImages = Map<EventID, List<EventParticipantModel>>.from(state.seenImages);
    image.forEach((eventId, participant) {
      final currentList = newSeenImages[eventId] ?? [];
      final newList = currentList.where((p) => p.userId != participant.userId).toList();
      newSeenImages[eventId] = newList;
    });
    emit(state.copyWith(seenImages: newSeenImages));
  }
}
