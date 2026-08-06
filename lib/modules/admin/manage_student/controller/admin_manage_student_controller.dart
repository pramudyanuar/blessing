import 'package:blessing/data/user/repository/user_repository_impl.dart';
import 'package:get/get.dart';
import 'package:blessing/core/utils/cache_util.dart';

class AdminManageStudentController extends GetxController {
  var selectedKelas = '1'.obs;
  final List<String> kelasList = ['1','2','3','4','5','6', '7', '8', '9', '10', '11', '12'];

  final RxList<Map<String, String>> students = <Map<String, String>>[].obs;
  final RxList<Map<String, String>> filteredStudents = <Map<String, String>>[].obs;

  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;

  final _repository = UserRepository();

  @override
  void onInit() {
    super.onInit();
    fetchStudentsByKelas();

    // Re-fetch dari server saat kelas berubah
    ever(selectedKelas, (_) => fetchStudentsByKelas());
    // Re-filter lokal saat search berubah (tidak perlu re-fetch)
    ever(searchQuery, (_) => _applySearch());
  }

  /// Fetch siswa berdasarkan kelas dari server — server yang filter, bukan FE.
  Future<void> fetchStudentsByKelas() async {
    try {
      isLoading.value = true;
      filteredStudents.clear();

      final gradeLevel = int.tryParse(selectedKelas.value) ?? 1;

      // Gunakan getUsersByGradeLevel — 1 request, server yang filter
      final result = await _repository.getUsersByGradeLevel(gradeLevel);

      final mapped = result
          .map((user) => <String, String>{
                'id': user.id.toString(),
                'nama': user.username ?? '',
                'kelas': user.gradeLevel?.toString() ?? '',
                'avatar': '',
              })
          .toList();

      students.assignAll(mapped);
      _applySearch();

      // Cache per kelas
      CacheUtil().setData('students_kelas_${selectedKelas.value}', mapped);
    } catch (e) {
      students.clear();
      filteredStudents.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// Filter lokal berdasarkan search query saja (kelas sudah dihandle server).
  void _applySearch() {
    final query = searchQuery.value.toLowerCase();
    if (query.isEmpty) {
      filteredStudents.assignAll(students);
    } else {
      filteredStudents.assignAll(
        students.where((s) => s['nama']!.toLowerCase().contains(query)),
      );
    }
  }

  void selectKelas(String kelas) {
    selectedKelas.value = kelas;
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }
}
