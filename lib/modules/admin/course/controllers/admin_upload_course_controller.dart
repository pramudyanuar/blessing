// lib/modules/admin/course/controllers/admin_upload_course_controller.dart

import 'dart:io';

import 'package:blessing/core/utils/app_routes.dart';
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
  final linkController = TextEditingController(); // Controller untuk link
  final gradeLevel = 1.obs; // Default ke 1, bisa diubah dari UI
  final isLoading = false.obs;
  late String subjectId;
  late int kelas;
  Function? onCourseCreated; // Callback untuk refresh course list

  /// [DIUBAH] Menggunakan satu list untuk semua konten (teks dan gambar).
  /// Ini adalah "source of truth" untuk konten course.
  final contentItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    subjectId = args['subjectId'];
    kelas = args['kelas'];
    onCourseCreated = args['onCourseCreated']; // Ambil callback dari arguments
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
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

  /// [BARU] Fungsi untuk menambahkan link ke content
  void addLink() {
    if (linkController.text.isNotEmpty) {
      // Validasi basic untuk URL
      final link = linkController.text.trim();
      if (Uri.tryParse(link) != null && link.startsWith('http')) {
        contentItems.add({
          'type': 'link',
          'data': link,
        });
        linkController.clear();
        Get.snackbar(
          'Berhasil',
          'Link berhasil ditambahkan',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Format link tidak valid. Pastikan dimulai dengan http:// atau https://',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
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

    try {
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
        return;
      }

      // Memanggil repository dengan signature yang sudah diperbarui
      final success = await _courseRepository.adminPostCourse(
          courseName: titleController.text,
          gradeLevel: kelas,
          content: finalPayloadContent,
          subjectId: subjectId);

      if (success) {
        Get.snackbar(
          'Berhasil',
          'Materi berhasil diunggah',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Tunggu sebentar agar user bisa melihat notifikasi sukses
        await Future.delayed(const Duration(seconds: 1));

        // Gunakan Get.offNamed() untuk memastikan kembali ke course list
        Get.offNamed(AppRoutes.manageSubject);

        // Panggil callback untuk refresh course list
        if (onCourseCreated != null) {
          onCourseCreated!();
        }
      } else {
        Get.snackbar(
          'Gagal',
          'Terjadi kesalahan saat mengunggah materi',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat mengunggah materi',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false; // Pastikan loading state selalu di-reset
    }
  }
}
