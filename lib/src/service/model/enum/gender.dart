import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gig_buddy/core/localization/manager/localization_manager.dart';

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
        return LocalizationManager().l10.gender_male;
      case Gender.female:
        return LocalizationManager().l10.gender_female;
      case Gender.other:
        return LocalizationManager().l10.gender_other;
    }
  }
}
