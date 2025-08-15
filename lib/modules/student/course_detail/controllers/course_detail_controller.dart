import 'package:blessing/data/course/models/response/course_with_quizzes_response.dart';
import 'package:blessing/data/course/repository/course_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CourseDetailController extends GetxController {
  // --- Dependensi ---
  // Instansiasi repository untuk mengambil data course. Pastikan sudah di-bind sebelumnya.
  final _courseRepository = Get.find<CourseRepository>();

  // --- State Observables ---
  final isLoading =
      true.obs; // Mulai dengan true untuk menunjukkan loading awal
  final errorMessage = ''.obs; // Untuk menyimpan pesan error jika ada

  // State untuk menyimpan detail course yang berhasil diambil
  final Rx<CourseWithQuizzesResponse?> course = Rx(null);

  // State untuk konten yang akan ditampilkan (gambar, teks, dll.)
  // Formatnya adalah List dari Map, contoh: [{'type': 'text', 'data': '...'}]
  final RxList<Map<String, dynamic>> contentItems =
      <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Ambil argumen 'courseId' yang dikirim dari halaman sebelumnya
    final arguments = Get.arguments as Map<String, dynamic>?;
    final courseId = arguments?['courseId'] as String?;

    if (courseId != null) {
      // Jika courseId ada, panggil fungsi untuk mengambil detailnya
      fetchCourseDetail(courseId);
    } else {
      // Jika tidak ada courseId, tampilkan error
      isLoading.value = false;
      errorMessage.value = 'ID Materi tidak valid atau tidak ditemukan.';
      debugPrint("Error: courseId is null.");
    }
  }

  /// Mengambil data detail course dari repository berdasarkan ID.
  Future<void> fetchCourseDetail(String courseId) async {
    try {
      // Reset state sebelum memuat data baru
      isLoading.value = true;
      errorMessage.value = '';

      // Panggil metode dari repository
      final result = await _courseRepository.getAccessibleCourseById(courseId);

      if (result != null) {
        // Jika berhasil, simpan data course
        course.value = result;
        // Proses dan simpan konten untuk ditampilkan di UI
        contentItems.value = List<Map<String, dynamic>>.from(result.content);
      } else {
        // Jika gagal (result == null), tampilkan pesan error
        errorMessage.value = 'Gagal memuat detail materi. Silakan coba lagi.';
      }
    } catch (e) {
      // Tangani error yang mungkin terjadi selama proses
      errorMessage.value = 'Terjadi kesalahan tidak terduga.';
      debugPrint('Error fetching course detail: $e');
    } finally {
      // Apapun hasilnya, hentikan loading indicator
      isLoading.value = false;
    }
  }
}
