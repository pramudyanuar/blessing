import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageUtil {
  static SecureStorageUtil? _instance;
  late FlutterSecureStorage _storage;

  factory SecureStorageUtil() {
    _instance ??= SecureStorageUtil._();
    return _instance!;
  }

  SecureStorageUtil._();

  Future<void> init() async {
    _storage = FlutterSecureStorage();
  }

  /// Save access token securely
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: 'access_token', value: token);
  }

  /// Retrieve access token securely
  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  /// Delete access token securely
  Future<void> deleteAccessToken() async {
    await _storage.delete(key: 'access_token');
  }

  /// Save refresh token securely
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: 'refresh_token', value: token);
  }

  /// Retrieve refresh token securely
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  /// Delete refresh token securely
  Future<void> deleteRefreshToken() async {
    await _storage.delete(key: 'refresh_token');
  }

  /// Clear all stored tokens
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  static const String _userRoleKey = 'user_role';

  Future<void> saveUserRole(String role) async {
    await _storage.write(key: _userRoleKey, value: role);
  }

  Future<String?> getUserRole() async {
    return await _storage.read(key: _userRoleKey);
  }

  Future<void> deleteUserRole() async {
    await _storage.delete(key: _userRoleKey);
  }
}
