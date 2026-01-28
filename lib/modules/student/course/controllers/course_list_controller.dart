// lib/modules/student/course/controllers/course_list_controller.dart

import 'package:blessing/data/course/models/response/course_with_quizzes_response.dart';
import 'package:blessing/data/course/repository/course_repository_impl.dart';
import 'package:blessing/data/report/model/response/quiz_report.dart';
import 'package:blessing/data/report/repository/report_repository_impl.dart';
import 'package:blessing/modules/student/course/widgets/course_card.dart';
import 'package:get/get.dart';
import 'package:blessing/core/utils/cache_util.dart';
import 'package:timeago/timeago.dart' as timeago;

class CourseListController extends GetxController {
  // State untuk UI
  final RxString title = 'Mata Pelajaran'.obs;
  final RxString classLevel = ''.obs;
  final RxString imagePath = ''.obs;
  final isLoading = true.obs;

  // State untuk data
  final RxList<dynamic> displayItems = <dynamic>[].obs;

  // Dependensi dan Cache
  final _courseRepo = CourseRepository();
  final _reportRepo = ReportRepository();
  String? _subjectId;
  String get _cacheKey => 'course_list_detailed_$_subjectId';
  
  // Cache untuk attempted quizzes
  Map<String, QuizReport> _attemptedQuizzesMap = {};

  @override
  void onInit() {
    super.onInit();
    _handleArguments();
    loadCourseData();
  }

  void _handleArguments() {
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      title.value = arguments['title'] ?? 'Mata Pelajaran';
      classLevel.value = arguments['classLevel'] ?? '';
      imagePath.value =
          arguments['imagePath'] ?? 'assets/images/bg-admin-subject.png';
      _subjectId = arguments['subjectId'];
    }
  }

  Future<void> loadCourseData() async {
    if (_subjectId == null) {
      isLoading.value = false;
      return;
    }

    timeago.setLocaleMessages('id', timeago.IdMessages());

    isLoading.value = true;
    try {
      await _loadFromCache();
      await _fetchFromNetwork();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadFromCache() async {
    final cachedData = CacheUtil().getData(_cacheKey);
    if (cachedData != null && cachedData is List) {
      displayItems.assignAll(cachedData.cast<dynamic>());
    }
  }

  Future<void> _fetchFromNetwork() async {
    try {
      // 1. Load report card untuk get info quiz yang sudah dikerjakan
      final reportCard = await _reportRepo.getMyCompleteReportCard();
      if (reportCard != null) {
        _attemptedQuizzesMap = {
          for (var quiz in reportCard.data.quizzes)
            quiz.quizId: quiz
        };
      }
      
      // 2. Load course dan quizzes
      final allCoursesFromApi =
          await _courseRepo.getAllAccessibleCoursesWithQuizzes();

      if (allCoursesFromApi != null) {
        final filteredCourses = allCoursesFromApi
            .where((course) => course.subject.id == _subjectId)
            .toList();

        // GUNAKAN FUNGSI TRANSFORMASI YANG SEKARANG BISA MEMPROSES KUIS
        final processedItems = _transformDataForUI(filteredCourses);

        displayItems.assignAll(processedItems);
        CacheUtil().setData(_cacheKey, processedItems);
      }
    } catch (e) {
      print('Error fetching from network: $e');
    }
  }

  /// SEKARANG FUNGSI INI BISA MEMPROSES KUIS KEMBALI!
  List<dynamic> _transformDataForUI(List<CourseWithQuizzesResponse> courses) {
    final List<dynamic> items = [];

    for (final course in courses) {
      // Tambahkan item untuk materi (course itu sendiri)
      items.add({
        'id': course.id,
        'type': CourseContentType.material,
        'title': course.courseName,
        'description': 'Materi pembelajaran untuk ${course.courseName}.',
        'fileName': 'Materi Digital',
        'dateText': _formatDateDisplay(course.createdAt),
        'date': course.createdAt,
        'previewImages': null,
      });

      // Tambahkan item untuk setiap kuis di dalam course
      for (final quiz in course.quizzes) {
        // Cek apakah quiz ini sudah SELESAI (submitted/completed, bukan hanya attempted)
        final attemptedQuiz = _attemptedQuizzesMap[quiz.id];
        final isQuizCompleted = attemptedQuiz != null && 
                                 (attemptedQuiz.submitted == true || 
                                  attemptedQuiz.status == 'submitted');
        
        items.add({
          'id': quiz.id,
          'type': CourseContentType.quiz,
          'title': quiz.quizName,
          'dateText': _formatDateDisplay(quiz.createdAt),
          'date': quiz.createdAt,
          'description': 'Kuis untuk menguji pemahaman materi.',
          'timeLimit': quiz.timeLimit,
          'questionCount': quiz.questionCount ?? 0,
          'isCompleted': isQuizCompleted,
          'score': attemptedQuiz?.score,
        });
      }
    }

    // Urutkan semua item (materi & kuis) berdasarkan tanggal terbaru
    items.sort(
        (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));

    return items;
  }

  /// Format date display: show relative time for recent dates, actual date for older ones
  String _formatDateDisplay(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    // Jika lebih dari 30 hari (sekitar 1 bulan), tampilkan tanggal aktual
    if (difference.inDays > 30) {
      return '${date.day} ${_getMonthName(date.month)} ${date.year}';
    }

    // Jika kurang dari 30 hari, gunakan timeago
    return timeago.format(date, locale: 'id');
  }

  /// Helper method to get Indonesian month name (short form)
  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Ags',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    return months[month - 1];
  }
}
