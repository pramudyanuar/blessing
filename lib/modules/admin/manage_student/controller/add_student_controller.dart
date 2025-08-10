import 'package:blessing/core/global_components/custom_snackbar.dart';
import 'package:blessing/data/user/models/request/register_user_request.dart';
import 'package:blessing/data/user/models/response/user_response.dart';
import 'package:blessing/data/user/repository/user_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddStudentController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final gradeController = TextEditingController();

  final _userRepository = Get.find<UserRepository>();
  var isLoading = false.obs;

  Future<void> addStudent() async {
    final request = RegisterUserRequest(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      username: usernameController.text.trim(),
      gradeLevel: gradeController.text.trim(),
    );

    isLoading.value = true;
    try {
      UserResponse? response = await _userRepository.register(request);

      if (response != null) {
        CustomSnackbar.show(
          title: 'Sukses',
          message: 'Siswa berhasil didaftarkan',
        );
        clearForm();
      } else {
        CustomSnackbar.show(
          title: 'Gagal',
          message: 'Registrasi gagal, coba lagi',
          isError: true,
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        title: 'Error',
        message: e.toString(),
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    emailController.clear();
    passwordController.clear();
    usernameController.clear();
    gradeController.clear();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    gradeController.dispose();
    super.onClose();
  }
}
