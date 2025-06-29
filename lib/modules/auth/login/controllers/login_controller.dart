import 'package:blessing/core/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool isLoading = false.obs;

  void login() async {
    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 2)); 

    if (usernameController.text == 'admin') {
      Get.offAllNamed(AppRoutes.adminMenu);
    } else if (usernameController.text == 'student') {
      Get.offAllNamed(AppRoutes.studentMenu);
    } else {
      Get.snackbar("Error", "Username atau password salah",
          snackPosition: SnackPosition.BOTTOM);
    }

    isLoading.value = false;
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
