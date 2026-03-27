// lib/modules/student/quiz_attempt/controller/quiz_attempts_list_controller.dart

import 'package:blessing/data/core/models/paging_response.dart';
import 'package:blessing/data/session/models/response/quiz_attempt_summary.dart';
import 'package:blessing/data/session/repository/session_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizAttemptsListController extends GetxController {
  final SessionRepository _sessionRepository = SessionRepository();

  late final String quizId;
  late final String quizName;
  String? userId; // Optional: untuk admin view

  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxList<QuizAttemptSummary> attempts = <QuizAttemptSummary>[].obs;
  
  late PagingResponse paging;
  final RxInt currentPage = 1.obs;
  final int pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    _handleArguments();
    loadAttempts();
  }

  void _handleArguments() {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    quizId = args['quizId'] ?? '';
    quizName = args['quizName'] ?? 'Quiz';
    userId = args['userId']; // Optional, untuk admin

    if (quizId.isEmpty) {
      errorMessage.value = 'Quiz ID tidak valid';
      isLoading.value = false;
    }
  }

  /// Load list of quiz attempts
  /// Jika userId diberikan, untuk admin view. Jika tidak, untuk student view.
  Future<void> loadAttempts({int page = 1}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      currentPage.value = page;

      dynamic result;
      
      if (userId != null && userId!.isNotEmpty) {
        // Admin view: gunakan getAllSessions dengan userId filter
        final sessionsResult = await _sessionRepository.getAllSessions(
          quizId: quizId,
          userId: userId,
          submitted: true, // Hanya yang submitted
          page: page,
          size: pageSize,
        );
        
        if (sessionsResult != null) {
          // Convert UserQuizSessionResponse to QuizAttemptSummary
          attempts.value = sessionsResult.sessions.map((session) {
            return QuizAttemptSummary(
              sessionId: session.id,
              quizId: quizId,
              quizName: quizName,
              score: session.score ?? 0,
              totalQuestions: 0, // Tidak tersedia dari endpoint ini
              correctAnswers: 0, // Tidak tersedia dari endpoint ini
              submittedAt: session.endedAt ?? DateTime.now(),
            );
          }).toList();
          paging = sessionsResult.paging;
        }
      } else {
        // Student view: gunakan getQuizAttemptSummaries
        result = await _sessionRepository.getQuizAttemptSummaries(
          quizId: quizId,
          page: page,
          size: pageSize,
        );

        if (result != null) {
          attempts.value = result.attempts;
          paging = result.paging;
        }
      }

      if (attempts.isEmpty && errorMessage.isEmpty) {
        errorMessage.value = 'Tidak ada attempt ditemukan';
      }
      
      debugPrint('Loaded ${attempts.length} attempts for quiz $quizId');
    } catch (e) {
      debugPrint('Error loading attempts: $e');
      errorMessage.value = 'Terjadi kesalahan: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Load next page of attempts
  Future<void> loadNextPage() async {
    if (currentPage.value < paging.totalPage) {
      await loadAttempts(page: currentPage.value + 1);
    }
  }

  /// Load previous page of attempts
  Future<void> loadPreviousPage() async {
    if (currentPage.value > 1) {
      await loadAttempts(page: currentPage.value - 1);
    }
  }

  /// Check if there is a next page
  bool get hasNextPage => currentPage.value < paging.totalPage;

  /// Navigate to attempt detail view
  void viewAttemptDetail(QuizAttemptSummary attempt) {
    Get.toNamed(
      '/quiz-review',
      arguments: {
        'sessionId': attempt.sessionId,
        'quizId': quizId,
        'quizName': quizName,
        'score': attempt.score,
        'fetchFromServer': true,
      },
    );
  }

  /// Get percentage score
  int getScorePercentage(QuizAttemptSummary attempt) {
    if (attempt.totalQuestions == 0) return 0;
    return ((attempt.correctAnswers / attempt.totalQuestions) * 100).toInt();
  }
}
