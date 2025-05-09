import 'package:dio/dio.dart';
import 'package:gig_buddy/src/common/constants/app_constants.dart';
import 'package:gig_buddy/src/http/dio/model/response_entity.dart';
import 'package:gig_buddy/src/repository/i_repository.dart';
import 'package:gig_buddy/src/service/api_provider/event_api_provider.dart';

class EventRepository extends IRepository {
  final _eventApiProvider = EventApiProvider();

  Future<ResponseEntity<dynamic>> fetchData({
    required int page,
    int? size = AppConstants.limit,
    String? keyword,
    String? city,
    String? location,
    CancelToken? cancelToken,
  }) async {
    return _eventApiProvider.fetchEvent(
      keyword: keyword,
      city: city,
      location: location,
      page: page,
      size: size,
      cancelToken: cancelToken,
    );
  }

  Future<ResponseEntity<dynamic>> fetchEventById(String eventId) {
    return _eventApiProvider.fetchEventById(eventId);
  }

  Future<ResponseEntity<void>> joinEvent(String eventId) {
    return _eventApiProvider.joinEvent(eventId);
  }

  Future<ResponseEntity<void>> leaveEvent(String eventId) {
    return _eventApiProvider.leaveEvent(eventId);
  }

  Future<ResponseEntity<dynamic>> getMyEvents() {
    return _eventApiProvider.getMyEvents();
  }

  Future<ResponseEntity<dynamic>> getEventsByUserId(String userId) {
    return _eventApiProvider.getEventsByUserId(userId);
  }

  Future<ResponseEntity<dynamic>> getNearCity({
    required num lat,
    required num lng,
    required int radius,
    required int limit,
  }) async {
    return _eventApiProvider.getNearCity(
      lat: lat,
      lng: lng,
      radius: radius,
      limit: limit,
    );
  }
}
