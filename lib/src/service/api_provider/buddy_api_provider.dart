import 'package:dio/dio.dart';
import 'package:gig_buddy/src/http/const/http_const.dart';
import 'package:gig_buddy/src/http/dio/model/response_entity.dart';
import 'package:gig_buddy/src/service/api_provider/i_api_provider.dart';
import 'package:gig_buddy/src/service/model/buddy_requests/buddy_requests.dart';

class BuddyApiProvider extends ApiProvider {
  BuddyApiProvider()
      : super(
          HttpConst.buddyPath,
        );

  Future<ResponseEntity<List<BuddyRequests>>> getBuddyRequests({
    CancelToken? cancelToken,
  }) async {
    final response = await get(
      resource: 'requests',
      cancelToken: cancelToken,
    );

    final buddyRequests = (response.result as List)
        .map((e) => BuddyRequests.fromJson(e as Map<String, dynamic>))
        .toList();

    return ResponseEntity.success(
      statusCode: response.statusCode,
      displayMessage: response.displayMessage,
      data: buddyRequests,
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

  Future<ResponseEntity<void>> acceptBuddyRequest({
    required String buddyRequestId,
    CancelToken? cancelToken,
  }) async {
    return post(
      resource: 'requests/$buddyRequestId/accept',
      cancelToken: cancelToken,
    );
  }

  Future<ResponseEntity<void>> rejectBuddyRequest({
    required String buddyRequestId,
    CancelToken? cancelToken,
  }) async {
    return post(
      resource: 'requests/$buddyRequestId/reject',
      cancelToken: cancelToken,
    );
  }

  Future<ResponseEntity<void>> blockBuddyRequest({
    required String buddyRequestId,
    CancelToken? cancelToken,
  }) async {
    return post(
      resource: 'requests/$buddyRequestId/block',
      cancelToken: cancelToken,
    );
  }
}
