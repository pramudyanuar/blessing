import 'package:blessing/core/global_components/custom_snackbar.dart';
import 'package:blessing/core/utils/app_routes.dart';
import 'package:blessing/core/utils/cache_util.dart';
import 'package:blessing/data/user/models/request/login_user_request.dart';
import 'package:blessing/data/user/repository/user_repository_impl.dart';
import 'package:blessing/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final _userRepository = Get.find<UserRepository>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;

  void login() async {
    final email = usernameController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      CustomSnackbar.show(
        title: "Gagal",
        message: "Email dan password tidak boleh kosong.",
        isError: true,
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      CustomSnackbar.show(
        title: "Gagal",
        message: "Format email yang Anda masukkan tidak valid.",
        isError: true,
      );
      return;
    }

    isLoading.value = true;

    try {
      final request = LoginUserRequest(
        email: email,
        password: password,
      );

      final loginResponse = await _userRepository.login(request);

      if (loginResponse != null && loginResponse.token.isNotEmpty) {

        await secureStorageUtil.saveAccessToken(loginResponse.token);

        final userResponse = await _userRepository.getCurrentUser();

        await CacheUtil().setData('user_data', userResponse?.toJson());
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
              CustomSnackbar.show(
                title: "Error",
                message: "Role pengguna tidak dikenali.",
                isError: true,
              );
          }
        } else {
          CustomSnackbar.show(
            title: "Error",
            message: "Gagal memverifikasi data pengguna setelah login.",
            isError: true,
          );
        }
      } else {
        // HttpManager already shows an error toast for the failed request;
        // just clear the password so the user isn't stuck retyping over a wrong one.
        passwordController.clear();
      }
    } catch (e) {
      Get.log("Login Error: $e");
      CustomSnackbar.show(
        title: "Error",
        message: "Terjadi kesalahan. Silakan coba lagi nanti.",
        isError: true,
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
