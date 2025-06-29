import 'package:freezed_annotation/freezed_annotation.dart';

enum Gender {
  @JsonValue("male")
  male,
  @JsonValue("female")
  female,
  @JsonValue("other")
  other,
}

extension GenderExtension on Gender {
  String get value {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.other:
        return 'Other';
    }
  }
}