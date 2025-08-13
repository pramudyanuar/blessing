// lib/modules/student/course/controllers/course_list_controller.dart

import 'package:blessing/modules/student/course/widgets/course_card.dart';
import 'package:get/get.dart';

class CourseListController extends GetxController {
  final RxString title = 'Mata Pelajaran'.obs;
  final RxString classLevel = ''.obs;
  final RxString imagePath = ''.obs;

  // Menggunakan RxList<dynamic> untuk menampung data Map dari materi dan kuis.
  // Nantinya, list ini akan diisi dari hasil panggilan API.
  final RxList<dynamic> courses = <dynamic>[
    // Contoh data Kuis Belum Dikerjakan
    {
      'id': 'quiz-001', // Contoh ID untuk navigasi
      'type': CourseContentType.quiz,
      'title': 'Quiz 7: Vektor',
      'dateText': '3 hari yang lalu',
      'description': 'Kuis pemahaman tentang konsep dasar vektor.',
      'timeLimit': 10,
      'questionCount': 20,
      'isCompleted': false, // Kuis ini belum dikerjakan
    },
    // Contoh data Kuis Sudah Dikerjakan
    {
      'id': 'quiz-002',
      'type': CourseContentType.quiz,
      'title': 'Quiz 6: Turunan Fungsi',
      'dateText': '5 hari yang lalu',
      'description': 'Kuis tentang aturan rantai dan turunan parsial.',
      'timeLimit': 15,
      'questionCount': 15,
      'isCompleted': true, // Kuis ini sudah selesai
      'score': 98,
    },
    // Contoh data Materi
    {
      'id': 'material-001',
      'type': CourseContentType.material,
      'title': 'Bab 5 : Geometri Ruang',
      'description':
          'Materi lengkap tentang bangun ruang sisi datar dan lengkung.',
      'fileName': 'geometri_ruang.pdf',
      'dateText': '1 minggu yang lalu',
      'previewImages': null, // Bisa diisi dengan List<Widget> jika ada gambar
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      title.value = arguments['title'] ?? 'Mata Pelajaran';
      classLevel.value = arguments['classLevel'] ?? '';
      imagePath.value = arguments['imagePath'] ?? 'assets/images/bg-admin-subject.png';
      // Logika path gambar Anda yang kompleks bisa tetap di sini
    }

    // Panggil fungsi untuk mengambil data dari API di sini.
    // fetchStudentCourseData(subjectId: arguments['subjectId']);
  }
}