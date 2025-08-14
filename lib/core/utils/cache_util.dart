import 'dart:io';
import 'package:blessing/core/helpers/course_content_type_adapter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class CacheUtil {
  static CacheUtil? _instance;

  static const String _boxName = 'app_cache';

  factory CacheUtil() {
    _instance ??= CacheUtil._();
    return _instance!;
  }

  CacheUtil._();

  Future<void> init() async {
    final Directory appSupportDir = await getApplicationSupportDirectory();
    await Hive.initFlutter(appSupportDir.path);

     if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(CourseContentTypeAdapter());
    }
    
    await Hive.openBox(_boxName);
  }

  Box<dynamic> get _cacheBox => Hive.box(_boxName);

  Future<void> setData(String key, dynamic value) async {
    try {
      await _cacheBox.put(key, value);
    } catch (e) {
      print('Error saving data to cache: $e');
    }
  }

  dynamic getData(String key) {
    try {
      return _cacheBox.get(key);
    } catch (e) {
      print('Error reading data from cache: $e');
      return null;
    }
  }

  bool hasData(String key) {
    try {
      return _cacheBox.containsKey(key);
    } catch (e) {
      print('Error checking data in cache: $e');
      return false;
    }
  }

  Future<void> removeData(String key) async {
    try {
      await _cacheBox.delete(key);
    } catch (e) {
      print('Error removing data from cache: $e');
    }
  }

  Future<void> clearCache() async {
    try {
      await _cacheBox.clear();
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }
}
