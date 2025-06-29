import 'package:dio/dio.dart';
import 'package:gig_buddy/src/http/const/http_const.dart';
import 'package:gig_buddy/src/http/dio/model/response_entity.dart';
import 'package:gig_buddy/src/service/api_provider/i_api_provider.dart';

class EventApiProvider extends ApiProvider {
  EventApiProvider()
      : super(
          HttpConst.eventPath,
        );

  Future<ResponseEntity<dynamic>> fetchEvent({
    required int page,
    required int? size,
    String? keyword,
    String? city,
    String? location,
    String? venueId,
    CancelToken? cancelToken,
  }) async {
    final queryParameters = venueId != null
        ? {
            'venue_id': venueId,
            'page': page,
            if (size != null) 'size': size,
          }
        : {
            if (keyword != null) 'keyword': keyword,
            if (location != null) 'location': location,
            if (city != null) 'city': city,
            'page': page,
            if (size != null) 'size': size,
          };
    return get(cancelToken: cancelToken, queryParameters: queryParameters);
  }

  Future<ResponseEntity<dynamic>> fetchEventById(String eventId) async {
    return get(resource: eventId);
  }

  Future<ResponseEntity<dynamic>> joinEvent(String eventId) async {
    return post(resource: '$eventId/join');
  }

  Future<ResponseEntity<dynamic>> leaveEvent(String eventId) async {
    return post(resource: '$eventId/leave');
  }

  Future<ResponseEntity<dynamic>> getMyEvents() async {
    return get(resource: 'user');
  }

  Future<ResponseEntity<dynamic>> getEventsByUserId(String userId) async {
    return get(resource: 'user/$userId');
  }

  Future<ResponseEntity<dynamic>> getNearCity({
    required num lat,
    required num lng,
    required int radius,
    required int limit,
  }) async {
    return post(
      resource: 'near-city',
      data: {
        'lat': lat,
        'lng': lng,
        'radius': radius,
        'limit': limit,
      },
    );
  }

  Future<ResponseEntity<dynamic>> suggests({
    required num lat,
    required num lng,
  }) async {
    return get(
      resource: 'suggest',
      queryParameters: {
        'location': '$lat,$lng',
      },
    );
  }
}
