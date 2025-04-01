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
    required int size,
    String? keyword,
    String? location,
  }) async {
    return get(
      queryParameters: {
        if (keyword != null) 'keyword': keyword,
        if (location != null) 'location': location,
        'page': page,
        'size': size,
      },
    );
  }

  Future<ResponseEntity<dynamic>> fetchEventById(String eventId) async {
    return get(resource: eventId);
  }
}
