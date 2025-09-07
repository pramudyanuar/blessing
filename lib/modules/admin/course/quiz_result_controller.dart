import 'package:blessing/data/report/model/response/quiz_report_card_response.dart';
import 'package:blessing/data/report/model/response/quiz_report_user.dart';
import 'package:blessing/data/report/model/response/quiz_report_statistics.dart';
import 'package:blessing/data/report/model/response/quiz_report_data.dart';
import 'package:blessing/data/report/repository/report_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminQuizResultController extends GetxController {
  final ReportRepository _reportRepository;

  AdminQuizResultController(this._reportRepository);

  // Observables
  final isLoading = false.obs;
  final quizReportData = Rxn<QuizReportCardResponse>();
  final searchText = ''.obs;
  final filteredUsers = <QuizReportUser>[].obs;

  // Getters
  List<QuizReportUser> get allUsers => quizReportData.value?.data.users ?? [];
  QuizReportStatistics? get statistics => quizReportData.value?.data.statistics;
  QuizReportData? get quizData => quizReportData.value?.data;

  @override
  void onInit() {
    super.onInit();

    // Get quiz ID from arguments
    final dynamic args = Get.arguments;

    if (args is Map && args.containsKey('quizId')) {
      final String quizId = args['quizId']; // String UUID, bukan int
      fetchQuizReportCard(quizId);
    }

    // Listen to search text changes
    debounce(searchText, (_) => _filterUsers(),
        time: const Duration(milliseconds: 500));
  }

  Future<void> fetchQuizReportCard(String quizId) async {
    try {
      isLoading.value = true;

      final response = await _reportRepository.getQuizReportCard(
        quizId: quizId, // Sudah String, tidak perlu toString()
        sortByScore: 'desc', // Sort by highest score first
      );

      if (response != null) {
        quizReportData.value = response;
        _filterUsers(); // Initialize filtered list
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat data hasil kuis: $e',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearchText(String text) {
    searchText.value = text;
  }

  void _filterUsers() {
    if (searchText.value.isEmpty) {
      filteredUsers.value = allUsers;
    } else {
      filteredUsers.value = allUsers.where((user) {
        final name = user.username.toLowerCase();
        final search = searchText.value.toLowerCase();
        return name.contains(search);
      }).toList();
    }
  }

  void refreshData() {
    final dynamic args = Get.arguments;
    if (args is Map && args.containsKey('quizId')) {
      final String quizId = args['quizId']; // String UUID
      fetchQuizReportCard(quizId);
    }
  }

  // Helper methods for UI
  String getAchievementText(int rank) {
    switch (rank) {
      case 1:
        return "1st Peringkat Tertinggi";
      case 2:
        return "2nd Peringkat Kedua";
      case 3:
        return "3rd Peringkat Ketiga";
      default:
        return "";
    }
  }

  Color getCardColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFA726); // Gold
      case 2:
        return const Color(0xFF9E9E9E); // Silver
      case 3:
        return const Color(0xFFFF8A65); // Bronze
      default:
        return const Color(0xFFE0E0E0); // Default
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return "";

    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];

    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }

  // Get ranking from user list
  int getUserRanking(QuizReportUser user) {
    final sortedUsers = List<QuizReportUser>.from(allUsers);
    sortedUsers.sort((a, b) => (b.score ?? 0).compareTo(a.score ?? 0));
    return sortedUsers.indexWhere((u) => u.userId == user.userId) + 1;
  }
}
