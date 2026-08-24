import 'package:blessing/core/constants/string.dart';
import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/utils/app_pages.dart';
import 'package:blessing/core/utils/app_routes.dart';
import 'package:blessing/modules/error/not_found_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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
      if (kDebugMode) {
        debugPrint('Screenshot taken: ${value.wasScreenshotTaken}');
        debugPrint('Screenshot path: ${value.screenshotPath}');
      }

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
            primaryColor: AppColors.c2,
            scaffoldBackgroundColor: AppColors.c5,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 3,
              shadowColor: Colors.black.withValues(alpha: 0.4),
              toolbarHeight: 65.h,
              centerTitle: false,
              iconTheme: const IconThemeData(color: AppColors.c2),
              actionsIconTheme: const IconThemeData(color: AppColors.c2),
              titleTextStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Inter',
              ),
            ),
            cardTheme: CardThemeData(
              color: Colors.white,
              elevation: 3,
              shadowColor: Colors.black.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.c2,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.c2,
                side: const BorderSide(color: AppColors.c2),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
