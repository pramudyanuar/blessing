import 'package:blessing/core/config/main_app.dart';
import 'package:blessing/core/utils/cache_util.dart';
import 'package:blessing/core/utils/system_ui_util.dart';
import 'package:blessing/core/services/crash_reporting_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:blessing/core/utils/secure_storage_util.dart';

final _noScreenshot = NoScreenshot.instance;
final SecureStorageUtil secureStorageUtil = SecureStorageUtil();
final CacheUtil cacheUtil = CacheUtil();

Future<void> disableScreenshot() async {
  bool result = await _noScreenshot.screenshotOff();
  if (kDebugMode) {
    debugPrint('Screenshot Off: $result');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize crash reporting first
  await crashReporting.initialize();
  
  await secureStorageUtil.init();
  await cacheUtil.init();
  await disableScreenshot();
  await initializeDateFormatting('id_ID', null);

  // Gunakan SystemUIUtil untuk mengatur system UI
  SystemUIUtil.initializeAppSystemUI();

  runApp(const MainApp());
}
