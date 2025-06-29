part of 'event_avatars_cubit.dart';

typedef EventID = String;
typedef EventImage = String;

@immutable
class EventAvatarsState extends Equatable {
  const EventAvatarsState({required this.seenImages});

  final  Map<EventID, List<EventParticipantModel>> seenImages;

  EventAvatarsState copyWith({
    Map<EventID, List<EventParticipantModel>>? seenImages,
  }) {
    return EventAvatarsState(
      seenImages: seenImages ?? this.seenImages,
    );
  }

  @override
  List<Object?> get props => [seenImages];
}
