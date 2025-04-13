import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gig_buddy/src/service/model/event_detail/event_detail.dart';
import 'package:gig_buddy/src/service/model/user/user_dto.dart';

part 'buddy_requests.freezed.dart';

part 'buddy_requests.g.dart';

@freezed
@immutable
class BuddyRequests with _$BuddyRequests {
  factory BuddyRequests({
    required String id,
    @JsonKey(name: 'sender') required UserDto sender,
    @JsonKey(name: 'receiver') required UserDto receiver,
    @JsonKey(name: 'event') required EventDetail event,
    required String status,
  }) = _BuddyRequests;

  factory BuddyRequests.fromJson(Map<String, dynamic> json) =>
      _$BuddyRequestsFromJson(json);
}

extension BuddyRequestsExt on BuddyRequests {
  bool get isAccepted => status == 'accepted';
}