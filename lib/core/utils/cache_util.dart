import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

/// Utilitas untuk mengelola caching data menggunakan Hive.
///
/// Menyediakan metode untuk menyimpan, mengambil, dan menghapus
/// data dari cache lokal. Hive dipilih karena performanya yang cepat
/// dan kemampuannya menyimpan objek Dart secara langsung.
class CacheUtil {
  static CacheUtil? _instance;

  // Nama untuk "box" atau "tabel" di Hive
  static const String _boxName = 'app_cache';

  factory CacheUtil() {
    _instance ??= CacheUtil._();
    return _instance!;
  }

  CacheUtil._();

  /// Inisialisasi Hive. Panggil method ini di main.dart sebelum runApp().
  Future<void> init() async {
    // Dapatkan direktori yang aman untuk menyimpan database di mobile
    final Directory appSupportDir = await getApplicationSupportDirectory();

    // Inisialisasi Hive dengan path tersebut
    await Hive.initFlutter(appSupportDir.path);

    // Buka box yang akan kita gunakan untuk caching
    await Hive.openBox(_boxName);
  }

  Box<dynamic> get _cacheBox => Hive.box(_boxName);

  /// Menyimpan data ke cache.
  ///
  /// [key] adalah pengenal unik untuk data.
  /// [value] adalah data yang ingin disimpan. Bisa berupa tipe data apa pun.
  Future<void> setData(String key, dynamic value) async {
    try {
      await _cacheBox.put(key, value);
    } catch (e) {
      print('Error saving data to cache: $e');
    }
  }

  /// Mengambil data dari cache.
  ///
  /// Mengembalikan data jika ada, atau null jika tidak ditemukan.
  dynamic getData(String key) {
    try {
      return _cacheBox.get(key);
    } catch (e) {
      print('Error reading data from cache: $e');
      return null;
    }
  }

  /// Memeriksa apakah data dengan key tertentu ada di cache.
  bool hasData(String key) {
    try {
      return _cacheBox.containsKey(key);
    } catch (e) {
      print('Error checking data in cache: $e');
      return false;
    }
  }

  /// Menghapus data spesifik dari cache berdasarkan key.
  Future<void> removeData(String key) async {
    try {
      await _cacheBox.delete(key);
    } catch (e) {
      print('Error removing data from cache: $e');
    }
  }

  /// Menghapus semua data dari cache box.
  /// Berguna saat logout atau saat ingin membersihkan cache sepenuhnya.
  Future<void> clearCache() async {
    try {
      await _cacheBox.clear();
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }
}
