// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'city.freezed.dart';

part 'city.g.dart';

@freezed
@immutable
class City with _$City {
  factory City({
    @JsonKey(name: 'Name') required String name,
    @JsonKey(name: 'Lat') required num lat,
    @JsonKey(name: 'Lng') required num lng,
    @JsonKey(name: 'Country') required String country,
    @JsonKey(name: 'AdminName') required String cityName,
    @JsonKey(name: 'Population') required int population,
    @JsonKey(name: 'Capital') required String capital,


  }) = _City;

  factory City.fromJson(Map<String, dynamic> json) =>
      _$CityFromJson(json);
}
