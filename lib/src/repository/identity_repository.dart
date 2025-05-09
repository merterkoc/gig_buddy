import 'dart:typed_data';

import 'package:fresh_dio/fresh_dio.dart';
import 'package:gig_buddy/src/http/dio/model/response_entity.dart';
import 'package:gig_buddy/src/repository/i_repository.dart';
import 'package:gig_buddy/src/service/api_provider/identiy_api_provider.dart';
import 'package:gig_buddy/src/service/model/token/token_dto.dart';

class IdentityRepository extends IRepository {
  final _identityApiProvider = IdentityApiProvider();

  Future<ResponseEntity<dynamic>> create({
    required String email,
    required String password,
    required String rePassword,
    required Uint8List? image,
  }) async {
    return _identityApiProvider.create(
      email: email,
      password: password,
      rePassword: rePassword,
      image: image,
    );
  }

  Future<ResponseEntity<TokenDTO>> verifyIDToken(String idToken) async {
    final response = await _identityApiProvider.verifyIDToken(idToken);
    final token = TokenDTO.fromJson(response.result as Map<String, dynamic>);
    return ResponseEntity<TokenDTO>(
      data: token,
      statusCode: response.statusCode,
    );
  }

  Future<void> setToken(OAuth2Token token) async {
    await _identityApiProvider.setToken(token);
  }

  Future<void> logout() async {
    _identityApiProvider.logout();
  }

  Future<ResponseEntity<dynamic>> getUserInfo() async {
    return await _identityApiProvider.getUserInfo();
  }

  Future<ResponseEntity<dynamic>> getAllInterests() async {
    return _identityApiProvider.getAllInterests();
  }

  Future<ResponseEntity<dynamic>> patchUserInterests(
    int interestsID,
    String operation,
  ) async {
    return _identityApiProvider.patchUserInterests(interestsID, operation);
  }

  Future<ResponseEntity<dynamic>> fetchUserProfile(String userId) async {
    return _identityApiProvider.fetchUserProfile(userId);
  }
}
