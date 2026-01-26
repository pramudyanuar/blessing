import 'package:blessing/core/constants/images.dart';
import 'package:blessing/core/constants/string.dart';
import 'package:blessing/core/utils/app_routes.dart';
import 'package:get/get.dart';
import 'package:blessing/core/utils/cache_util.dart';

class OnboardingController extends GetxController {
  var currentIndex = 0.obs;
  final CacheUtil _cacheUtil = CacheUtil();

  final List<String> images = Images.onboardingImages;
  final List<String> titles = StringText.onboardingTitles;
  final List<String> descriptions = StringText.onboardingDescriptions;

  void nextScreen() {
    if (currentIndex.value < images.length - 1) {
      currentIndex.value++;
    } else {
      completeOnboarding();
    }
  }

  void completeOnboarding() async {
    await _cacheUtil.setData('isFirstTime', false);
    Get.offAllNamed(AppRoutes.login);
  }
}
