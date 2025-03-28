import 'package:blessing/modules/auth/login/login_screen.dart';
import 'package:blessing/modules/onboarding/onboarding_screen.dart';
import 'package:blessing/modules/splash/splash_screen.dart';
import 'package:get/get.dart';

class NavigationRoutes {
  static String initial = '/';
  // static String notFound = '/not-found';
  // static String getStarted = '/get-started';
  static String onboarding = '/onboarding';
  static String login = '/login';

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => SplashScreen()),
    // GetPage(name: notFound, page: () => NotFoundScreen()),
    // GetPage(name: getStarted, page: () => GetStartedScreen()),
    GetPage(name: onboarding, page: () => OnboardingScreen()),
    GetPage(name: login, page: () => LoginScreen()),
  ];
}
