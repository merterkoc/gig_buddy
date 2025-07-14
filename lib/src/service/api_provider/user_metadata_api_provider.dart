import 'package:gig_buddy/src/http/const/http_const.dart';
import 'package:gig_buddy/src/http/dio/model/response_entity.dart';
import 'package:gig_buddy/src/service/api_provider/i_api_provider.dart';
import 'package:gig_buddy/src/service/model/user/user_metadata_dto.dart';

class UserMetadataApiProvider extends ApiProvider {
  UserMetadataApiProvider() : super(HttpConst.userMetadataPath);

  Future<ResponseEntity<dynamic>> patchUserMetadata(UserMetadataDTO dto) {
    return patch(
      resource: '',
      data: dto.toJson(),
    );
  }
}
