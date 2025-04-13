import 'package:dio/dio.dart';
import 'package:gig_buddy/src/http/const/http_const.dart';
import 'package:gig_buddy/src/http/dio/model/response_entity.dart';
import 'package:gig_buddy/src/service/api_provider/i_api_provider.dart';

class BuddyApiProvider extends ApiProvider {
  BuddyApiProvider()
      : super(
          HttpConst.buddyPath,
        );

  Future<ResponseEntity<dynamic>> getBuddyRequests({
    CancelToken? cancelToken,
  }) async {
    return get(
      resource: 'requests',
      cancelToken: cancelToken,
    );
  }

  Future<ResponseEntity<dynamic>> createBuddyRequest({
    required String eventId,
    required String receiverId,
    CancelToken? cancelToken,
  }) async {
    return post(
      resource: 'requests',
      cancelToken: cancelToken,
      data: {
        'receiver_id': receiverId,
        'event_id': eventId,
      },
    );
  }

  Future<ResponseEntity<dynamic>> acceptBuddyRequest({
    required String buddyRequestId,
    CancelToken? cancelToken,
  }) async {
    return post(
      resource: 'requests/$buddyRequestId/accept',
      cancelToken: cancelToken,
    );
  }
}
