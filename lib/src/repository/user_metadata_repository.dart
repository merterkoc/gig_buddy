import 'dart:typed_data';

import 'package:fresh_dio/fresh_dio.dart';
import 'package:gig_buddy/src/http/dio/model/response_entity.dart';
import 'package:gig_buddy/src/repository/i_repository.dart';
import 'package:gig_buddy/src/service/api_provider/user_metadata_api_provider.dart';
import 'package:gig_buddy/src/service/model/token/token_dto.dart';
import 'package:gig_buddy/src/service/model/update_user_request/update_user_request.dart';
import 'package:gig_buddy/src/service/model/enum/gender.dart';
import 'package:gig_buddy/src/service/model/user/user_metadata_dto.dart';

class UserMetadataRepository extends IRepository {
  final _userMetadataApiProvider = UserMetadataApiProvider();

  Future<ResponseEntity<dynamic>> patchUserMetadata({
    String? fcmt_token,
    String? location,
    bool? notification_enabled,
  }) async {
    final dto = UserMetadataDTO(
      fcmt_token: fcmt_token,
      location: location,
      notification_enabled: notification_enabled,
    );
    return _userMetadataApiProvider.patchUserMetadata(dto);
  }
}
