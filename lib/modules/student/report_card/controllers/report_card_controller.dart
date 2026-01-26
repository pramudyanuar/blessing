import 'package:blessing/data/report/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportCardController extends GetxController {
  final ReportRepository _reportRepository = ReportRepository();

  // Observable variables
  final RxList<QuizReport> allQuizzes = <QuizReport>[].obs;
  final RxList<QuizReport> filteredQuizzes = <QuizReport>[].obs;
  final Rx<ReportSummary?> summary = Rx<ReportSummary?>(null);
  final RxString userName = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Filter options
  final RxString selectedFilter = 'all'.obs; // all, attempted, not_attempted
  final RxString selectedSubject = 'all'.obs;
  final RxList<String> availableSubjects = <String>[].obs;

  // Pagination
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxBool hasMoreData = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadReportCard();
  }

  /// Load report card data
  Future<void> loadReportCard() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Get complete report card data
      final result = await _reportRepository.getMyCompleteReportCard();

      if (result != null) {
        userName.value = result.data.userName;
        allQuizzes.value = result.data.quizzes;
        summary.value = result.data.summary;

        // Extract unique subjects
        final subjects = result.data.quizzes
            .map((quiz) => quiz.subjectName)
            .toSet()
            .toList();
        subjects.sort();
        availableSubjects.value = subjects;

        // Apply current filter
        applyFilter();
      } else {
        errorMessage.value = 'Gagal memuat data report card';
      }
    } catch (e) {
      debugPrint('Error loading report card: $e');
      errorMessage.value = 'Terjadi kesalahan saat memuat data';
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh data
  Future<void> refreshData() async {
    await loadReportCard();
  }

  /// Apply filter to quizzes
  void applyFilter() {
    List<QuizReport> filtered = List.from(allQuizzes);

    // Filter by status
    switch (selectedFilter.value) {
      case 'attempted':
        filtered = filtered.where((quiz) => quiz.isAttempted).toList();
        break;
      case 'not_attempted':
        filtered = filtered.where((quiz) => !quiz.isAttempted).toList();
        break;
      case 'completed':
        filtered =
            filtered.where((quiz) => quiz.status == 'completed').toList();
        break;
      default: // 'all'
        break;
    }

    // Filter by subject
    if (selectedSubject.value != 'all') {
      filtered = filtered
          .where((quiz) => quiz.subjectName == selectedSubject.value)
          .toList();
    }

    // Sort by attempted status and date
    filtered.sort((a, b) {
      // Attempted quizzes first
      if (a.isAttempted && !b.isAttempted) return -1;
      if (!a.isAttempted && b.isAttempted) return 1;

      // Then by completion/attempt date
      if (a.completedAt != null && b.completedAt != null) {
        return b.completedAt!.compareTo(a.completedAt!);
      } else if (a.attemptedAt != null && b.attemptedAt != null) {
        return b.attemptedAt!.compareTo(a.attemptedAt!);
      }

      // Finally by quiz name
      return a.quizName.compareTo(b.quizName);
    });

    filteredQuizzes.value = filtered;
  }

  /// Change filter
  void changeFilter(String filter) {
    selectedFilter.value = filter;
    applyFilter();
  }

  /// Change subject filter
  void changeSubjectFilter(String subject) {
    selectedSubject.value = subject;
    applyFilter();
  }

  /// Get statistics for display
  Map<String, dynamic> getStatistics() {
    if (summary.value == null) return {};

    final summaryData = summary.value!;
    return {
      'totalQuizzes': summaryData.totalQuizzes,
      'attemptedQuizzes': summaryData.attemptedQuizzes,
      'completedQuizzes': summaryData.completedQuizzes,
      'averageScore': summaryData.averageScore,
      'completionRate': summaryData.completionRate,
    };
  }

  /// Get quiz by subject
  Map<String, List<QuizReport>> getQuizzesBySubject() {
    final Map<String, List<QuizReport>> grouped = {};

    for (final quiz in filteredQuizzes) {
      if (!grouped.containsKey(quiz.subjectName)) {
        grouped[quiz.subjectName] = [];
      }
      grouped[quiz.subjectName]!.add(quiz);
    }

    return grouped;
  }

  /// Get color for score
  Color getScoreColor(int? score) {
    if (score == null) return Colors.grey;
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  /// Get status color
  Color getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.orange;
      case 'not_attempted':
      default:
        return Colors.grey;
    }
  }

  /// Get status text
  String getStatusText(QuizReport quiz) {
    if (!quiz.isAttempted) return 'Belum Dikerjakan';
    if (quiz.status == 'completed') return 'Selesai';
    if (quiz.status == 'in_progress') return 'Sedang Dikerjakan';
    return 'Tidak Diketahui';
  }

  /// Format date for display
  String formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Format time for display
  String formatTime(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours > 0) {
      return '${hours}h ${mins}m';
    }
    return '${mins}m';
  }
}
