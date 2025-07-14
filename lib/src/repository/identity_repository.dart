import 'dart:typed_data';

import 'package:fresh_dio/fresh_dio.dart';
import 'package:gig_buddy/src/http/dio/model/response_entity.dart';
import 'package:gig_buddy/src/repository/i_repository.dart';
import 'package:gig_buddy/src/service/api_provider/identiy_api_provider.dart';
import 'package:gig_buddy/src/service/model/token/token_dto.dart';
import 'package:gig_buddy/src/service/model/update_user_request/update_user_request.dart';
import 'package:gig_buddy/src/service/model/enum/gender.dart';

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

  Future<ResponseEntity<dynamic>> updateUserDetails(
      UpdateUserRequestDTO updateUserRequestDTO) async {
    return _identityApiProvider.updateUserDetails(updateUserRequestDTO);
  }

  Future<ResponseEntity<dynamic>> patchUserMetadata({
    String? fcmt_token,
    String? location,
    bool? notification_enabled,
    Gender? gender,
    DateTime? birthdate,
  }) async {
    // Only gender and birthdate are required in DTO, but for metadata patch, allow them to be optional
    final dto = UpdateUserRequestDTO(
      gender: gender ?? Gender.other, // fallback if not provided
      birthdate: birthdate ?? DateTime(2000, 1, 1), // fallback if not provided
      fcmt_token: fcmt_token,
      location: location,
      notification_enabled: notification_enabled,
    );
    return _identityApiProvider.updateUserDetails(dto);
  }
}
