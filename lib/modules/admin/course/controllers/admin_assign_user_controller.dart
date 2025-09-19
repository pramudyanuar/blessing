import 'package:blessing/data/course/models/response/user_course_response.dart'; // Pastikan import ini ada
import 'package:blessing/data/course/repository/course_repository_impl.dart';
import 'package:blessing/data/user/models/response/user_response.dart';
import 'package:blessing/data/user/repository/user_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminAssignUserController extends GetxController {
  // --- DEPENDENCIES ---
  final _userRepository = Get.find<UserRepository>();
  final _courseRepository = Get.find<CourseRepository>();

  // --- STATE VARIABLES ---
  // Loading & Error
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isAssigning = false.obs;

  // User Data & Filtering
  final RxList<UserResponse> allUsers = <UserResponse>[].obs;
  final RxList<UserResponse> filteredUsers = <UserResponse>[].obs;
  final RxString selectedKelas = '7'.obs;
  final List<String> kelasList = ['7', '8', '9', '10', '11', '12'];
  final RxString searchQuery = ''.obs;

  // Selection Management
  final RxSet<String> selectedUserIds = <String>{}.obs;
  // BARU: Menyimpan ID user yang sudah punya akses dari awal
  final RxSet<String> existingUserIds = <String>{}.obs;

  // Data from previous screen
  late final String courseId;

  @override
  void onInit() {
    super.onInit();
    courseId = Get.arguments as String? ?? '';
    if (courseId.isEmpty) {
      errorMessage.value = "ID Materi tidak valid.";
      isLoading.value = false;
      return;
    }

    // Panggil fungsi inisialisasi data
    _initializeData();

    // Listener untuk filter otomatis
    ever(selectedKelas, (_) => _filterUsers());
    ever(searchQuery, (_) => _filterUsers());
  }

  /// Mengambil semua data yang dibutuhkan secara bersamaan
  Future<void> _initializeData() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      // Jalankan kedua future secara paralel untuk efisiensi
      final results = await Future.wait([
        _userRepository.getAllUsersComplete(),
        _courseRepository.adminGetAllUserCoursesByCourseId(courseId: courseId),
      ]);

      // --- Proses hasil dari `getAllUsersComplete` ---
      final allUsersResult = results[0] as List<UserResponse>?;
      if (allUsersResult != null) {
        allUsers.assignAll(allUsersResult);
      } else {
        throw 'Gagal mendapatkan daftar siswa.';
      }

      // --- Proses hasil dari `adminGetAllUserCoursesByCourseId` ---
      // =========================================================
      // PERBAIKAN DI SINI: Tambahkan cast `as List<UserCourseResponse>?`
      // =========================================================
      final existingPermissionsResult = results[1] as List<UserCourseResponse>?;
      if (existingPermissionsResult != null) {
        // Ambil semua ID user yang sudah punya akses
        final ids = existingPermissionsResult
            .map((permission) => permission.user.id)
            .toSet();
        existingUserIds.assignAll(ids);
        // Langsung centang user yang sudah punya akses
        selectedUserIds.assignAll(ids);
      }
      // Jika null, tidak apa-apa, artinya belum ada yang punya akses

      _filterUsers(); // Terapkan filter awal setelah semua data siap
    } catch (e) {
      errorMessage.value = "Gagal memuat data: $e";
      debugPrint("Error initializing data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _filterUsers() {
    final kelas = selectedKelas.value;
    final query = searchQuery.value.toLowerCase();

    final results = allUsers.where((user) {
      final kelasMatch = user.gradeLevel.toString() == kelas;
      final nameMatch = user.username?.toLowerCase().contains(query) ?? false;
      return kelasMatch && (query.isEmpty || nameMatch);
    }).toList();

    filteredUsers.assignAll(results);
  }

  void onKelasChanged(String? newValue) {
    if (newValue != null) {
      selectedKelas.value = newValue;
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  /// Menambah atau menghapus user dari daftar pilihan
  void toggleUserSelection(String userId) {
    if (selectedUserIds.contains(userId)) {
      selectedUserIds.remove(userId);
    } else {
      selectedUserIds.add(userId);
    }
  }

  /// Mengirim data user terpilih ke API
  Future<void> assignSelectedUsers() async {
    if (selectedUserIds.isEmpty) {
      Get.snackbar('Perhatian', 'Pilih setidaknya satu siswa untuk ditugaskan.',
          backgroundColor: Colors.orange);

      // Tunggu sebentar agar user bisa melihat notifikasi peringatan
      await Future.delayed(const Duration(seconds: 2));

      return;
    }

    // Filter hanya user yang belum memiliki akses (baru ditambahkan)
    final newUserIds = selectedUserIds
        .where((userId) => !existingUserIds.contains(userId))
        .toList();

    // Jika tidak ada user baru yang dipilih, tampilkan pesan
    if (newUserIds.isEmpty) {
      Get.snackbar('Info', 'Semua siswa yang dipilih sudah memiliki akses.',
          backgroundColor: Colors.blue, colorText: Colors.white);

      // Tunggu sebentar agar user bisa melihat notifikasi info
      await Future.delayed(const Duration(seconds: 1));

      Get.back(result: true); // Tetap kembali dengan success
      return;
    }

    isAssigning.value = true;
    final success = await _courseRepository.adminAssignCoursesToUsers(
      userIds: newUserIds, // Hanya kirim user yang belum memiliki akses
      courseIds: [courseId],
    );
    isAssigning.value = false;

    if (success) {
      Get.snackbar('Berhasil', 'Akses siswa telah diperbarui.',
          backgroundColor: Colors.green, colorText: Colors.white);

      // Tunggu sebentar agar user bisa melihat notifikasi sukses
      await Future.delayed(const Duration(seconds: 1));

      Get.back(result: true);
    } else {
      Get.snackbar('Gagal', 'Terjadi kesalahan saat memperbarui akses.',
          backgroundColor: Colors.red, colorText: Colors.white);

      // Tunggu sebentar agar user bisa melihat notifikasi error
      await Future.delayed(const Duration(seconds: 2));
    }
  }
}
