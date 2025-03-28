import 'package:blessing/core/config/main_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// SharedPreferencesUtils sharedPreferencesUtils = SharedPreferencesUtils();
// SecureStorageUtil secureStorageUtil = SecureStorageUtil();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await sharedPreferencesUtils.init();
  // await secureStorageUtil.init();
  // await dotenv.load(fileName: ".env");
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // sharedPreferencesUtils.init();

  // FlavorConfig(name: "PRODUCTION", color: Colors.red, variables: {
  //   "counter": 0,
  //   "baseUrl": "https://www.example.com",
  // });

  // runApp(const MainApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(const MainApp());
  });
}
