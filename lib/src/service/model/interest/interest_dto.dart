
import 'package:freezed_annotation/freezed_annotation.dart';

part 'interest_dto.freezed.dart';

part 'interest_dto.g.dart';

@freezed
@immutable
class InterestDto with _$InterestDto {
  factory InterestDto({
    required int id,
    required String name,
  }) = _InterestDto;

  factory InterestDto.fromJson(Map<String, dynamic> json) =>
      _$InterestDtoFromJson(json);
}
