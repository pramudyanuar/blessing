// lib/data/session/models/response/user_quiz_session_response.dart

import '../../../user/models/response/user_response.dart';
import '../../../quiz/models/response/quiz_response.dart';

class UserQuizSessionResponse {
  final String id;
  final DateTime startedAt;
  final DateTime? endedAt;
  final bool submitted;
  final bool autoSubmitted;
  final int? score;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserResponse? user;
  final QuizResponse? quiz;

  UserQuizSessionResponse({
    required this.id,
    required this.startedAt,
    this.endedAt,
    required this.submitted,
    required this.autoSubmitted,
    this.score,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.quiz,
  });

  factory UserQuizSessionResponse.fromJson(Map<String, dynamic> json) =>
      UserQuizSessionResponse(
        id: json["id"],
        startedAt: DateTime.parse(json["started_at"]),
        endedAt:
            json["ended_at"] == null ? null : DateTime.parse(json["ended_at"]),
        submitted: json["submitted"],
        autoSubmitted: json["auto_submitted"],
        score: json["score"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: json["user"] == null ? null : UserResponse.fromJson(json["user"]),
        quiz: json["quiz"] == null ? null : QuizResponse.fromJson(json["quiz"]),
      );
}
