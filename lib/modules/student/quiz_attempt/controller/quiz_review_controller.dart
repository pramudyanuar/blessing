import 'package:blessing/data/report/repository/report_repository_impl.dart';
import 'package:blessing/data/quiz/repository/question_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizReviewController extends GetxController {
  final ReportRepository _reportRepository = ReportRepository();
  final QuestionRepository _questionRepository = QuestionRepository();

  late final String quizId;
  late final String sessionId;
  final RxString quizName = ''.obs;
  final RxInt score = 0.obs;
  final RxBool isLoading = true.obs;
  final RxBool fetchFromServer = false.obs;

  // List of review items: {question, userAnswer, correctAnswer, isCorrect}
  final RxList<Map<String, dynamic>> reviewItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _handleArguments();
    if (fetchFromServer.value) {
      _loadFromServer();
    } else {
      isLoading.value = false;
    }
  }

  void _handleArguments() {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    quizId = args['quizId'] ?? '';
    sessionId = args['sessionId'] ?? '';
    quizName.value = args['quizName'] ?? 'Kuis';
    score.value = args['score'] ?? 0;
    fetchFromServer.value = args['fetchFromServer'] as bool? ?? false;

    // Handle reviewItems dari arguments
    final items = args['reviewItems'] as List<dynamic>? ?? [];
    if (items.isNotEmpty) {
      reviewItems.assignAll(items.cast<Map<String, dynamic>>());
    }
  }

  /// Load data dari server jika dipanggil dari quiz list
  Future<void> _loadFromServer() async {
    try {
      isLoading.value = true;

      // Get complete report card untuk user ini
      final reportCard = await _reportRepository.getMyCompleteReportCard();

      if (reportCard != null) {
        // Cari quiz yang match dengan quizId
        final quizReport = reportCard.data.quizzes
            .firstWhereOrNull((q) => q.quizId == quizId);

        if (quizReport != null && quizReport.isAttempted) {
          score.value = quizReport.score ?? 0;
          quizName.value = quizReport.quizName;

          // Load questions untuk quiz ini
          final result =
              await _questionRepository.getAllQuestions(quizId: quizId);

          if (result != null && result.questions.isNotEmpty) {
            // Build review items dari questions
            final items = <Map<String, dynamic>>[];
            for (final question in result.questions) {
              items.add({
                'question': question,
                'userAnswer': null, // Tidak ada dari server saat ini
                'correctAnswer': null, // Tidak ada dari server saat ini
                'isCorrect': false, // Placeholder
              });
            }
            reviewItems.assignAll(items);
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading from server: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void setReviewItems(List<Map<String, dynamic>> items) {
    reviewItems.assignAll(items);
  }
}
