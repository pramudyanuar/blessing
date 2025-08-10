import 'package:blessing/data/user/repository/user_repository_impl.dart';
import 'package:blessing/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blessing/core/utils/app_routes.dart'; // Untuk navigasi

// Enum untuk menentukan mode halaman, agar kode lebih mudah dibaca
enum ProfileMode { initialSetup, edit }

class ProfileController extends GetxController {

  final _userRepository = Get.find<UserRepository>();
  
  // --- State untuk UI ---
  final fullNameController = TextEditingController();
  final schoolController = TextEditingController();
  final birthDateController = TextEditingController();
  final Rxn<String> selectedClass = Rxn<String>();
  var isLoading = false.obs;

  // --- Properti & Data ---
  final List<String> classOptions = [
    'Kelas 7',
    'Kelas 8',
    'Kelas 9',
    'Kelas 10',
    'Kelas 11',
    'Kelas 12'
  ];
  late final ProfileMode mode;

  // --- Constructor ---
  ProfileController() {
    // Cek argumen yang dikirim saat navigasi untuk menentukan mode
    mode = Get.arguments?['mode'] as ProfileMode? ?? ProfileMode.edit;
  }

  // --- Lifecycle Methods ---
  @override
  void onInit() {
    super.onInit();
    // Jika modenya adalah edit, muat data pengguna yang sudah ada
    if (mode == ProfileMode.edit) {
      loadExistingUserData();
    }
  }

  @override
  void onClose() {
    // Selalu dispose controller untuk menghindari memory leak
    fullNameController.dispose();
    schoolController.dispose();
    birthDateController.dispose();
    super.onClose();
  }

  // --- Logika Aplikasi ---
  void loadExistingUserData() {
    // Simulasi memuat data dari API atau cache untuk mode edit
    fullNameController.text = "Siswa Cerdas";
    schoolController.text = "SMA Harapan Bangsa";
    birthDateController.text = "10/10/2006";
    selectedClass.value = "Kelas 12";
  }

  // void pickImage() async {
  //   // Tambahkan logika untuk memilih gambar dari galeri/kamera di sini
  // }

  void saveProfile() {
    if (fullNameController.text.isEmpty || selectedClass.value == null) {
      Get.snackbar('Error', 'Nama Lengkap dan Kelas wajib diisi.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    isLoading.value = true;
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      Get.snackbar('Sukses', 'Profil berhasil disimpan!');

      if (mode == ProfileMode.initialSetup) {
        // Jika setup awal, arahkan ke menu utama & hapus semua halaman sebelumnya
        Get.offAllNamed(AppRoutes.studentMenu);
      } else {
        // Jika edit, cukup kembali ke halaman sebelumnya
        Get.back();
      }
    });
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
}
