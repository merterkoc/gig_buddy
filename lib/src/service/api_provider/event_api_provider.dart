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
    String? location,
    CancelToken? cancelToken,
  }) async {
    return get(
      cancelToken: cancelToken,
      queryParameters: {
        if (keyword != null) 'keyword': keyword,
        if (location != null) 'location': location,
        if (size != null) 'page': page,
        if (size != null) 'size': size,
      },
    );
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
}
