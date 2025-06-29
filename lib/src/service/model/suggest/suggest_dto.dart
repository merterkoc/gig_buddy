import 'package:freezed_annotation/freezed_annotation.dart';

part 'suggest_dto.freezed.dart';

part 'suggest_dto.g.dart';

@freezed
@immutable
@freezed
class SuggestDTO with _$SuggestDTO {
  const factory SuggestDTO({
    @JsonKey(name: '_links') required SuggestLinks links,
    @JsonKey(name: '_embedded') required SuggestEmbedded embedded,
  }) = _SuggestDTO;

  factory SuggestDTO.fromJson(Map<String, dynamic> json) =>
      _$SuggestDTOFromJson(json);
}

@freezed
class SuggestLinks with _$SuggestLinks {
  const factory SuggestLinks({
    required SuggestSelfLink self,
  }) = _SuggestLinks;

  factory SuggestLinks.fromJson(Map<String, dynamic> json) =>
      _$SuggestLinksFromJson(json);
}

@freezed
class SuggestSelfLink with _$SuggestSelfLink {
  const factory SuggestSelfLink({
    required String href,
  }) = _SuggestSelfLink;

  factory SuggestSelfLink.fromJson(Map<String, dynamic> json) =>
      _$SuggestSelfLinkFromJson(json);
}

@freezed
class SuggestEmbedded with _$SuggestEmbedded {
  const factory SuggestEmbedded({
    List<Venue>? venues,
    List<Attraction>? attractions,
    List<Event>? events,
    List<Product>? products,
  }) = _SuggestEmbedded;

  factory SuggestEmbedded.fromJson(Map<String, dynamic> json) =>
      _$SuggestEmbeddedFromJson(json);
}

@freezed
class Venue with _$Venue {
  const factory Venue({
    required String name,
    String? type,
    required String id,
    String? url,
    required String locale,
    double? distance,
    String? units,
    String? timezone,
    required City city,
    required Country country,
    Location? location,
    @JsonKey(name: 'upcomingEvents') VenueEvents? upcomingEvents,
    @JsonKey(name: '_links') SuggestLinks? links,
  }) = _Venue;

  factory Venue.fromJson(Map<String, dynamic> json) => _$VenueFromJson(json);
}

@freezed
class City with _$City {
  const factory City({
    required String name,
  }) = _City;

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
}

@freezed
class Country with _$Country {
  const factory Country({
    required String name,
    required String countryCode,
  }) = _Country;

  factory Country.fromJson(Map<String, dynamic> json) =>
      _$CountryFromJson(json);
}

@freezed
class Location with _$Location {
  const factory Location({
    required String longitude,
    required String latitude,
  }) = _Location;

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
}

@freezed
class VenueEvents with _$VenueEvents {
  const factory VenueEvents({
    @JsonKey(name: 'wts-tr') required int wtsTr,
    @JsonKey(name: '_total') required int total,
    @JsonKey(name: '_filtered') required int filtered,
  }) = _VenueEvents;

  factory VenueEvents.fromJson(Map<String, dynamic> json) =>
      _$VenueEventsFromJson(json);
}

@freezed
class Attraction with _$Attraction {
  const factory Attraction({
    required String name,
    required String type,
    required String id,
    required String? url,
    required String? locale,
    ExternalLinks? externalLinks,
    List<String>? aliases,
    List<ImageData>? images,
    List<Classification>? classifications,
    UpcomingEvents? upcomingEvents,
    @JsonKey(name: '_links') required SuggestLinks? links,
  }) = _Attraction;

  factory Attraction.fromJson(Map<String, dynamic> json) =>
      _$AttractionFromJson(json);
}

@freezed
class ExternalLinks with _$ExternalLinks {
  const factory ExternalLinks({
    List<ExternalUrl>? twitter,
    List<ExternalUrl>? facebook,
    List<ExternalUrl>? wiki,
    List<ExternalUrl>? instagram,
    List<ExternalUrl>? homepage,
  }) = _ExternalLinks;

  factory ExternalLinks.fromJson(Map<String, dynamic> json) =>
      _$ExternalLinksFromJson(json);
}

@freezed
class ExternalUrl with _$ExternalUrl {
  const factory ExternalUrl({
    required String url,
  }) = _ExternalUrl;

  factory ExternalUrl.fromJson(Map<String, dynamic> json) =>
      _$ExternalUrlFromJson(json);
}

