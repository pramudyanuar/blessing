import 'package:blessing/core/utils/app_routes.dart';
import 'package:blessing/data/user/models/request/login_user_request.dart';
import 'package:blessing/data/user/repository/user_repository_impl.dart';
import 'package:blessing/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final UserRepository _userRepository = UserRepository();
  // We no longer need a direct instance of SecureStorage here, but it's fine to keep it
  // if you use it for other things. The global instance is used by the interceptor.

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;

  void login() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        "Gagal",
        "Username dan password tidak boleh kosong.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      final request = LoginUserRequest(
        email: usernameController.text,
        password: passwordController.text,
      );

      final loginResponse = await _userRepository.login(request);

      if (loginResponse != null && loginResponse.token.isNotEmpty) {

        await secureStorageUtil.saveAccessToken(loginResponse.token);

        final userResponse = await _userRepository.getCurrentUser();

        await secureStorageUtil.saveUserRole(userResponse?.role ?? '');

        if (userResponse != null && userResponse.role != null) {
          switch (userResponse.role?.toLowerCase()) {
            case 'admin':
              Get.offAllNamed(AppRoutes.adminMenu);
              break;
            case 'user':
              Get.offAllNamed(AppRoutes.studentMenu);
              break;
            default:
              Get.snackbar(
                "Error",
                "Role pengguna tidak dikenali.",
                snackPosition: SnackPosition.BOTTOM,
              );
          }
        } else {
          Get.snackbar(
            "Error",
            "Gagal memverifikasi data pengguna setelah login.",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        Get.snackbar(
          "Error",
          "Username atau password salah.",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.log("Login Error: $e");
      Get.snackbar(
        "Error",
        "Terjadi kesalahan. Silakan coba lagi nanti.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
