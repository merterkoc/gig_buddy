import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:gig_buddy/src/http/const/http_const.dart';
import 'package:gig_buddy/src/http/dio/model/response_entity.dart';
import 'package:gig_buddy/src/service/api_provider/i_api_provider.dart';

class IdentityApiProvider extends ApiProvider {
  IdentityApiProvider()
      : super(
          HttpConst.identity,
        );

  Future<ResponseEntity<dynamic>> create({
    required String email,
    required String password,
    required Uint8List? image,
  }) async {
    MultipartFile? multipartFile;
    if (image != null) {
      multipartFile = MultipartFile.fromBytes(
        image as List<int>,
        filename: '${image.hashCode}.jpg',
        contentType: DioMediaType('image', 'jpg'),
      );
    }

    final data = FormData.fromMap({
      'email': email,
      'password': password,
      'username': email,
      if (image != null) 'image': multipartFile,
    });
    return post(
      resource: 'create',
      data: data,
    );
  }

  Future<ResponseEntity<dynamic>> verifyIDToken(String token) async {
    return post(
      resource: 'verify',
      data: {
        'idToken': token,
      },
    );
  }

  Future<Future<ResponseEntity<dynamic>>> getUserInfo() async {
    return get(
      resource: 'userinfo',
    );
  }

  Future<ResponseEntity<dynamic>> getAllInterests() {
    return get(
      resource: 'userinfo/interests',
    );
  }

  Future<ResponseEntity<dynamic>> patchUserInterests(
    int interestsID,
    String operation,
  ) {
    return patch(
      resource: 'userinfo/interests',
      data: {
        'interest_id': interestsID,
        'operation': operation,
      },
    );
  }
}
