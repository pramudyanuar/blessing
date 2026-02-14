import 'package:blessing/data/report/repository/report_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizResultDetailController extends GetxController {
  final ReportRepository _reportRepository = ReportRepository();

  late final String quizId;
  final RxString quizName = ''.obs;
  final RxInt score = 0.obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  // List of review items: {question, userAnswer, correctAnswer, isCorrect}
  final RxList<Map<String, dynamic>> reviewItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _handleArguments();
    _loadResultDetail();
  }

  void _handleArguments() {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    quizId = args['quizId'] ?? '';
    quizName.value = args['quizName'] ?? 'Kuis';
  }

  Future<void> _loadResultDetail() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Get complete report card untuk user ini
      final reportCard = await _reportRepository.getMyCompleteReportCard();
      
      if (reportCard != null) {
        // Cari quiz yang match dengan quizId
        final quizReport = reportCard.data.quizzes
            .firstWhereOrNull((q) => q.quizId == quizId);

        if (quizReport != null && quizReport.isAttempted) {
          score.value = quizReport.score ?? 0;
          quizName.value = quizReport.quizName;
          
          // Untuk sekarang, tampilkan empty review (perlu API enhancement)
        } else {
          errorMessage.value = 'Quiz belum dikerjakan atau tidak ditemukan';
        }
      } else {
        errorMessage.value = 'Gagal memuat data hasil quiz';
      }
    } catch (e) {
      debugPrint('Error loading result detail: $e');
      errorMessage.value = 'Terjadi kesalahan: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
