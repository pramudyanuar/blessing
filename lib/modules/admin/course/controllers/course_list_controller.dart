// lib/modules/admin/course/controllers/course_list_controller.dart

import 'package:blessing/core/global_components/custom_snackbar.dart';
import 'package:blessing/core/global_components/global_confirmation_dialog.dart';
import 'package:blessing/core/utils/app_routes.dart';
import 'package:blessing/data/subject/models/request/update_subject_request.dart';
import 'package:blessing/data/subject/repository/subject_repository_impl.dart';
import 'package:blessing/modules/student/course/widgets/course_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CourseItem {
  final CardType cardType;
  final String title;
  final String dateText;
  final String? description;
  final String? fileName;
  final List<Widget>? previewImages;
  final VoidCallback? onTapDetail;
  final List<String>? quizDetails;
  final bool isCompleted;
  final int? score;
  final VoidCallback? onStart;

  CourseItem({
    required this.cardType,
    required this.title,
    required this.dateText,
    this.description,
    this.fileName,
    this.previewImages,
    this.onTapDetail,
    this.quizDetails,
    this.isCompleted = false,
    this.score,
    this.onStart,
  });
}

class AdminManageCourseListController extends GetxController {
  // State untuk UI AppBar
  final RxString title = 'Mata Pelajaran'.obs;
  final RxString classLevel = ''.obs;
  final RxString imagePath = ''.obs;

  // --- PERUBAHAN DI SINI: Variabel untuk menyimpan data yang diterima ---
  late final String subjectId;
  late final int kelas;
  // --- AKHIR PERUBAHAN ---

  // --- PERUBAHAN DI SINI: Tambahkan dependensi dan state untuk edit ---
  final _subjectRepository = Get.find<SubjectRepository>();
  late final TextEditingController editNameController;
  // --- AKHIR PERUBAHAN ---

  // Daftar materi/kuis (nantinya akan diisi dari API)
  final RxList<CourseItem> courses = <CourseItem>[
    // Contoh Kuis Belum Dikerjakan
    CourseItem(
      cardType: CardType.quiz,
      title: 'Quiz 7',
      dateText: '3 hari yang lalu',
      quizDetails: ['Waktu Pengerjaan : 10 Menit', 'Jumlah Soal : 20 Soal'],
      isCompleted: false,
      onStart: () {
        Get.snackbar("Info", "Membuka halaman kuis...");
      },
    ),
    // Contoh Materi
    CourseItem(
      cardType: CardType.material,
      title: 'Bab 5 : Geometri Ruang',
      description:
          'Materi lengkap tentang bangun ruang sisi datar dan lengkung.',
      fileName: 'geometri.pdf',
      dateText: '1 minggu yang lalu',
      onTapDetail: () => Get.toNamed(AppRoutes.courseDetail),
    ),
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

      // --- PERUBAHAN DI SINI: Inisialisasi TextEditingController ---
      editNameController = TextEditingController(text: subjectName);
      // --- AKHIR PERUBAHAN ---

      print('✅ ID Mata Pelajaran: $subjectId');
      print('✅ Kelas: $kelas');
    } else {
      print('❌ Error: Tidak ada data arguments yang diterima. Kembali.');
      Get.back();
    }

    imagePath.value = 'assets/images/bg-admin-subject.png';
  }

  // --- PERUBAHAN DI SINI: Tambahkan fungsi untuk edit nama mata pelajaran ---
  void showEditSubjectDialog() {
    // Pastikan controller direset ke nama saat ini setiap kali dialog dibuka
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
    // Tutup dialog dulu, lalu panggil fungsi update
    if (Get.isDialogOpen!) {
      Get.back();
    }
    updateSubjectName();
  }

  Future<void> updateSubjectName() async {
    final newName = editNameController.text.trim();

    if (newName.isEmpty) {
      CustomSnackbar.show(title: 'Error', message: 'Nama mata pelajaran tidak boleh kosong.', isError: true);
      return;
    }

    if (newName == title.value) {
      CustomSnackbar.show(
          title: 'Error', message: 'Nama mata pelajaran tidak boleh sama.', isError: true);
      return;
    }

    // Tampilkan loading indicator
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    final request = UpdateSubjectRequest(subjectName: newName,);
    final result = await _subjectRepository.updateSubject(subjectId, request);

    // Tutup loading indicator
    Get.back();

    if (result != null) {
      title.value = result.subjectName!;
      CustomSnackbar.show(
          title: 'Berhasil', message: 'Nama mata pelajaran berhasil diubah.');
      // Opsional: Kirim sinyal kembali ke halaman sebelumnya bahwa ada update.
      // Jika halaman sebelumnya perlu refresh list, Anda bisa gunakan:
      // Get.back(result: true);
    } else {
      CustomSnackbar.show(
          title: 'Error', message: 'Gagal mengubah nama mata pelajaran.', isError: true);
    }
  }
  // --- AKHIR PERUBAHAN ---

  void showDeleteConfirmationDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text(
            'Apakah Anda yakin ingin menghapus mata pelajaran ini? Tindakan ini juga akan menghapus semua materi dan kuis di dalamnya dan tidak dapat diurungkan.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              // Tutup dialog konfirmasi, lalu jalankan proses hapus
              if (Get.isDialogOpen!) {
                Get.back();
              }
              deleteSubject();
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// Menjalankan proses penghapusan mata pelajaran.
  Future<void> deleteSubject() async {
    // Tampilkan loading indicator
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    final result = await _subjectRepository.deleteSubject(subjectId);

    // Tutup loading indicator
    Get.back();

    if (result != null) {
      CustomSnackbar.show(
        title: 'Berhasil',
        message: 'Mata pelajaran "${title.value}" berhasil dihapus.',
      );
      // Kembali ke halaman daftar mata pelajaran dan kirim sinyal untuk refresh
      Get.back(result: true);
    } else {
      CustomSnackbar.show(
        title: 'Error',
        message: 'Gagal menghapus mata pelajaran.',
        isError: true,
      );
    }
  }
  // --- AKHIR PERUBAHAN ---

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

  void showDeleteConfirmation() {
    Get.dialog(
      GlobalConfirmationDialog(
        message:
            'Apakah Anda yakin ingin menghapus mata pelajaran ini? Tindakan ini akan menghapus semua materi dan kuis terkait pada SEMUA KELAS dan tidak dapat diurungkan.',
        noText: 'Batal',
        yesText: 'Hapus',
        yesColor: Colors.red, // Jadikan tombol hapus berwarna merah
        onNo: () {
          Get.back(); // Tutup dialog
        },
        onYes: () {
          Get.back(); // Tutup dialog
          deleteSubject(); // Lanjutkan proses hapus
        },
      ),
      barrierDismissible: false,
    );
  }

  @override
  void onClose() {
    // --- PERUBAHAN DI SINI: Dispose controller ---
    
    editNameController.dispose();
    // --- AKHIR PERUBAHAN ---
    super.onClose();
  }
}