@freezed
class ImageData with _$ImageData {
  const factory ImageData({
    required String ratio,
    required String url,
    required int width,
    required int height,
    required bool fallback,
  }) = _ImageData;

  factory ImageData.fromJson(Map<String, dynamic> json) =>
      _$ImageDataFromJson(json);
}

@freezed
class Classification with _$Classification {
  const factory Classification({
    required bool primary,
    required Segment segment,
    required Genre genre,
    required SubGenre? subGenre,
    required Type? type,
    required SubType? subType,
    required bool? family,
  }) = _Classification;

  factory Classification.fromJson(Map<String, dynamic> json) =>
      _$ClassificationFromJson(json);
}

@freezed
class Segment with _$Segment {
  const factory Segment({
    required String id,
    required String name,
  }) = _Segment;

  factory Segment.fromJson(Map<String, dynamic> json) =>
      _$SegmentFromJson(json);
}

@freezed
class Genre with _$Genre {
  const factory Genre({
    required String id,
    required String name,
  }) = _Genre;

  factory Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);
}

@freezed
class SubGenre with _$SubGenre {
  const factory SubGenre({
    required String id,
    required String name,
  }) = _SubGenre;

  factory SubGenre.fromJson(Map<String, dynamic> json) =>
      _$SubGenreFromJson(json);
}

@freezed
class Type with _$Type {
  const factory Type({
    required String id,
    required String name,
  }) = _Type;

  factory Type.fromJson(Map<String, dynamic> json) => _$TypeFromJson(json);
}

@freezed
class SubType with _$SubType {
  const factory SubType({
    required String id,
    required String name,
  }) = _SubType;

  factory SubType.fromJson(Map<String, dynamic> json) =>
      _$SubTypeFromJson(json);
}

@freezed
class UpcomingEvents with _$UpcomingEvents {
  const factory UpcomingEvents({
    @JsonKey(name: 'ticketmaster') int? ticketmaster,
    @JsonKey(name: '_total') required int total,
    @JsonKey(name: '_filtered') required int filtered,
  }) = _UpcomingEvents;

  factory UpcomingEvents.fromJson(Map<String, dynamic> json) =>
      _$UpcomingEventsFromJson(json);
}

@freezed
class Event with _$Event {
  const factory Event({
    required String name,
    required String type,
    required String id,
    required String url,
    required String locale,
    required List<ImageData> images,
    required double distance,
    required String units,
    required EventDates dates,
    required List<Classification> classifications,
    required Location location,
    @JsonKey(name: '_links') required EventLinks links,
    @JsonKey(name: '_embedded') EventEmbedded? embedded,
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}

@freezed
class EventDates with _$EventDates {
  const factory EventDates({
    required EventStart start,
    required String timezone,
    required EventStatus status,
    required bool spanMultipleDays,
  }) = _EventDates;

  factory EventDates.fromJson(Map<String, dynamic> json) =>
      _$EventDatesFromJson(json);
}

@freezed
class EventStart with _$EventStart {
  const factory EventStart({
    required String localDate,
    required String localTime,
    required DateTime dateTime,
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
  const factory EventStatus({
    required String code,
  }) = _EventStatus;

  factory EventStatus.fromJson(Map<String, dynamic> json) =>
      _$EventStatusFromJson(json);
}

@freezed
class EventLinks with _$EventLinks {
  const factory EventLinks({
    required SuggestSelfLink self,
    List<SuggestSelfLink>? attractions,
    List<SuggestSelfLink>? venues,
  }) = _EventLinks;

  factory EventLinks.fromJson(Map<String, dynamic> json) =>
      _$EventLinksFromJson(json);
}

@freezed
class EventEmbedded with _$EventEmbedded {
  const factory EventEmbedded({
    List<Venue>? venues,
    List<Attraction>? attractions,
  }) = _EventEmbedded;

  factory EventEmbedded.fromJson(Map<String, dynamic> json) =>
      _$EventEmbeddedFromJson(json);
}

@freezed
class Product with _$Product {
  const factory Product({
    required String name,
    required String type,
    required String id,
    required String url,
    required String locale,
    required List<ImageData> images,
    required double distance,
    required String units,
    required EventDates dates,
    required List<Classification> classifications,
    required Location location,
    @JsonKey(name: '_links') required EventLinks links,
    @JsonKey(name: '_embedded') EventEmbedded? embedded,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
