import 'package:blessing/core/utils/route_utils.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToOnboarding();
  }

  void _navigateToOnboarding() async {
    await Future.delayed(const Duration(seconds: 2));
    Get.toNamed(NavigationRoutes.onboarding);
  }
}
