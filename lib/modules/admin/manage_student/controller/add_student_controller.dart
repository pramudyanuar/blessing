import 'package:blessing/core/global_components/custom_snackbar.dart';
import 'package:blessing/data/user/models/request/register_user_request.dart';
import 'package:blessing/data/user/models/response/user_response.dart';
import 'package:blessing/data/user/repository/user_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async'; // Tambahkan import untuk Future.delayed

class AddStudentController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final gradeController = TextEditingController();

  final _userRepository = Get.find<UserRepository>();
  var isLoading = false.obs;
  Function? onStudentAdded; // Callback untuk refresh student list

  @override
  void onInit() {
    super.onInit();
    onStudentAdded =
        Get.arguments?['onStudentAdded']; // Ambil callback dari arguments
  }

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
        // Tunggu sebentar agar user bisa melihat notifikasi sukses
        await Future.delayed(const Duration(seconds: 1));

        // Tutup semua overlay (dialog, snackbar, dll) dan kembali ke halaman sebelumnya
        Get.close(1); // Tutup 1 halaman dari stack
        // Panggil callback untuk refresh student list
        if (onStudentAdded != null) {
          onStudentAdded!();
        }
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
