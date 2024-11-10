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
    required String location,
    required String distance,
    @JsonKey(name: 'is_joined') required bool isJoined,
    @JsonKey(name: 'ticket_url') required String ticketUrl,
    required List<String> images,
    @JsonKey(name: 'participant_avatars')
    required List<String>? participantAvatars,
  }) = _EventModel;

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);
}
