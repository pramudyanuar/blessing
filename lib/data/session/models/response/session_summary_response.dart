import 'session_question_detail_response.dart';

/// Response dari endpoint GET /api/sessions/{sessionId}/summary
/// Berisi score, jawaban user, dan jawaban benar untuk setiap soal
class SessionSummaryResponse {
  final String sessionId;
  final String quizId;
  final String quizName;
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final DateTime submittedAt;
  final List<SessionQuestionDetailResponse> questions;

  SessionSummaryResponse({
    required this.sessionId,
    required this.quizId,
    required this.quizName,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.submittedAt,
    required this.questions,
  });

  factory SessionSummaryResponse.fromJson(Map<String, dynamic> json) =>
      SessionSummaryResponse(
        sessionId: json["session_id"] ?? "",
        quizId: json["quiz_id"] ?? "",
        quizName: json["quiz_name"] ?? "Quiz",
        score: json["score"] ?? 0,
        totalQuestions: json["total_questions"] ?? 0,
        correctAnswers: json["correct_answers"] ?? 0,
        submittedAt: json["submitted_at"] != null
            ? DateTime.parse(json["submitted_at"])
            : DateTime.now(),
        questions: List<SessionQuestionDetailResponse>.from(
          json["questions"]?.map(
                (x) => SessionQuestionDetailResponse.fromJson(x),
              ) ??
              [],
        ),
      );
}
