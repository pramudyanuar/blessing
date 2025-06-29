import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Enum untuk tipe konten agar lebih aman dan mudah dibaca
enum ContentType { pdf, gallery }

class CourseDetailController extends GetxController {
  // --- State Observables ---
  final RxString title = ''.obs;
  final Rx<ContentType> contentType = ContentType.pdf.obs;
  final RxList<String> contentPaths = <String>[].obs;
  final RxInt currentPage = 0.obs; // Untuk navigasi galeri gambar

  // --- Controller untuk PageView ---
  late final PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();

    // Ambil argumen yang dikirim dari halaman daftar materi
    final arguments = Get.arguments as Map<String, dynamic>?;

    if (arguments != null) {
      title.value = arguments['title'] ?? 'Detail Materi';
      contentType.value = arguments['type'] as ContentType? ?? ContentType.pdf;

      final paths = arguments['paths'] as List<dynamic>?;
      if (paths != null) {
        contentPaths.value = List<String>.from(paths);
      }
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  // --- Metode untuk Navigasi Galeri ---
  void goToNextPage() {
    if (currentPage.value < contentPaths.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void goToPreviousPage() {
    if (currentPage.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }
}
