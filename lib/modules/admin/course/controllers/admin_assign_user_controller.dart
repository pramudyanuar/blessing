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
  final RxList<UserResponse> filteredUsers = <UserResponse>[].obs;
  final RxString selectedKelas = '7'.obs;
  final List<String> kelasList = ['7', '8', '9', '10', '11', '12'];
  final RxString searchQuery = ''.obs;
  // Cache semua user dari kelas aktif (untuk filter search lokal)
  final List<UserResponse> _usersInCurrentKelas = [];

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

    // Listener: re-fetch dari server saat kelas berubah
    ever(selectedKelas, (_) => _fetchUsersForCurrentKelas());
    // Listener: filter search lokal saat query berubah
    ever(searchQuery, (_) => _applySearch());

    // Panggil fungsi inisialisasi data
    _initializeData();
  }

  /// Inisialisasi: ambil existing permissions dan fetch user kelas awal.
  Future<void> _initializeData() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      // Ambil existing permissions
      final existingPermissions = await _courseRepository
          .adminGetAllUserCoursesByCourseId(courseId: courseId);

      if (existingPermissions != null) {
        final ids = existingPermissions
            .map((permission) => permission.user.id)
            .toSet();
        existingUserIds.assignAll(ids);
        selectedUserIds.assignAll(ids);
      }

      // Fetch user untuk kelas awal
      await _fetchUsersForCurrentKelas();
    } catch (e) {
      errorMessage.value = "Gagal memuat data: $e";
      debugPrint("Error initializing data: $e");
      isLoading.value = false;
    }
  }

  /// Fetch siswa dari server berdasarkan kelas aktif.
  Future<void> _fetchUsersForCurrentKelas() async {
    isLoading.value = true;
    try {
      final gradeLevel = int.tryParse(selectedKelas.value) ?? 7;
      // Server yang filter berdasarkan grade_level — tidak perlu fetch semua
      final result = await _userRepository.getUsersByGradeLevel(gradeLevel);
      _usersInCurrentKelas
        ..clear()
        ..addAll(result);
      _applySearch();
    } catch (e) {
      debugPrint("Error fetching users for kelas: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Filter search lokal (kelas sudah dihandle server).
  void _applySearch() {
    final query = searchQuery.value.toLowerCase();
    if (query.isEmpty) {
      filteredUsers.assignAll(_usersInCurrentKelas);
    } else {
      filteredUsers.assignAll(
        _usersInCurrentKelas.where(
            (u) => u.username?.toLowerCase().contains(query) ?? false),
      );
    }
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

      // Kembali ke manage access course dengan result success
      Get.back(result: true);
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

      // Kembali ke manage access course dengan result success
      Get.back(result: true);
    } else {
      Get.snackbar('Gagal', 'Terjadi kesalahan saat memperbarui akses.',
          backgroundColor: Colors.red, colorText: Colors.white);

      // Tunggu sebentar agar user bisa melihat notifikasi error
      await Future.delayed(const Duration(seconds: 2));
    }
  }
}
