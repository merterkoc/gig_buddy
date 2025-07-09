import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gig_buddy/src/service/model/interest/interest_dto.dart';
import 'package:gig_buddy/src/service/model/enum/gender.dart';

part 'public_user_dto.freezed.dart';

part 'public_user_dto.g.dart';

@freezed
@immutable
class PublicUserDto with _$PublicUserDto {
  factory PublicUserDto({
    required String id,
    required String username,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'user_image') required String userImage,
    @JsonKey(name: 'interests') required List<InterestDto> interests,
    @JsonKey(name: 'birthdate') DateTime? birthdate,
    @JsonKey(name: 'gender') Gender? gender,
  }) = _PublicUserDto;

  factory PublicUserDto.fromJson(Map<String, dynamic> json) =>
      _$PublicUserDtoFromJson(json);
}
