import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gig_buddy/src/service/model/event/event.dart';

part 'event_detail.freezed.dart';

part 'event_detail.g.dart';

@freezed
@immutable
class EventDetail with _$EventDetail {
  factory EventDetail({
    required String id,
    required String name,
    required String start,
    required String end,
    required String? location,
    required String? distance,
    required String? locale,
    required String? city,
    required String? country,
    @JsonKey(name: 'venue_name')required String? venueName,
    @JsonKey(name: 'is_joined') required bool isJoined,
    @JsonKey(name: 'ticket_url') required String ticketUrl,
    required List<Images> images,
    @JsonKey(name: 'participant_avatars')
    required List<EventParticipantModel>? participantAvatars,
  }) = _EventDetail ;

  factory EventDetail.fromJson(Map<String, dynamic> json) =>
      _$EventDetailFromJson(json);
}

@freezed
@immutable
class Images with _$Images {
  factory Images({
    required String ratio,
    required String url,
    required int width,
    required int height,
    required bool fallback,
  }) = _Images;

  factory Images.fromJson(Map<String, dynamic> json) =>
      _$ImagesFromJson(json);
}