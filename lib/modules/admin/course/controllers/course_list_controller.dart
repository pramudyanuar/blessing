import 'package:get/get.dart';

class AdminManageCourseController extends GetxController {
  // Observable state untuk data AppBar
  final RxString title = 'Mata Pelajaran'.obs;
  final RxString subtitle = ''.obs;
  final RxString classLevel = 'Kelas 10'.obs;
  final RxString imagePath = ''.obs;

  // Observable list untuk menyimpan daftar kursus
  final RxList<CourseItem> courses = <CourseItem>[
    CourseItem(
      title: 'Bab 2 : Integral',
      description: 'Materi lengkap tentang integral.',
      fileName: 'integral.pdf',
      dateText: '12 Juni 2025',
    ),
    CourseItem(
      title: 'Bab 1 : Turunan',
      description: 'Materi lengkap tentang turunan.',
      fileName: 'turunan.pdf',
      dateText: '5 Juni 2025',
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    // Ambil argumen yang dikirim dari ClassCard
    final arguments = Get.arguments as Map<String, dynamic>?;

    // Perbarui state dengan data dari argumen
    if (arguments != null) {
      title.value = arguments['title'] ?? 'Mata Pelajaran';
      subtitle.value = arguments['subtitle'] ?? '';
      classLevel.value = arguments['classLevel'] ?? '';

      // Periksa imagePath apakah valid
      final rawImagePath = arguments['imagePath'];
      if (rawImagePath != null && rawImagePath.toString().isNotEmpty) {
        final path = rawImagePath as String;
        final lastSlash = path.lastIndexOf('/') + 1;
        final dir = path.substring(0, lastSlash);
        final file = path.substring(lastSlash);
        imagePath.value = dir + 'detail-' + file;
      } else {
        imagePath.value = 'assets/images/bg-admin-subject.png';
      }
    } else {
      imagePath.value = 'assets/images/bg-admin-subject.png';
    }
  }
}

// Class untuk item kursus
class CourseItem {
  final String title;
  final String description;
  final String fileName;
  final String dateText;

  CourseItem({
    required this.title,
    required this.description,
    required this.fileName,
    required this.dateText,
  });
}
