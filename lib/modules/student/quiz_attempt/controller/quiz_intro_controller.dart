import 'package:blessing/data/quiz/repository/quiz_repository_impl.dart';
import 'package:blessing/data/report/repository/report_repository_impl.dart';
import 'package:blessing/data/session/repository/session_repository_impl.dart';
import 'package:blessing/core/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum QuizAttemptStatus { notStarted, inProgress, submitted }

class QuizIntroController extends GetxController {
  // --- Dependencies ---
  final QuizRepository _quizRepository = QuizRepository();
  final ReportRepository _reportRepository = ReportRepository();
  final SessionRepository _sessionRepository = SessionRepository();

  // --- State & Data ---
  late final String quizId;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  // Quiz attempt status
  final Rx<QuizAttemptStatus> quizStatus = QuizAttemptStatus.notStarted.obs;
  final RxString sessionId = ''.obs;
  final RxInt previousScore = 0.obs;
  final RxBool canRetake = false.obs;

  // Untuk menyimpan detail kuis seperti judul, durasi, dll.
  final Rx<Map<String, dynamic>> quizDetails = Rx<Map<String, dynamic>>({});

  @override
  void onInit() {
    super.onInit();
    // Ambil quizId dari argument
    if (Get.arguments is String) {
      quizId = Get.arguments;
      _loadInitialData();
    } else {
      isLoading.value = false;
      errorMessage.value = "ID Kuis tidak valid.";
    }
  }

  @override
  void onReady() {
    super.onReady();
    // Refresh status setiap kali screen di-visit (penting untuk handle resume setelah app close)
    _refreshQuizStatus();
  }

  /// Refresh quiz status tanpa loading full data
  Future<void> _refreshQuizStatus() async {
    try {
      await checkQuizStatus();
    } catch (e) {
      debugPrint("Error refreshing quiz status: $e");
    }
  }

  /// Load quiz details dan check status (selesai atau in-progress)
  Future<void> _loadInitialData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Parallel load: quiz details + status check
      await Future.wait([
        fetchQuizDetails(),
        checkQuizStatus(),
      ]);
    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint("Error loading initial data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch quiz details (title, duration, etc)
  Future<void> fetchQuizDetails() async {
    try {
      final response = await _quizRepository.getQuizById(quizId);
      if (response != null) {
        quizDetails.value = {
          "title": response.quizName,
          "duration": response.timeLimit,
          "totalQuestions": 0,
        };
      } else {
        throw Exception("Gagal memuat detail kuis.");
      }
    } catch (e) {
      debugPrint("Error fetching quiz details: $e");
      rethrow;
    }
  }

  /// Check apakah quiz sudah dikerjakan, sedang dikerjakan, atau belum
  Future<void> checkQuizStatus() async {
    try {
      // 1. Check report card untuk score (jika sudah SELESAI/submitted)
      final reportCard = await _reportRepository.getMyCompleteReportCard();
      if (reportCard != null) {
        // Cari apakah quiz ini sudah selesai (submitted)
        final completedQuiz = FirstWhereOrNullExt(reportCard.data.quizzes)
            .firstWhereOrNull((quiz) => quiz.quizId == quizId);

        if (completedQuiz != null && 
            (completedQuiz.submitted == true || completedQuiz.status == 'submitted')) {
          // Quiz sudah selesai (submitted)
          quizStatus.value = QuizAttemptStatus.submitted;
          previousScore.value = completedQuiz.score ?? 0;
          canRetake.value = false;
          return;
        }
      }

      // 2. Check apakah ada active session (in-progress)
      final sessionsResult = await _sessionRepository.getAllSessions(
        submitted: false,
        quizId: quizId,
        size: 100,
      );

      if (sessionsResult != null && sessionsResult.sessions.isNotEmpty) {
        final activeSession = sessionsResult.sessions.firstOrNull;
        if (activeSession != null) {
          // Ada session yang belum diselesaikan
          quizStatus.value = QuizAttemptStatus.inProgress;
          sessionId.value = activeSession.id;
          return;
        }
      }

      // 3. Tidak ada session dan tidak ada score → belum pernah dicoba
      quizStatus.value = QuizAttemptStatus.notStarted;
    } catch (e) {
      debugPrint("Error checking quiz status: $e");
      // Fallback: asumsikan belum pernah dicoba
      quizStatus.value = QuizAttemptStatus.notStarted;
    }
  }

  /// Mulai quiz baru (create new session)
  void startNewQuiz() {
    if (quizId.isNotEmpty) {
      Get.toNamed(AppRoutes.quizAttempt, arguments: quizId);
    } else {
      Get.snackbar("Error", "ID Kuis tidak valid.");
    }
  }

  /// Lanjutkan quiz yang belum selesai (resume existing session)
  void resumeQuiz() {
    if (sessionId.isNotEmpty && quizId.isNotEmpty) {
      // Pass both sessionId dan quizId untuk resume
      Get.toNamed(
        AppRoutes.quizAttempt,
        arguments: {
          'quizId': quizId,
          'sessionId': sessionId.value,
          'isResume': true,
        },
      );
    } else {
      Get.snackbar("Error", "Tidak dapat melanjutkan kuis. Data session hilang.");
    }
  }

  /// Lihat hasil quiz yang sudah selesai
  void viewResult() {
    Get.toNamed(AppRoutes.quizReview, arguments: {
      'quizId': quizId,
      'score': previousScore.value,
      'quizName': quizDetails.value['title'] ?? 'Kuis',
      'sessionId': '', // Tidak ada session ID saat view dari list
      'reviewItems': [], // Empty, akan di-fetch dari API
      'fetchFromServer': true, // Flag untuk fetch dari server
    });
  }

  /// Coba lagi quiz (create new session, hapus yang lama)
  void retakeQuiz() {
    Get.dialog(
      _buildRetakeConfirmationDialog(),
    );
  }

  Widget _buildRetakeConfirmationDialog() {
    return AlertDialog(
      title: const Text('Coba Lagi?'),
      content: const Text(
        'Anda akan memulai kuis dari awal. Hasil sebelumnya akan tetap tersimpan.',
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
            startNewQuiz();
          },
          child: const Text('Mulai Ulang'),
        ),
      ],
    );
  }
}

/// Extension untuk firstWhereOrNull
extension FirstWhereOrNullExt<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    try {
      return firstWhere(test);
    } catch (e) {
      return null;
    }
  }
}
