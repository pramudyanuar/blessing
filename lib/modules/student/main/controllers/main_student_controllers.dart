import 'package:blessing/data/subject/models/response/subject_response.dart';
import 'package:blessing/data/subject/repository/subject_repository_impl.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/modules/student/main/widgets/birth_date_setup_dialog.dart';
import 'package:get/get.dart';
import 'package:blessing/core/utils/cache_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MainStudentController extends GetxController {
  // Instance dari Repository untuk mengambil data
  final _subjectRepository = Get.find<SubjectRepository>();

  // Variabel untuk menyimpan data user
  var name = ''.obs;
  var classInfo = ''.obs;
  var profileImageUrl = ''.obs;

  // State untuk daftar mata pelajaran dan status loading
  var subjectList = <SubjectResponse>[].obs; // Master list of all subjects
  var filteredSubjectList = <SubjectResponse>[].obs; // List to be displayed
  var isLoadingSubjects = true.obs;

  // State untuk search
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    
    // Check if birth date is set, if not redirect to profile
    _checkBirthDateAndRedirect();
    _checkBirthdayAndShow();
    
    _loadInitialData();

    // Listener for search query changes.
    // 'debounce' waits for the user to stop typing for 300ms before filtering.
    // This improves performance by avoiding filtering on every keystroke.
    debounce(searchQuery, (_) => _filterSubjects(),
        time: const Duration(milliseconds: 300));
  }

  /// Check if birth date is set, show dialog if not
  Future<void> _checkBirthDateAndRedirect() async {
    final userData = await CacheUtil().getData('user_data');
    debugPrint('[MainStudentController] Birth date check - userData: $userData');
    
    if (userData != null) {
      final birthDate = userData['birth_date'];
      debugPrint('[MainStudentController] Birth date: $birthDate, type: ${birthDate.runtimeType}');
      
      bool isBirthDateEmpty = false;
      
      if (birthDate == null) {
        isBirthDateEmpty = true;
      } else if (birthDate is String) {
        final cleanDate = birthDate.trim();
        isBirthDateEmpty = cleanDate.isEmpty || 
                          cleanDate.startsWith('0001-') ||
                          cleanDate == '0001-01-01T00:00:00Z';
      } else if (birthDate is DateTime) {
        isBirthDateEmpty = birthDate.year <= 1;
      }
      
      debugPrint('[MainStudentController] isBirthDateEmpty: $isBirthDateEmpty');
      
      if (isBirthDateEmpty) {
        debugPrint('[MainStudentController] Showing birth date setup dialog');
        Get.dialog(
          const BirthDateSetupDialog(),
          barrierDismissible: false,
        );
      }
    }
  }

  /// Show birthday popup once per day if today matches user's birth date.
  Future<void> _checkBirthdayAndShow() async {
    final userData = await CacheUtil().getData('user_data');
    if (userData == null) return;

    final birthDate = _parseBirthDate(userData['birth_date']);
    if (birthDate == null || birthDate.year <= 1) return;

    final now = DateTime.now();
    if (birthDate.month != now.month || birthDate.day != now.day) return;

    final userId = userData['id']?.toString() ?? userData['username'] ?? 'user';
    final cacheKey =
        'birthday_popup_${userId}_${now.year}-${now.month}-${now.day}';

    if (CacheUtil().hasData(cacheKey)) return;
    await CacheUtil().setData(cacheKey, true);

    final userName = userData['username']?.toString().trim().isNotEmpty == true
        ? userData['username'].toString().trim()
        : 'Siswa';

    Get.dialog(
      AlertDialog(
        title: GlobalText.semiBold('Selamat ulang tahun, $userName!', fontSize: 16),
        content: GlobalText.regular(
          'Semoga hari ini penuh kebahagiaan, kesehatan, dan semangat baru.\n\n'
          'Terus berjuang dan jangan ragu untuk bermimpi besar. Kami bangga melihat usaha kamu setiap hari.\n\n'
          'Semoga semua doa dan harapan baik terkabul. Selamat merayakan!'
          ,
          textAlign: TextAlign.start,
          fontSize: 13,
          color: Colors.grey.shade700,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: GlobalText.medium('Terima kasih', fontSize: 13),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  DateTime? _parseBirthDate(dynamic birthDate) {
    if (birthDate == null) return null;
    if (birthDate is DateTime) return birthDate.toLocal();
    if (birthDate is String) {
      final cleanDate = birthDate.trim();
      if (cleanDate.isEmpty || cleanDate.startsWith('0001-')) return null;
      try {
        return DateTime.parse(cleanDate).toLocal();
      } catch (e) {
        debugPrint('[MainStudentController] Invalid birth date: $e');
      }
    }
    return null;
  }

  /// Memuat semua data awal yang diperlukan untuk halaman ini.
  Future<void> _loadInitialData() async {
    await _loadUserData();
    await fetchSubjects(); // Panggil method untuk mengambil data mapel
  }

  /// Memuat data pengguna dari cache.
  Future<void> _loadUserData() async {
    final userData = await CacheUtil().getData('user_data');
    if (userData != null) {
      name.value = userData['username'] ?? 'Siswa';
      classInfo.value = userData['grade_level'] != null
          ? 'Kelas ${userData['grade_level']}'
          : 'Kelas Tidak Diketahui';
    }
  }

  /// Reload user data from cache (for updating after profile edit)
  Future<void> reloadUserData() async {
    await _loadUserData();
  }

  /// Mengambil data semua mata pelajaran dari API.
  Future<void> fetchSubjects() async {
    try {
      isLoadingSubjects.value = true;
      // Menggunakan getAllSubjectsComplete() untuk mengambil semua data tanpa paginasi
      final result = await _subjectRepository.getAllSubjectsComplete();
      if (result.isNotEmpty) {
        subjectList.assignAll(result);
        filteredSubjectList
            .assignAll(result); // Initially, filtered list is the full list
      }
    } catch (e) {
      debugPrint("Error fetching subjects: $e");
      // Opsional: Tampilkan pesan error ke pengguna
      Get.snackbar("Error", "Gagal memuat data mata pelajaran.");
    } finally {
      isLoadingSubjects.value = false;
    }
  }

  /// Updates the search query. Called from the UI.
  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  /// Filters the subject list based on the current search query.
  void _filterSubjects() {
    final query = searchQuery.value.toLowerCase();
    if (query.isEmpty) {
      // If search is empty, show all subjects
      filteredSubjectList.assignAll(subjectList);
    } else {
      // Otherwise, filter by subject name
      filteredSubjectList.assignAll(subjectList.where((subject) =>
          subject.subjectName?.toLowerCase().contains(query) ?? false));
    }
  }
}
