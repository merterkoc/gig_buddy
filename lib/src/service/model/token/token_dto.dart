import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_dto.freezed.dart';

part 'token_dto.g.dart';

@freezed
@immutable
class TokenDTO with _$TokenDTO {
  factory TokenDTO({
    required String token,
  }) = _TokenDTO;

  factory TokenDTO.fromJson(Map<String, dynamic> json) =>
      _$TokenDTOFromJson(json);
}
