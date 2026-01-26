import 'package:blessing/core/utils/cache_util.dart';
import 'package:blessing/data/user/models/request/update_user_request.dart';
import 'package:blessing/data/user/repository/user_repository_impl.dart';
import 'package:blessing/main.dart';
import 'package:blessing/core/utils/app_routes.dart';
import 'package:blessing/modules/student/main/controllers/main_student_controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

enum ProfileMode { initialSetup, edit }

class ProfileController extends GetxController {
  final _userRepository = Get.find<UserRepository>();

  final fullNameController = TextEditingController();
  final schoolController =
      TextEditingController(); // Tidak digunakan di UI, tapi ada di sini
  final birthDateController = TextEditingController();
  final Rxn<String> selectedClass = Rxn<String>();
  var isLoading = false.obs;

  var isEditMode = false.obs;

  final List<String> classOptions = [
    'Kelas 7',
    'Kelas 8',
    'Kelas 9',
    'Kelas 10',
    'Kelas 11',
    'Kelas 12'
  ];
  late final ProfileMode mode;

  ProfileController() {
    mode = Get.arguments?['mode'] as ProfileMode? ?? ProfileMode.edit;
  }

  @override
  void onInit() {
    super.onInit();
    if (mode == ProfileMode.initialSetup) {
      isEditMode.value = true;
    } else {
      isEditMode.value = false;
      loadExistingUserData();
    }
  }

  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
  }

  // ===== PERBAIKAN UTAMA DAN FINAL ADA DI FUNGSI INI =====
  Future<void> loadExistingUserData() async {
    final userData = await CacheUtil().getData('user_data');
    if (userData != null) {
      fullNameController.text = userData['username'] ?? '';

      // Membuat fungsi load lebih pintar untuk menangani tipe data yang tidak konsisten
      final dynamic rawBirthDateValue = userData['birth_date'];
      String birthDateString = ''; // Default ke string kosong

      if (rawBirthDateValue is DateTime) {
        // Jika data di cache adalah DateTime, konversi ke String ISO
        birthDateString = rawBirthDateValue.toUtc().toIso8601String();
      } else if (rawBirthDateValue is String) {
        // Jika sudah String, langsung gunakan
        birthDateString = rawBirthDateValue;
      }

      // Sekarang kita bisa memformat dengan aman
      birthDateController.text = formatDate(birthDateString);

      // Kode untuk kelas sekarang akan berjalan karena tidak ada crash
      if (userData['grade_level'] != null) {
        // Menggunakan .toString() untuk keamanan jika grade_level adalah integer
        selectedClass.value = 'Kelas ${userData['grade_level'].toString()}';
      }
    }
  }
  // ==========================================================

  String formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      // Menangani tanggal default dari server seperti "0001-01-01T00:00:00Z"
      if (date.year <= 1) return ''; // Akan menampilkan field kosong
      final formatter = DateFormat('dd-MM-yyyy');
      return formatter.format(date);
    } catch (e) {
      // Jika format gagal diparsing, kembalikan string kosong
      return '';
    }
  }

  DateTime? parseInputDate(String input) {
    if (input.trim().isEmpty) return null;
    try {
      final formatter = DateFormat('dd-MM-yyyy');
      return formatter.parseStrict(input.trim());
    } catch (e) {
      try {
        return DateTime.parse(input.trim());
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

  Future<void> saveProfile() async {
    // Validasi berbeda untuk initial setup vs edit mode
    if (mode == ProfileMode.initialSetup) {
      if (fullNameController.text.isEmpty || selectedClass.value == null) {
        Get.snackbar('Error', 'Nama Lengkap dan Kelas wajib diisi.',
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
    } else {
      // Mode edit: hanya validasi nama lengkap
      if (fullNameController.text.isEmpty) {
        Get.snackbar('Error', 'Nama Lengkap wajib diisi.',
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
    }

    isLoading.value = true;

    try {
      final parsedDate = parseInputDate(birthDateController.text);
      String? birthDateForApi;
      if (parsedDate != null) {
        birthDateForApi = parsedDate.toUtc().toIso8601String();
      }

      String? gradeLevelForApi;
      if (mode == ProfileMode.initialSetup) {
        // Hanya kirim gradeLevel saat initial setup
        gradeLevelForApi = selectedClass.value?.replaceAll('Kelas ', '') ?? '';
      }
      // Untuk mode edit, gradeLevel tidak dikirim (siswa tidak bisa ubah kelas)

      final request = UpdateUserRequest(
        username: fullNameController.text,
        gradeLevel: gradeLevelForApi,
        birthDate: birthDateForApi,
      );

      final updatedUser = await _userRepository.updateUser(request);

      if (updatedUser != null) {
        final currentData = await CacheUtil().getData('user_data') ?? {};
        currentData['username'] = updatedUser.username;

        // Update grade_level hanya saat initial setup
        if (mode == ProfileMode.initialSetup) {
          currentData['grade_level'] = updatedUser.gradeLevel;
        }

        currentData['birth_date'] = updatedUser.birthDate;

        await CacheUtil().setData('user_data', currentData);

        // Reload user data in MainStudentController if it exists
        if (Get.isRegistered<MainStudentController>()) {
          final mainController = Get.find<MainStudentController>();
          await mainController.reloadUserData();
        }

        isEditMode.value = false;
        Get.snackbar('Sukses', 'Profil berhasil diperbarui!');

        if (mode == ProfileMode.initialSetup) {
          Get.offAllNamed(AppRoutes.studentMenu);
        }
      } else {
        Get.snackbar('Gagal', 'Gagal memperbarui profil. Coba lagi.',
            backgroundColor: Colors.orange, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: ${e.toString()}',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    final isSuccess = await _userRepository.logout();
    if (isSuccess) {
      await secureStorageUtil.deleteAccessToken();
      await secureStorageUtil.deleteUserRole();
      Get.offAllNamed(AppRoutes.login);
    } else {
      Get.snackbar('Logout Gagal', 'Terjadi kesalahan saat logout. Coba lagi.');
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    schoolController.dispose();
    birthDateController.dispose();
    super.onClose();
  }
}
