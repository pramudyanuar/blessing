import 'package:blessing/core/global_components/custom_snackbar.dart';
import 'package:blessing/modules/admin/manage_student/controller/admin_manage_student_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blessing/data/user/repository/user_repository_impl.dart';
import 'package:blessing/data/user/models/request/update_user_request.dart';
import 'package:blessing/data/user/models/response/user_response.dart';
import 'package:intl/intl.dart';


class DetailStudentController extends GetxController {
  var isEditMode = false.obs;

  var studentId = ''.obs;
  var name = ''.obs;
  var grade = ''.obs;
  var school = ''.obs;
  var birthDate = ''.obs;

  late TextEditingController nameController;
  late TextEditingController gradeController;
  late TextEditingController schoolController;
  late TextEditingController birthDateController;

  final quizScores = {
    "Quiz 1": 85,
    "Quiz 2": 90,
    "Quiz 3": 88,
  };

  final _userRepository =
      UserRepository(); // Ganti dengan Get.find jika Anda menggunakan dependency injection

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    gradeController = TextEditingController();
    schoolController = TextEditingController();
    birthDateController = TextEditingController();

    nameController.addListener(() {
      name.value = nameController.text;
    });

    final args = Get.arguments;
    if (args != null && args['id'] != null) {
      studentId.value = args['id'];
      fetchStudentDetail();
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    gradeController.dispose();
    schoolController.dispose();
    birthDateController.dispose();
    super.onClose();
  }

  Future<void> fetchStudentDetail() async {
    try {
      final UserResponse? user =
          await _userRepository.getUserById(studentId.value);

      if (user != null) {
        name.value = user.username ?? '';
        grade.value = user.gradeLevel?.toString() ?? '';
        // school.value = user.school ?? ''; // Aktifkan jika ada di response

        final rawBirthDate = user.birthDate?.toIso8601String() ?? '';
        birthDate.value = rawBirthDate;

        nameController.text = name.value;
        gradeController.text = grade.value;
        schoolController.text = school.value;
        birthDateController.text = formatDate(rawBirthDate);
      }
    } catch (e) {
      CustomSnackbar.show(
        title: "Error",
        message: "Gagal memuat data siswa: $e",
        isError: true,
      );
    }
  }

  String formatDate(String dateStr) {
    if (dateStr.isEmpty) return 'Belum diatur';
    try {
      final date = DateTime.parse(dateStr);
      if (date.year <= 1900) return 'Belum diatur';
      final formatter = DateFormat('dd-MM-yyyy');
      return formatter.format(date);
    } catch (e) {
      return 'Format tidak valid';
    }
  }

  DateTime? parseInputDate(String input) {
    final trimmedInput = input.trim();
    if (trimmedInput.isEmpty ||
        trimmedInput == 'Belum diatur' ||
        trimmedInput == 'Format tidak valid') {
      return null;
    }
    try {
      final formatter = DateFormat('dd-MM-yyyy');
      return formatter.parseStrict(trimmedInput);
    } catch (e) {
      try {
        return DateTime.parse(trimmedInput);
      } catch (e2) {
        return null;
      }
    }
  }

  Future<void> selectBirthDate(BuildContext context) async {
    DateTime initialDate =
        parseInputDate(birthDateController.text) ?? DateTime.now();
    if (initialDate.isAfter(DateTime.now())) {
      initialDate = DateTime.now();
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      final formattedDate = DateFormat('dd-MM-yyyy').format(picked);
      birthDateController.text = formattedDate;
    }
  }

  Future<void> saveChanges() async {
    try {
      final parsedDate = parseInputDate(birthDateController.text);
      String? birthDateString;
      if (parsedDate != null) {
        birthDateString = parsedDate.toUtc().toIso8601String();
      }

      final request = UpdateUserRequest(
        username: nameController.text.trim().isEmpty
            ? null
            : nameController.text.trim(),
        gradeLevel: gradeController.text.trim().isEmpty
            ? null
            : gradeController.text.trim(),
        birthDate: birthDateString,
      );

      print('Payload update user: ${request.toJson()}');

      final UserResponse? updatedUser =
          await _userRepository.updateUserAdmin(studentId.value, request);

      if (updatedUser != null) {
        await fetchStudentDetail();
        isEditMode.value = false;
        CustomSnackbar.show(
            title: "Sukses", message: "Data siswa berhasil diperbarui");
        Get.find<AdminManageStudentController>().fetchStudents();
      } else {
        CustomSnackbar.show(
            title: "Gagal",
            message: "Gagal memperbarui data siswa",
            isError: true);
      }
    } catch (e) {
      CustomSnackbar.show(
          title: "Error", message: "Terjadi kesalahan: $e", isError: true);
    }
  }


  Future<void> deleteStudent() async {
    try {
      final UserResponse? deletedUser =
          await _userRepository.deleteUserAdmin(studentId.value);

      if (deletedUser != null) {
        CustomSnackbar.show(title: "Sukses", message: "User berhasil dihapus");
        final adminController = Get.find<AdminManageStudentController>();
        await adminController.fetchStudents();
        Get.back();
      } else {
        CustomSnackbar.show(
            title: "Gagal", message: "Gagal menghapus user", isError: true);
      }
    } catch (e) {
      print('Error saat hapus: $e');
      CustomSnackbar.show(
          title: "Error",
          message: "Terjadi kesalahan saat menghapus user",
          isError: true);
    }
  }

  void toggleEditMode() => isEditMode.value = !isEditMode.value;
}
