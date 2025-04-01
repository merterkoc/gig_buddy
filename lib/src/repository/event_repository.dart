import 'package:gig_buddy/src/common/constants/app_constants.dart';
import 'package:gig_buddy/src/http/dio/model/response_entity.dart';
import 'package:gig_buddy/src/repository/i_repository.dart';
import 'package:gig_buddy/src/service/api_provider/event_api_provider.dart';

class EventRepository extends IRepository {

  final _eventApiProvider = EventApiProvider();

  Future<ResponseEntity<dynamic>> fetchData({
    required int page,
    String? keyword,
    String? location,
  }) async {
    return _eventApiProvider.fetchEvent(
      keyword: keyword,
      location: location,
      page: page,
      size: AppConstants.limit,
    );
  }
}
