import 'package:blessing/data/user/repository/user_repository_impl.dart';
import 'package:get/get.dart';
import 'package:blessing/core/utils/cache_util.dart';

class AdminManageStudentController extends GetxController {
  var selectedKelas = '7'.obs;
  final List<String> kelasList = ['7', '8', '9', '10', '11', '12'];

  final RxList<Map<String, String>> allStudents = <Map<String, String>>[].obs;
  final RxList<Map<String, String>> filteredStudents =
      <Map<String, String>>[].obs;

  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs; // Tambahkan loading state

  final _cacheKey = 'all_students';

  @override
  void onInit() {
    super.onInit();
    _loadFromCache();
    fetchStudents();

    // re-filter tiap kali searchQuery berubah
    ever(searchQuery, (_) => filterStudents());
    // juga re-filter tiap kelas berubah
    ever(selectedKelas, (_) => filterStudents());
  }

  Future<void> _loadFromCache() async {
    final cachedData = CacheUtil().getData(_cacheKey);
    if (cachedData != null) {
      final mappedCache = (cachedData as List).cast<Map>();
      allStudents.assignAll(
        mappedCache
            .map((e) =>
                e.map((k, v) => MapEntry(k.toString(), v?.toString() ?? '')))
            .toList(),
      );
      filterStudents();
    } else {
      // Jika tidak ada cache, set loading true sampai fetch selesai
      isLoading.value = true;
    }
  }

  Future<void> fetchStudents() async {
    try {
      isLoading.value = true; // Set loading state

      final repository = UserRepository();

      final students = await repository.getAllUsersComplete();

      final mappedStudents = students
          .map((user) => <String, String>{
                'id': user.id.toString(),
                'nama': user.username ?? '',
                'kelas': user.gradeLevel?.toString() ?? '',
                'avatar': '',
              })
          .toList();

      allStudents.assignAll(mappedStudents);
      CacheUtil().setData(_cacheKey, mappedStudents);

      filterStudents();
    } catch (e) {
      print('Error fetching students: $e');
      // Tetap reset loading state meski ada error
      allStudents.clear();
      filteredStudents.clear();
    } finally {
      isLoading.value = false; // Reset loading state
    }
  }

  void selectKelas(String kelas) {
    selectedKelas.value = kelas;
    // filterStudents();  // sudah otomatis karena ever(selectedKelas)
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    // filterStudents(); // sudah otomatis karena ever(searchQuery)
  }

  void filterStudents() {
    final kelas = selectedKelas.value;
    final query = searchQuery.value.toLowerCase();

    final results = allStudents.where((student) {
      final kelasMatch = student['kelas'] == kelas;
      final nameMatch = student['nama']?.toLowerCase().contains(query) ?? false;
      return kelasMatch && (query.isEmpty || nameMatch);
    }).toList();

    filteredStudents.assignAll(results);
  }
}
