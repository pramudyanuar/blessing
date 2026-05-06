import 'package:blessing/core/utils/app_routes.dart';
import 'package:blessing/data/quiz/models/response/question_option_response.dart';
import 'package:blessing/data/quiz/repository/question_option_repository.dart';
import 'package:blessing/data/session/models/response/session_question_detail_response.dart';
import 'package:blessing/data/session/repository/session_repository_impl.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AdminAnswerReviewController extends GetxController {
  late final SessionRepository _sessionRepository;
  final QuestionOptionRepository _optionRepository = QuestionOptionRepository();

  late String sessionId;
  late String userId;
  late String quizId;

  final RxString quizName = ''.obs;
  final RxString userName = ''.obs;
  final RxBool isLoading = true.obs;
  final RxList<QuestionReviewData> questions = <QuestionReviewData>[].obs;

  @override
  void onInit() {
    super.onInit();
    _sessionRepository = SessionRepository();
    _handleArguments();
    _loadSessionSummary();
  }

  void _handleArguments() {
    final args = Get.arguments as Map<String, dynamic>?;
    sessionId = args?['sessionId'] ?? '';
    userId = args?['userId'] ?? '';
    quizId = args?['quizId'] ?? '';
    quizName.value = args?['quizName'] ?? 'Quiz';
    userName.value = args?['userName'] ?? 'Siswa';

    debugPrint(
        'AdminAnswerReviewController: Args loaded - sessionId=$sessionId, userId=$userId, quizName=${quizName.value}');
  }

  /// Fetch session summary dari API
  Future<void> _loadSessionSummary() async {
    try {
      isLoading.value = true;

      if (sessionId.isEmpty) {
        debugPrint('Error: sessionId is empty');
        return;
      }

      debugPrint('AdminAnswerReviewController: Fetching summary for sessionId: $sessionId');

      // Fetch session summary
      final summary = await _sessionRepository.getSessionSummary(sessionId);

      if (summary != null) {
        debugPrint(
            'AdminAnswerReviewController: Success! Got ${summary.questions.length} questions');

        quizName.value = summary.quizName;

        final optionsByQuestionId =
            await _loadOptionsByQuestion(summary.questions);

        // Map response ke QuestionReviewData format
        final items = <QuestionReviewData>[];
        for (final q in summary.questions) {
          final options = optionsByQuestionId[q.questionId] ?? [];
          final userAnswerDisplay = _formatAnswerWithOption(
            options,
            q.userAnswerId,
            q.userAnswer,
          );
          final correctAnswerDisplay = _formatAnswerWithOption(
            options,
            q.correctAnswerId,
            q.correctAnswer,
          );

          // Prepare options from answer data
          final mappedOptions = <Map<String, dynamic>>[];

          // Option user answer
          if (userAnswerDisplay != null) {
            mappedOptions.add({
              'label': userAnswerDisplay,
              'isUserAnswer': true,
              'isCorrect': q.isCorrect,
            });
          }

          // Option correct answer
          if (correctAnswerDisplay != null &&
              correctAnswerDisplay != userAnswerDisplay) {
            mappedOptions.add({
              'label': correctAnswerDisplay,
              'isUserAnswer': false,
              'isCorrect': true,
            });
          }

          items.add(
            QuestionReviewData(
              questionNumber: q.questionNumber,
              questionText: q.questionText,
              questionImages: q.questionImages,
              userAnswer: userAnswerDisplay,
              correctAnswer: correctAnswerDisplay ?? q.correctAnswer,
              isCorrect: q.isCorrect,
              options: mappedOptions,
              explanation: null, // Backend belum provide explanation
            ),
          );
        }

        questions.assignAll(items);
        debugPrint('AdminAnswerReviewController: Mapped ${items.length} items');
      } else {
        debugPrint('AdminAnswerReviewController: Summary response is null');
      }
    } catch (e) {
      debugPrint('Error loading session summary: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Get akurasi jawaban
  String get accuracy {
    if (questions.isEmpty) return '0.0';
    final correctCount = questions.where((q) => q.isCorrect).length;
    final acc = ((correctCount / questions.length) * 100).toStringAsFixed(1);
    return acc;
  }

  /// Navigate ke attempts list untuk student ini
  void goToAttemptsList() {
    Get.toNamed(
      AppRoutes.adminQuizAttemptsList,
      arguments: {
        'quizId': quizId,
        'quizName': quizName.value,
        'userId': userId,
        'studentName': userName.value,
      },
    );
  }

  Future<Map<String, List<QuestionOptionResponse>>> _loadOptionsByQuestion(
      List<SessionQuestionDetailResponse> questions) async {
    final results =
        await Future.wait<MapEntry<String, List<QuestionOptionResponse>>>(
      questions.map((q) async {
      try {
        final result = await _optionRepository.getAllOptionsByQuestionId(
          q.questionId,
          size: 20,
        );
        return MapEntry<String, List<QuestionOptionResponse>>(
          q.questionId,
          result?.options ?? <QuestionOptionResponse>[],
        );
      } catch (e) {
        debugPrint('Option load failed for question ${q.questionId}: $e');
        return MapEntry<String, List<QuestionOptionResponse>>(
          q.questionId,
          <QuestionOptionResponse>[],
        );
      }
      },
    ));

    return Map<String, List<QuestionOptionResponse>>.fromEntries(results);
  }

  String? _formatAnswerWithOption(
    List<QuestionOptionResponse> options,
    String? optionId,
    String? fallback,
  ) {
    if (optionId != null && options.isNotEmpty) {
      final index = options.indexWhere((opt) => opt.id == optionId);
      if (index >= 0 && index < options.length) {
        final letter = String.fromCharCode('A'.codeUnitAt(0) + index);
        final optionText = options[index].option;
        return '$letter. $optionText';
      }
    }

    if (fallback != null && fallback.trim().isNotEmpty) {
      return fallback.trim();
    }

    return null;
  }
}

class QuestionReviewData {
  final int questionNumber;
  final String questionText;
  final List<String> questionImages;
  final String? userAnswer;
  final String correctAnswer;
  final bool isCorrect;
  final List<Map<String, dynamic>> options;
  final String? explanation;

  QuestionReviewData({
    required this.questionNumber,
    required this.questionText,
    required this.questionImages,
    required this.userAnswer,
    required this.correctAnswer,
    required this.isCorrect,
    required this.options,
    this.explanation,
  });
}
