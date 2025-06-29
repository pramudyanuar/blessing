import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/constants/images.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/modules/splash/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final SplashController controller = Get.find<SplashController>();
  
  @override
  Widget build(BuildContext context) {
    return BaseWidgetContainer(
      backgroundColor: AppColors.c2,
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(seconds: 1),
          builder: (context, opacity, child) {
            return Opacity(
              opacity: opacity,
              child: child,
            );
          },
          child: Image.asset(Images.blessingLogo),
        ),
      ),
    );
  }
}
