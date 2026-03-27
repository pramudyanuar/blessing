// lib/data/session/models/response/quiz_attempt_summary.dart

/// Response model untuk satu item dalam list attempt dari endpoint GET /api/quiz/{quizId}/quiz-summary
/// Merepresentasikan lightweight summary dari satu kali quiz attempt
class QuizAttemptSummary {
  final String sessionId;
  final String quizId;
  final String quizName;
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final DateTime submittedAt;

  QuizAttemptSummary({
    required this.sessionId,
    required this.quizId,
    required this.quizName,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.submittedAt,
  });

  factory QuizAttemptSummary.fromJson(Map<String, dynamic> json) =>
      QuizAttemptSummary(
        sessionId: json["session_id"] ?? "",
        quizId: json["quiz_id"] ?? "",
        quizName: json["quiz_name"] ?? "Quiz",
        score: json["score"] ?? 0,
        totalQuestions: json["total_questions"] ?? 0,
        correctAnswers: json["correct_answers"] ?? 0,
        submittedAt: json["submitted_at"] != null
            ? DateTime.parse(json["submitted_at"])
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "session_id": sessionId,
        "quiz_id": quizId,
        "quiz_name": quizName,
        "score": score,
        "total_questions": totalQuestions,
        "correct_answers": correctAnswers,
        "submitted_at": submittedAt.toIso8601String(),
      };
}
