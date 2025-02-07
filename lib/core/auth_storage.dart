import 'dart:convert';

import 'package:categorease/feature/home/model/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthStorage {
  Future<void> setAccessToken(String token);
  Future<void> setRefreshToken(String token);
  Future<void> setAuthenticatedUser(User user);
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<User?> getAuthenticatedUser();
  Future<void> clearTokens();
}

class AuthStorageImpl implements AuthStorage {
  final FlutterSecureStorage _storage;
  final String _accessTokenKey = 'token';
  final String _refreshTokenKey = 'refresh_token';
  final String _authenticatedUserKey = 'auth_user';

  AuthStorageImpl({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<void> setAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  @override
  Future<void> setRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  @override
  Future<void> setAuthenticatedUser(User user) async {
    await _storage.write(
        key: _authenticatedUserKey, value: jsonEncode(user.toJson()));
  }

  @override
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  @override
  Future<User?> getAuthenticatedUser() async {
    final rawUser = await _storage.read(key: _authenticatedUserKey);

    if (rawUser == null) {
      return null;
    }

    final user = User.fromJson(jsonDecode(rawUser));

    return user;
  }

  @override
  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }
}
