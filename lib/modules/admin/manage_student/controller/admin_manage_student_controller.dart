import 'package:get/get.dart';

class AdminManageStudentController extends GetxController {
  var selectedKelas = '7'.obs;

  final List<String> kelasList = ['7', '8', '9', '10', '11', '12'];

  final RxList<Map<String, String>> allStudents = <Map<String, String>>[
    {'nama': 'Aulia Rahma', 'kelas': '7', 'avatar': ''},
    {'nama': 'Rizky Pratama', 'kelas': '8', 'avatar': ''},
    {'nama': 'Nadia Fatimah', 'kelas': '9', 'avatar': ''},
    {'nama': 'Dewi Lestari', 'kelas': '7', 'avatar': ''},
    {'nama': 'Budi Santoso', 'kelas': '10', 'avatar': ''},
    {'nama': 'Citra Kirana', 'kelas': '11', 'avatar': ''},
    {'nama': 'Agung Wijaya', 'kelas': '12', 'avatar': ''},
    {'nama': 'Putri Amelia', 'kelas': '8', 'avatar': ''},
  ].obs;

  final RxList<Map<String, String>> filteredStudents =
      <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    filterStudentsByClass(selectedKelas.value);
  }

  void selectKelas(String kelas) {
    selectedKelas.value = kelas;
    filterStudentsByClass(kelas);
  }

  void filterStudentsByClass(String kelas) {
    var results =
        allStudents.where((student) => student['kelas'] == kelas).toList();
    filteredStudents.assignAll(results);
  }
}
