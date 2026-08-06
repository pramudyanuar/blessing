import 'package:blessing/core/utils/app_routes.dart';
import 'package:blessing/core/utils/cache_util.dart';
import 'package:blessing/data/subject/models/response/subject_response.dart';
import 'package:blessing/data/subject/repository/subject_repository_impl.dart';
import 'package:blessing/data/user/models/response/user_response.dart';
import 'package:blessing/data/user/repository/user_repository_impl.dart';
import 'package:blessing/main.dart';
import 'package:blessing/modules/admin/homepage/widgets/admin_birthday_popup.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AdminHomepageController extends GetxController {
  // --- DEPENDENCIES ---
  final _userRepository = Get.find<UserRepository>();
  final _subjectRepository = Get.find<SubjectRepository>();

  // --- CACHE ---
  final _cacheUtil = CacheUtil();
  String get _cacheKey => 'all_admin_subjects_${selectedKelas.value}';

  // --- STATE ---
  var isLoading = true.obs;
  var selectedKelas = 1.obs;
  final List<int> kelasList = [1 ,2 ,3 ,4 ,5 ,6 ,7, 8, 9, 10, 11, 12];

  final _allSubjects = <SubjectResponse>[].obs; // Menyimpan semua data asli
  var displayedSubjects =
      <SubjectResponse>[].obs; // Data yang akan ditampilkan (setelah filter)
  var searchQuery = ''.obs; // Menyimpan query pencarian

  @override
  void onInit() {
    super.onInit();
    _loadSubjectsFromCache();
    fetchAllSubjects();
    _checkBirthdayStudentsAndShow();
  }

  /// Cek siapa saja siswa yang ulang tahun hari ini, dan tampilkan popup sekali per hari.
  Future<void> _checkBirthdayStudentsAndShow() async {
    try {
      final now = DateTime.now();
      final cacheKey =
          'admin_birthday_popup_${now.year}-${now.month}-${now.day}';

      // Sudah pernah tampil hari ini? Skip.
      if (_cacheUtil.hasData(cacheKey)) return;

      // Panggil endpoint khusus — server sudah filter siswa yang ultah hari ini
      final List<UserResponse> birthdayStudents =
          await _userRepository.getTodayBirthdays();

      if (birthdayStudents.isEmpty) return;

      // Tandai sudah tampil hari ini
      await _cacheUtil.setData(cacheKey, true);

      // Tampilkan popup
      Get.dialog(
        AdminBirthdayPopup(birthdayStudents: birthdayStudents),
        barrierDismissible: true,
      );
    } catch (e) {
      debugPrint('[AdminHomepageController] Birthday check error: $e');
    }
  }

  // --- PERUBAHAN DI SINI ---
  /// Memfilter mata pelajaran HANYA berdasarkan query pencarian.
  void _filterSubjects() {
    // Mulai dengan semua data dari master list, tanpa filter kelas.
    List<SubjectResponse> filtered = _allSubjects.toList();

    // Jika ada query pencarian, filter berdasarkan nama mata pelajaran.
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((subject) {
        final subjectName = subject.subjectName?.toLowerCase() ?? '';
        final query = searchQuery.value.toLowerCase();
        return subjectName.contains(query);
      }).toList();
    }

    // Perbarui daftar yang ditampilkan di UI.
    displayedSubjects.assignAll(filtered);
  }
  // --- PERUBAHAN SELESAI ---

  /// Mengatur query pencarian dan memicu filter.
  void setSearchQuery(String query) {
    searchQuery.value = query;
    _filterSubjects();
  }

  Future<void> _loadSubjectsFromCache() async {
    final cachedData = _cacheUtil.getData(_cacheKey);
    if (cachedData != null && cachedData is List) {
      try {
        final subjects = cachedData
            .map((json) =>
                SubjectResponse.fromJson(Map<String, dynamic>.from(json)))
            .toList();

        if (subjects.isNotEmpty) {
          _allSubjects.assignAll(subjects);
          _filterSubjects(); // Terapkan filter awal
          isLoading.value = false;
        }
      } catch (e) {
        // print('Error parsing cached subjects: $e');
        await _cacheUtil.removeData(_cacheKey);
      }
    }
  }

  Future<void> fetchAllSubjects() async {
    try {
      if (_allSubjects.isEmpty) {
        isLoading.value = true;
      }

      final subjects = await _subjectRepository.getAllSubjectsComplete(
        gradeLevel: selectedKelas.value,
      );

      _allSubjects.assignAll(subjects); // Simpan ke list master

      final dataToCache = subjects.map((subject) => subject.toJson()).toList();
      await _cacheUtil.setData(_cacheKey, dataToCache);

      _filterSubjects(); // Panggil filter setelah fetch data
    } catch (e) {
      if (_allSubjects.isEmpty) {
        Get.snackbar('Error', 'Gagal memuat data mata pelajaran: $e');
      }
      // print('Failed to fetch subjects from network: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Mengganti status UI tab kelas, dan memfilter list berdasarkan kelas tersebut.
  void selectKelas(int kelas) {
    selectedKelas.value = kelas;
    _allSubjects.clear();
    displayedSubjects.clear();
    _loadSubjectsFromCache();
    fetchAllSubjects();
  }

  Future<void> logout() async {
    final isSuccess = await _userRepository.logout();

    if (isSuccess) {
      await _cacheUtil.removeData(_cacheKey);
      await secureStorageUtil.deleteAccessToken();
      await secureStorageUtil.deleteUserRole();
      Get.offAllNamed(AppRoutes.login);
    } else {
      Get.snackbar('Logout Gagal', 'Terjadi kesalahan saat logout. Coba lagi.');
    }
  }
}
