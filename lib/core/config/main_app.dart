import 'package:blessing/core/constants/string.dart';
import 'package:blessing/core/utils/route_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          debugShowCheckedModeBanner: true,
          initialRoute: NavigationRoutes.initial,
          getPages: NavigationRoutes.routes,
          // unknownRoute: GetPage(
          //   name: NavigationRoutes.notFound,
          //   page: () => NotFoundScreen(),
          // ),
          defaultTransition: Transition.noTransition,
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          // Widget utama
          home: child,
        );
      },
    );
  }
}
