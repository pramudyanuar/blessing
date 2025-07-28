// lib/data/session/models/request/create_user_answer_request.dart

class CreateUserAnswerRequest {
  final String sessionId;
  final String questionId;
  final String optionId;

  CreateUserAnswerRequest({
    required this.sessionId,
    required this.questionId,
    required this.optionId,
  });

  Map<String, dynamic> toJson() => {
        "session_id": sessionId,
        "question_id": questionId,
        "option_id": optionId,
      };
}
