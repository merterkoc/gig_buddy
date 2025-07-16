// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gig_buddy/src/service/model/enum/buddy_request_status.dart';
import 'package:gig_buddy/src/service/model/suggest/suggest_dto.dart';

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
    required Location? location,
    required String? distance,
    required String? locale,
    required String? city,
    required String? country,
    @JsonKey(name: 'venue')  Venue? venue,
    @JsonKey(name: 'is_joined') required bool isJoined,
    @JsonKey(name: 'is_matched') bool? isMatched,
    @JsonKey(name: 'buddy_request_status',required: false)
    BuddyRequestStatus? buddyRequestStatus,
    @JsonKey(name: 'ticket_url') required String ticketUrl,
    required List<Images> images,
    @JsonKey(name: 'participant_avatars')
    required List<EventParticipantModel>? participantAvatars,
  }) = _EventDetail;

  factory EventDetail.fromJson(Map<String, dynamic> json) =>
      _$EventDetailFromJson(json);
}

@freezed
@immutable
class Location with _$Location {
  factory Location({
    required String longitude,
    required String latitude,
  }) = _Location;

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);
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

  factory Images.fromJson(Map<String, dynamic> json) => _$ImagesFromJson(json);
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
