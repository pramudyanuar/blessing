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
    print('AdminQuizResultController - Arguments received: $args');
    
    if (args is Map && args.containsKey('quizId')) {
      final int quizId = args['quizId'];
      print('AdminQuizResultController - Quiz ID found: $quizId');
      fetchQuizReportCard(quizId);
    } else {
      print('AdminQuizResultController - No quiz ID found in arguments!');
      // Show error state or fetch sample data
      Get.snackbar(
        'Error', 
        'Quiz ID tidak ditemukan. Pastikan navigasi dari detail quiz.',
        snackPosition: SnackPosition.TOP,
      );
    }

    // Listen to search text changes
    debounce(searchText, (_) => _filterUsers(), time: const Duration(milliseconds: 500));
  }

  Future<void> fetchQuizReportCard(int quizId) async {
    try {
      isLoading.value = true;
      print('AdminQuizResultController - Fetching quiz report for ID: $quizId');
      
      final response = await _reportRepository.getQuizReportCard(
        quizId: quizId.toString(),
        sortByScore: 'desc', // Sort by highest score first
      );
      
      print('AdminQuizResultController - API Response: $response');
      
      if (response != null) {
        quizReportData.value = response;
        print('AdminQuizResultController - Users count: ${response.data.users.length}');
        _filterUsers(); // Initialize filtered list
      } else {
        print('AdminQuizResultController - Response is null');
        Get.snackbar(
          'Error',
          'Data quiz report tidak ditemukan',
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      print('AdminQuizResultController - Error: $e');
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
      final int quizId = args['quizId'];
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
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
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
