import 'package:get/get.dart';

enum QuizStatus { available, completed, missed }

class QuizListController extends GetxController {
  // --- State untuk AppBar ---
  final RxString title = 'Mata Pelajaran'.obs;
  final RxString subtitle = ''.obs;
  final RxString classLevel = ''.obs;
  final RxString imagePath = ''.obs;

  // --- Daftar Kuis (menggunakan Map) ---
  final RxList<Map<String, dynamic>> quizzes = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      title.value = arguments['title'] ?? 'Mata Pelajaran';
      subtitle.value = arguments['subtitle'] ?? '';
      classLevel.value = arguments['classLevel'] ?? '';
      imagePath.value = _getDetailImagePath(arguments['imagePath']);
    }
    loadQuizzes();
  }

  String _getDetailImagePath(String? path) {
    if (path == null) return 'assets/images/detail-matematika-minat.webp';
    final lastSlash = path.lastIndexOf('/') + 1;
    final file = path.substring(lastSlash);
    final dir = path.substring(0, lastSlash);
    return dir + 'detail-' + file;
  }

  void loadQuizzes() {
    // Data dummy dalam bentuk List<Map<String, dynamic>>
    quizzes.value = [
      {
        'title': 'Kuis 8',
        'dueDate': '9 Maret 2025 (23:59)',
        'status': QuizStatus.available
      },
      {
        'title': 'Kuis 7',
        'dueDate': '5 Maret 2025 (23:59)',
        'status': QuizStatus.available
      },
      {
        'title': 'Kuis 6',
        'dueDate': '28 Februari 2025 (23:59)',
        'status': QuizStatus.available
      },
      {'title': 'Kuis 5', 'status': QuizStatus.missed},
      {'title': 'Kuis 4', 'status': QuizStatus.completed, 'score': 98},
      {'title': 'Kuis 3', 'status': QuizStatus.completed, 'score': 70},
      {'title': 'Kuis 2', 'status': QuizStatus.completed, 'score': 98},
      {'title': 'Kuis 1', 'status': QuizStatus.completed, 'score': 90},
    ];
  }
}
