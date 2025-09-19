import 'package:blessing/core/utils/app_routes.dart';
import 'package:blessing/data/course/models/response/user_course_response.dart';
import 'package:blessing/data/course/repository/course_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminManageAccessCourseController extends GetxController {
  // Instance dari repository untuk mengambil data
  final _courseRepository = Get.find<CourseRepository>();

  // Variabel state yang akan direaksikan oleh UI
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxList<UserCourseResponse> userAccessList = <UserCourseResponse>[].obs;

  // ID dari course yang sedang dikelola. Didapat dari Get.arguments
  late final String courseId;
  // Nama course untuk ditampilkan di AppBar. Juga dari Get.arguments.
  late final String courseName;
  // Callback untuk refresh course list setelah perubahan akses
  Function? onAccessChanged;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      courseId = arguments['courseId'] ?? '';
      courseName = arguments['courseName'] ?? 'Kelola Akses';
      onAccessChanged =
          arguments['onAccessChanged']; // Ambil callback dari arguments
      if (courseId.isNotEmpty) {
        // Langsung panggil fungsi untuk mengambil data saat controller diinisialisasi
        fetchUserAccess();
      } else {
        errorMessage.value = 'ID Materi tidak valid.';
        isLoading.value = false;
      }
    } else {
      errorMessage.value = 'Gagal mendapatkan data materi.';
      isLoading.value = false;
    }
  }

  /// Mengambil semua data akses pengguna untuk course ini.
  Future<void> fetchUserAccess() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _courseRepository.adminGetAllUserCoursesByCourseId(
        courseId: courseId,
      );

      if (result != null) {
        userAccessList.value = result;
      } else {
        errorMessage.value = 'Gagal memuat data akses.';
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Menghapus akses seorang pengguna dari course ini.
  Future<void> removeUserAccess(String userCourseId) async {
    // Tampilkan loading indicator atau dialog
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    final success = await _courseRepository.adminDeleteUserCourse(userCourseId);

    Get.back(); // Tutup dialog loading

    if (success) {
      // Hapus item dari list secara lokal agar UI langsung update
      userAccessList.removeWhere((item) => item.id == userCourseId);
      Get.snackbar(
        'Berhasil',
        'Akses pengguna telah dihapus.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      // Panggil callback untuk refresh course list
      if (onAccessChanged != null) {
        onAccessChanged!();
      }
    } else {
      Get.snackbar(
        'Gagal',
        'Gagal menghapus akses pengguna.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Navigasi ke halaman untuk menambahkan pengguna baru.
  Future<void> navigateToAddUsers() async {
    // Navigasi ke halaman 'AdminAssignUserScreen'
    // Kirim courseId agar halaman tujuan tahu course mana yang akan di-assign.
    final result =
        await Get.toNamed(AppRoutes.adminAssignUser, arguments: courseId);

    // Jika kita kembali dengan hasil 'true' (artinya assignment berhasil),
    // panggil ulang fetchUserAccess untuk me-refresh daftar.
    if (result == true) {
      fetchUserAccess();
      // Panggil callback untuk refresh course list
      if (onAccessChanged != null) {
        onAccessChanged!();
      }
    }
  }
}
