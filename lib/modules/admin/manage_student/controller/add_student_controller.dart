import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddStudentController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final gradeController = TextEditingController();

  void addStudent() {
    final data = {
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
      "username": usernameController.text.trim(),
      "grade_level": gradeController.text.trim(),
    };

    // TODO: Tambahkan logika kirim ke backend
    print("Siswa ditambahkan: $data");
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
