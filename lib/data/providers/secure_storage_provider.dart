

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageProvider {

  static SecureStorageProvider? _instance;

  factory SecureStorageProvider() =>
      _instance ??= SecureStorageProvider._(const FlutterSecureStorage());

  SecureStorageProvider._(this._storage);

  final FlutterSecureStorage _storage;


  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  Future<void> setAccessToken({required String accessToken}) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
  }
  Future<String?> getAccessToken() async {
    return _storage.read(key: _accessTokenKey);
  }


  Future<void> setRefreshToken({required String refreshToken}) async {
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }
  Future<String?> getRefreshToken() async {
    return _storage.read(key: _refreshTokenKey);
  }

  Future<void> deleteTokens() async {
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _accessTokenKey);
  }
}