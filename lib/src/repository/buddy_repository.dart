import 'package:dio/dio.dart';
import 'package:gig_buddy/src/http/dio/model/response_entity.dart';
import 'package:gig_buddy/src/repository/i_repository.dart';
import 'package:gig_buddy/src/service/api_provider/buddy_api_provider.dart';
import 'package:gig_buddy/src/service/model/buddy_requests/buddy_requests.dart';

class BuddyRepository extends IRepository {
  final _buddyApiProvider = BuddyApiProvider();

  Future<ResponseEntity<List<BuddyRequests>>> getBuddyRequests({
    CancelToken? cancelToken,
  }) async {
    return _buddyApiProvider.getBuddyRequests(
      cancelToken: cancelToken,
    );
  }

  Future<ResponseEntity<dynamic>> createBuddyRequest({
    required String eventId,
    required String receiverId,
    CancelToken? cancelToken,
  }) async {
    return _buddyApiProvider.createBuddyRequest(
      eventId: eventId,
      receiverId: receiverId,
      cancelToken: cancelToken,
    );
  }

  Future<ResponseEntity<void>> acceptBuddyRequest({
    required String buddyRequestId,
    CancelToken? cancelToken,
  }) async {
    return _buddyApiProvider.acceptBuddyRequest(
      buddyRequestId: buddyRequestId,
      cancelToken: cancelToken,
    );
  }

  Future<ResponseEntity<void>> rejectBuddyRequest({
    required String buddyRequestId,
    CancelToken? cancelToken,
  }) async {
    return _buddyApiProvider.rejectBuddyRequest(
      buddyRequestId: buddyRequestId,
      cancelToken: cancelToken,
    );
  }

  Future<ResponseEntity<void>> blockBuddyRequest({
    required String buddyRequestId,
    CancelToken? cancelToken,
  }) async {
    return _buddyApiProvider.blockBuddyRequest(
      buddyRequestId: buddyRequestId,
      cancelToken: cancelToken,
    );
  }
}
