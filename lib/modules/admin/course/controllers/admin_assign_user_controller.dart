
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
  final RxBool isAssigning = false.obs; // Loading state untuk proses assignment

  // User Data & Filtering
  final RxList<UserResponse> allUsers = <UserResponse>[].obs;
  final RxList<UserResponse> filteredUsers = <UserResponse>[].obs;
  final RxString selectedKelas = '7'.obs;
  final List<String> kelasList = ['7', '8', '9', '10', '11', '12'];
  final RxString searchQuery = ''.obs;

  // Selection Management
  final RxSet<String> selectedUserIds = <String>{}.obs;

  // Data from previous screen
  late final String courseId;

  @override
  void onInit() {
    super.onInit();
    // Ambil courseId dari arguments
    courseId = Get.arguments as String? ?? '';
    if (courseId.isEmpty) {
      errorMessage.value = "ID Materi tidak valid.";
      isLoading.value = false;
      return;
    }

    fetchAllUsers();

    // Listener untuk filter otomatis
    ever(selectedKelas, (_) => _filterUsers());
    ever(searchQuery, (_) => _filterUsers());
  }

  Future<void> fetchAllUsers() async {
    isLoading.value = true;
    try {
      final users = await _userRepository.getAllUsersComplete();
      allUsers.assignAll(users);
      _filterUsers(); // Terapkan filter awal
    } catch (e) {
      errorMessage.value = "Gagal memuat daftar siswa: $e";
      debugPrint("Error fetching users: $e");
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
      return;
    }

    isAssigning.value = true;
    final success = await _courseRepository.adminAssignCoursesToUsers(
      userIds: selectedUserIds.toList(),
      courseIds: [courseId], // courseId didapat dari onInit
    );
    isAssigning.value = false;

    if (success) {
      Get.snackbar('Berhasil', 'Siswa telah berhasil ditambahkan ke materi.',
          backgroundColor: Colors.green, colorText: Colors.white);
      // Kembali ke halaman sebelumnya dengan hasil 'true' untuk trigger refresh
      Get.back(result: true);
    } else {
      Get.snackbar('Gagal', 'Terjadi kesalahan saat menambahkan siswa.',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
