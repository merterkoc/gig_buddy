import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gig_buddy/src/service/model/enum/gender.dart';

part 'update_user_request.freezed.dart';

part 'update_user_request.g.dart';

@freezed
@immutable
class UpdateUserRequestDTO with _$UpdateUserRequestDTO {
  factory UpdateUserRequestDTO({
    required Gender gender,
    @JsonKey(
      fromJson: _fromJsonDate,
      toJson: _toJsonDate,
    )
    required DateTime birthdate,
  }) = _UpdateUserRequestDTO;

  factory UpdateUserRequestDTO.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserRequestDTOFromJson(json);
}

// Saat dilimini içeren ISO 8601 formatı için converter
String _toJsonDate(DateTime date) => date.toUtc().toIso8601String();
DateTime _fromJsonDate(String date) => DateTime.parse(date);