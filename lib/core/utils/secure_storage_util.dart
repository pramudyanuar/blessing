import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Utilitas untuk mengelola penyimpanan aman (secure storage) di aplikasi.
///
/// Menggunakan singleton pattern untuk memastikan hanya ada satu instance.
/// Mengamankan data menggunakan Keychain pada iOS dan EncryptedSharedPreferences pada Android.
class SecureStorageUtil {
  static SecureStorageUtil? _instance;
  late final FlutterSecureStorage _storage;

  factory SecureStorageUtil() {
    _instance ??= SecureStorageUtil._();
    return _instance!;
  }

  /// Konstruktor privat untuk singleton pattern.
  SecureStorageUtil._();

  /// Inisialisasi storage. Panggil method ini di main.dart sebelum runApp().
  Future<void> init() async {
    // Menambahkan opsi keamanan ekstra untuk Android.
    // Ini akan menggunakan SharedPreferences yang terenkripsi.
    const androidOptions = AndroidOptions(
      encryptedSharedPreferences: true,
    );
    _storage = const FlutterSecureStorage(aOptions: androidOptions);
  }

  /// Menyimpan access token dengan aman.
  Future<void> saveAccessToken(String token) async {
    try {
      await _storage.write(key: 'access_token', value: token);
    } catch (e) {
      // Sebaiknya gunakan logger yang lebih baik di aplikasi produksi
      print('Error saving access token: $e');
    }
  }

  /// Mengambil access token yang tersimpan.
  /// Mengembalikan null jika token tidak ada atau terjadi error.
  Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: 'access_token');
    } catch (e) {
      print('Error reading access token: $e');
      return null;
    }
  }

  /// Menghapus access token dari penyimpanan.
  Future<void> deleteAccessToken() async {
    try {
      await _storage.delete(key: 'access_token');
    } catch (e) {
      print('Error deleting access token: $e');
    }
  }

  /// Menyimpan refresh token dengan aman.
  Future<void> saveRefreshToken(String token) async {
    try {
      await _storage.write(key: 'refresh_token', value: token);
    } catch (e) {
      print('Error saving refresh token: $e');
    }
  }

  /// Mengambil refresh token yang tersimpan.
  /// Mengembalikan null jika token tidak ada atau terjadi error.
  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: 'refresh_token');
    } catch (e) {
      print('Error reading refresh token: $e');
      return null;
    }
  }

  /// Menghapus refresh token dari penyimpanan.
  Future<void> deleteRefreshToken() async {
    try {
      await _storage.delete(key: 'refresh_token');
    } catch (e) {
      print('Error deleting refresh token: $e');
    }
  }

  /// Menghapus semua data (access token, refresh token, dll.) dari secure storage.
  /// Berguna saat pengguna logout.
  Future<void> clearTokens() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      print('Error clearing all tokens: $e');
    }
  }
}
