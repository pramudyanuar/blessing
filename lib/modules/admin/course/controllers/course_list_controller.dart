// lib/modules/admin/course/controllers/course_list_controller.dart

import 'package:blessing/core/global_components/custom_snackbar.dart';
import 'package:blessing/core/global_components/global_confirmation_dialog.dart';
import 'package:blessing/data/subject/models/request/update_subject_request.dart';
import 'package:blessing/data/subject/repository/subject_repository_impl.dart';
import 'package:blessing/modules/admin/course/widgets/course_card.dart';
// --- PERUBAHAN: Import CourseContentType ---
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// --- PERUBAHAN: Kelas CourseItem dihapus ---

class AdminManageCourseListController extends GetxController {
  // State untuk UI AppBar
  final RxString title = 'Mata Pelajaran'.obs;
  final RxString classLevel = ''.obs;
  final RxString imagePath = ''.obs;

  late final String subjectId;
  late final int kelas;

  final _subjectRepository = Get.find<SubjectRepository>();
  late final TextEditingController editNameController;

  // --- PERUBAHAN: Menggunakan RxList<dynamic> untuk menampung data Map ---
  final RxList<dynamic> courses = <dynamic>[
    // Contoh data Kuis dalam bentuk Map
    {
      'type': CourseContentType.quiz,
      'title': 'Quiz 7: Persamaan Kuadrat',
      'dateText': '3 hari yang lalu',
      'description': 'Uji pemahamanmu tentang akar-akar persamaan kuadrat.',
      'timeLimit': 10, // Menggunakan timeLimit sesuai CourseCard baru
    },
    // Contoh data Materi dalam bentuk Map
    {
      'type': CourseContentType.material,
      'title': 'Bab 5 : Geometri Ruang',
      'description':
          'Materi lengkap tentang bangun ruang sisi datar dan lengkung.',
      'fileName': 'geometri.pdf',
      'dateText': '1 minggu yang lalu',
      'previewImages': null, // Bisa diisi dengan list widget gambar
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>?;

    if (arguments != null) {
      subjectId = arguments['subjectId'] ?? '';
      kelas = arguments['kelas'] ?? 0;
      final subjectName = arguments['subjectName'] ?? 'Mata Pelajaran';

      title.value = subjectName;
      classLevel.value = 'Kelas $kelas';
      editNameController = TextEditingController(text: subjectName);

      print('✅ ID Mata Pelajaran: $subjectId');
      print('✅ Kelas: $kelas');
    } else {
      print('❌ Error: Tidak ada data arguments yang diterima. Kembali.');
      // Tambahkan pengecekan agar tidak error saat hot reload
      subjectId = '';
      kelas = 0;
      editNameController = TextEditingController();
      Get.back();
    }
    imagePath.value = 'assets/images/bg-admin-subject.png';
    // fetchCourseData(); // Panggil fungsi untuk mengambil data dari API di sini
  }

  /*
  // --- CONTOH FUNGSI FETCH DATA DARI API ---
  Future<void> fetchCourseData() async {
    // Tampilkan loading
    // Panggil repository untuk get materials dan quizzes berdasarkan subjectId
    // final materials = await _courseRepository.getMaterials(subjectId);
    // final quizzes = await _courseRepository.getQuizzes(subjectId);

    // Ubah data model dari API menjadi format Map yang kita butuhkan
    // final formattedMaterials = materials.map((m) => { 'type': CourseContentType.material, 'title': m.title, ... }).toList();
    // final formattedQuizzes = quizzes.map((q) => { 'type': CourseContentType.quiz, 'title': q.name, ... }).toList();

    // Gabungkan dan urutkan berdasarkan tanggal
    final combinedList = [...formattedMaterials, ...formattedQuizzes];
    combinedList.sort((a, b) => b['date'].compareTo(a['date'])); // contoh sorting

    courses.value = combinedList; // Update list
    // Hilangkan loading
  }
  */

  void showEditSubjectDialog() {
    editNameController.text = title.value;
    Get.dialog(
      AlertDialog(
        title: const Text('Ubah Nama Mata Pelajaran'),
        content: TextField(
          controller: editNameController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Nama Mata Pelajaran Baru',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) => _performUpdate(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: _performUpdate,
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _performUpdate() {
    if (Get.isDialogOpen!) Get.back();
    updateSubjectName();
  }

  Future<void> updateSubjectName() async {
    final newName = editNameController.text.trim();
    if (newName.isEmpty) {
      CustomSnackbar.show(
          title: 'Error',
          message: 'Nama mata pelajaran tidak boleh kosong.',
          isError: true);
      return;
    }
    if (newName == title.value) {
      CustomSnackbar.show(
          title: 'Info',
          message: 'Tidak ada perubahan pada nama mata pelajaran.',
          isError: false);
      return;
    }
    Get.dialog(const Center(child: CircularProgressIndicator()),
        barrierDismissible: false);
    final request = UpdateSubjectRequest(subjectName: newName);
    final result = await _subjectRepository.updateSubject(subjectId, request);
    Get.back();
    if (result != null) {
      title.value = result.subjectName!;
      CustomSnackbar.show(
          title: 'Berhasil', message: 'Nama mata pelajaran berhasil diubah.');
      Get.back(result: true); // Kirim sinyal update ke halaman sebelumnya
    } else {
      CustomSnackbar.show(
          title: 'Error',
          message: 'Gagal mengubah nama mata pelajaran.',
          isError: true);
    }
  }

  void showDeleteConfirmation() {
    Get.dialog(
      GlobalConfirmationDialog(
        message:
            'Apakah Anda yakin ingin menghapus mata pelajaran ini? Tindakan ini akan menghapus semua materi dan kuis terkait pada SEMUA KELAS dan tidak dapat diurungkan.',
        noText: 'Batal',
        yesText: 'Hapus',
        yesColor: Colors.red,
        onNo: () => Get.back(),
        onYes: () {
          Get.back();
          deleteSubject();
        },
      ),
      barrierDismissible: false,
    );
  }

  Future<void> deleteSubject() async {
    Get.dialog(const Center(child: CircularProgressIndicator()),
        barrierDismissible: false);
    final result = await _subjectRepository.deleteSubject(subjectId);
    Get.back();
    if (result != null) {
      CustomSnackbar.show(
        title: 'Berhasil',
        message: 'Mata pelajaran "${title.value}" berhasil dihapus.',
      );
      Get.back(result: true);
    } else {
      CustomSnackbar.show(
        title: 'Error',
        message: 'Gagal menghapus mata pelajaran.',
        isError: true,
      );
    }
  }

  void handleMenuSelection(String value) {
    switch (value) {
      case 'edit':
        showEditSubjectDialog();
        break;
      case 'delete':
        showDeleteConfirmation();
        break;
    }
  }

  @override
  void onClose() {
    editNameController.dispose();
    super.onClose();
  }
}
