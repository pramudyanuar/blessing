import 'package:blessing/core/global_components/custom_snackbar.dart';
import 'package:blessing/core/global_components/global_confirmation_dialog.dart';
import 'package:blessing/core/utils/cache_util.dart';
import 'package:blessing/data/core/models/content_block.dart';
import 'package:blessing/data/course/models/response/course_response.dart'; // Pastikan import ini ada
import 'package:blessing/data/course/repository/course_repository_impl.dart';
import 'package:blessing/data/subject/models/request/update_subject_request.dart';
import 'package:blessing/data/subject/repository/subject_repository_impl.dart';
import 'package:blessing/modules/admin/course/widgets/course_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AdminManageCourseListController extends GetxController {
  final RxString title = 'Mata Pelajaran'.obs;
  final RxString classLevel = ''.obs;
  final RxString imagePath = ''.obs;

  late final String subjectId;
  late final int kelas;

  final _subjectRepository = Get.find<SubjectRepository>();
  final _courseRepository = Get.find<CourseRepository>();

  late final TextEditingController editNameController;

  final RxBool isLoading = false.obs;
  final RxList<dynamic> courses = <dynamic>[].obs;

  late final String _cacheKey;

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

      _cacheKey = 'courses_${subjectId}_$kelas';
      _loadFromCache();
      fetchCourses();

      print('✅ Controller Initialized. Subject ID: $subjectId, Kelas: $kelas');
    } else {
      print('❌ Error: Tidak ada data arguments yang diterima. Kembali.');
      subjectId = '';
      kelas = 0;
      _cacheKey = 'courses_error';
      editNameController = TextEditingController();
      if (Get.context != null) Get.back();
    }
    imagePath.value = 'assets/images/bg-admin-subject.png';
  }

  Future<void> _loadFromCache() async {
    final cachedData = CacheUtil().getData(_cacheKey);
    if (cachedData != null && cachedData is List) {
      final mappedData = cachedData.map((item) {
        if (item is Map) {
          final newItem = Map<String, dynamic>.from(item);
          if (newItem.containsKey('dateObject')) {
            newItem['dateObject'] = DateTime.parse(newItem['dateObject']);
          }
          return newItem;
        }
        return item;
      }).toList();
      courses.assignAll(mappedData);
    }
  }

  // --- PERUBAHAN UTAMA DI FUNGSI INI ---
  Future<void> fetchCourses() async {
    if (courses.isEmpty) {
      isLoading.value = true;
    }

    try {
      // 1. Panggil metode baru untuk mengambil SEMUA course
      final List<CourseResponse>? allCourses =
          await _courseRepository.adminGetAllCoursesWithoutPaging();

      // 2. Lanjutkan proses hanya jika hasilnya tidak null
      if (allCourses != null) {
        // 3. Lakukan filter, map, dan sort pada SEMUA data yang sudah didapat
        final mappedCourses = allCourses
            .where((c) => c.subject?.id == subjectId && c.gradeLevel == kelas)
            .map((course) {
          final date = course.updatedAt ?? course.createdAt ?? DateTime.now();
          return {
            'id': course.id,
            'type': CourseContentType.material,
            'title': course.courseName ?? 'Materi Tanpa Judul',
            'description': _extractDescriptionFromContent(course.content),
            'fileName': 'Lihat Detail',
            'dateObject': date,
            'dateText': _formatDate(date),
          };
        }).toList()
          ..sort((a, b) => (b['dateObject'] as DateTime)
              .compareTo(a['dateObject'] as DateTime));

        // Simpan hasil yang sudah difilter ke cache
        CacheUtil().setData(
          _cacheKey,
          mappedCourses.map((item) {
            final newItem = Map<String, dynamic>.from(item);
            newItem['dateObject'] =
                (newItem['dateObject'] as DateTime).toIso8601String();
            return newItem;
          }).toList(),
        );

        // Tampilkan hasilnya di UI
        courses.assignAll(mappedCourses);
      }
    } catch (e) {
      print('❌ Error fetching data: $e');
      CustomSnackbar.show(
          title: 'Error',
          message: 'Gagal memuat data dari server.',
          isError: true);
    } finally {
      isLoading.value = false;
    }
  }
  // --- AKHIR DARI PERUBAHAN ---

  String _formatDate(DateTime date) {
    return DateFormat('d MMMM yyyy', 'id_ID').format(date);
  }

  String _extractDescriptionFromContent(List<ContentBlock>? content) {
    if (content == null || content.isEmpty) {
      return 'Ketuk untuk melihat detail materi.';
    }
    try {
      final firstText = content.firstWhere((c) => c.type == 'text');
      return firstText.data.length > 100
          ? '${firstText.data.substring(0, 100)}...'
          : firstText.data;
    } catch (e) {
      return 'Materi ini berisi konten gambar/non-teks.';
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
    Get.back();

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
            'Apakah Anda yakin ingin menghapus mata pelajaran "${title.value}"? Tindakan ini akan menghapus semua materi terkait pada SEMUA KELAS dan tidak dapat diurungkan.',
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
          message: 'Mata pelajaran "${title.value}" berhasil dihapus.');
      Get.back(result: true);
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

  Future<void> refreshCourses() async {
    CacheUtil().removeData(_cacheKey);
    // Tidak perlu assignAll([]) karena fetchCourses akan menggantinya
    await fetchCourses();
  }

  @override
  void onClose() {
    editNameController.dispose();
    super.onClose();
  }
}
