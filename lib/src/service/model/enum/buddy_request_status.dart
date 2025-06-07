import 'package:freezed_annotation/freezed_annotation.dart';

enum BuddyRequestStatus {
  @JsonValue("pending")
  pending,
  @JsonValue("accepted")
  accepted,
  @JsonValue("rejected")
  rejected,
  @JsonValue("blocked")
  blocked,
}
