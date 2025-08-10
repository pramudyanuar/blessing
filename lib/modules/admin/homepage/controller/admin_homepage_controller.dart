import 'package:blessing/core/utils/app_routes.dart';
import 'package:blessing/data/user/repository/user_repository_impl.dart';
import 'package:blessing/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminHomepageController extends GetxController {

  final _userRepository = Get.find<UserRepository>();
  
  // --- STATE UNTUK FILTER KELAS ---
  var selectedKelas = 7.obs;
  final List<int> kelasList = [7, 8, 9]; // Disederhanakan untuk contoh

  // --- STATE UNTUK DAFTAR MATA PELAJARAN ---
  // Daftar mata pelajaran yang akan ditampilkan di UI
  var displayedSubjects = <Map<String, dynamic>>[].obs;

  // Data 'database' contoh. Key adalah kelas, value adalah list mata pelajaran
  final Map<int, List<Map<String, dynamic>>> _allSubjects = {
    7: [
      {'title': 'Matematika', 'icon': Icons.calculate_rounded},
      {'title': 'Bahasa Indonesia', 'icon': Icons.book_rounded},
    ],
    8: [
      {'title': 'IPA', 'icon': Icons.science_rounded},
      {'title': 'IPS', 'icon': Icons.public_rounded},
      {'title': 'Bahasa Inggris', 'icon': Icons.translate_rounded},
    ],
    9: [
      {'title': 'Fisika', 'icon': Icons.thermostat_rounded},
      {'title': 'Biologi', 'icon': Icons.biotech_rounded},
    ],
  };

  @override
  void onInit() {
    super.onInit();
    // Saat controller pertama kali diinisialisasi, tampilkan data untuk kelas 7
    _updateDisplayedSubjects(selectedKelas.value);
  }

  // Method untuk mengubah kelas yang dipilih
  void selectKelas(int kelas) {
    selectedKelas.value = kelas;
    // Update juga daftar mata pelajaran yang ditampilkan
    _updateDisplayedSubjects(kelas);
  }

  // Method internal untuk memfilter dan memperbarui daftar mata pelajaran
  void _updateDisplayedSubjects(int kelas) {
    // Ambil data dari map, atau list kosong jika tidak ada
    displayedSubjects.value = _allSubjects[kelas] ?? [];
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
