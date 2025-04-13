import 'package:freezed_annotation/freezed_annotation.dart';

part 'event.freezed.dart';

part 'event.g.dart';

@freezed
@immutable
class EventModel with _$EventModel {
  factory EventModel({
    required String id,
    required String name,
    required String start,
    required String end,
    required String? location,
    required String? locale,
    required String? distance,
    required String? city,
    required String? country,
    @JsonKey(name: 'venue_name') required String? venueName,
    @JsonKey(name: 'is_joined') required bool isJoined,
    @JsonKey(name: 'ticket_url') required String ticketUrl,
    required List<String> images,
    @JsonKey(name: 'participant_avatars')
    required List<EventParticipantModel>? participantAvatars,
  }) = _EventModel;

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);
}

@freezed
@immutable
class EventParticipantModel with _$EventParticipantModel {
  factory EventParticipantModel({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'user_image') required String? userImage,
  }) = _EventParticipantModel;

  factory EventParticipantModel.fromJson(Map<String, dynamic> json) =>
      _$EventParticipantModelFromJson(json);
}
