import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fresh_dio/fresh_dio.dart';

enum StorageKey {
  accessToken;

  String get rawValue => toString();
}

class TokenStorageImpl implements TokenStorage<OAuth2Token> {
  /// Singleton class for token storage
  /// [TokenStorageImpl] is used to store token in secure storage
  factory TokenStorageImpl() => _instance;

  TokenStorageImpl._();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static final TokenStorageImpl _instance = TokenStorageImpl._();

  @override
  Future<void> delete() {
    return _secureStorage.delete(key: StorageKey.accessToken.rawValue);
  }

  @override
  Future<OAuth2Token?> read() async {
    OAuth2Token? token;
    final result =
        await _secureStorage.read(key: StorageKey.accessToken.rawValue);
    if (result != null) {
      return OAuth2Token(accessToken: result);
    }
    return token;
  }

  @override
  Future<void> write(OAuth2Token token) {
    return _secureStorage.write(
      key: StorageKey.accessToken.toString(),
      value: token.accessToken,
    );
  }
}
