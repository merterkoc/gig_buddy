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
    String? location,
    CancelToken? cancelToken,
  }) async {
    return _eventApiProvider.fetchEvent(
      keyword: keyword,
      location: location,
      page: page,
      size: size,
      cancelToken: cancelToken,
    );
  }

  Future<ResponseEntity<void>> joinEvent(String eventId) {
    return _eventApiProvider.joinEvent(eventId);
  }

  Future<ResponseEntity<void>> leaveEvent(String eventId) {
    return _eventApiProvider.leaveEvent(eventId);
  }
}
