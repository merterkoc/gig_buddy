import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_dto.freezed.dart';

part 'user_dto.g.dart';

@freezed
@immutable
class UserDto with _$UserDto {
  factory UserDto({
    required String email,
    required String username,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'user_image') required String userImage,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}
