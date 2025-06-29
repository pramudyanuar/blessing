import 'package:blessing/core/config/main_app.dart';
import 'package:blessing/core/utils/cache_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:blessing/core/utils/secure_storage_util.dart';

final _noScreenshot = NoScreenshot.instance;
final SecureStorageUtil secureStorageUtil = SecureStorageUtil();
final CacheUtil cacheUtil = CacheUtil();

Future<void> disableScreenshot() async {
  bool result = await _noScreenshot.screenshotOff();
  debugPrint('Screenshot Off: $result');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await secureStorageUtil.init();
  await cacheUtil.init();
  await disableScreenshot();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(const MainApp());
  });
}
