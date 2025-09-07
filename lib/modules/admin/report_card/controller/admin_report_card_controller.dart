import 'package:blessing/data/report/model/response/quiz_report.dart';
import 'package:blessing/data/report/model/response/report_summary.dart';
import 'package:blessing/data/report/repository/report_repository_impl.dart';
import 'package:get/get.dart';

class AdminReportCardController extends GetxController {
  final ReportRepository _reportRepository = ReportRepository();

  final RxList<QuizReport> userQuizzes = <QuizReport>[].obs;
  final Rx<ReportSummary?> userSummary = Rx<ReportSummary?>(null);
  final RxString selectedUserId = ''.obs;
  final RxString userName = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Filter properties
  final RxString selectedSubject = 'All'.obs;
  final RxString selectedDateRange = 'All Time'.obs;
  final RxList<String> availableSubjects = <String>['All'].obs;
  final RxList<QuizReport> filteredQuizzes = <QuizReport>[].obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      selectedUserId.value = args['userId'] ?? '';
      userName.value = args['userName'] ?? 'Siswa';
    }

    if (selectedUserId.value.isNotEmpty) {
      loadUserReportCard();
    }
  }

  Future<void> loadUserReportCard() async {
    if (selectedUserId.value.isEmpty) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _reportRepository.getUserReportCard(
          userId: selectedUserId.value);

      if (result != null) {
        userQuizzes.value = result.data.quizzes;
        userSummary.value = result.data.summary;

        // Update available subjects
        final subjects =
            userQuizzes.map((quiz) => quiz.subjectName).toSet().toList();
        availableSubjects.value = ['All', ...subjects];

        // Apply initial filter
        applyFilters();
      } else {
        errorMessage.value = 'Gagal memuat data report card';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters() {
    List<QuizReport> filtered = List.from(userQuizzes);

    // Filter by subject
    if (selectedSubject.value != 'All') {
      filtered = filtered
          .where((quiz) => quiz.subjectName == selectedSubject.value)
          .toList();
    }

    // Filter by date range
    if (selectedDateRange.value != 'All Time') {
      final now = DateTime.now();
      DateTime? cutoffDate;

      switch (selectedDateRange.value) {
        case 'Last 7 Days':
          cutoffDate = now.subtract(const Duration(days: 7));
          break;
        case 'Last 30 Days':
          cutoffDate = now.subtract(const Duration(days: 30));
          break;
        case 'Last 3 Months':
          cutoffDate = DateTime(now.year, now.month - 3, now.day);
          break;
      }

      if (cutoffDate != null) {
        filtered = filtered
            .where((quiz) =>
                quiz.completedAt != null &&
                quiz.completedAt!.isAfter(cutoffDate!))
            .toList();
      }
    }

    // Sort by completion date (newest first)
    filtered.sort((a, b) {
      if (a.completedAt == null && b.completedAt == null) return 0;
      if (a.completedAt == null) return 1;
      if (b.completedAt == null) return -1;
      return b.completedAt!.compareTo(a.completedAt!);
    });

    filteredQuizzes.value = filtered;
  }

  void onSubjectChanged(String? subject) {
    if (subject != null) {
      selectedSubject.value = subject;
      applyFilters();
    }
  }

  void onDateRangeChanged(String? dateRange) {
    if (dateRange != null) {
      selectedDateRange.value = dateRange;
      applyFilters();
    }
  }

  Future<void> refreshData() async {
    await loadUserReportCard();
  }

  // Helper methods for analytics
  double get averageScore {
    if (filteredQuizzes.isEmpty) return 0.0;
    final scores = filteredQuizzes
        .map((quiz) => quiz.score ?? 0)
        .where((score) => score > 0)
        .toList();
    if (scores.isEmpty) return 0.0;
    return scores.reduce((a, b) => a + b) / scores.length;
  }

  int get totalQuizzes => filteredQuizzes.length;

  int get completedQuizzes =>
      filteredQuizzes.where((quiz) => quiz.completedAt != null).length;

  Map<String, int> get subjectBreakdown {
    final breakdown = <String, int>{};
    for (final quiz in filteredQuizzes) {
      breakdown[quiz.subjectName] = (breakdown[quiz.subjectName] ?? 0) + 1;
    }
    return breakdown;
  }
}
