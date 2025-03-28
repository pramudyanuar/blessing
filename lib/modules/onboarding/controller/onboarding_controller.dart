import 'package:blessing/core/constants/images.dart';
import 'package:blessing/core/constants/string.dart';
import 'package:blessing/core/utils/route_utils.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  var currentIndex = 0.obs;
  // final SharedPreferencesUtils _prefs = SharedPreferencesUtils();

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
    // await _prefs.setFirstTime(false);
    Get.offAllNamed(NavigationRoutes.login);
  }
}
