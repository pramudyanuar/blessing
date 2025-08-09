import 'package:blessing/core/utils/app_routes.dart';
import 'package:blessing/core/utils/cache_util.dart';
import 'package:blessing/data/user/repository/user_repository_impl.dart';
import 'package:blessing/main.dart'; // Pastikan secureStorageUtil di-import dari sini
import 'package:get/get.dart';

class SplashController extends GetxController {
  final CacheUtil _cacheUtil = CacheUtil();
  final UserRepository _userRepository = UserRepository();

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 2));

    final bool isFirstTime = _cacheUtil.getData('isFirstTime') ?? true;

    if (isFirstTime) {
      Get.offAllNamed(AppRoutes.onboarding);
      return;
    }

    await _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final String? token = await secureStorageUtil.getAccessToken();

    if (token == null || token.isEmpty) {
      Get.offAllNamed(AppRoutes.login);
      return;
    }

    try {
      final userResponse = await _userRepository.getCurrentUser();

      if (userResponse != null && userResponse.role != null) {
        await secureStorageUtil.saveUserRole(userResponse.role!);

        switch (userResponse.role?.toLowerCase()) {
          case 'admin':
            Get.offAllNamed(AppRoutes.adminMenu);
            break;
          case 'user':
            Get.offAllNamed(AppRoutes.studentMenu);
            break;
          default:
            Get.offAllNamed(AppRoutes.login);
        }
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    } catch (e) {
      Get.log("Gagal memvalidasi token: $e");
      await secureStorageUtil.clearAll();
      Get.offAllNamed(AppRoutes.login);
    }
  }
}