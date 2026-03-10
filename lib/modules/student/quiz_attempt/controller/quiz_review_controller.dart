import 'package:blessing/data/report/repository/report_repository_impl.dart';
import 'package:blessing/data/quiz/repository/question_repository_impl.dart';
import 'package:blessing/data/session/repository/session_repository_impl.dart';
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
    
    // Priority: 
    // 1. Jika ada sessionId -> ALWAYS fetch dari server untuk format konsisten
    // 2. Kalau tidak ada sessionId tapi ada reviewItems -> gunakan itu (backward compat)
    // 3. Kalau fetchFromServer: true tapi no sessionId -> fetch via quizId
    
    if (sessionId.isNotEmpty) {
      // Fetch dari server menggunakan sessionId (konsisten format)
      debugPrint('QuizReviewController: Fetching from server with sessionId: $sessionId');
      _loadFromServer();
    } else if (reviewItems.isNotEmpty) {
      // Gunakan reviewItems yang sudah dikirim dari arguments
      debugPrint('QuizReviewController: Using reviewItems from arguments');
      isLoading.value = false;
    } else if (fetchFromServer.value && quizId.isNotEmpty) {
      // Fetch via quizId dari report card
      debugPrint('QuizReviewController: Fetching from server with quizId: $quizId');
      _loadFromServerWithQuizId();
    } else {
      debugPrint('QuizReviewController: No valid data source');
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

  /// Load data dari server menggunakan sessionId
  /// Endpoint: GET /api/sessions/{sessionId}/summary
  Future<void> _loadFromServer() async {
    try {
      isLoading.value = true;

      debugPrint('_loadFromServer: Fetching summary for sessionId: $sessionId');

      // Fetch session summary dengan detail jawaban user dan jawaban benar
      final summary =
          await SessionRepository().getSessionSummary(sessionId);

      if (summary != null) {
        debugPrint(
            '_loadFromServer: Success! Got ${summary.questions.length} questions');
        
        score.value = summary.score;
        quizName.value = summary.quizName;

        // Map response ke reviewItems format
        final items = <Map<String, dynamic>>[];
        for (final q in summary.questions) {
          items.add({
            'question': {
              'questionText': q.questionText,
              'questionImages': q.questionImages,
              'questionNumber': q.questionNumber,
            },
            'userAnswer': q.userAnswer != null
                ? {'option': q.userAnswer}
                : null,
            'correctAnswer': {
              'option': q.correctAnswer,
            },
            'isCorrect': q.isCorrect,
          });
        }
        reviewItems.assignAll(items);
        
        debugPrint('_loadFromServer: Mapped ${items.length} review items');
      } else {
        debugPrint('_loadFromServer: Summary response is null');
        // Fallback ke quizId jika ada
        if (quizId.isNotEmpty) {
          debugPrint('_loadFromServer: Falling back to _loadFromServerWithQuizId');
          await _loadFromServerWithQuizId();
        }
      }
    } catch (e) {
      debugPrint('Error loading from server: $e');
      // Fallback
      if (quizId.isNotEmpty) {
        debugPrint('_loadFromServer: Falling back to _loadFromServerWithQuizId due to error');
        await _loadFromServerWithQuizId();
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Fallback method untuk load data dari server menggunakan quizId
  /// Ketika sessionId tidak tersedia (misalnya dari quiz list)
  Future<void> _loadFromServerWithQuizId() async {
    try {
      isLoading.value = true;

      if (quizId.isEmpty) {
        debugPrint('Error: Both sessionId and quizId are empty');
        return;
      }

      debugPrint('_loadFromServerWithQuizId: Fetching with quizId: $quizId');

      // Get complete report card untuk user ini
      final reportCard = await _reportRepository.getMyCompleteReportCard();

      if (reportCard != null) {
        debugPrint(
            '_loadFromServerWithQuizId: Got report card with ${reportCard.data.quizzes.length} quizzes');
        
        // Cari quiz yang match dengan quizId
        final quizReport = reportCard.data.quizzes
            .firstWhereOrNull((q) => q.quizId == quizId);

        if (quizReport != null && quizReport.isAttempted) {
          debugPrint(
              '_loadFromServerWithQuizId: Found quiz with score ${quizReport.score}');
          
          score.value = quizReport.score ?? 0;
          quizName.value = quizReport.quizName;

          // Load questions untuk quiz ini
          final result =
              await _questionRepository.getAllQuestions(quizId: quizId);

          if (result != null && result.questions.isNotEmpty) {
            debugPrint(
                '_loadFromServerWithQuizId: Got ${result.questions.length} questions');
            
            // Build review items dari questions (tanpa detail jawaban benar)
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
            debugPrint('_loadFromServerWithQuizId: Mapped ${items.length} items');
          } else {
            debugPrint('_loadFromServerWithQuizId: No questions found');
          }
        } else {
          debugPrint(
              '_loadFromServerWithQuizId: Quiz tidak ditemukan atau belum dikerjakan (quizId: $quizId)');
        }
      } else {
        debugPrint('_loadFromServerWithQuizId: Report card is null');
      }
    } catch (e) {
      debugPrint('Error loading from server with quizId: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void setReviewItems(List<Map<String, dynamic>> items) {
    reviewItems.assignAll(items);
  }
}
