import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthStorage {
  Future<void> setAccessToken(String token);
  Future<void> setRefreshToken(String token);
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> clearTokens();
}

class AuthStorageImpl implements AuthStorage {
  final FlutterSecureStorage _storage;

  AuthStorageImpl({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<void> setAccessToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  @override
  Future<void> setRefreshToken(String token) async {
    await _storage.write(key: 'refresh_token', value: token);
  }

  @override
  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'token');
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  @override
  Future<void> clearTokens() async {
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'refresh_token');
  }
}
