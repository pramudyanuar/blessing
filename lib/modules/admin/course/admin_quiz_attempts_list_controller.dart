import 'package:blessing/core/utils/app_routes.dart';
import 'package:blessing/data/session/models/response/quiz_attempt_summary.dart';
import 'package:blessing/data/core/models/paging_response.dart';
import 'package:blessing/data/session/repository/session_repository_impl.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// Controller untuk admin view list of quiz attempts untuk specific user
/// Reuse logic dari student attempts list controller
class AdminQuizAttemptsListController extends GetxController {
  final SessionRepository _sessionRepository = SessionRepository();

  late final String quizId;
  late final String quizName;
  late final String userId;
  String? studentName; // Optional: nama student untuk display

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
    userId = args['userId'] ?? '';
    studentName = args['studentName']; // Optional

    if (quizId.isEmpty || userId.isEmpty) {
      errorMessage.value = 'Quiz ID atau User ID tidak valid';
      isLoading.value = false;
    }
  }

  /// Load list of quiz attempts untuk specific student
  Future<void> loadAttempts({int page = 1}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      currentPage.value = page;

      // Gunakan getAllSessions dengan userId filter
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
        
        debugPrint('Loaded ${attempts.length} attempts for user $userId on quiz $quizId');
      } else {
        errorMessage.value = 'Gagal memuat daftar attempt';
      }

      if (attempts.isEmpty && errorMessage.isEmpty) {
        errorMessage.value = 'Tidak ada attempt ditemukan';
      }
    } catch (e) {
      debugPrint('Error loading attempts: $e');
      errorMessage.value = 'Terjadi kesalahan: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigate ke detail attempt
  void viewAttemptDetail(QuizAttemptSummary attempt) {
    Get.toNamed(
      AppRoutes.adminAnswerReview,
      arguments: {
        'sessionId': attempt.sessionId,
        'quizId': quizId,
        'quizName': quizName,
        'userId': userId,
        'studentName': studentName,
      },
    );
  }

  /// Load next page
  void loadNextPage() {
    if (currentPage.value * pageSize < paging.totalItem) {
      loadAttempts(page: currentPage.value + 1);
    }
  }

  /// Load previous page
  void loadPreviousPage() {
    if (currentPage.value > 1) {
      loadAttempts(page: currentPage.value - 1);
    }
  }

  bool get hasNextPage => currentPage.value * pageSize < paging.totalItem;
  bool get hasPreviousPage => currentPage.value > 1;
}
