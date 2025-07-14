import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_metadata_dto.freezed.dart';
part 'user_metadata_dto.g.dart';

@freezed
class UserMetadataDTO with _$UserMetadataDTO {
  factory UserMetadataDTO({
    String? fcmt_token,
    String? location,
    bool? notification_enabled,
  }) = _UserMetadataDTO;

  factory UserMetadataDTO.fromJson(Map<String, dynamic> json) =>
      _$UserMetadataDTOFromJson(json);
}
