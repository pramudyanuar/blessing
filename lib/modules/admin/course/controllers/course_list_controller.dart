import 'package:blessing/core/global_components/custom_snackbar.dart';
import 'package:blessing/core/global_components/global_confirmation_dialog.dart';
import 'package:blessing/core/utils/cache_util.dart';
import 'package:blessing/data/core/models/content_block.dart';
import 'package:blessing/data/course/models/response/course_response.dart';
import 'package:blessing/data/course/repository/course_repository_impl.dart';
import 'package:blessing/data/subject/models/request/update_subject_request.dart';
import 'package:blessing/data/subject/repository/subject_repository_impl.dart';
import 'package:blessing/modules/admin/course/widgets/course_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AdminManageCourseListController extends GetxController {
  // State untuk UI AppBar
  final RxString title = 'Mata Pelajaran'.obs;
  final RxString classLevel = ''.obs;
  final RxString imagePath = ''.obs;

  // Properti dari arguments
  late final String subjectId;
  late final int kelas;

  // Repositories
  final _subjectRepository = Get.find<SubjectRepository>();
  final _courseRepository = Get.find<CourseRepository>();
  // --- BAGIAN KUIS (DIKOMENTARI SEMENTARA) ---
  // final _quizRepository = Get.find<QuizRepository>();

  // Controller untuk dialog edit
  late final TextEditingController editNameController;

  // State
  final RxBool isLoading = false.obs;

  /// List yang menampung SEMUA course dari cache/API (data model mentah).
  final RxList<CourseResponse> _masterCourseList = <CourseResponse>[].obs;

  /// List yang sudah difilter dan di-map untuk ditampilkan di UI.
  final RxList<dynamic> courses = <dynamic>[].obs;

  /// Kunci cache global untuk semua course.
  static const _masterCacheKey = 'all_admin_courses';

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

      _initializeData();
      print('✅ Controller Initialized. Subject ID: $subjectId, Kelas: $kelas');
    } else {
      print('❌ Error: Tidak ada data arguments yang diterima. Kembali.');
      if (Get.context != null) Get.back();
    }
    imagePath.value = 'assets/images/bg-admin-subject.png';
  }

  /// Mengatur alur pemuatan dan pembaruan data.
  void _initializeData() async {
    // 1. Muat data master dari cache secara sinkron
    await _loadMasterCache();
    // 2. Filter dan tampilkan data yang sesuai untuk halaman ini
    _filterAndDisplayCourses();
    // 3. Panggil API di latar belakang untuk memperbarui master cache
    await _fetchAndRefreshMasterCache();
  }

  /// Memuat semua data course dari cache ke dalam `_masterCourseList`.
  Future<void> _loadMasterCache() async {
    final cachedData = CacheUtil().getData(_masterCacheKey);
    if (cachedData != null && cachedData is List) {
      print(
          '✅ Memuat ${cachedData.length} item dari MASTER CACHE: $_masterCacheKey');
      // Ubah List<Map> dari cache menjadi List<CourseResponse>
      final models = cachedData
          .map((map) => CourseResponse.fromJson(Map<String, dynamic>.from(map)))
          .toList();
      _masterCourseList.assignAll(models);
    }
  }

  /// Mengambil data terbaru dari API dan memperbarui `_masterCourseList` serta cache.
  Future<void> _fetchAndRefreshMasterCache() async {
    if (_masterCourseList.isEmpty) {
      isLoading.value = true;
    }

    try {
      final coursesResult = await _courseRepository
          .adminGetAllCourses(); // Ambil semua tanpa filter
      if (coursesResult != null) {
        _masterCourseList.assignAll(coursesResult.courses);
        print(
            '✅ Master data diperbarui dari API, total: ${coursesResult.courses.length} courses.');

        // Simpan data model mentah ke cache setelah diubah ke Map
        final cacheableData =
            coursesResult.courses.map((c) => c.toJson()).toList();
        await CacheUtil().setData(_masterCacheKey, cacheableData);
        print('✅ Master cache diperbarui.');

        // Setelah cache diperbarui, filter ulang data untuk UI
        _filterAndDisplayCourses();
      }
    } catch (e) {
      print('❌ Error fetching master data: $e');
      // Tidak perlu menampilkan snackbar error jika data dari cache sudah ada
      if (courses.isEmpty) {
        CustomSnackbar.show(
            title: 'Error',
            message: 'Gagal memuat data dari server.',
            isError: true);
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Memfilter `_masterCourseList` berdasarkan `subjectId` dan `kelas` lalu menampilkannya.
  void _filterAndDisplayCourses() {
    // 1. Filter data dari master list
    final filtered = _masterCourseList.where((c) {
      return c.subject?.id == subjectId && c.gradeLevel == kelas;
    }).toList();

    // 2. Map ke format yang dibutuhkan oleh UI
    final mapped = filtered.map((course) {
      final date = course.updatedAt ?? course.createdAt ?? DateTime.now();
      return {
        'id': course.id,
        'type': CourseContentType.material,
        'title': course.courseName ?? 'Materi Tanpa Judul',
        'description': _extractDescriptionFromContent(course.content),
        'fileName': 'Lihat Detail',
        'dateObject': date, // Simpan object DateTime untuk sorting
        'dateText': _formatDate(date), // Simpan string untuk display
      };
    }).toList();

    // --- BAGIAN KUIS (DIKOMENTARI SEMENTARA) ---
    // Nantinya, data kuis dari master list kuis juga akan di-filter dan di-map di sini,
    // lalu ditambahkan ke `combinedList`.
    // final combinedList = [...mapped, ...mappedQuizzes];

    final combinedList = mapped; // Untuk saat ini, hanya berisi materi

    // 3. Urutkan berdasarkan tanggal terbaru
    combinedList.sort((a, b) =>
        (b['dateObject'] as DateTime).compareTo(a['dateObject'] as DateTime));

    // 4. Update state UI
    courses.assignAll(combinedList);
    print(
        '🔄 UI diperbarui dengan ${courses.length} item untuk Subject ID: $subjectId & Kelas: $kelas.');
  }

  // =======================================================================
  // Fungsi Helper dan Aksi Pengguna
  // =======================================================================

  /// Helper untuk memformat DateTime menjadi String yang mudah dibaca.
  String _formatDate(DateTime date) {
    // Contoh format: "14 Agustus 2025"
    return DateFormat('d MMMM yyyy', 'id_ID').format(date);
  }

  /// Helper untuk mengambil deskripsi singkat dari list ContentBlock.
  String _extractDescriptionFromContent(List<ContentBlock>? content) {
    if (content == null || content.isEmpty) {
      return 'Ketuk untuk melihat detail materi.';
    }
    try {
      // Cari blok konten pertama yang bertipe 'text'
      final firstText = content.firstWhere((c) => c.type == 'text');
      // Batasi deskripsi hingga 100 karakter
      return firstText.data.length > 100
          ? '${firstText.data.substring(0, 100)}...'
          : firstText.data;
    } catch (e) {
      // Jika tidak ada blok teks sama sekali
      return 'Materi ini berisi konten gambar atau non-teks.';
    }
  }

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
    if (newName == title.value) return;

    Get.dialog(const Center(child: CircularProgressIndicator()),
        barrierDismissible: false);
    final request = UpdateSubjectRequest(subjectName: newName);
    final result = await _subjectRepository.updateSubject(subjectId, request);
    Get.back(); // close loading

    if (result != null) {
      title.value = result.subjectName!;
      CustomSnackbar.show(
          title: 'Berhasil', message: 'Nama mata pelajaran berhasil diubah.');
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
            'Apakah Anda yakin ingin menghapus mata pelajaran "${title.value}"? Tindakan ini akan menghapus semua materi dan kuis terkait pada SEMUA KELAS dan tidak dapat diurungkan.',
        noText: 'Batal',
        yesText: 'Hapus',
        yesColor: Colors.red,
        onNo: () => Get.back(),
        onYes: () {
          Get.back(); // close confirmation dialog
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
    Get.back(); // close loading

    if (result != null) {
      CustomSnackbar.show(
          title: 'Berhasil',
          message: 'Mata pelajaran "${title.value}" berhasil dihapus.');
      Get.back(result: true); // Kirim sinyal update ke halaman sebelumnya
    } else {
      CustomSnackbar.show(
          title: 'Error',
          message: 'Gagal menghapus mata pelajaran.',
          isError: true);
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
