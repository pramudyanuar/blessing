// lib/data/session/models/request/create_user_quiz_session_request.dart

class CreateUserQuizSessionRequest {
  final String quizId;

  CreateUserQuizSessionRequest({required this.quizId});

  Map<String, dynamic> toJson() => {"quiz_id": quizId};
}
