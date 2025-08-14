// lib/modules/admin/course/controllers/admin_upload_course_controller.dart

import 'dart:io';

import 'package:blessing/data/course/repository/course_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AdminUploadCourseController extends GetxController {
  // Gunakan CourseRepository langsung, sesuai binding Anda
  final _courseRepository = Get.find<CourseRepository>();
  final ImagePicker _picker = ImagePicker();

  // State untuk UI
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final gradeLevel = 1.obs; // Default ke 1, bisa diubah dari UI
  final isLoading = false.obs;
  late String subjectId;
  late int kelas;

  /// [DIUBAH] Menggunakan satu list untuk semua konten (teks dan gambar).
  /// Ini adalah "source of truth" untuk konten course.
  final contentItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    subjectId = args['subjectId'];
    kelas = args['kelas'];
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  /// [BARU] Fungsi untuk memilih beberapa gambar dari galeri.
  Future<void> pickImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      for (var xFile in pickedFiles) {
        // Menambahkan gambar ke dalam list contentItems dengan format yang benar
        contentItems.add({
          'type': 'image',
          'data': File(xFile.path),
        });
      }
    }
  }

  /// [DIUBAH] Menghapus item dari list konten.
  void removeContentItem(Map<String, dynamic> item) {
    contentItems.remove(item);
  }

  /// [DIUBAH TOTAL] Logika upload yang sesuai dengan arsitektur baru.
  Future<void> uploadCourse() async {
    if (titleController.text.isEmpty) {
      Get.snackbar('Error', 'Judul materi tidak boleh kosong');
      return;
    }

    isLoading.value = true;

    // --- Membangun Payload 'content' ---
    final List<Map<String, dynamic>> finalPayloadContent = [];

    // 1. Tambahkan deskripsi sebagai item teks pertama (jika ada)
    if (descriptionController.text.isNotEmpty) {
      finalPayloadContent.add({
        'type': 'text',
        'data': descriptionController.text,
      });
    }

    // 2. Tambahkan semua item gambar yang sudah dipilih pengguna
    finalPayloadContent.addAll(contentItems);
    // --- Selesai Membangun Payload ---

    if (finalPayloadContent.isEmpty) {
      Get.snackbar(
          'Error', 'Konten (deskripsi atau gambar) tidak boleh kosong');
      isLoading.value = false;
      return;
    }

    // Memanggil repository dengan signature yang sudah diperbarui
    final success = await _courseRepository.adminPostCourse(
      courseName: titleController.text,
      gradeLevel: kelas,
      content: finalPayloadContent,
      subjectId: subjectId
    );

    isLoading.value = false;

    if (success) {
      Get.back(); // Kembali ke halaman sebelumnya
      Get.snackbar(
        'Berhasil',
        'Materi berhasil diunggah',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Gagal',
        'Terjadi kesalahan saat mengunggah materi',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
