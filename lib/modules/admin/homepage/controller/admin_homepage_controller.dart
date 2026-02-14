import 'package:blessing/core/utils/app_routes.dart';
import 'package:blessing/core/utils/cache_util.dart';
import 'package:blessing/data/subject/models/response/subject_response.dart';
import 'package:blessing/data/subject/repository/subject_repository_impl.dart';
import 'package:blessing/data/user/repository/user_repository_impl.dart';
import 'package:blessing/main.dart';
import 'package:get/get.dart';

class AdminHomepageController extends GetxController {
  // --- DEPENDENCIES ---
  final _userRepository = Get.find<UserRepository>();
  final _subjectRepository = Get.find<SubjectRepository>();

  // --- CACHE ---
  final _cacheUtil = CacheUtil();
  final _cacheKey = 'all_admin_subjects';

  // --- STATE ---
  var isLoading = true.obs;
  var selectedKelas = 7.obs;
  final List<int> kelasList = [7, 8, 9, 10, 11, 12];

  final _allSubjects = <SubjectResponse>[].obs; // Menyimpan semua data asli
  var displayedSubjects =
      <SubjectResponse>[].obs; // Data yang akan ditampilkan (setelah filter)
  var searchQuery = ''.obs; // Menyimpan query pencarian

  @override
  void onInit() {
    super.onInit();
    _loadSubjectsFromCache();
    fetchAllSubjects();
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

      final subjects = await _subjectRepository.getAllSubjectsComplete();

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

  /// Mengganti status UI tab kelas, tidak lagi memfilter list.
  void selectKelas(int kelas) {
    selectedKelas.value = kelas;
    // Panggilan _filterSubjects() di sini tidak lagi diperlukan karena tidak ada filter kelas,
    // tapi tidak masalah jika tetap ada.
    _filterSubjects();
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
