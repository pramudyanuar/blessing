import 'package:blessing/core/constants/string.dart';
import 'package:blessing/core/utils/app_pages.dart';
import 'package:blessing/core/utils/app_routes.dart';
import 'package:blessing/modules/error/not_found_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:fluttertoast/fluttertoast.dart';

final _noScreenshot = NoScreenshot.instance;

class MainAppWrapper extends StatefulWidget {
  const MainAppWrapper({super.key});

  @override
  State<MainAppWrapper> createState() => _MainAppWrapperState();
}

class _MainAppWrapperState extends State<MainAppWrapper> {
  @override
  void initState() {
    super.initState();
    listenForScreenshot();
  }

  void listenForScreenshot() {
    _noScreenshot.screenshotStream.listen((value) {
      debugPrint('Screenshot taken: ${value.wasScreenshotTaken}');
      debugPrint('Screenshot path: ${value.screenshotPath}');

      Fluttertoast.showToast(
        msg: "Screenshot detected!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const MainApp();
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: StringText.appName,
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.initial,
          getPages: AppPages.routes,
          unknownRoute: GetPage(
            name: AppRoutes.notFound,
            page: () => NotFoundScreen(),
          ),
          defaultTransition: Transition.fadeIn,
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          home: child,
        );
      },
    );
  }
}
