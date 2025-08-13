import 'package:blessing/core/global_components/custom_snackbar.dart';
import 'package:blessing/data/subject/models/request/create_subject_request.dart';
import 'package:blessing/data/subject/repository/subject_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminCreateSubjectController extends GetxController {
  // --- DEPENDENCIES ---
  // Pastikan SubjectRepository sudah didaftarkan di bindings
  final _subjectRepository = Get.find<SubjectRepository>();

  // --- STATE ---
  final formKey = GlobalKey<FormState>();
  late TextEditingController subjectNameController;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    subjectNameController = TextEditingController();
  }

  @override
  void onClose() {
    subjectNameController.dispose();
    super.onClose();
  }

  /// Fungsi untuk membuat mata pelajaran baru
  Future<void> createSubject() async {
    // Validasi form terlebih dahulu
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Tampilkan loading
    isLoading.value = true;

    try {
      // Siapkan data request
      final request = CreateSubjectRequest(
        subjectName: subjectNameController.text,
      );

      final result = await _subjectRepository.createSubject(request);

      if (result != null) {
        CustomSnackbar.show(
          title: 'Sukses',
          message: 'Mata pelajaran "${result.subjectName}" berhasil dibuat.',
        );
      } else {
        CustomSnackbar.show(
          title: 'Gagal',
          message: 'Tidak dapat membuat mata pelajaran. Coba lagi.',
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        isError: true,
        message: 'Terjadi kesalahan: $e',
        title: 'Error',
      );
    } finally {
      // Sembunyikan loading
      isLoading.value = false;
    }
  }
}
