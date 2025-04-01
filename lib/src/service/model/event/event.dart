import 'package:freezed_annotation/freezed_annotation.dart';

part 'event.freezed.dart';

part 'event.g.dart';

@freezed
@immutable
class EventModel with _$EventModel {
  factory EventModel({
    required String name,
    required String type,
    required String id,
    required String locale,
    required Sales sales,
    required EventDates dates,
    @JsonKey(name: '_embedded') required Embedded embedded,
  }) = _EventModel;

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);
}

@freezed
class Embedded with _$Embedded {
  factory Embedded({
    required List<Attraction>? attractions,
    required List<Venue>? venues,
  }) = _Embedded;

  factory Embedded.fromJson(Map<String, dynamic> json) =>
      _$EmbeddedFromJson(json);
}

@freezed
class Sales with _$Sales {
  factory Sales({
    required PublicSales public,
  }) = _Sales;

  factory Sales.fromJson(Map<String, dynamic> json) => _$SalesFromJson(json);
}

@freezed
class PublicSales with _$PublicSales {
  factory PublicSales({
    required String startDateTime,
    required bool startTBD,
    required bool startTBA,
    required String endDateTime,
  }) = _PublicSales;

  factory PublicSales.fromJson(Map<String, dynamic> json) =>
      _$PublicSalesFromJson(json);
}

@freezed
class EventDates with _$EventDates {
  factory EventDates({
    required EventStart start,
    required EventStatus status,
    required String timezone,
    required bool spanMultipleDays,
  }) = _EventDates;

  factory EventDates.fromJson(Map<String, dynamic> json) =>
      _$EventDatesFromJson(json);
}

@freezed
class EventStart with _$EventStart {
  factory EventStart({
    required String localDate,
    required String localTime,
    required String dateTime,
    required bool dateTBD,
    required bool dateTBA,
    required bool timeTBA,
    required bool noSpecificTime,
  }) = _EventStart;

  factory EventStart.fromJson(Map<String, dynamic> json) =>
      _$EventStartFromJson(json);
}

@freezed
class EventStatus with _$EventStatus {
  factory EventStatus({
    required String code,
  }) = _EventStatus;

  factory EventStatus.fromJson(Map<String, dynamic> json) =>
      _$EventStatusFromJson(json);
}

@freezed
class Venue with _$Venue {
  factory Venue({
    required String name,
    required String locale,
    required String postalCode,
    required City city,
    required Country country,
  }) = _Venue;

  factory Venue.fromJson(Map<String, dynamic> json) => _$VenueFromJson(json);
}

@freezed
class City with _$City {
  factory City({
    required String name,
  }) = _City;

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
}

@freezed
class Country with _$Country {
  factory Country({
    required String name,
    required String countryCode,
  }) = _Country;

  factory Country.fromJson(Map<String, dynamic> json) =>
      _$CountryFromJson(json);
}

@freezed
class Attraction with _$Attraction {
  factory Attraction({
    required String type,
    required String id,
    required bool test,
    required String url,
    required ExternalLinks externalLinks,
    required List<ImageModel> images,
  }) = _Attraction;

  factory Attraction.fromJson(Map<String, dynamic> json) =>
      _$AttractionFromJson(json);
}

@freezed
class ExternalLinks with _$ExternalLinks {
  factory ExternalLinks({
    required List<Link>? facebook,
    required List<Link>? wiki,
    required List<Link>? homepage,
  }) = _ExternalLinks;

  factory ExternalLinks.fromJson(Map<String, dynamic> json) =>
      _$ExternalLinksFromJson(json);
}

@freezed
class Link with _$Link {
  factory Link({
    required String href,
  }) = _Link;

  factory Link.fromJson(Map<String, dynamic> json) => _$LinkFromJson(json);
}

@freezed
class ImageModel with _$ImageModel {
  factory ImageModel({
    required String ratio,
    required String url,
    required int width,
    required int height,
    required bool fallback,
  }) = _ImageModel;

  factory ImageModel.fromJson(Map<String, dynamic> json) =>
      _$ImageModelFromJson(json);
}
